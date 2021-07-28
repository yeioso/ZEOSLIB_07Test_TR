unit Form_IWMovimiento_Det;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWCompExtCtrls, IWCompEdit, IWDBStdCtrls,
  IWCompCheckbox, Vcl.Controls, IWVCLBaseControl, IWBaseControl,
  IWBaseHTMLControl, IWControl, IWCompLabel, IWCompGrids, IWDBGrids,
  UtConexion, Vcl.Forms, IWVCLBaseContainer, IWContainer,  IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompListbox, DB,  IWCompGradButton,
  IWCompMemo, IWBaseComponent, IWBaseHTMLComponent,  IWBaseHTML40Component,
  UtGrid_JQ, UtBusqueda_UPL_IWjQDBGrid;

type
  TFrIWMovimiento_Det = class(TIWAppForm)
    BTNADD: TIWImage;
    BTNEDIT: TIWImage;
    BTNDEL: TIWImage;
    BTNSAVE: TIWImage;
    BTNCANCEL: TIWImage;
    BTNEXIT: TIWImage;
    DATO: TIWEdit;
    IWRREGISTRODETALLE: TIWRegion;
    IWLabel23: TIWLabel;
    IWLabel25: TIWLabel;
    UNIDAD_MEDIDA: TIWDBLabel;
    IWLabel9: TIWLabel;
    IWLabel10: TIWLabel;
    lbFabricacion: TIWLabel;
    lbVencimiento: TIWLabel;
    IWLabel13: TIWLabel;
    IWLabel15: TIWLabel;
    OBSERVACION: TIWDBMemo;
    IWLabel4: TIWLabel;
    BTNADDLOTE: TIWGradButton;
    BTNPRODUCTO: TIWImage;
    CODIGO_PRODUCTO: TIWDBLabel;
    lbNombre_Producto: TIWLabel;
    BTNBODEGA: TIWImage;
    CODIGO_BODEGA: TIWDBLabel;
    lbNombre_Bodega: TIWLabel;
    BTNNOMBRE: TIWImage;
    NOMBRE: TIWDBLabel;
    BTNCANTIDAD: TIWImage;
    CANTIDAD: TIWDBLabel;
    FECHA_FABRICACION: TIWDBLabel;
    FECHA_VENCIMIENTO: TIWDBLabel;
    BTNFABRICACION: TIWImage;
    BTNVENCIMIENTO: TIWImage;
    BTNOBSERVACION: TIWImage;
    BTNACTIVO: TIWImage;
    lbNombre_Activo: TIWLabel;
    CONSECUTIVO: TIWDBLabel;
    IWModalWindow1: TIWModalWindow;
    BTNLOTE: TIWImage;
    LOTE: TIWDBLabel;
    procedure BTNEXITAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNADDAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNEDITAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDELAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNSAVEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCANCELAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure NOMBREAsyncChange(Sender: TObject; EventParams: TStringList);
    procedure DATOAsyncKeyUp(Sender: TObject; EventParams: TStringList);
    procedure BTNEMAILAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNADDLOTEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNOBSERVACIONAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNPRODUCTOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNBODEGAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNFABRICACIONAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNVENCIMIENTOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCANTIDADAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNLOTEAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCNX : TConexion;
    FENC : Integer;
    FDET : Integer;

    FLOTE : String;

    FQRDETALLE : TMANAGER_DATA;
    FGRID_MAESTRO : TGRID_JQ;

    FNUMERO_DOCUMENTO : String;
    FCODIGO_DOCUMENTO_ADM : String;
    procedure Buscar_Info(pSD : TSD; pEvent : TIWAsyncEvent);

    Procedure Confirmacion_Guardar(EventParams: TStringList);
    Procedure Confirmacion_Eliminacion(EventParams: TStringList);

    Procedure Actualizar_Nombre;
    procedure Resultado_Producto(Sender: TObject; EventParams: TStringList);
    procedure Resultado_Bodega(Sender: TObject; EventParams: TStringList);
    procedure Resultado_Nombre(EventParams: TStringList);
    procedure Resultado_Lote(Sender: TObject; EventParams: TStringList);
    procedure Agregar_Lote(EventParams: TStringList);
    procedure Resultado_Fabricacion(EventParams: TStringList);
    procedure Resultado_Vencimiento(EventParams: TStringList);
    procedure Resultado_Cantidad(EventParams: TStringList);
    procedure Resultado_Observacion(EventParams: TStringList);
    procedure Resultado_Activo(EventParams: TStringList);

    Procedure Release_Me;
    Function Existe_Registro(Const pConsecutivo : String) : Boolean;
    Function Existencia_Valida : Boolean;
    Procedure Validar_Campos_Detalle(pSender: TObject);
    Procedure Prellenar_Informacion_Detalle(Sender: TObject; EventParams: TStringList);
    procedure NewRecordDetalle(pSender: TObject);
    procedure AfterPost(pSender: TObject);
    procedure DsDataChangeDetalle(pSender: TObject);
    procedure DsStateChangeDetalle(pSender: TObject);
    Function AbrirDetalle(Const pDato : String  = '') : Boolean;
  public
    Constructor Create(AOwner: TComponent; Const pCodigo_Documento_Adm, pNumero_Documento : String; Const pEnc, pDet : Integer);
    Destructor Destroy; override;
  end;

implementation
{$R *.dfm}
Uses
  Math,
  UtLog,
  StrUtils,
  Variants,
  UtFuncion,
  UtInfoTablas,
  ServerController;

procedure TFrIWMovimiento_Det.Buscar_Info(pSD : TSD; pEvent : TIWAsyncEvent);
Var
  lBusqueda : TBusqueda_Ercol_WjQDBGrid;
begin
  Try
    lBusqueda := TBusqueda_Ercol_WjQDBGrid.Create(Self);
    lBusqueda.Parent := Self;
    lBusqueda.SetComponents(FCNX, pEvent);
    lBusqueda.SetTSD(pSD);
    Case pSD Of
      TSD.TSD_Lote : Begin
                       lBusqueda.FILTRO   := [FCNX.Trim_Sentence('X.CODIGO_PRODUCTO') + ' = ' + QuotedStr(Trim(FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO').AsString)),
                                              FCNX.Trim_Sentence('X.UNIDAD_MEDIDA'  ) + ' = ' + QuotedStr(Trim(FQRDETALLE.QR.FieldByName('UNIDAD_MEDIDA'  ).AsString))];
                       lBusqueda.CONECTOR := [' AND ', ' AND '];
                     End;
    End;
    If lBusqueda.Abrir_Tabla Then
    Begin
      IWModalWindow1.Reset;
      IWModalWindow1.Buttons.CommaText := '&Cancelar';
      IWModalWindow1.Title := 'Busqueda de datos';
      IWModalWindow1.ContentElement := lBusqueda;
      IWModalWindow1.Autosize := True;
      IWModalWindow1.Draggable := True;
      IWModalWindow1.WindowTop := 10;
      IWModalWindow1.WindowLeft := 10;
      IWModalWindow1.WindowWidth := lBusqueda.Width + 20;
      IWModalWindow1.WindowHeight := lBusqueda.Height + 200;
      IWModalWindow1.OnAsyncClick := lBusqueda.Finish_Manager;
      IWModalWindow1.OnAsyncClose := lBusqueda.Finish_Manager;
      IWModalWindow1.SizeUnit := suPixel;
      IWModalWindow1.Show;
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Buscar_Info, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento_Det.Confirmacion_Guardar(EventParams: TStringList);
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
      FGRID_MAESTRO.RefreshData;
      WebApplication.ShowNotification('Registro almacenado', MsgType);
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWMovimiento_Det.Confirmacion_Guardar, ' + E.Message);
    End;
  End
  Else
  Begin
    SelectedButton := 'No';
    MsgType := ntError;
  end;
//  WebApplication.ShowNotification('This is the callback. ' + 'The selected button was: ' + SelectedButton, MsgType);
end;

Procedure TFrIWMovimiento_Det.Confirmacion_Eliminacion(EventParams: TStringList);
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
      FGRID_MAESTRO.Refresh;
      WebApplication.ShowNotification('Registro eliminado', MsgType);
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWMovimiento_Det.Confirmacion_Guardar, ' + E.Message);
    End;
  End
  Else
  Begin
    SelectedButton := 'No';
    MsgType := ntError;
  end;
//  WebApplication.ShowNotification('This is the callback. ' + 'The selected button was: ' + SelectedButton, MsgType);
end;

Procedure TFrIWMovimiento_Det.Actualizar_Nombre;
Begin
  Try
    If FQRDETALLE.Mode_Edition  Then
    Begin
      FQRDETALLE.QR.FieldByName('NOMBRE').AsString := Trim(FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO').AsString) + ', ' +
                                                      Trim(lbNombre_Producto.Caption) + ', ' +
                                                      Trim(FQRDETALLE.QR.FieldByName('LOTE').AsString) + ', ' +
                                                      Trim(lbNombre_Bodega.Caption  );
      FQRDETALLE.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(FQRDETALLE.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Actualizar_Nombre, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Producto(Sender: TObject; EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      FQRDETALLE.QR.FieldByName('UNIDAD_MEDIDA'  ).AsString := EventParams.Values['UNIDAD_MEDIDA'  ];
      FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO').AsString := EventParams.Values['CODIGO_PRODUCTO'];
      Actualizar_Nombre;
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Producto, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Bodega(Sender: TObject; EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      FQRDETALLE.QR.FieldByName('CODIGO_BODEGA').AsString := EventParams.Values['CODIGO_BODEGA'];
      Actualizar_Nombre;
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Bodega, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Nombre(EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRDETALLE.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Nombre, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Lote(Sender: TObject; EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      FQRDETALLE.QR.FieldByName('LOTE').AsString := AnsiUpperCase(Trim(EventParams.Values['LOTE']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Lote, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Fabricacion(EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRDETALLE.QR.FieldByName('FECHA_FABRICACION').AsString := EventParams.Values['InputStr'];
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Fabricacion, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Vencimiento(EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRDETALLE.QR.FieldByName('FECHA_VENCIMIENTO').AsString := EventParams.Values['InputStr'];
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Vencimiento, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Cantidad(EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRDETALLE.QR.FieldByName('CANTIDAD').AsFloat := SetToFloat(EventParams.Values['InputStr']);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Cantidad, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Observacion(EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRDETALLE.QR.FieldByName('OBSERVACION').AsString := EventParams.Values['InputStr'];
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Observacion, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Agregar_Lote(EventParams: TStringList);
Var
  InputValue: string;
Begin
  Try
    If FQRDETALLE.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      InputValue := Trim(EventParams.Values['InputStr']);
      InputValue := AnsiUpperCase(InputValue);
      FQRDETALLE.QR.FieldByName('LOTE').AsString := InputValue;
      Actualizar_Nombre;
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Agregar_Lote, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.Resultado_Activo(EventParams: TStringList);
Begin
  Try
    If FQRDETALLE.Mode_Edition Then
      FQRDETALLE.QR.FieldByName('ID_ACTIVO').AsString := IfThen(Result_Is_OK(EventParams.Values['RetValue']), 'S', 'N');
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Resultado_Activo, ' + e.Message);
  End;
End;

procedure TFrIWMovimiento_Det.BTNDELAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Está seguro(a) de eliminar?', Self.Name + '.Confirmacion_Eliminacion', 'Eliminar', 'Sí', 'No');
end;

procedure TFrIWMovimiento_Det.BTNSAVEAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Validar_Campos_Detalle(Sender);
  If FQRDETALLE.ERROR = 0 Then
    WebApplication.ShowConfirm('Está seguro(a) de guardar?', Self.Name + '.Confirmacion_Guardar', 'Guardar', 'Sí', 'No')
  Else
    UserSession.SetMessage(FQRDETALLE.LAST_ERROR, True);

end;

procedure TFrIWMovimiento_Det.BTNVENCIMIENTOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la fecha de vencimiento', Self.Name + '.Resultado_Vencimiento', 'Fecha de vencimiento', FQRDETALLE.QR.FieldByName('FECHA_VENCIMIENTO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNVENCIMIENTOAsyncClick, ' + e.Message);
  End;
end;

Constructor TFrIWMovimiento_Det.Create(AOwner: TComponent; Const pCodigo_Documento_Adm, pNumero_Documento : String; Const pEnc, pDet : Integer);
Var
  lI : Integer;
begin
  FENC := pEnc;
  FDET := pDet;
  FCNX := UserSession.CNX;
  Inherited Create(AOwner);
  Try
    Randomize;
    Self.Name := 'TERCERO_EMAIL' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
    WebApplication.RegisterCallBack(Self.Name + '.Confirmacion_Guardar'    , Confirmacion_Guardar    );
    WebApplication.RegisterCallBack(Self.Name + '.Confirmacion_Eliminacion', Confirmacion_Eliminacion);

    WebApplication.RegisterCallBack(Self.Name + '.Resultado_Nombre'        , Resultado_Nombre        );
    WebApplication.RegisterCallBack(Self.Name + '.Agregar_Lote'            , Agregar_Lote            );
    WebApplication.RegisterCallBack(Self.Name + '.Resultado_Fabricacion'   , Resultado_Fabricacion   );
    WebApplication.RegisterCallBack(Self.Name + '.Resultado_Vencimiento'   , Resultado_Vencimiento   );
    WebApplication.RegisterCallBack(Self.Name + '.Resultado_Cantidad'      , Resultado_Cantidad      );
    WebApplication.RegisterCallBack(Self.Name + '.Resultado_Observacion'   , Resultado_Observacion   );
    WebApplication.RegisterCallBack(Self.Name + '.Resultado_Activo'        , Resultado_Activo        );

    FNUMERO_DOCUMENTO := pNumero_Documento;
    FCODIGO_DOCUMENTO_ADM := pCodigo_Documento_Adm;

    FGRID_MAESTRO        := TGRID_JQ.Create(Self);
    FGRID_MAESTRO.Parent := Self;

    FGRID_MAESTRO.Top    := DATO.Top + DATO.Height + 3;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := DATO.Width;
    FGRID_MAESTRO.Height := 300;

    FQRDETALLE := UserSession.Create_Manager_Data(Retornar_Info_Tabla(FDET).Name, Retornar_Info_Tabla(FDET).Caption);

    FQRDETALLE.ON_NEW_RECORD   := NewRecordDetalle;
    FQRDETALLE.ON_BEFORE_POST  := Validar_Campos_Detalle;
    FQRDETALLE.ON_DATA_CHANGE  := DsDataChangeDetalle;
    FQRDETALLE.ON_STATE_CHANGE := DsStateChangeDetalle;

    CONSECUTIVO.DataSource       := FQRDETALLE.DS;
    CODIGO_PRODUCTO.DataSource   := FQRDETALLE.DS;
    UNIDAD_MEDIDA.DataSource     := FQRDETALLE.DS;
    CODIGO_BODEGA.DataSource     := FQRDETALLE.DS;
    LOTE.DataSource              := FQRDETALLE.DS;
    NOMBRE.DataSource            := FQRDETALLE.DS;
    FECHA_FABRICACION.DataSource := FQRDETALLE.DS;
    FECHA_VENCIMIENTO.DataSource := FQRDETALLE.DS;
    CANTIDAD.DataSource          := FQRDETALLE.DS;
    OBSERVACION.DataSource       := FQRDETALLE.DS;

    FGRID_MAESTRO.VisibleRowCount := 11;
    FGRID_MAESTRO.SetGrid(FQRDETALLE.DS, ['CONSECUTIVO' , 'NOMBRE'     , 'CANTIDAD'       ],
                                         ['Código'      , 'Nombre'     , 'Activo'         ],
                                         ['S'           , 'N'          , 'N'              ],
                                         [100           , 400          , 100              ],
                                         [taRightJustify, taLeftJustify, taRightJustify   ]);

    If Not AbrirDetalle Then
      Release_Me;
Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento_Det.Create, ' + E.Message);
    End;
  End;
end;

procedure TFrIWMovimiento_Det.DATOAsyncKeyUp(Sender: TObject; EventParams: TStringList);
begin
  AbrirDetalle(DATO.Text);
end;

destructor TFrIWMovimiento_Det.Destroy;
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
      UtLog_Execute('TFrIWMovimiento_Det.Destroy, ' + E.Message);
    End;
  End;
  inherited;
end;

Procedure TFrIWMovimiento_Det.Release_Me;
Begin
  Self.Release;
End;

procedure TFrIWMovimiento_Det.BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Registro activo?', Self.Name + '.Resultado_Activo', 'Activo', 'Sí', 'No')
end;

procedure TFrIWMovimiento_Det.BTNADDAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    FQRDETALLE.QR.Append;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento_Det.BTNADDAsyncClick, ' + E.Message);
    End;
  End;
end;

procedure TFrIWMovimiento_Det.BTNADDLOTEAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowPrompt('Ingreso de lote', Self.Name + '.Agregar_Lote', 'Lote', FQRDETALLE.QR.FieldByName('LOTE').AsString, 'Asignar', 'Cancelar');
end;

procedure TFrIWMovimiento_Det.BTNBODEGAAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
//      Search_IW1.FILTRO := [];
      Buscar_Info(TSD.TSD_Bodega, Resultado_Bodega);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNBODEGAAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento_Det.BTNCANCELAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    FQRDETALLE.QR.Cancel;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento_Det.BTNCANCELAsyncClick, ' + E.Message);
    End;
  End;
end;

procedure TFrIWMovimiento_Det.BTNCANTIDADAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la cantidad', Self.Name + '.Resultado_Cantidad', 'Cantidad', FQRDETALLE.QR.FieldByName('CANTIDAD').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNCANTIDADAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento_Det.BTNEDITAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    FQRDETALLE.QR.Edit;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento_Det.BTNEDITAsyncClick, ' + E.Message);
    End;
  End;
end;

procedure TFrIWMovimiento_Det.BTNEMAILAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el correo electronico', Self.Name + '.Resultado_Email', 'Correo electronico', FQRDETALLE.QR.FieldByName('EMAIL').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNEMAILAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento_Det.BTNEXITAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Movimiento(FNUMERO_DOCUMENTO, FENC, FDET);
  Release_Me;
end;

procedure TFrIWMovimiento_Det.BTNFABRICACIONAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la fecha de fabricación', Self.Name + '.Resultado_Fabricacion', 'Fecha de fabricación', FQRDETALLE.QR.FieldByName('FECHA_FABRICACION').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNFABRICACIONAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento_Det.BTNLOTEAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
//      Search_IW1.FILTRO   := [FCNX.Trim_Sentence('X.CODIGO_PRODUCTO') + ' = ' + QuotedStr(Trim(FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO').AsString)),
//                              FCNX.Trim_Sentence('X.UNIDAD_MEDIDA'  ) + ' = ' + QuotedStr(Trim(FQRDETALLE.QR.FieldByName('UNIDAD_MEDIDA'  ).AsString))];
//      Search_IW1.CONECTOR := [' AND ', ' AND '];
      Buscar_Info(TSD.TSD_Lote, Resultado_Lote);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNLOTEAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento_Det.BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre del documento', Self.Name + '.Resultado_Nombre', 'Nombre', FQRDETALLE.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento_Det.BTNOBSERVACIONAsyncClick(Sender: TObject; EventParams: TStringList);
Var
  ltmp : String;
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
      ltmp := FQRDETALLE.QR.FieldByName('OBSERVACION').AsString;
      WebApplication.ShowPrompt('Ingrese la observación', Self.Name + '.Resultado_Observacion', 'Observación', ltmp);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNOBSERVACIONAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento_Det.BTNPRODUCTOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRDETALLE.Mode_Edition Then
    Begin
//      Search_IW1.FILTRO := [];
      Buscar_Info(TSD.TSD_Producto, Resultado_Producto);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.BTNPRODUCTOAsyncClick, ' + e.Message);
  End;
end;

Function TFrIWMovimiento_Det.AbrirDetalle(Const pDato : String  = '') : Boolean;
Begin
  Result := False;
  Try
    FQRDETALLE.Active := False;
    FQRDETALLE.SENTENCE := ' SELECT * FROM ' + Retornar_Info_Tabla(FDET).Name + ' (nolock) ';
    FQRDETALLE.WHERE    := ' WHERE ' + FCNX.Trim_Sentence('NUMERO_DOCUMENTO') + ' = ' + QuotedStr(Trim(FNUMERO_DOCUMENTO));
    If Not Vacio(pDato) Then
    Begin
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' AND ';
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' ( ';
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + FCNX.Trim_Sentence('CONSECUTIVO') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' OR ' + FCNX.Trim_Sentence('CODIGO_PRODUCTO') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' OR ' + FCNX.Trim_Sentence('UNIDAD_MEDIDA') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' OR ' + FCNX.Trim_Sentence('CODIGO_BODEGA') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' OR ' + FCNX.Trim_Sentence('LOTE') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' OR ' + FCNX.Trim_Sentence('FECHA_FABRICACION') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      FQRDETALLE.WHERE := FQRDETALLE.WHERE + ' OR ' + FCNX.Trim_Sentence('FECHA_VENCIMIENTO') + ' LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
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
      UtLog_Execute('TFrIWMovimiento_Det.AbrirDetalle, ' + E.Message);
    End;
  End;
End;

Function TFrIWMovimiento_Det.Existe_Registro(Const pConsecutivo : String) : Boolean;
Begin
  Result := FCNX.Record_Exist(Retornar_Info_Tabla(FDET).Name, ['NUMERO_DOCUMENTO', 'CONSECUTIVO'], [FNUMERO_DOCUMENTO, pConsecutivo]);
End;

Function TFrIWMovimiento_Det.Existencia_Valida : Boolean;
Var
  ltmp : String;

Begin
  Result := True;
  Try
    If Copy(FCODIGO_DOCUMENTO_ADM, 01, 02) = 'SA' Then
    Begin
      ltmp := UtGetSQL_Saldo_Inventario(FQRDETALLE.QR.FieldByName('LOTE'           ).AsString,
                                        FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO').AsString,
                                        FQRDETALLE.QR.FieldByName('UNIDAD_MEDIDA'  ).AsString);
      FCNX.SQL.Active :=  False;
      FCNX.SQL.SQL.Clear;
      FCNX.SQL.SQL.Add(ltmp);
      FCNX.SQL.Active := True;
      Result := FCNX.SQL.Active And (FCNX.SQL.FieldByName('CANTIDAD').AsFloat > 0);
      FCNX.SQL.Active := False;
      FCNX.SQL.SQL.Clear;
    End;

  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Existencia_Valida, ' + E.Message);
  End;
End;

Procedure TFrIWMovimiento_Det.Validar_Campos_Detalle(pSender: TObject);
Var
  lMensaje : String;
Begin
  FQRDETALLE.ERROR := 0;
  Try
    lMensaje := '';
    LOTE.BGColor := UserSession.COLOR_OK;
    NOMBRE.BGColor := UserSession.COLOR_OK;
    CANTIDAD.BGColor := UserSession.COLOR_OK;
    CONSECUTIVO.BGColor := UserSession.COLOR_OK;
    CODIGO_BODEGA.BGColor := UserSession.COLOR_OK;
    CODIGO_PRODUCTO.BGColor := UserSession.COLOR_OK;
    FECHA_FABRICACION.BGColor := UserSession.COLOR_OK;
    FECHA_VENCIMIENTO.BGColor := UserSession.COLOR_OK;

    If (FQRDETALLE.DS.State In [dsInsert]) And (Existe_Registro(FQRDETALLE.QR.FieldByName('CONSECUTIVO').AsString)) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Consecutivo existe';
      CONSECUTIVO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNNOMBRE.Visible And Vacio(FQRDETALLE.QR.FieldByName('NOMBRE').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Nombre invalido';
      NOMBRE.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNPRODUCTO.Visible And Vacio(FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Producto invalido';
      CODIGO_PRODUCTO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNBODEGA.Enabled And Vacio(FQRDETALLE.QR.FieldByName('CODIGO_BODEGA').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Bodega invalida';
      CODIGO_BODEGA.BGColor := UserSession.COLOR_ERROR;
    End;

    If LOTE.Enabled And Vacio(FQRDETALLE.QR.FieldByName('LOTE').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Lote invalido';
      LOTE.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNFABRICACION.Visible And Vacio(FQRDETALLE.QR.FieldByName('FECHA_FABRICACION').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Fecha de fabricación invalida';
      FECHA_FABRICACION.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNVENCIMIENTO.Visible And Vacio(FQRDETALLE.QR.FieldByName('FECHA_VENCIMIENTO').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Fecha de vencimiento invalida';
      FECHA_VENCIMIENTO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNCANTIDAD.Visible Then
    Begin
      If FQRDETALLE.QR.FieldByName('CANTIDAD').AsFloat <= 0 Then
      Begin
        lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Cantidad invalida';
        CANTIDAD.BGColor := UserSession.COLOR_ERROR;
      End;

      If (Not Vacio(FQRDETALLE.QR.FieldByName('LOTE').AsString)) And (Not Existencia_Valida) Then
      Begin
        lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Existencia invalida';
        CANTIDAD.BGColor := UserSession.COLOR_ERROR;
      End;
    End;

    FQRDETALLE.ERROR := IfThen(Vacio(lMensaje), 0, -1);
    If FQRDETALLE.ERROR <> 0 Then
    Begin
      FQRDETALLE.LAST_ERROR := 'Datos invalidos, ' + lMensaje;
      UserSession.SetMessage(FQRDETALLE.LAST_ERROR, True);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento_Det.Validar_Campos_Detalle, ' + E.Message);
  End;
End;

Procedure TFrIWMovimiento_Det.Prellenar_Informacion_Detalle(Sender: TObject; EventParams: TStringList);
Begin
  Validar_Campos_Detalle(Nil);
End;

procedure TFrIWMovimiento_Det.NewRecordDetalle(pSender: TObject);
begin
  Inherited;
  Try
    FQRDETALLE.QR.FieldByName('NUMERO_DOCUMENTO').AsString := FNUMERO_DOCUMENTO;
    FQRDETALLE.QR.FieldByName('CONSECUTIVO'     ).AsString := FCNX.Next(Retornar_Info_Tabla(FDET).Name, '0', ['CONSECUTIVO'], ['NUMERO_DOCUMENTO'],[FNUMERO_DOCUMENTO], FQRDETALLE.QR.FieldByName('CONSECUTIVO').Size);
    FQRDETALLE.QR.FieldByName('FECHA_REGISTRO'  ).AsString := FormatDateTime('YYYY-MM-DD', Now);
    FQRDETALLE.QR.FieldByName('HORA_REGISTRO'   ).AsString := FormatDateTime(  'HH:NN:SS', Now);
    FQRDETALLE.QR.FieldByName('CODIGO_USUARIO'  ).AsString := UserSession.CODIGO_USUARIO;

    If FECHA_FABRICACION.Visible Then
      FQRDETALLE.QR.FieldByName('FECHA_FABRICACION').AsString := FormatDateTime('YYYY-MM-DD', Now);

    If FECHA_VENCIMIENTO.Visible Then
      FQRDETALLE.QR.FieldByName('FECHA_VENCIMIENTO').AsString := FormatDateTime('YYYY-MM-DD', Now);

    FQRDETALLE.QR.FieldByName('ID_ACTIVO'        ).AsString := 'S';
    FQRDETALLE.QR.FieldByName('LOTE'             ).AsString := FLOTE;

    FQRDETALLE.QR.FieldByName('ID_ACTIVO'       ).AsString := 'S';
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento_Det.NewRecordDetalle, ' + E.Message);
    End;
  End;
end;

procedure TFrIWMovimiento_Det.NOMBREAsyncChange(Sender: TObject; EventParams: TStringList);
begin
  Prellenar_Informacion_Detalle(Sender, EventParams);
end;

procedure TFrIWMovimiento_Det.AfterPost(pSender: TObject);
Begin
  Try
    If FQRDETALLE.Mode_Edition Then
      FLOTE := FQRDETALLE.QR.FieldByName('LOTE').AsString;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento_Det.AfterPost, ' + E.Message);
    End;
  End;
End;

procedure TFrIWMovimiento_Det.DsDataChangeDetalle(pSender: TObject);
Begin
  If (Not FQRDETALLE.ACTIVE) Then
    Exit;
  Try
    lbNombre_Activo.Caption := IfThen(FQRDETALLE.QR.FieldByName('ID_ACTIVO').AsString = 'S', 'Esta activo', 'No esta activo');
    lbNombre_Bodega.Caption := FCNX.GetValue(Retornar_Info_Tabla(Id_Bodega).Name, ['CODIGO_BODEGA'], [FQRDETALLE.QR.FieldByName('CODIGO_BODEGA').AsString], ['NOMBRE']);
    lbNombre_Producto.Caption := FCNX.GetValue(Retornar_Info_Tabla(Id_Producto).Name, ['CODIGO_PRODUCTO'], [FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO').AsString], ['NOMBRE']);
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento_Det.DsDataChangeDetalle, ' + E.Message);
    End;
  End;
End;

procedure TFrIWMovimiento_Det.DsStateChangeDetalle(pSender: TObject);
Begin
  BTNADD.Visible       := Not FQRDETALLE.Mode_Edition And (FDET = Id_Movimiento_Det);
  BTNDEL.Visible       := FQRDETALLE.ACTIVE And  (Not FQRDETALLE.Mode_Edition) And (FQRDETALLE.QR.RecordCount > 0) And (FDET = Id_Movimiento_Det);
  BTNEDIT.Visible      := Not FQRDETALLE.Mode_Edition And (FDET = Id_Movimiento_Det);
  BTNSAVE.Visible      := FQRDETALLE.Mode_Edition And (FDET = Id_Movimiento_Det);
  BTNCANCEL.Visible    := FQRDETALLE.Mode_Edition And (FDET = Id_Movimiento_Det);
  DATO.Visible         := Not FQRDETALLE.Mode_Edition;
//  GRID_DETALLE.Visible := Not FQRDETALLE.Mode_Edition;

  BTNPRODUCTO.Visible    := FQRDETALLE.Mode_Edition;
  BTNBODEGA.Visible      := FQRDETALLE.Mode_Edition;
  BTNBODEGA.Visible      := FQRDETALLE.Mode_Edition;
  BTNLOTE.Visible        := FQRDETALLE.Mode_Edition;
  BTNNOMBRE.Visible      := FQRDETALLE.Mode_Edition;
  BTNFABRICACION.Visible := FQRDETALLE.Mode_Edition;
  BTNVENCIMIENTO.Visible := FQRDETALLE.Mode_Edition;
  BTNCANTIDAD.Visible    := FQRDETALLE.Mode_Edition;
  BTNOBSERVACION.Visible := FQRDETALLE.Mode_Edition;
  BTNACTIVO.Visible      := FQRDETALLE.Mode_Edition;
  BTNADDLOTE.Visible     := FQRDETALLE.Mode_Edition And (Pos('EN', FCODIGO_DOCUMENTO_ADM) > 0);

  If Pos('SA', FCODIGO_DOCUMENTO_ADM) > 0 Then
  Begin
    FECHA_FABRICACION.Visible := False;
    FECHA_VENCIMIENTO.Visible := False;
    FECHA_FABRICACION.Enabled := False;
    FECHA_VENCIMIENTO.Enabled := False;
    lbFabricacion.Visible     := False;
    lbVencimiento.Visible     := False;
    BTNFABRICACION.Visible    := False;
    BTNVENCIMIENTO.Visible    := False;
  End;
End;

end.
