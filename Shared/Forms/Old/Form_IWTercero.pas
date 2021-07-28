unit Form_IWTercero;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompTabControl, IWCompJQueryWidget, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, UtConexion, Data.DB, IWCompGrids,
  IWDBStdCtrls, IWCompEdit, IWCompCheckbox, IWCompMemo, IWDBExtCtrls,
  IWCompButton, IWCompListbox, UtTypeTEST_TR, UtGrid_JQ, UtNavegador_ASE;

type
  TFrIWTercero = class(TIWAppForm)
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
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWLabel4: TIWLabel;
    IWLabel5: TIWLabel;
    BTNCODIGO: TIWImage;
    BTNNOMBRE: TIWImage;
    NOMBRE: TIWDBLabel;
    CODIGO_TERCERO: TIWDBLabel;
    BTNDIRECCION: TIWImage;
    DIRECCION: TIWDBLabel;
    TELEFONO: TIWDBLabel;
    BTNTELEFONO: TIWImage;
    BTNCONTACTO: TIWImage;
    CONTACTO: TIWDBLabel;
    OBSERVACION: TIWDBMemo;
    BTNOBSERVACION: TIWImage;
    BTNACTIVO: TIWImage;
    lbNombre_Activo: TIWLabel;
    IWRegion_Navegador: TIWRegion;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCONTACTOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNTELEFONOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNOBSERVACIONAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDIRECCIONAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCNX : TConexion;
    FINFO : String;

    FQRMAESTRO : TMANAGER_DATA;
    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;

    FCODIGO_TERCERO : String;
    Procedure Release_Me;

    Function Existe_Tercero(Const pCODIGO_TERCERO : String) : Boolean;

    procedure Resultado_Codigo(EventParams: TStringList);
    procedure Resultado_Nombre(EventParams: TStringList);
    procedure Resultado_Contacto(EventParams: TStringList);
    procedure Resultado_Direccion(EventParams: TStringList);
    procedure Resultado_Telefono(EventParams: TStringList);
    procedure Resultado_Observacion(EventParams: TStringList);
    procedure Resultado_Activo(EventParams: TStringList);

    Procedure Validar_Campos_Master(pSender : TObject);
    Function Documento_Activo : Boolean;

    Procedure NewRecordMaster(pSender : TObject);
    Procedure DsDataChangeMaster(pSender : TObject);
    Procedure DsStateMaster(pSender : TObject);

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

Procedure TFrIWTercero.Release_Me;
Begin
  Self.Release;
End;

procedure TFrIWTercero.Resultado_Codigo(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString := Justificar(EventParams.Values['InputStr'], ' ', FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.Resultado_Codigo, ' + e.Message);
  End;
End;

procedure TFrIWTercero.Resultado_Nombre(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.Resultado_Nombre, ' + e.Message);
  End;
End;

procedure TFrIWTercero.Resultado_Contacto(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('CONTACTO').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.Resultado_Contacto, ' + e.Message);
  End;
End;

procedure TFrIWTercero.Resultado_Direccion(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
      FQRMAESTRO.QR.FieldByName('DIRECCION').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.Resultado_Direccion, ' + e.Message);
  End;
End;

procedure TFrIWTercero.Resultado_Telefono(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
      FQRMAESTRO.QR.FieldByName('TELEFONO').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.Resultado_Telefono, ' + e.Message);
  End;
End;

procedure TFrIWTercero.Resultado_Observacion(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
      FQRMAESTRO.QR.FieldByName('OBSERVACION').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.Resultado_Observacion, ' + e.Message);
  End;
End;

procedure TFrIWTercero.Resultado_Activo(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition Then
      FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString := IfThen(Result_Is_OK(EventParams.Values['RetValue']), 'S', 'N');
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.Resultado_Activo, ' + e.Message);
  End;
End;

Function TFrIWTercero.Existe_Tercero(Const pCODIGO_TERCERO : String) : Boolean;
Begin
  Result := FCNX.Record_Exist(Retornar_Info_Tabla(Id_Tercero).Name, ['CODIGO_TERCERO'], [pCODIGO_TERCERO]);
End;

Procedure TFrIWTercero.Validar_Campos_Master(pSender : TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    NOMBRE.BGColor := UserSession.COLOR_OK;
    CODIGO_TERCERO.BGColor := UserSession.COLOR_OK;

    If BTNCODIGO.Visible And FCNX.Record_Exist(Retornar_Info_Tabla(Id_Tercero).Name, ['CODIGO_TERCERO'], [FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString]) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Tercero ya existe';
      CODIGO_TERCERO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNCODIGO.Visible And Vacio(FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Tercero invalido';
      CODIGO_TERCERO.BGColor := UserSession.COLOR_ERROR;
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
      UtLog_Execute('TFrIWTercero.Validar_Campos_Master, ' + E.Message);
  End;
End;

Procedure TFrIWTercero.Estado_Controles;
Begin
  BTNCODIGO.Visible      := (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  BTNNOMBRE.Visible      := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNDIRECCION.Visible   := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNTELEFONO.Visible    := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNCONTACTO.Visible    := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNOBSERVACION.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNACTIVO.Visible      := FQRMAESTRO.Mode_Edition And Documento_Activo;

  DATO.Visible          := (Not FQRMAESTRO.Mode_Edition);
//  BTNBUSCAR.Visible     := (Not FQRMAESTRO.Mode_Edition);
  PAG_00.Visible        := (Not FQRMAESTRO.Mode_Edition);
  PAG_01.Visible        := True;
End;

Procedure TFrIWTercero.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try
    lbNombre_Activo.Caption := IfThen(FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString = 'S', 'Activo', 'No activo');
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWTercero.SetLabel, ' + E.Message);
    End;
  End;
End;

Function TFrIWTercero.Documento_Activo : Boolean;
Begin
  Try
    Result := True;
    //Result := (FQRMAESTRO.RecordCount >= 1) {And (Trim(FQRMAESTRO.FieldByName('ID_ANULADO').AsString) <> 'S')};
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWTercero.Documento_Activo, ' + E.Message);
    End;
  End;
End;

procedure TFrIWTercero.DsDataChangeMaster(pSender : TObject);
Var
  lNumero_Documento : String;
begin
  FNAVEGADOR.UpdateState;
  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString + ', ' + FQRMAESTRO.QR.FieldByName('NOMBRE').AsString + ' ] ';

  Try
    SetLabel;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWTercero.DsDataChangeMaster, ' + E.Message);
    End;
  End;
end;

Procedure TFrIWTercero.DsStateMaster(pSender : TObject);
Begin
  Estado_Controles;
  If FQRMAESTRO.Mode_Edition Then
    PAGINAS.ActivePage := 1;
  Case FQRMAESTRO.DS.State Of
    dsInsert : Begin
//                 If CODIGO_TERCERO.Enabled Then
//                   CODIGO_TERCERO.SetFocus;
               End;
    dsEdit   : Begin
//                 If NOMBRE.Enabled Then
//                   NOMBRE.SetFocus;
               End;
  End;
End;

Function TFrIWTercero.AbrirMaestro(Const pDato : String = '') : Boolean;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(Id_Tercero).Caption;
  Result := False;
  Try
    FQRMAESTRO.Active := False;
    FQRMAESTRO.WHERE := '';
    FQRMAESTRO.SENTENCE := ' SELECT ' + FCNX.Top_Sentence(UserSession.Const_Max_Record) + ' * FROM ' + Retornar_Info_Tabla(Id_Tercero).Name + ' ';
    If Trim(pDato) <> '' Then
    Begin
      FQRMAESTRO.WHERE := ' WHERE CODIGO_TERCERO LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' OR NOMBRE LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
    End;
    FQRMAESTRO.ORDER := ' ORDER BY CODIGO_TERCERO ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
    If Result Then
    Begin

    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWTercero.AbrirMaestro, ' + E.Message);
    End;
  End;
  FGRID_MAESTRO.RefreshData;
End;

procedure TFrIWTercero.IWAppFormCreate(Sender: TObject);
Var
  lI : Integer;
begin
  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(Id_Tercero).Caption;
  Randomize;
  Self.Name := 'Tercero' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Codigo'     , Resultado_Codigo     );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Nombre'     , Resultado_Nombre     );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Contacto'   , Resultado_Contacto   );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Direccion'  , Resultado_Direccion  );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Telefono'   , Resultado_Telefono   );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Observacion', Resultado_Observacion);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Activo'     , Resultado_Activo     );
  Try
    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;
    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;

    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Tercero).Name, Retornar_Info_Tabla(Id_Tercero).Caption);

    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_BEFORE_POST  := Validar_Campos_Master;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;

    CODIGO_TERCERO.DataSource := FQRMAESTRO.DS;
    NOMBRE.DataSource         := FQRMAESTRO.DS;
    DIRECCION.DataSource      := FQRMAESTRO.DS;
    TELEFONO.DataSource       := FQRMAESTRO.DS;
    CONTACTO.DataSource       := FQRMAESTRO.DS;
    OBSERVACION.DataSource    := FQRMAESTRO.DS;

    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['CODIGO_TERCERO', 'NOMBRE'     ],
                                         ['Tercero'       , 'Nombre'     ],
                                         ['S'             , 'N'          ],
                                         [100             , 550          ],
                                         [taRightJustify  , taLeftJustify]);


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
      UtLog_Execute('TFrIWTercero.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWTercero.IWAppFormDestroy(Sender: TObject);
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
        UtLog_Execute('TFrIWTercero.IWAppFormDestroy, ' + e.Message);
    End;
end;

procedure TFrIWTercero.NewRecordMaster(pSender : TObject);
begin
  Try
//    If CHECK_ACARREO.Checked And (Not Vacio(FCODIGO_TERCERO)) Then
//      UtAcarreo_Execute(Retornar_Info_Tabla(Id_Tercero).Name, ['CODIGO_TERCERO'], [FCODIGO_TERCERO], FQRMAESTRO.QR);
    FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString := 'S';
//    FQRMAESTRO.FieldByName('CODIGO_TERCERO' ).AsString := UserSession.DataMain.CNX.Next(Retornar_Info_Tabla(Id_Tercero).Name, '0', ['CODIGO_TERCERO'], [],[], FQRMAESTRO.FieldByName('CODIGO_TERCERO').Size);
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWTercero.NewRecordMaster, ' + E.Message);
    End;
  End;
end;

procedure TFrIWTercero.BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Tercero activo?', Self.Name + '.Resultado_Activo', 'Activo', 'Sí', 'No')
end;

procedure TFrIWTercero.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Release_Me;
end;

procedure TFrIWTercero.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;


procedure TFrIWTercero.BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la cédula o nit del tercero', Self.Name + '.Resultado_Codigo', 'Cédula/NIT', FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.BTNCODIGOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWTercero.BTNCONTACTOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el contacto del tercero', Self.Name + '.Resultado_Contacto', 'Contacto', FQRMAESTRO.QR.FieldByName('CONTACTO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.BTNCONTACTOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWTercero.BTNDIRECCIONAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la dirección', Self.Name + '.Resultado_Direccion', 'Dirección', FQRMAESTRO.QR.FieldByName('DIRECCION').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.BTNDIRECCIONAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWTercero.BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre del tercero', Self.Name + '.Resultado_Nombre', 'Nombre', FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWTercero.BTNOBSERVACIONAsyncClick(Sender: TObject; EventParams: TStringList);
Var
  ltmp : String;
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      ltmp := FQRMAESTRO.QR.FieldByName('OBSERVACION').AsString;
      WebApplication.ShowPrompt('Ingrese la observación', Self.Name + '.Resultado_Observacion', 'Observación', ltmp);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.BTNOBSERVACIONAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWTercero.BTNTELEFONOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el telefono', Self.Name + '.Resultado_Telefono', 'Telefono', FQRMAESTRO.QR.FieldByName('TELEFONO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWTercero.BTNTELEFONOAsyncClick, ' + e.Message);
  End;
end;

end.
