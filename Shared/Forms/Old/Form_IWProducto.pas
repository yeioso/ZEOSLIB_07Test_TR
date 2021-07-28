unit Form_IWProducto;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompTabControl, IWCompJQueryWidget, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, UtConexion, Data.DB, IWCompGrids,
  IWDBStdCtrls, IWCompEdit, IWCompCheckbox, IWCompMemo, IWDBExtCtrls,
  IWCompButton, IWCompListbox, UtTypeUPL, UtGrid_JQ, UtNavegador_ASE;

type
  TFrIWProducto = class(TIWAppForm)
    RINFO: TIWRegion;
    lbInfo: TIWLabel;
    IWRegion1: TIWRegion;
    PAGINAS: TIWTabControl;
    PAG_00: TIWTabPage;
    PAG_01: TIWTabPage;
    IWModalWindow1: TIWModalWindow;
    RNAVEGADOR: TIWRegion;
    IWLabel1: TIWLabel;
    IWLabel8: TIWLabel;
    DATO: TIWEdit;
    IWLabel2: TIWLabel;
    BTNACTIVO: TIWImage;
    lbNombre_Activo: TIWLabel;
    CODIGO_PRODUCTO: TIWDBLabel;
    BTNCODIGO: TIWImage;
    UNIDAD_MEDIDA: TIWDBLabel;
    BTNUNIDAD: TIWImage;
    BTNNOMBRE: TIWImage;
    NOMBRE: TIWDBLabel;
    IWRegion_Navegador: TIWRegion;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNUNIDADAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCNX : TConexion;
    FINFO : String;
    FQRMAESTRO : TMANAGER_DATA;

    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;

    FCODIGO_PRODUCTO : String;

    procedure Resultado_Codigo(EventParams: TStringList);
    procedure Resultado_Unidad(EventParams: TStringList);
    procedure Resultado_Nombre(EventParams: TStringList);
    procedure Resultado_Activo(EventParams: TStringList);

    Procedure Release_Me;

    Function Existe_Producto(Const pCODIGO_PRODUCTO : String) : Boolean;

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

Procedure TFrIWProducto.Release_Me;
Begin
  Self.Release;
End;

procedure TFrIWProducto.Resultado_Codigo(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('CODIGO_PRODUCTO').AsString := Justificar(EventParams.Values['InputStr'], ' ', FQRMAESTRO.QR.FieldByName('CODIGO_PRODUCTO').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProducto.Resultado_Codigo, ' + e.Message);
  End;
End;

procedure TFrIWProducto.Resultado_Nombre(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProducto.Resultado_Nombre, ' + e.Message);
  End;
End;

procedure TFrIWProducto.Resultado_Unidad(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('UNIDAD_MEDIDA').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProducto.Resultado_Unidad, ' + e.Message);
  End;
End;

procedure TFrIWProducto.Resultado_Activo(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition Then
      FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString := IfThen(Result_Is_OK(EventParams.Values['RetValue']), 'S', 'N');
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProducto.Resultado_Activo, ' + e.Message);
  End;
End;

Function TFrIWProducto.Existe_Producto(Const pCODIGO_PRODUCTO : String) : Boolean;
Begin
  Result := UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Producto).Name, ['CODIGO_PRODUCTO'], [pCODIGO_PRODUCTO]);
End;

Procedure TFrIWProducto.Validar_Campos_Master(pSender : TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    NOMBRE.BGColor := UserSession.COLOR_OK;
    CODIGO_PRODUCTO.BGColor := UserSession.COLOR_OK;

    If BTNCODIGO.Visible And UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Producto).Name, ['CODIGO_PRODUCTO', 'UNIDAD_MEDIDA'], [FQRMAESTRO.QR.FieldByName('CODIGO_PRODUCTO').AsString, FQRMAESTRO.QR.FieldByName('UNIDAD_MEDIDA').AsString]) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Producto ya existe';
      CODIGO_PRODUCTO.BGColor := UserSession.COLOR_ERROR;
      UNIDAD_MEDIDA.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNCODIGO.Visible And Vacio(FQRMAESTRO.QR.FieldByName('CODIGO_PRODUCTO').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Codigo producto invalido';
      CODIGO_PRODUCTO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNUNIDAD.Visible And Vacio(FQRMAESTRO.QR.FieldByName('UNIDAD_MEDIDA').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Unidad de medida invalida';
      UNIDAD_MEDIDA.BGColor := UserSession.COLOR_ERROR;
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
      UtLog_Execute('TFrIWProducto.Validar_Campos_Master, ' + E.Message);
  End;
End;

Procedure TFrIWProducto.Estado_Controles;
Begin
  BTNCODIGO.Visible := (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  BTNUNIDAD.Visible := (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  BTNNOMBRE.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNACTIVO.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;
  DATO.Visible      := (Not FQRMAESTRO.Mode_Edition);
//  BTNBUSCAR.Visible := (Not FQRMAESTRO.Mode_Edition);
  PAG_00.Visible    := (Not FQRMAESTRO.Mode_Edition);
  PAG_01.Visible    := True;
End;

Procedure TFrIWProducto.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try
    lbNombre_Activo.Caption := IfThen(FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString = 'S', 'Activo', 'No activo');
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProducto.SetLabel, ' + E.Message);
    End;
  End;
End;

Function TFrIWProducto.Documento_Activo : Boolean;
Begin
  Try
    Result := True;
    //Result := (FQRMAESTRO.RecordCount >= 1) {And (Trim(FQRMAESTRO.FieldByName('ID_ANULADO').AsString) <> 'S')};
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProducto.Documento_Activo, ' + E.Message);
    End;
  End;
End;

procedure TFrIWProducto.DsDataChangeMaster(pSender : TObject);
begin
  FNAVEGADOR.UpdateState;
  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + Trim(FQRMAESTRO.QR.FieldByName('CODIGO_PRODUCTO').AsString) + ', ' +
                                      Trim(FQRMAESTRO.QR.FieldByName('UNIDAD_MEDIDA'  ).AsString) + ', ' +
                                      Trim(FQRMAESTRO.QR.FieldByName('NOMBRE'         ).AsString) +
                              ' ] ';

  Try
    SetLabel;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProducto.DsDataChangeMaster, ' + E.Message);
    End;
  End;
end;

Procedure TFrIWProducto.DsStateMaster(pSender : TObject);
Begin
  Estado_Controles;
  If FQRMAESTRO.Mode_Edition Then
    PAGINAS.ActivePage := 1;
  Case FQRMAESTRO.DS.State Of
    dsInsert : Begin
//                 If CODIGO_PRODUCTO.Enabled Then
//                   CODIGO_PRODUCTO.SetFocus;
               End;
    dsEdit   : Begin
//                 If NOMBRE.Enabled Then
//                   NOMBRE.SetFocus;
               End;
  End;
End;

Function TFrIWProducto.AbrirMaestro(Const pDato : String = '') : Boolean;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(Id_Producto).Caption;
  Result := False;
  Try
    FQRMAESTRO.Active := False;
    FQRMAESTRO.WHERE := '';
    FQRMAESTRO.SENTENCE := ' SELECT ' + UserSession.CNX.Top_Sentence(UserSession.Const_Max_Record) + ' * FROM ' + Retornar_Info_Tabla(Id_Producto).Name + ' ';
    If Trim(pDato) <> '' Then
    Begin
      FQRMAESTRO.WHERE :=  ' WHERE CODIGO_PRODUCTO LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' OR NOMBRE LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
    End;
    FQRMAESTRO.ORDER := ' ORDER BY CODIGO_PRODUCTO ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
    If Result Then
    Begin

    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProducto.AbrirMaestro, ' + E.Message);
    End;
  End;
  FGRID_MAESTRO.RefreshData;
End;

procedure TFrIWProducto.IWAppFormCreate(Sender: TObject);
Var
  lI : Integer;
begin
  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(Id_Producto).Caption;
  Randomize;
  Self.Name := 'PRODUCTO' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Codigo', Resultado_Codigo);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Unidad', Resultado_Unidad);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Nombre', Resultado_Nombre);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Activo', Resultado_Activo);

  Try
    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;
    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;

    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Producto).Name, Retornar_Info_Tabla(Id_Producto).Caption);

    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_BEFORE_POST  := Validar_Campos_Master;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;

    CODIGO_PRODUCTO.DataSource := FQRMAESTRO.DS;
    UNIDAD_MEDIDA.DataSource   := FQRMAESTRO.DS;
    NOMBRE.DataSource          := FQRMAESTRO.DS;

    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['CODIGO_PRODUCTO', 'UNIDAD_MEDIDA', 'NOMBRE'     ],
                                         ['Producto'       , 'U/M'          , 'Nombre'     ],
                                         ['S'              , 'N'            , 'N'          ],
                                         [100              , 100            , 450          ],
                                         [taRightJustify   , taLeftJustify  , taLeftJustify]);


    FNAVEGADOR               := TNavegador_ASE.Create(IWRegion_Navegador);
    FNAVEGADOR.Parent        := IWRegion_Navegador;
    FNAVEGADOR.SetNavegador(FQRMAESTRO, WebApplication, FGRID_MAESTRO);
    FNAVEGADOR.ACTION_SEARCH := BTNBUSCARAsyncClick ;
//  FNAVEGADOR.ACTION_COPY   := BtnAcarreoAsyncClick;
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
      UtLog_Execute('TFrIWProducto.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWProducto.IWAppFormDestroy(Sender: TObject);
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
        UtLog_Execute('TFrIWProducto.IWAppFormDestroy, ' + e.Message);
    End;
end;

procedure TFrIWProducto.NewRecordMaster(pSender : TObject);
begin
  Try
    FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString := 'S';
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProducto.NewRecordMaster, ' + E.Message);
    End;
  End;
end;

procedure TFrIWProducto.BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Producto activo?', Self.Name + '.Resultado_Activo', 'Activo', 'Sí', 'No')
end;

procedure TFrIWProducto.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Release_Me;
end;

procedure TFrIWProducto.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;

procedure TFrIWProducto.BTNCODIGOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese código producto', Self.Name + '.Resultado_Codigo', 'Producto', FQRMAESTRO.QR.FieldByName('CODIGO_PRODUCTO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProducto.BTNCODIGOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWProducto.BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre del producto', Self.Name + '.Resultado_Nombre', 'Nombre', FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProducto.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWProducto.BTNUNIDADAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la unidad de medida', Self.Name + '.Resultado_Unidad', 'Unidad de medida', FQRMAESTRO.QR.FieldByName('UNIDAD_MEDIDA').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProducto.BTNUNIDADAsyncClick, ' + e.Message);
  End;
end;

end.
