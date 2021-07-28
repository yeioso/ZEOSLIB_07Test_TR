unit Form_IWPerfil_Permiso;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWCompExtCtrls, IWCompEdit, IWDBStdCtrls,
  IWCompCheckbox, Vcl.Controls, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompLabel, IWCompGrids,
  UtConexion, Vcl.Forms, IWVCLBaseContainer, IWContainer,
  IWHTMLContainer, IWHTML40Container, IWRegion, IWCompListbox, UtGrid_JQ;

type
  TFrIWPerfil_Permiso = class(TIWAppForm)
    BTNADD: TIWImage;
    BTNEDIT: TIWImage;
    BTNDEL: TIWImage;
    BTNSAVE: TIWImage;
    BTNCANCEL: TIWImage;
    BTNEXIT: TIWImage;
    DATO: TIWEdit;
    IWLabel23: TIWLabel;
    IWLabel25: TIWLabel;
    NOMBRE: TIWDBComboBox;
    CONSECUTIVO: TIWDBLabel;
    BTNACTIVO: TIWImage;
    lbNombre_Activo: TIWLabel;
    procedure BTNEXITAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNADDAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNEDITAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDELAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNSAVEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCANCELAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure DATOAsyncKeyUp(Sender: TObject; EventParams: TStringList);
    procedure BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FQRDETALLE : TMANAGER_DATA;
    FGRID_MAESTRO : TGRID_JQ;
    FEJECUTANDO_ONCHANGE : Boolean;
    FCODIGO_PERFIL : String;
    Procedure Confirmacion_Guardar(EventParams: TStringList);
    Procedure Confirmacion_Eliminacion(EventParams: TStringList);
    procedure Resultado_Activo(EventParams: TStringList);
    Procedure Release_Me;
    Procedure Validar_Campos_Detalle(pSender: TObject);
    procedure NewRecordDetalle(pSender: TObject);
    procedure DsDataChangeDetalle(pSender: TObject);
    procedure DsStateChangeDetalle(pSender: TObject);
    Function AbrirDetalle(Const pDato : String  = '') : Boolean;
  public
    Constructor Create(AOwner: TComponent; const pCodigo_Perfil : String);
    Destructor Destroy; override;
  end;

implementation
{$R *.dfm}
Uses
  db,
  Math,
  UtLog,
  StrUtils,
  Variants,
  UtFuncion,
  UtInfoTablas,
  ServerController;

{ TFrIWPerfil_Permiso }

Procedure TFrIWPerfil_Permiso.Confirmacion_Guardar(EventParams: TStringList);
var
  Response: Boolean;
  SelectedButton: string;
  MsgType: TIWNotifyType;
begin
  // Confirm callback has 1 main parameters:
  // RetValue (Boolean), indicates if the first button (Yes/OK/custom) was choosen
  Response := Result_Is_OK(EventParams.Values['RetValue']);
  If Response Then
  Begin
    SelectedButton := 'Yes';
    MsgType := ntSuccess;
    Try
      FQRDETALLE.QR.Post;
      WebApplication.ShowNotification('Registro almacenado', MsgType);
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWPerfil_Permiso.Confirmacion_Guardar, ' + E.Message);
    End;
  End
  Else
  Begin
    SelectedButton := 'No';
    MsgType := ntError;
  end;
//  WebApplication.ShowNotification('This is the callback. ' + 'The selected button was: ' + SelectedButton, MsgType);
end;

Procedure TFrIWPerfil_Permiso.Confirmacion_Eliminacion(EventParams: TStringList);
var
  Response: Boolean;
  SelectedButton: string;
  MsgType: TIWNotifyType;
begin
  // Confirm callback has 1 main parameters:
  // RetValue (Boolean), indicates if the first button (Yes/OK/custom) was choosen
  Response := Result_Is_OK(EventParams.Values['RetValue']);
  If Response Then
  Begin
    SelectedButton := 'Yes';
    MsgType := ntSuccess;
    Try
      FQRDETALLE.QR.Delete;
      WebApplication.ShowNotification('Registro eliminado', MsgType);
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWPerfil_Permiso.Confirmacion_Guardar, ' + E.Message);
    End;
  End
  Else
  Begin
    SelectedButton := 'No';
    MsgType := ntError;
  end;
//  WebApplication.ShowNotification('This is the callback. ' + 'The selected button was: ' + SelectedButton, MsgType);
end;

procedure TFrIWPerfil_Permiso.BTNDELAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Está seguro(a) de eliminar?', Self.Name + '.Confirmacion_Eliminacion', 'Eliminar', 'Sí', 'No');
end;

procedure TFrIWPerfil_Permiso.BTNSAVEAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Validar_Campos_Detalle(Sender);
  If FQRDETALLE.ERROR = 0 Then
    WebApplication.ShowConfirm('Está seguro(a) de guardar?', Self.Name + '.Confirmacion_Guardar', 'Guardar', 'Sí', 'No')
  Else
    UserSession.SetMessage(FQRDETALLE.LAST_ERROR, True);
end;

procedure TFrIWPerfil_Permiso.Resultado_Activo(EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition Then
      FQRDETALLE.QR.FieldByName('HABILITA_OPCION').AsString := IfThen(Result_Is_OK(EventParams.Values['RetValue']), 'S', 'N');
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWPerfil_Permiso.Resultado_Activo, ' + e.Message);
  End;
End;

constructor TFrIWPerfil_Permiso.Create(AOwner: TComponent; const pCodigo_Perfil : String);
Var
  lI : Integer;
begin
  Inherited Create(AOwner);
  Try
    Randomize;
    Self.Name := 'PERFIL_PERMISO' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
    WebApplication.RegisterCallBack(Self.Name + '.Confirmacion_Guardar'    , Confirmacion_Guardar    );
    WebApplication.RegisterCallBack(Self.Name + '.Confirmacion_Eliminacion', Confirmacion_Eliminacion);
    WebApplication.RegisterCallBack(Self.Name + '.Resultado_Activo'        , Resultado_Activo        );
    NOMBRE.Items.Clear;
    For lI := Low(UserSession.PERMISOS_APP) To High(UserSession.PERMISOS_APP) Do
      NOMBRE.Items.Add(UserSession.PERMISOS_APP[lI]);

    FCODIGO_PERFIL := pCodigo_Perfil;

    FGRID_MAESTRO        := TGRID_JQ.Create(Self);
    FGRID_MAESTRO.Parent := Self;

    FGRID_MAESTRO.Top    := DATO.Top + DATO.Height + 3;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := DATO.Width;
    FGRID_MAESTRO.Height := 300;


    FQRDETALLE := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Permiso_App).Name, Retornar_Info_Tabla(Id_Permiso_App).Caption);
    FQRDETALLE.ON_NEW_RECORD   := NewRecordDetalle;
    FQRDETALLE.ON_BEFORE_POST  := Validar_Campos_Detalle;
    FQRDETALLE.ON_DATA_CHANGE  := DsDataChangeDetalle;
    FQRDETALLE.ON_STATE_CHANGE := DsStateChangeDetalle;

    CONSECUTIVO.DataSource     := FQRDETALLE.DS;
    NOMBRE.DataSource          := FQRDETALLE.DS;

    FGRID_MAESTRO.VisibleRowCount := 11;
    FGRID_MAESTRO.SetGrid(FQRDETALLE.DS, ['CONSECUTIVO' , 'NOMBRE'     , 'HABILITA_OPCION'],
                                         ['Código'      , 'Nombre'     , 'Activo'         ],
                                         ['S'           , 'N'          , 'N'              ],
                                         [100           , 150          , 100              ],
                                         [taRightJustify, taLeftJustify, taCenter         ]);
    AbrirDetalle;

  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.Create, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil_Permiso.DATOAsyncKeyUp(Sender: TObject; EventParams: TStringList);
begin
  AbrirDetalle(DATO.Text);
end;

destructor TFrIWPerfil_Permiso.Destroy;
begin
  Try
    If Assigned(FQRDETALLE) Then
    Begin
      FQRDETALLE.Active := False;
      FreeAndNil(FQRDETALLE);
    End;

    If Assigned(FGRID_MAESTRO) Then
      FreeAndNil(FGRID_MAESTRO);
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.Destroy, ' + E.Message);
    End;
  End;
  inherited;
end;

Procedure TFrIWPerfil_Permiso.Release_Me;
Begin
  Self.Release;
End;

procedure TFrIWPerfil_Permiso.BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Esta activo?', Self.Name + '.Resultado_Activo', 'Activo', 'Sí', 'No')
end;

procedure TFrIWPerfil_Permiso.BTNADDAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    FQRDETALLE.QR.Append;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.BTNADDAsyncClick, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil_Permiso.BTNCANCELAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    FQRDETALLE.QR.Cancel;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.BTNCANCELAsyncClick, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil_Permiso.BTNEDITAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    FQRDETALLE.QR.Edit;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.BTNEDITAsyncClick, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil_Permiso.BTNEXITAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Perfil(FCODIGO_PERFIL);
  Release_Me;
end;

Function TFrIWPerfil_Permiso.AbrirDetalle(Const pDato : String  = '') : Boolean;
Begin
  Result := False;
  Try
    FQRDETALLE.Active := False;
    FQRDETALLE.SENTENCE := ' SELECT * FROM ' + Retornar_Info_Tabla(Id_Permiso_App).Name + ' (nolock) ';
    FQRDETALLE.WHERE    := ' WHERE ' + UserSession.CNX.Trim_Sentence('CODIGO_PERFIL') + ' = ' + QuotedStr(Trim(FCODIGO_PERFIL));
    If Not Vacio(pDato) Then
    Begin
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' AND ( ';
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + '  ' + UserSession.CNX.Trim_Sentence('NOMBRE') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' OR ' + UserSession.CNX.Trim_Sentence('HABILITA_OPCION') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' ) ';
    End;
    FQRDETALLE.Active := True;
    Result := FQRDETALLE.Active;
    If Result Then
    Begin
    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.AbrirDetalle, ' + E.Message);
    End;
  End;
End;

Procedure TFrIWPerfil_Permiso.Validar_Campos_Detalle(pSender: TObject);
Var
  lMensaje : String;
Begin
  FQRDETALLE.ERROR := 0;
  Try
    lMensaje := '';
    CONSECUTIVO.BGColor := UserSession.COLOR_OK;
    NOMBRE.BGColor := UserSession.COLOR_OK;

    If NOMBRE.Enabled And Vacio(FQRDETALLE.QR.FieldByName('NOMBRE').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Nombre invalido';
      NOMBRE.BGColor := UserSession.COLOR_ERROR;
    End;

    FQRDETALLE.ERROR := IfThen(Vacio(lMensaje), 0, -1);
    If FQRDETALLE.ERROR <> 0 Then
    Begin
      FQRDETALLE.LAST_ERROR := 'Datos invalidos, ' + lMensaje;
      UserSession.SetMessage(FQRDETALLE.LAST_ERROR, True);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWPerfil_Permiso.Validar_Campos_Detalle, ' + E.Message);
  End;
End;

procedure TFrIWPerfil_Permiso.NewRecordDetalle(pSender: TObject);
begin
  Inherited;
  Try
    FQRDETALLE.QR.FieldByName('CODIGO_PERFIL'  ).AsString := FCODIGO_PERFIL;
    FQRDETALLE.QR.FieldByName('CONSECUTIVO'    ).AsString := UserSession.CNX.Next(Retornar_Info_Tabla(Id_Permiso_App).Name, '0', ['CONSECUTIVO'], [],[], FQRDETALLE.QR.FieldByName('CODIGO_PERFIL').Size);
    FQRDETALLE.QR.FieldByName('HABILITA_OPCION').AsString := 'S';
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.NewRecordDetalle, ' + E.Message);
    End;
  End;
end;

procedure TFrIWPerfil_Permiso.DsDataChangeDetalle(pSender: TObject);
Begin
  Try
    lbNombre_Activo.Caption := IfThen(FQRDETALLE.QR.FieldByName('HABILITA_OPCION').AsString = 'S', 'Esta activo', 'No esta activo');
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWPerfil_Permiso.DsDataChangeDetalle, ' + E.Message);
    End;
  End;
End;

procedure TFrIWPerfil_Permiso.DsStateChangeDetalle(pSender: TObject);
Begin
  BTNADD.Visible       := Not FQRDETALLE.Mode_Edition;
  BTNDEL.Visible       := FQRDETALLE.ACTIVE and (Not FQRDETALLE.Mode_Edition) And (FQRDETALLE.QR.RecordCount > 0);
  BTNEDIT.Visible      := Not FQRDETALLE.Mode_Edition;
  BTNSAVE.Visible      := FQRDETALLE.Mode_Edition;
  BTNCANCEL.Visible    := FQRDETALLE.Mode_Edition;
  DATO.Visible         := Not FQRDETALLE.Mode_Edition;

  NOMBRE.Enabled       := FQRDETALLE.DS.State In [dsInsert, dsEdit];
  NOMBRE.Editable      := FQRDETALLE.DS.State In [dsInsert, dsEdit];
  BTNACTIVO.Visible    := FQRDETALLE.DS.State In [dsInsert, dsEdit];
End;

end.
