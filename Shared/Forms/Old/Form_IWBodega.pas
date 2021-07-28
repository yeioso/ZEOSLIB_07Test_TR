unit Form_IWBodega;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompTabControl, IWCompJQueryWidget, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, UtConexion, Data.DB, IWCompGrids,
  IWDBStdCtrls, IWCompEdit, IWCompCheckbox, IWCompMemo, IWDBExtCtrls,
  IWCompButton, IWCompListbox, IWCompGradButton, UtTypeTEST_TR, IWCompRadioButton,
  UtGrid_JQ, UtNavegador_ASE;

type
  TFrIWBodega = class(TIWAppForm)
    RINFO: TIWRegion;
    lbInfo: TIWLabel;
    IWRegion1: TIWRegion;
    PAGINAS: TIWTabControl;
    PAG_00: TIWTabPage;
    PAG_01: TIWTabPage;
    RNAVEGADOR: TIWRegion;
    IWLabel1: TIWLabel;
    IWLabel8: TIWLabel;
    DATO: TIWEdit;
    CODIGO_BODEGA: TIWDBLabel;
    BTNNOMBRE: TIWImage;
    NOMBRE: TIWDBLabel;
    BTNCODIGO: TIWImage;
    BTNACTIVO: TIWImage;
    lbNombre_Activo: TIWLabel;
    IWRegion_Navegador: TIWRegion;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCNX : TConexion;
    FINFO : String;
    FQRMAESTRO : TMANAGER_DATA;
    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;

    FCODIGO_BODEGA : String;

    Procedure Release_Me;

    Function Existe_Bodega(Const pCODIGO_BODEGA : String) : Boolean;

    procedure Resultado_Codigo(EventParams: TStringList);
    procedure Resultado_Nombre(EventParams: TStringList);
    Procedure Resultado_Activo(EventParams: TStringList);

    Procedure Validar_Campos_Master(pSender : TObject);
    Function Documento_Activo : Boolean;

    Procedure NewRecordMaster(pSender: TObject);
    Procedure DsDataChangeMaster(pSender: TObject);
    Procedure DsStateMaster(pSender: TObject);

    Procedure SetLabel;
    Procedure Estado_Controles;
    Function AbrirMaestro(Const pDato : String = '') : Boolean;
  public
  end;


implementation
{$R *.dfm}
Uses
  Math,
  UtLog,
  UtFecha,
  Variants,
  UtFuncion,
  UtAcarreo,
  Vcl.Graphics,
  UtInfoTablas,
  Winapi.Windows,
  System.UITypes,
  System.StrUtils,
  ServerController;

procedure TFrIWBodega.Resultado_Codigo(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA').AsString := Justificar(EventParams.Values['InputStr'], '0', FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWBodega_Enc.Resultado_Codigo, ' + e.Message);
  End;
End;

procedure TFrIWBodega.Resultado_Nombre(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWBodega_Enc.Resultado_Nombre, ' + e.Message);
  End;
End;

Procedure TFrIWBodega.Resultado_Activo(EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
      FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString := IfThen(Result_Is_OK(EventParams.Values['RetValue']), 'S', 'N');
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWBodega.Resultado_Activo, ' + E.Message);
  End;
end;


Procedure TFrIWBodega.Release_Me;
Begin
  Self.Release;
End;

Function TFrIWBodega.Existe_Bodega(Const pCODIGO_BODEGA : String) : Boolean;
Begin
  Result := UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Bodega).Name, ['CODIGO_BODEGA'], [pCODIGO_BODEGA]);
End;

Procedure TFrIWBodega.Validar_Campos_Master(pSender : TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    NOMBRE.BGColor := UserSession.COLOR_OK;
    CODIGO_BODEGA.BGColor := UserSession.COLOR_OK;

    If FQRMAESTRO.Mode_Edition And (Not Vacio(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString)) Then
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);

    If BTNCODIGO.Visible And UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Bodega).Name, ['CODIGO_BODEGA'], [FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA').AsString]) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Bodega ya existe';
      CODIGO_BODEGA.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNCODIGO.Visible And Vacio(FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Bodega invalida';
      CODIGO_BODEGA.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNNOMBRE.Visible And Vacio(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Nombre invalido';
      NOMBRE.BGColor := UserSession.COLOR_ERROR;
    End;

    FQRMAESTRO.ERROR := IfThen(Vacio(lMensaje), 0, -1);
    If FQRMAESTRO.ERROR <> 0 Then
    Begin
      FQRMAESTRO.LAST_ERROR := 'Datos invalidos, ' + lMensaje;
      UserSession.SetMessage(FQRMAESTRO.LAST_ERROR, True);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWBodega.Validar_Campos_Master, ' + E.Message);
  End;
End;


Procedure TFrIWBodega.Estado_Controles;
Begin
  BTNCODIGO.Visible := (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  BTNNOMBRE.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNACTIVO.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;

//  BtnBuscar.Enabled := FQRMAESTRO.Active And (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount >= 1);
  DATO.Visible      := (Not FQRMAESTRO.Mode_Edition);
  PAG_00.Visible    := (Not FQRMAESTRO.Mode_Edition);
  PAG_01.Visible    := True;
End;

Procedure TFrIWBodega.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try
    lbNombre_Activo.Caption := IfThen(FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString = 'S', 'Activo', 'No activo');
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWBodega.SetLabel, ' + E.Message);
    End;
  End;
End;

Function TFrIWBodega.Documento_Activo : Boolean;
Begin
  Try
    Result := True;
    //Result := (FQRMAESTRO.RecordCount >= 1) {And (Trim(FQRMAESTRO.FieldByName('ID_ANULADO').AsString) <> 'S')};
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWBodega.Documento_Activo, ' + E.Message);
    End;
  End;
End;

procedure TFrIWBodega.DsDataChangeMaster(pSender: TObject);
begin
  FNAVEGADOR.UpdateState;
  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA').AsString + ', ' + FQRMAESTRO.QR.FieldByName('NOMBRE').AsString + ' ] ';
  Try
    SetLabel;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWBodega.DsDataChangeMaster, ' + E.Message);
    End;
  End;
end;

Procedure TFrIWBodega.DsStateMaster(pSender: TObject);
Begin
  Estado_Controles;
  If FQRMAESTRO.Mode_Edition Then
    PAGINAS.ActivePage := 1;
  Case FQRMAESTRO.DS.State Of
    dsInsert : Begin
//                 If CODIGO_BODEGA.Enabled Then
//                   CODIGO_BODEGA.SetFocus;
               End;
    dsEdit   : Begin
//                 If NOMBRE.Enabled Then
//                   NOMBRE.SetFocus;
               End;
  End;
End;

Function TFrIWBodega.AbrirMaestro(Const pDato : String = '') : Boolean;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(Id_Bodega).Caption;
  Result := False;
  Try
    FQRMAESTRO.Active := False;
    FQRMAESTRO.WHERE := '';
    FQRMAESTRO.SENTENCE := ' SELECT ' + UserSession.CNX.Top_Sentence(UserSession.Const_Max_Record) + ' * FROM ' + Retornar_Info_Tabla(Id_Bodega).Name + ' ';
    If Trim(pDato) <> '' Then
    Begin
      FQRMAESTRO.WHERE := ' WHERE CODIGO_BODEGA LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' OR NOMBRE LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
    End;
    FQRMAESTRO.ORDER := ' ORDER BY CODIGO_BODEGA ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
    If Result Then
    Begin

    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWBodega.AbrirMaestro, ' + E.Message);
    End;
  End;
  FGRID_MAESTRO.RefreshData;
End;

procedure TFrIWBodega.IWAppFormCreate(Sender: TObject);
Var
  lI : Integer;
begin
  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(Id_Bodega).Caption;
  Randomize;
  Self.Name := 'Bodega' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Codigo', Resultado_Codigo);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Nombre', Resultado_Nombre);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Activo', Resultado_Activo);
  Try
    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;
    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;

    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Bodega).Name, Retornar_Info_Tabla(Id_Bodega).Caption);

    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_BEFORE_POST  := Validar_Campos_Master;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;

    CODIGO_BODEGA.DataSource   := FQRMAESTRO.DS;
    NOMBRE.DataSource          := FQRMAESTRO.DS;

    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['CODIGO_BODEGA', 'NOMBRE'     ],
                                         ['Bodega'       , 'Nombre'     ],
                                         ['S'            , 'N'          ],
                                         [100            , 550          ],
                                         [taRightJustify , taLeftJustify]);


    FNAVEGADOR               := TNavegador_ASE.Create(IWRegion_Navegador);
    FNAVEGADOR.Parent        := IWRegion_Navegador;
    FNAVEGADOR.SetNavegador(FQRMAESTRO, WebApplication, FGRID_MAESTRO);
    FNAVEGADOR.ACTION_SEARCH := BTNBUSCARAsyncClick ;
//    FNAVEGADOR.ACTION_COPY   := BtnAcarreoAsyncClick;
    FNAVEGADOR.ACTION_EXIT   := BTNBACKAsyncClick   ;
    FNAVEGADOR.Top  := 1;
    FNAVEGADOR.Left := 1;
    IWRegion_Navegador.Width  := FNAVEGADOR.Width  + 1;
    IWRegion_Navegador.Height := FNAVEGADOR.Height + 1;

    If AbrirMaestro Then
    Begin
    End
    Else
      Release_Me
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWBodega.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWBodega.IWAppFormDestroy(Sender: TObject);
begin
    Try
      If Assigned(FQRMAESTRO) Then
      Begin
        FQRMAESTRO.Active := False;
        FreeAndNil(FQRMAESTRO);
      End;

      If Assigned(FNAVEGADOR) Then
      Begin
        FreeAndNil(FNAVEGADOR);
      End;

      If Assigned(FGRID_MAESTRO) Then
      Begin
        FreeAndNil(FGRID_MAESTRO);
      End;

    Except
      On E: Exception Do
        UtLog_Execute('TFrIWBodega.IWAppFormDestroy, ' + e.Message);
    End;
end;

procedure TFrIWBodega.NewRecordMaster(pSender: TObject);
begin
  Try
    FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA' ).AsString := UserSession.CNX.Next(Retornar_Info_Tabla(Id_Bodega).Name, '0', ['CODIGO_BODEGA'], [],[], FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA').Size);
    FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString := 'S';
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWBodega.NewRecordMaster, ' + E.Message);
    End;
  End;
end;

procedure TFrIWBodega.BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Está seguro(a) de activar el registro?', Self.Name + '.Resultado_Activo', 'Activar', 'Sí', 'No')
end;

procedure TFrIWBodega.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Release_Me;
end;

procedure TFrIWBodega.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;

procedure TFrIWBodega.BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el código de la bodega', Self.Name + '.Resultado_Codigo', 'Bodega', FQRMAESTRO.QR.FieldByName('CODIGO_BODEGA').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWBodega.BTNCODIGOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWBodega.BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre de la bodega', Self.Name + '.Resultado_Nombre', 'Nombre', FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWBodega.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;

end.
