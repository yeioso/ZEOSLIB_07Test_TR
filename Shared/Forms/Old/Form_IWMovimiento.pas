unit Form_IWMovimiento;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompTabControl, IWCompJQueryWidget, IWBaseComponent, IWBaseHTMLComponent,
  IWBaseHTML40Component, UtConexion, Data.DB, IWCompGrids,  IWDBGrids,
  IWDBStdCtrls, IWCompEdit, IWCompCheckbox, IWCompMemo, IWDBExtCtrls,
  IWCompButton, IWCompListbox, IWCompGradButton, UtTypeUPL,
  IWCompRadioButton, IWCompProgressIndicator,
  UtGrid_JQ, UtNavegador_ASE, UtBusqueda_UPL_IWjQDBGrid;

type
  TFrIWMovimiento = class(TIWAppForm)
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
    IWRDETALLE: TIWRegion;
    IWRBOTONDETALLE: TIWRegion;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWLabel5: TIWLabel;
    OBSERVACION: TIWDBMemo;
    IWLabel7: TIWLabel;
    lbNombre_Tercero: TIWLabel;
    BtnNovedad: TIWImage;
    BTNDOCUMENTO_ADM: TIWImage;
    CODIGO_DOCUMENTO_ADM: TIWDBLabel;
    lbNombre_Codigo_Documento_Adm: TIWLabel;
    NUMERO_DOCUMENTO: TIWDBLabel;
    BTNNOMBRE: TIWImage;
    NOMBRE: TIWDBLabel;
    CODIGO_TERCERO: TIWDBLabel;
    BTNTERCERO: TIWImage;
    BTNFECHA: TIWImage;
    FECHA_MOVIMIENTO: TIWDBLabel;
    HORA_MOVIMIENTO: TIWDBLabel;
    BTNHORA: TIWImage;
    BTNOBSERVACION: TIWImage;
    IWLabel4: TIWLabel;
    BTNIMPRIMIR: TIWImage;
    BTNCERRADO: TIWImage;
    lbNombre_Cerrado: TIWLabel;
    BTNANULAR: TIWImage;
    lbNombre_Anulado: TIWLabel;
    IWProgressIndicator1: TIWProgressIndicator;
    IWRegion_Navegador: TIWRegion;
    DETALLES: TIWListbox;
    IWLabel6: TIWLabel;
    DOCUMENTO_REFERENCIA: TIWDBLabel;
    BTNDOCUMENTO_REFERENCIA: TIWImage;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNANULARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCERRADOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDOCUMENTO_ADMAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNTERCEROAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNFECHAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNOBSERVACIONAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNHORAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BtnNovedadAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNIMPRIMIRClick(Sender: TObject);
    procedure BTNDOCUMENTO_REFERENCIAAsyncClick(Sender: TObject;
      EventParams: TStringList);
  private
    FCNX : TConexion;
    FENC : Integer;
    FDET : Integer;

    FINFO : String;
    FLOTE : String;

    FQRMAESTRO : TMANAGER_DATA;
    FQRDETALLE : TMANAGER_DATA;

    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;

    FCODIGO_ACTUAL : String;
    FNUMERO_DOCUMENTO : String;

    procedure Buscar_Info(pSD : TSD; pEvent : TIWAsyncEvent);
    Procedure Actualizar_Nombre;
    Procedure Resultado_Tipo_Documento(Sender: TObject; EventParams: TStringList);
    Procedure Resultado_Documento_Referencia(EventParams: TStringList);
    Procedure Resultado_Tercero(Sender: TObject; EventParams: TStringList);

    procedure Resultado_Nombre(EventParams: TStringList);
    procedure Resultado_Fecha(EventParams: TStringList);
    procedure Resultado_Hora(EventParams: TStringList);
    procedure Resultado_Observacion(EventParams: TStringList);
    procedure Ejecutar_Cerrado(EventParams: TStringList);
    procedure Ejecutar_Anulacion(EventParams: TStringList);
    Procedure Release_Me;

    Function Existe_Movimiento(Const pNUMERO_DOCUMENTO : String) : Boolean;

    Procedure Validar_Campos_Master (pSender: TObject);
    Function Documento_Activo : Boolean;

    Procedure NewRecordMaster(pSender: TObject);
    Procedure AfterPostMaster(pSender: TObject);
    Procedure DsDataChangeMaster(pSender: TObject);
    Procedure DsStateMaster(pSender: TObject);

    Procedure SetLabel;
    Procedure Estado_Controles;
    Function AbrirMaestro(Const pDato : String = '') : Boolean;
    Function AbrirDetalle(Const pNUMERO_DOCUMENTO : String) : Boolean;
  public
    Constructor Create(AOwner: TComponent; Const pNumero_Documento : String; Const pEnc, pDet : Integer);
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
  UtBusqueda_UPL,
  UtImprimir_UPL,
  Winapi.Windows,
  System.UITypes,
  System.StrUtils,
  ServerController,
  Form_Plantilla_UPL,
  TableName_006Documento_ADM;

procedure TFrIWMovimiento.Buscar_Info(pSD : TSD; pEvent : TIWAsyncEvent);
Var
  lBusqueda : TBusqueda_Ercol_WjQDBGrid;
begin
  Try
    lBusqueda := TBusqueda_Ercol_WjQDBGrid.Create(Self);
    lBusqueda.Parent := Self;
    lBusqueda.SetComponents(FCNX, pEvent);
    lBusqueda.SetTSD(pSD);
    Case pSD Of
      TSD.TSD_Documento_ADM : Begin
                                lBusqueda.FILTRO   := ['ID_ACTIVO = ' + QuotedStr('S') ];
                                lBusqueda.CONECTOR := [' OR '                          ];
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
      UtLog_Execute('TFrIWMovimiento.Buscar_Info, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Actualizar_Nombre;
Begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := Trim(lbNombre_Tercero.Caption) + ', ' + Trim(lbNombre_Codigo_Documento_Adm.Caption);
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Actualizar_Nombre, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Resultado_Tipo_Documento(Sender: TObject; EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString := EventParams.Values['CODIGO_DOCUMENTO_ADM'];
      FQRMAESTRO.QR.FieldByName('NOMBRE'              ).AsString := EventParams.Values['CODIGO_DOCUMENTO_ADM'];
      FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO'    ).AsString := TableName_006Documento_ADM_Get(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString);
      Actualizar_Nombre;
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Resultado_Tipo_Documento, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Resultado_Documento_Referencia(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('DOCUMENTO_REFERENCIA').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Resultado_Documento_Referencia, ' + e.Message);
  End;
End;


Procedure TFrIWMovimiento.Resultado_Tercero(Sender: TObject; EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString := EventParams.Values['CODIGO_TERCERO'];
      Actualizar_Nombre;
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Resultado_Tercero, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Resultado_Nombre(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Resultado_Nombre, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Resultado_Fecha(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('FECHA_MOVIMIENTO').AsString := EventParams.Values['InputStr'];
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Resultado_Fecha, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Resultado_Hora(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('HORA_MOVIMIENTO').AsString := EventParams.Values['InputStr'];
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Resultado_Hora, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Resultado_Observacion(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('OBSERVACION').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Resultado_Observacion, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Ejecutar_Cerrado(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      FQRMAESTRO.QR.FieldByName('ID_CERRADO').AsString := IfThen(Result_Is_OK(EventParams.Values['RetValue']), 'S', 'N');
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Ejecutar_Cerrado, ' + e.Message);
  End;
End;

Procedure TFrIWMovimiento.Release_Me;
Begin
  Self.Release;
End;

Function TFrIWMovimiento.Existe_Movimiento(Const pNUMERO_DOCUMENTO : String) : Boolean;
Begin
  Result := UserSession.CNX.Record_Exist(Retornar_Info_Tabla(FENC).Name, ['NUMERO_DOCUMENTO'], [pNUMERO_DOCUMENTO]);
End;


Procedure TFrIWMovimiento.Validar_Campos_Master(pSender: TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    NOMBRE.BGColor := UserSession.COLOR_OK;
    CODIGO_TERCERO.BGColor := UserSession.COLOR_OK;
    HORA_MOVIMIENTO.BGColor := UserSession.COLOR_OK;
    NUMERO_DOCUMENTO.BGColor := UserSession.COLOR_OK;
    FECHA_MOVIMIENTO.BGColor := UserSession.COLOR_OK;
    CODIGO_DOCUMENTO_ADM.BGColor := UserSession.COLOR_OK;

    If BTNTERCERO.Visible And (Not Vacio(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString)) Then
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);

    If BTNDOCUMENTO_ADM.Visible And Vacio(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Código del tipo de documento invalido';
      CODIGO_DOCUMENTO_ADM.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNDOCUMENTO_ADM.Visible And (FQRMAESTRO.DS.State In [dsInsert]) And UserSession.CNX.Record_Exist(Retornar_Info_Tabla(FENC).Name, ['NUMERO_DOCUMENTO'], [FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString]) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Movimiento ya existe';
      NUMERO_DOCUMENTO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNDOCUMENTO_ADM.Visible And Vacio(FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Movimiento invalido';
      NOMBRE.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNNOMBRE.Visible And Vacio(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Nombre invalido';
      NOMBRE.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNTERCERO.Visible And
       (Vacio(FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString) Or
        (Not UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Tercero).Name, ['CODIGO_TERCERO'], [FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString])))
        Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Tercero invalido';
      CODIGO_TERCERO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNFECHA.Visible And Vacio(FQRMAESTRO.QR.FieldByName('FECHA_MOVIMIENTO').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Fecha de Movimiento invalido';
      FECHA_MOVIMIENTO.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNHORA.Visible And Vacio(FQRMAESTRO.QR.FieldByName('HORA_MOVIMIENTO').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Hora de Movimiento invalido';
      HORA_MOVIMIENTO.BGColor := UserSession.COLOR_ERROR;
    End;

    FQRMAESTRO.ERROR := IfThen(Vacio(lMensaje), 0, -1);
    If FQRMAESTRO.ERROR <> 0 Then
    Begin
      FQRMAESTRO.LAST_ERROR := 'Datos invalidos, ' + lMensaje;
      UserSession.SetMessage(FQRMAESTRO.LAST_ERROR, True);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.Validar_Campos_Master, ' + E.Message);
  End;
End;


Procedure TFrIWMovimiento.Estado_Controles;
Begin
  BTNDOCUMENTO_ADM.Visible        := (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  BTNNOMBRE.Visible               := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNDOCUMENTO_REFERENCIA.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNTERCERO.Visible              := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNFECHA.Visible                := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNHORA.Visible                 := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNOBSERVACION.Visible          := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNCERRADO.Visible              := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNANULAR.Visible               := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNIMPRIMIR.Visible             := FQRMAESTRO.Active And (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount >= 1);

  DATO.Visible                    := (Not FQRMAESTRO.Mode_Edition);
  PAG_00.Visible                  := (Not FQRMAESTRO.Mode_Edition);
  PAG_01.Visible                  := True;
End;

Procedure TFrIWMovimiento.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try
    lbNombre_Cerrado.Caption := IfThen(FQRMAESTRO.QR.FieldByName('ID_CERRADO').AsString = 'S', 'Documento cerrado', 'Documento pendiente por cerrar');
    lbNombre_Anulado.Caption := IfThen(FQRMAESTRO.QR.FieldByName('ID_ANULADO').AsString = 'S', 'Documento anulado', 'Documento activo');
    lbNombre_Tercero.Caption := UserSession.CNX.GetValue(Retornar_Info_Tabla(Id_Tercero).Name, ['CODIGO_TERCERO'], [FQRMAESTRO.QR.FieldByName('CODIGO_TERCERO').AsString], ['NOMBRE']);
    lbNombre_Codigo_Documento_Adm.Caption := UserSession.CNX.GetValue(Retornar_Info_Tabla(Id_Documento_ADM).Name, ['CODIGO_DOCUMENTO_ADM'], [FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString], ['NOMBRE']);
    IWRBOTONDETALLE.Visible := FQRMAESTRO.Active And (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount >= 1) And Documento_Activo;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento.SetLabel, ' + E.Message);
    End;
  End;
End;

Function TFrIWMovimiento.Documento_Activo : Boolean;
Begin
  Try
    Result := True;
    Result := {(FQRMAESTRO.RecordCount >= 1) And}
              (Trim(FQRMAESTRO.QR.FieldByName('ID_ANULADO').AsString) <> 'S') And
              (Trim(FQRMAESTRO.QR.FieldByName('ID_CERRADO').AsString) <> 'S') And (FENC = Id_Movimiento_Enc);
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento.Documento_Activo, ' + E.Message);
    End;
  End;
End;

procedure TFrIWMovimiento.DsDataChangeMaster(pSender: TObject);
Var
  lNumero_Documento : String;
begin
  FNAVEGADOR.UpdateState;

  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString + ' ] ';

  Try

    If (FCODIGO_ACTUAL <> FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString) And (Not FQRMAESTRO.Mode_Edition) Then
    Begin
      AbrirDetalle(FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString);
      FCODIGO_ACTUAL := FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString;
    End;
    SetLabel;
//    If Modo_Edicion_Master Then
//    Begin
//      Prellenar_Informacion_Master(Nil, Nil);
//      FQRMAESTRO.FieldByName('NOMBRE').AsString := Trim(lbNombre_Tercero.Caption) + ', ' +
//                                                   UserSession.CNX.GetValue(Retornar_Info_Tabla(Id_Documento_ADM).Name, ['CODIGO_DOCUMENTO_ADM'], [FQRMAESTRO.FieldByName('CODIGO_DOCUMENTO_ADM').AsString], ['NOMBRE']);
//      If (Not Vacio(FQRMAESTRO.FieldByName('CODIGO_DOCUMENTO_ADM').AsString)) And (FDSMAESTRO.State In [dsInsert])  Then
//        FQRMAESTRO.FieldByName('NUMERO_DOCUMENTO').AsString := TableName_006Documento_ADM_Get(FQRMAESTRO.FieldByName('CODIGO_DOCUMENTO_ADM').AsString);
//    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento.DsDataChangeMaster, ' + E.Message);
    End;
  End;
end;

Procedure TFrIWMovimiento.DsStateMaster(pSender: TObject);
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Estado_Controles;
  If FQRMAESTRO.Mode_Edition Then
    PAGINAS.ActivePage := 1;
  Case FQRMAESTRO.DS.State Of
    dsInsert : Begin
//                 If NUMERO_DOCUMENTO.Enabled Then
//                   NUMERO_DOCUMENTO.SetFocus;
               End;
    dsEdit   : Begin
//                 If NOMBRE.Enabled Then
//                   NOMBRE.SetFocus;
               End;
  End;
End;

Function TFrIWMovimiento.AbrirDetalle(Const pNUMERO_DOCUMENTO : String) : Boolean;
Begin
  Result := False;
  DETALLES.Items.Clear;
  Try
    FQRDETALLE.Active := False;
    FQRDETALLE.SENTENCE := ' SELECT * FROM ' + Retornar_Info_Tabla(FDET).Name + ' ';
    FQRDETALLE.SENTENCE := FQRDETALLE.SENTENCE + ' WHERE ' + UserSession.CNX.Trim_Sentence('NUMERO_DOCUMENTO') +' = ' + QuotedStr(Trim(pNUMERO_DOCUMENTO));
    FQRDETALLE.Active := True;
    Result := FQRDETALLE.Active;
    If Result Then
    Begin
      TFloatField(FQRDETALLE.QR.FieldByName('CANTIDAD')).DisplayFormat := '###,###,###,##0.#0';
      FQRDETALLE.QR.First;
      While Not FQRDETALLE.QR.Eof Do
      Begin
       DETALLES.Items.Add(
                          FQRDETALLE.QR.FieldByName('CONSECUTIVO'      ).AsString + ' - ' +
                          FQRDETALLE.QR.FieldByName('CODIGO_PRODUCTO'  ).AsString + ' - ' +
                          FQRDETALLE.QR.FieldByName('UNIDAD_MEDIDA'    ).AsString + ' - ' +
                          FQRDETALLE.QR.FieldByName('CODIGO_BODEGA'    ).AsString + ' - ' +
                          FQRDETALLE.QR.FieldByName('LOTE'             ).AsString + ' - ' +
                          FQRDETALLE.QR.FieldByName('NOMBRE'           ).AsString + ' - ' +
                          FQRDETALLE.QR.FieldByName('FECHA_FABRICACION').AsString + ' - ' +
                          FQRDETALLE.QR.FieldByName('FECHA_VENCIMIENTO').AsString + ' - ' +
                          FormatFloat('###,##0.#0', FQRDETALLE.QR.FieldByName('CANTIDAD').AsFloat) + ' - ' +
                          DepurarSaltoLinea(FQRDETALLE.QR.FieldByName('OBSERVACION').AsString)
                         );
        FQRDETALLE.QR.Next;
      End;
    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento.AbrirDetalle, ' + E.Message);
    End;
  End;
End;

Function TFrIWMovimiento.AbrirMaestro(Const pDato : String = '') : Boolean;
Var
  lResult : String;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(FDET).Caption;
  Result := False;
  Try
    FQRMAESTRO.WHERE := '';
    If UtBusqueda_UPL_Execute(FQRMAESTRO.QR, pDato, lResult) Then
    Begin
      FQRMAESTRO.Active := False;
      FQRMAESTRO.SENTENCE := ' SELECT ' + UserSession.CNX.Top_Sentence(UserSession.Const_Max_Record) + ' * FROM '+ Retornar_Info_Tabla(FENC).Name + ' ';
      FQRMAESTRO.SENTENCE := FQRMAESTRO.SENTENCE + lResult;
    End
    Else
    Begin
      FQRMAESTRO.Active := False;
      FQRMAESTRO.SENTENCE :=' SELECT ' + UserSession.CNX.Top_Sentence(UserSession.Const_Max_Record) + ' * FROM ' + Retornar_Info_Tabla(FENC).Name + ' ';
      If Trim(pDato) <> '' Then
      Begin
        FQRMAESTRO.WHERE := ' WHERE NUMERO_DOCUMENTO LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
        FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' OR NOMBRE LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      End;
    End;
    FQRMAESTRO.ORDER := ' ORDER BY FECHA_MOVIMIENTO DESC ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento.AbrirMaestro, ' + E.Message);
    End;
  End;
  FGRID_MAESTRO.RefreshData;
End;

procedure TFrIWMovimiento.Ejecutar_Anulacion(EventParams: TStringList);
var
  Response: Boolean;
  InputValue: string;
  MsgType: TIWNotifyType;
  Msg: string;
begin
  // Prompt callback has 2 main parameters:
  // RetValue (Boolean), indicates if the first button (Yes/OK/custom) was choosen
  // InputStr, contains the string entered in the input box
  Response := SameText(EventParams.Values['RetValue'], 'True');
  InputValue := EventParams.Values['InputStr'];
  if Response then
  begin
    MsgType := ntSuccess;
    If FQRMAESTRO.Mode_Edition Then
    Begin
      Try
        FQRMAESTRO.QR.FieldByName('ID_ANULADO').AsString := 'S';
        FQRMAESTRO.QR.FieldByName('OBSERVACION').AsString := FQRMAESTRO.QR.FieldByName('OBSERVACION').AsString +  #13 + InputValue + #13 + UserSession.NOMBRE_USUARIO;
        OBSERVACION.Editable := False;
//        WebApplication.ShowNotification('Anulación realizada', MsgType);
      Except
        On E: Exception Do
        Begin
          UtLog_Execute('TFrIWMovimiento.Ejecutar_Anulacion, ' + E.Message);
          WebApplication.ShowNotification('No fue posible realizar la anulación, ' + E.Message, MsgType);
        End;
      End;
    End;
  end
  else
  begin
    MsgType := ntError;
    WebApplication.ShowNotification('Anulación no realizada', MsgType);
  end;
End;


procedure TFrIWMovimiento.IWAppFormCreate(Sender: TObject);
Var
  lI : Integer;
begin
  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(FENC).Caption;
  Randomize;
  Self.Name := 'MOVIMIENTO' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Documento_Referencia',  Resultado_Documento_Referencia);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Nombre'              ,  Resultado_Nombre              );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Fecha'               ,  Resultado_Fecha               );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Hora'                ,  Resultado_Hora                );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Observacion'         ,  Resultado_Observacion         );
  WebApplication.RegisterCallBack(Self.Name + '.Ejecutar_Cerrado'              ,  Ejecutar_Cerrado              );
  WebApplication.RegisterCallBack(Self.Name + '.Ejecutar_Anulacion'            ,  Ejecutar_Anulacion            );
  Try

    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;
    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;

    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(FENC).Name, Retornar_Info_Tabla(FENC).Caption);

    FQRDETALLE := UserSession.Create_Manager_Data(Retornar_Info_Tabla(FDET).Name, Retornar_Info_Tabla(FDET).Caption);

    CODIGO_DOCUMENTO_ADM.DataSource := FQRMAESTRO.DS;
    NUMERO_DOCUMENTO.DataSource     := FQRMAESTRO.DS;
    DOCUMENTO_REFERENCIA.DataSource := FQRMAESTRO.DS;
    NOMBRE.DataSource               := FQRMAESTRO.DS;
    CODIGO_TERCERO.DataSource       := FQRMAESTRO.DS;
    FECHA_MOVIMIENTO.DataSource     := FQRMAESTRO.DS;
    HORA_MOVIMIENTO.DataSource      := FQRMAESTRO.DS;
    OBSERVACION.DataSource          := FQRMAESTRO.DS;

    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_BEFORE_POST  := Validar_Campos_Master;
    FQRMAESTRO.ON_AFTER_POST   := AfterPostMaster;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;

    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['CODIGO_DOCUMENTO_ADM', 'NUMERO_DOCUMENTO'    , 'NOMBRE'     ],
                                         ['Tipo'                , 'Documento'           , 'Nombre'     ],
                                         ['S'                   , 'S'                   , 'N'          ],
                                         [100                   , 200                   , 350          ],
                                         [taRightJustify        , taLeftJustify         , taLeftJustify]);


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

    If AbrirMaestro(FNUMERO_DOCUMENTO) Then
    Begin

    End
    Else
      Release_Me
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWMovimiento.IWAppFormDestroy(Sender: TObject);
begin
    Try
      If Assigned(FNAVEGADOR) Then
      Begin
        FreeAndNil(FNAVEGADOR);
      End;

      If Assigned(FGRID_MAESTRO) Then
      Begin
        FreeAndNil(FGRID_MAESTRO);
      End;

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
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWMovimiento.IWAppFormDestroy, ' + e.Message);
    End;
end;

procedure TFrIWMovimiento.NewRecordMaster(pSender: TObject);
begin
  Try
    FLOTE := '';
    FQRMAESTRO.QR.FieldByName('FECHA_MOVIMIENTO').AsString := FormatDateTime('YYYY-MM-DD', Now);
    FQRMAESTRO.QR.FieldByName('HORA_MOVIMIENTO' ).AsString := FormatDateTime(  'HH:NN:SS', Now);
    FQRMAESTRO.QR.FieldByName('FECHA_REGISTRO'  ).AsString := FormatDateTime('YYYY-MM-DD', Now);
    FQRMAESTRO.QR.FieldByName('HORA_REGISTRO'   ).AsString := FormatDateTime(  'HH:NN:SS', Now);
    FQRMAESTRO.QR.FieldByName('CODIGO_USUARIO'  ).AsString := UserSession.CODIGO_USUARIO;
    FQRMAESTRO.QR.FieldByName('ID_CERRADO'      ).AsString := 'N';
    FQRMAESTRO.QR.FieldByName('ID_ANULADO'      ).AsString := 'N';
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWMovimiento.NewRecordMaster, ' + E.Message);
    End;
  End;
end;

Procedure TFrIWMovimiento.AfterPostMaster(pSender: TObject);
Begin
  If FQRMAESTRO.NEW_RECORD Then
    If Not TableName_006Documento_ADM_Post(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString) Then
      UserSession.SetMessage('Hay inconsistencias actualizando consecutivo', True);
End;

procedure TFrIWMovimiento.BTNANULARAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowPrompt('Está seguro(a) de realizar la anulación', Self.Name + '.Ejecutar_Anulacion', 'Anulación', 'Ingrese el motivo de la anulación', 'Sí Anular', 'No Anular');
end;

procedure TFrIWMovimiento.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Release_Me;
end;

procedure TFrIWMovimiento.BTNIMPRIMIRClick(Sender: TObject);
Var
  lError : String;
begin
  If Not Form_Plantilla_Documento_UPL(WebApplication, FENC, FDET, FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString, lError ) Then
    UserSession.SetMessage(lError, True);
//  UtImprimir_UPL_Documento(WebApplication, FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, FQRMAESTRO.QR.FieldByName('NUMERO_DOCUMENTO').AsString, lError);
//   If Not Vacio(lError) Then
//    UserSession.SetMessage(lError, True);
end;

procedure TFrIWMovimiento.BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre del documento', Self.Name + '.Resultado_Nombre', 'Nombre', FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWUsuario.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento.BtnNovedadAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Movimiento_Det(CODIGO_DOCUMENTO_ADM.Text, NUMERO_DOCUMENTO.Text, FENC, FDET);
  Release_Me;
end;

procedure TFrIWMovimiento.BTNOBSERVACIONAsyncClick(Sender: TObject; EventParams: TStringList);
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
      UtLog_Execute('TFrIWMovimiento.BTNOBSERVACIONAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento.BTNTERCEROAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      Buscar_Info(TSD.TSD_Tercero, Resultado_Tercero);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.BTNTERCEROAsyncClick, ' + e.Message);
  End;
end;

constructor TFrIWMovimiento.Create(AOwner: TComponent; Const pNumero_Documento : String; Const pEnc, pDet : Integer);
begin
  FENC := pEnc;
  FDET := pDet;
  FNUMERO_DOCUMENTO := pNumero_Documento;
  Inherited Create(AOwner);
end;

procedure TFrIWMovimiento.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;

procedure TFrIWMovimiento.BTNCERRADOAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  If FQRDETALLE.ACTIVE And (FQRDETALLE.QR.RecordCount > 0) Then
  Begin
    WebApplication.ShowConfirm('Está seguro(a) de cerrar el documento?', Self.Name + '.Ejecutar_Cerrado', 'Cerrar', 'Sí', 'No')
  End
  Else
    UserSession.SetMessage('Debe existir al menos un detalle para cerrar el documento', True);
end;

procedure TFrIWMovimiento.BTNDOCUMENTO_ADMAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
//      Search_IW1.FILTRO   := ['ID_ACTIVO = ' + QuotedStr('S') ];
//      Search_IW1.CONECTOR := [' OR '                          ];
      Buscar_Info(TSD.TSD_Documento_ADM, Resultado_Tipo_Documento);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWBodega_Enc.BTNCODIGOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento.BTNDOCUMENTO_REFERENCIAAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el documento referencia', Self.Name + '.Resultado_Documento_Referencia', 'Documento referencia', FQRMAESTRO.QR.FieldByName('DOCUMENTO_REFERENCIA').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.BTNDOCUMENTO_REFERENCIAAsyncClick, ' + e.Message);
  End;
end;

Procedure TFrIWMovimiento.BTNFECHAAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la fecha del movimiento', Self.Name + '.Resultado_Fecha', 'Fecha', FQRMAESTRO.QR.FieldByName('FECHA_MOVIMIENTO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.BTNFECHAAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWMovimiento.BTNHORAAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese la hora del movimiento', Self.Name + '.Resultado_Hora', 'Hora', FQRMAESTRO.QR.FieldByName('HORA_MOVIMIENTO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMovimiento.BTNHORAAsyncClick, ' + e.Message);
  End;
end;

end.
