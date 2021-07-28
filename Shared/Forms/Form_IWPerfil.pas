unit Form_IWPerfil;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompTabControl, IWCompJQueryWidget, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, UtConexion, Data.DB, IWCompGrids,
  IWDBStdCtrls, IWCompEdit, IWCompCheckbox, IWCompMemo, IWDBExtCtrls,
  IWCompButton, IWCompListbox, IWCompGradButton,
  UtGrid_JQ, UtNavegador_ASE;

type
  TFrIWPerfil = class(TIWAppForm)
    RINFO: TIWRegion;
    lbInfo: TIWLabel;
    IWRegion1: TIWRegion;
    PAGINAS: TIWTabControl;
    PAG_00: TIWTabPage;
    PAG_01: TIWTabPage;
    RNAVEGADOR: TIWRegion;
    DATO: TIWEdit;
    IWRDETALLE: TIWRegion;
    IWRBOTONDETALLE: TIWRegion;
    BtnGrid: TIWImage;
    IWLabel1: TIWLabel;
    IWLabel8: TIWLabel;
    BTNCODIGO: TIWImage;
    CODIGO_PERFIL: TIWDBLabel;
    BTNNOMBRE: TIWImage;
    NOMBRE: TIWDBLabel;
    DETALLE_PERFIL: TIWListbox;
    IWRegion_Navegador: TIWRegion;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BtnAcarreoAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BtnGridAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCNX : TConexion;
    FINFO : String;
    FQRMAESTRO : TMANAGER_DATA;

    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;

    FQRDETALLE : TMANAGER_DATA;

    FCODIGO_ACTUAL : String;
    FCODIGO_PERFIL : String;

    Procedure Release_Me;

    Function Existe_Perfil(Const pCodigo_Perfil : String) : Boolean;

    Procedure Validar_Campos_Master (pSender: TObject);
    Function Documento_Activo : Boolean;

    procedure Resultado_Codigo(EventParams: TStringList);
    procedure Resultado_Nombre(EventParams: TStringList);

    Procedure NewRecordMaster(pSender: TObject);
    Procedure DsDataChangeMaster(pSender: TObject);
    Procedure DsStateMaster(pSender: TObject);

    Procedure SetLabel;
    Procedure Estado_Controles;
    Function AbrirMaestro(Const pDato : String = '') : Boolean;
    Function AbrirDetalle(Const pCodigo_Perfil : String) : Boolean;
  public
    Constructor Create(AOwner: TComponent; Const pCodigo_Perfil : String);
  end;


implementation
{$R *.dfm}
Uses
  Math,
  UtLog,
  UtFecha,
  Variants,
  UtFuncion,
  Vcl.Graphics,
  UtInfoTablas,
  Winapi.Windows,
  System.UITypes,
  System.StrUtils,
  ServerController;

Procedure TFrIWPerfil.Release_Me;
Begin
  Self.Release;
End;

Function TFrIWPerfil.Existe_Perfil(Const pCodigo_Perfil : String) : Boolean;
Begin
  Result := FCNX.Record_Exist(Retornar_Info_Tabla(Id_Perfil).Name, ['CODIGO_PERFIL'], [pCodigo_Perfil]);
End;

procedure TFrIWPerfil.Resultado_Codigo(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString := Justificar(EventParams.Values['InputStr'], '0', FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWPerfil_Enc.Resultado_Codigo, ' + e.Message);
  End;
End;

procedure TFrIWPerfil.Resultado_Nombre(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWPerfil_Enc.Resultado_Nombre, ' + e.Message);
  End;
End;

Procedure  TFrIWPerfil.Validar_Campos_Master(pSender: TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    NOMBRE.BGColor := UserSession.COLOR_OK;
    CODIGO_PERFIL.BGColor := UserSession.COLOR_OK;

    If BTNCODIGO.Visible And (Vacio(FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString) Or Existe_Perfil(FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString)) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Perfil invalido';
      CODIGO_PERFIL.BGColor := UserSession.COLOR_ERROR;
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
      UtLog_Execute('TFrIWPerfil_Enc.Validar_Campos_Master, ' + E.Message);
  End;
End;

Procedure TFrIWPerfil.Estado_Controles;
Begin
  BTNCODIGO.Visible := (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  BTNNOMBRE.Visible :=  FQRMAESTRO.Mode_Edition And Documento_Activo;

  IWRBOTONDETALLE.Visible := FQRMAESTRO.Active And (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount >= 1);
//  BtnBuscar.Enabled       := FQRMAESTRO.Active And (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount >= 1);
//  BtnAcarreo.Visible      := FQRMAESTRO.Active And (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount > 0);

  DATO.Visible            := (Not FQRMAESTRO.Mode_Edition);
//  BTNBUSCAR.Visible       := (Not FQRMAESTRO.Mode_Edition);
  PAG_00.Visible          := (Not FQRMAESTRO.Mode_Edition);
  PAG_01.Visible          := True;

End;

Procedure TFrIWPerfil.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try

  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Enc.SetLabel, ' + E.Message);
    End;
  End;
End;

Function TFrIWPerfil.Documento_Activo : Boolean;
Begin
  Try
    Result := True;
    //Result := (FQRMAESTRO.RecordCount >= 1) {And (Trim(FQRMAESTRO.FieldByName('ID_ANULADO').AsString) <> 'S')};
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Enc.Documento_Activo, ' + E.Message);
    End;
  End;
End;

procedure TFrIWPerfil.DsDataChangeMaster(pSender: TObject);
Var
  lNumero_Documento : String;
begin
  FNAVEGADOR.UpdateState;
  If (Not FQRMAESTRO.Active)Then
    Exit;

  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString + ', ' + FQRMAESTRO.QR.FieldByName('NOMBRE').AsString + ' ] ';

  SetLabel;

  Try
    If (FCODIGO_ACTUAL <> FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString) And (Not FQRMAESTRO.Mode_Edition) Then
    Begin
      FCODIGO_ACTUAL := FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString;
      AbrirDetalle(FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString);
    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Enc.DsDataChangeMaster, ' + E.Message);
    End;
  End;
end;

Procedure TFrIWPerfil.DsStateMaster(pSender: TObject);
Begin
  Estado_Controles;
  If FQRMAESTRO.Mode_Edition Then
    PAGINAS.ActivePage := 1;
  Case FQRMAESTRO.DS.State Of
    dsInsert : Begin
//                 If CODIGO_PERFIL.Enabled Then
//                   CODIGO_PERFIL.SetFocus;
               End;
    dsEdit   : Begin
//                 If NOMBRE.Enabled Then
//                   NOMBRE.SetFocus;
               End;
  End;
End;


Function TFrIWPerfil.AbrirMaestro(Const pDato : String = '') : Boolean;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(Id_Perfil).Caption;
  Result := False;
//  GRID_MAESTRO.Visible := False;
  Try
    FQRMAESTRO.Active := False;
    FQRMAESTRO.SENTENCE := ' SELECT * FROM ' + Retornar_Info_Tabla(Id_Perfil).Name + ' ';
    If Trim(pDato) <> '' Then
    Begin
      FQRMAESTRO.WHERE := '  WHERE CODIGO_PERFIL LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE +  '  OR NOMBRE LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
    End;
    FQRMAESTRO.ORDER := ' ORDER BY CODIGO_PERFIL ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
    If Result Then
    Begin

    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Enc.AbrirMaestro, ' + E.Message);
    End;
  End;
  FGRID_MAESTRO.RefreshData;
End;

Function TFrIWPerfil.AbrirDetalle(Const pCodigo_Perfil : String) : Boolean;
Begin
//  GRID_DETALLE.Caption := Retornar_Info_Tabla(Id_Permiso_App).Caption;
  Result := False;
//  GRID_DETALLE.Visible := False;
  DETALLE_PERFIL.Items.Clear;
  Try
    FQRDETALLE.Active := False;
    FQRDETALLE.SENTENCE := ' SELECT * FROM ' + Retornar_Info_Tabla(Id_Permiso_App).Name + ' ';
    FQRDETALLE.WHERE    := ' WHERE ' + FCNX.Trim_Sentence('CODIGO_PERFIL') +' = ' + QuotedStr(Trim(pCodigo_Perfil));
    FQRDETALLE.Active := True;
    Result := FQRDETALLE.Active;
    If Result Then
    Begin
      FQRDETALLE.QR.First;
      While Not FQRDETALLE.QR.Eof Do
      Begin
        DETALLE_PERFIL.Items.Add(FQRDETALLE.QR.FieldByName('NOMBRE').AsString);
        FQRDETALLE.QR.Next;
      End;
    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Enc.AbrirDetalle, ' + E.Message);
    End;
  End;
End;

constructor TFrIWPerfil.Create(AOwner: TComponent; Const pCodigo_Perfil : String);
begin
  Inherited Create(AOwner);
  Try
    Self.FCODIGO_PERFIL := pCodigo_Perfil ;
    If AbrirMaestro(FCODIGO_PERFIL) Then
    Begin
    End
    Else
      Release_Me
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWUsuario_Enc.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil.IWAppFormCreate(Sender: TObject);
Var
  lI : Integer;
begin
  Randomize;
  Self.Name := 'PERFIL' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Codigo'    , Resultado_Codigo    );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Nombre'    , Resultado_Nombre    );
  FCODIGO_ACTUAL := '';
  FCODIGO_PERFIL := '';

  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(Id_Perfil).Caption;
  Try

    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;
    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;

    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Perfil).Name, Retornar_Info_Tabla(Id_Perfil).Caption);

    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_BEFORE_POST  := Validar_Campos_Master;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;

    FQRDETALLE := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Permiso_App).Name, Retornar_Info_Tabla(Id_Permiso_App).Caption);

    CODIGO_PERFIL.DataSource := FQRMAESTRO.DS;
    NOMBRE.DataSource        := FQRMAESTRO.DS;

    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['CODIGO_PERFIL' , 'NOMBRE'     ],
                                         ['Perfil'        , 'Nombre'     ],
                                         ['S'             , 'N'          ],
                                         [100             , 550          ],
                                         [taRightJustify  , taLeftJustify]);


    FNAVEGADOR               := TNavegador_ASE.Create(IWRegion_Navegador);
    FNAVEGADOR.Parent        := IWRegion_Navegador;
    FNAVEGADOR.SetNavegador(FQRMAESTRO, WebApplication, FGRID_MAESTRO);
    FNAVEGADOR.ACTION_SEARCH := BTNBUSCARAsyncClick ;
    FNAVEGADOR.ACTION_COPY   := BtnAcarreoAsyncClick;
    FNAVEGADOR.ACTION_EXIT   := BTNBACKAsyncClick   ;
    FNAVEGADOR.Top  := 1;
    FNAVEGADOR.Left := 1;
    IWRegion_Navegador.Width  := FNAVEGADOR.Width  + 1;
    IWRegion_Navegador.Height := FNAVEGADOR.Height + 1;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Enc.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil.IWAppFormDestroy(Sender: TObject);
begin
    Try
      If Assigned(FQRDETALLE) Then
      Begin
        FQRDETALLE.Active := False;
        FreeAndNil(FQRDETALLE);
      End;

      If Assigned(FQRMAESTRO) Then
      Begin
        FQRMAESTRO.Active := False;
        FreeAndNil(FQRMAESTRO);
      End;

      If Assigned(FNAVEGADOR) Then
        FreeAndNil(FNAVEGADOR);

      If Assigned(FGRID_MAESTRO) Then
        FreeAndNil(FGRID_MAESTRO);

    Except
      On E: Exception Do
        UtLog_Execute('TFrIWPerfil_Enc.IWAppFormDestroy, ' + e.Message);
    End;
end;

procedure TFrIWPerfil.NewRecordMaster(pSender: TObject);
begin
  Try
    FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL' ).AsString := FCNX.Next(Retornar_Info_Tabla(Id_Perfil).Name, '0', ['CODIGO_PERFIL'], [],[], FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').Size);
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Enc.NewRecordMaster, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil.BtnAcarreoAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  FQRMAESTRO.SetAcarreo(Not FQRMAESTRO.ACARREO, ['CODIGO_PERFIL'], [FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString]);
//  If Not FQRMAESTRO.ACARREO Then
//    BtnAcarreo.Hint := 'Acarreo Inactivo'
//  Else
//    BtnAcarreo.Hint := 'Acarreo Activo';
end;


procedure TFrIWPerfil.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  If FQRMAESTRO.Mode_Edition Then
    FQRMAESTRO.QR.Cancel;
  Release_Me;
end;

procedure TFrIWPerfil.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;

procedure TFrIWPerfil.BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el código del perfil', Self.Name + '.Resultado_Codigo', 'Perfíl', FQRMAESTRO.QR.FieldByName('CODIGO_PERFIL').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWPerfil_Enc.BTNCODIGOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWPerfil.BtnGridAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Perfil_Permiso(CODIGO_PERFIL.Text);
  Release_Me;
end;

procedure TFrIWPerfil.BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre del usuario', Self.Name + '.Resultado_Nombre', 'Nombre', FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWPerfil_Enc.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;

end.
