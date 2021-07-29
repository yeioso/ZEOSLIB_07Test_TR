unit Form_IWManager_Report;
interface
uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompGradButton, IWCompEdit, IWCompGrids, IWDBGrids, UtConexion,
  UtTypeTEST_TR, IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component,
  IWCompCheckbox, UtBusqueda_TEST_TR_IWjQDBGrid, IWCompProgressIndicator,
  IWCompTabControl, IWCompListbox, UtMananger_Control;
type
  TFrIWManager_Report = class(TIWAppForm)
    RREGRESAR: TIWRegion;
    BTNBACK: TIWImage;
    IWModalWindow1: TIWModalWindow;
    BTNGENERAR: TIWImage;
    IWProgressIndicator1: TIWProgressIndicator;
    PAGINAS: TIWTabControl;
    PAG_BUYER: TIWTabPage;
    IWLabel10: TIWLabel;
    CODIGO_BUYER: TIWEdit;
    BTNTERCERO_INI: TIWImage;
    PAG_FECHA: TIWTabPage;
    LbFecha: TIWLabel;
    IWLabel1: TIWLabel;
    FECHA: TIWEdit;
    OPCIONES: TIWRadioGroup;
    IWLabel2: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure PRODUCTO_INIAsyncKeyUp(Sender: TObject; EventParams: TStringList);
    procedure PRODUCTO_FINAsyncKeyUp(Sender: TObject; EventParams: TStringList);
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNGENERARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNTERCERO_INIAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWRadioGroup1AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormDestroy(Sender: TObject);
  Private
    FMC : TMananger_Control;
    FCNX : TConexion;
    Function Load_Data_Execute(Var pError : String) : Boolean;
    Function Buyer_Execute : Boolean;
    Function History_Execute(Const pBUYER_ID : String) : Boolean;
    Function Other_Buy_Execute(Const pBUYER_ID : String) : Boolean;
    Function Rank_Execute : Boolean;
    procedure Buscar_Info(pSD : Integer; pEvent : TIWAsyncEvent);
    procedure Resultado_TerceroIni(Sender: TObject; EventParams: TStringList);
    Procedure SetLabels;
  public
  end;
implementation
{$R *.dfm}
Uses
  DB,
  Math,
  UtLog,
  Variants,
  StrUtils,
  UtReporte,
  UtFuncion,
  UtInfoTablas,
  UtRest_TEST_TR,
  System.UITypes,
  UtSaveData_Buyer,
  ServerController,
  UtSaveData_Product,
  Form_Plantilla_UPL,
  UtSaveData_Transaction;

procedure TFrIWManager_Report.Buscar_Info(pSD : Integer; pEvent : TIWAsyncEvent);
Var
  lBusqueda : TBusqueda_TEST_TR_WjQDBGrid;
begin
  Try
    lBusqueda := TBusqueda_TEST_TR_WjQDBGrid.Create(Self);
    lBusqueda.Parent := Self;
    lBusqueda.SetComponents(FCNX, pEvent);
    lBusqueda.SetTSD(pSD);
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
      UtLog_Execute('TFrIWManager_Report.Buscar_Info, ' + e.Message);
  End;
End;

Procedure TFrIWManager_Report.SetLabels;
Begin
End;

procedure TFrIWManager_Report.Resultado_TerceroIni(Sender: TObject; EventParams: TStringList);
Begin
  Try
    CODIGO_BUYER.Text := EventParams.Values['ID'];
    SetLabels;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWManager_Report.Resultado_TerceroIni, ' + e.Message);
  End;
End;

procedure TFrIWManager_Report.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Self.Release;
end;

Function TFrIWManager_Report.Load_Data_Execute(Var pError : String) : Boolean;
Var
  lSDB : TSaveData_Buyer;
  lSDP : TSaveData_Product;
  lSDT : TSaveData_Transaction;
  lFecha : String;
  lResult : String;
Begin
  UtLog_Execute('TFrIWManager_Report.Load_Data_Execute, GET BUYER Request ');
  lFecha := UtRest_Datetime_To_Unix_Timestamp(FECHA.AsDateTime);
  Result := UtRest_Execute('buyers', lFecha, lResult);
  UtLog_Execute('TFrIWManager_Report.Load_Data_Execute, GET BUYER Response ');
  If Result Then
  Begin
    lSDB := TSaveData_Buyer.Create(UserSession.CNX, lResult);
    FreeAndNil(lSDB);
  End;

  UtLog_Execute('TFrIWManager_Report.Load_Data_Execute, GET PRODUCT ');
  Result := UtRest_Execute('products', lFecha, lResult);
  If Result Then
  Begin
    lSDP := TSaveData_Product.Create(UserSession.CNX, lResult);
    FreeAndNil(lSDP);
  End;

  UtLog_Execute('TFrIWManager_Report.Load_Data_Execute, GET TRANSACTIONS ');
  Result := UtRest_Execute('transactions', lFecha, lResult);
  If Result Then
  Begin
    lSDT := TSaveData_Transaction.Create(UserSession.CNX, lResult);
    FreeAndNil(lSDT);
  End;
End;

Function TFrIWManager_Report.Buyer_Execute : Boolean;
Var
  lRT : TReporte_Test;
Begin
  lRT := TReporte_Test.Create(UserSession.CNX, UserSession.CODIGO_USUARIO);
  Result := lRT.Execute_Buyer;
  FreeAndNil(lRT);
End;

Function TFrIWManager_Report.History_Execute(Const pBUYER_ID : String) : Boolean;
Var
  lRT : TReporte_Test;
Begin
  Result := False;
  If Vacio(pBUYER_ID) Then
  Begin
    UserSession.SetMessage('Debe seleccionar un comprador', True);
    Exit;
  End;
  lRT := TReporte_Test.Create(UserSession.CNX, UserSession.CODIGO_USUARIO);
  Result := lRT.Execute_History(pBUYER_ID);
  FreeAndNil(lRT);
End;

Function TFrIWManager_Report.Other_Buy_Execute(Const pBUYER_ID : String) : Boolean;
Var
  lRT : TReporte_Test;
Begin
  Result := False;
  If Vacio(pBUYER_ID) Then
  Begin
    UserSession.SetMessage('Debe seleccionar un comprador', True);
    Exit;
  End;
  lRT := TReporte_Test.Create(UserSession.CNX, UserSession.CODIGO_USUARIO);
  Result := lRT.Execute_Other_Buy(pBUYER_ID);
  FreeAndNil(lRT);
End;

Function TFrIWManager_Report.Rank_Execute : Boolean;
Var
  lRT : TReporte_Test;
Begin
  lRT := TReporte_Test.Create(UserSession.CNX, UserSession.CODIGO_USUARIO);
  Result := lRT.Execute_Rank;
  FreeAndNil(lRT);
End;


procedure TFrIWManager_Report.BTNGENERARAsyncClick(Sender: TObject; EventParams: TStringList);
Var
  lOk : Boolean;
  lError : AnsiString;
  lError2 : String;
begin
  lOk := False;
  If OPCIONES.Items[OPCIONES.ItemIndex] = 'CARGA DE DATOS'                   Then lOk := Load_Data_Execute(lError2);
  If OPCIONES.Items[OPCIONES.ItemIndex] = 'LISTA DE COMPRADORES'             Then lOk := Buyer_Execute;
  If OPCIONES.Items[OPCIONES.ItemIndex] = 'HISTORIAL DE COMPRAS'             Then lOk := History_Execute(CODIGO_BUYER.Text);
  If OPCIONES.Items[OPCIONES.ItemIndex] = 'COMPRADORES QUE USAN LA MISMA IP' Then lOk := Other_Buy_Execute(CODIGO_BUYER.Text);
  If OPCIONES.Items[OPCIONES.ItemIndex] = 'RECOMENDACION DE PRODUCTOS'       Then lOk := Rank_Execute;

//  Case IWOPCIONES.ItemIndex Of
//    0 : lOk := UtReporte_Execute_Lote_Producto   (WebApplication, FCNX, lENC, lDET, UserSession.CODIGO_USUARIO, lFecha_Ini, lFecha_Fin, lProducto_Ini, lProducto_Fin, lUnidadMedida_Ini, lUnidadMedida_Fin, lLote_Ini, lLote_Fin, CHECK_DOCUMENTOS.Checked, CHECK_MSEXCEL.Checked);
//    1 : lOk := UtReporte_Execute_Producto_Lote   (WebApplication, FCNX, lENC, lDET, UserSession.CODIGO_USUARIO, lFecha_Ini, lFecha_Fin, lProducto_Ini, lProducto_Fin, lUnidadMedida_Ini, lUnidadMedida_Fin, lLote_Ini, lLote_Fin, CHECK_DOCUMENTOS.Checked, CHECK_MSEXCEL.Checked);
//    2 : lOk := UtReporte_Execute_Resumen_Producto(WebApplication, FCNX, lENC, lDET, UserSession.CODIGO_USUARIO, lFecha_Ini, lFecha_Fin, lProducto_Ini, lProducto_Fin, lUnidadMedida_Ini, lUnidadMedida_Fin, lLote_Ini, lLote_Fin, CHECK_DOCUMENTOS.Checked, CHECK_MSEXCEL.Checked);
//    3 : lOk := UtReporte_Execute_Lote_Bodega     (WebApplication, FCNX, lENC, lDET, UserSession.CODIGO_USUARIO, lFecha_Ini, lFecha_Fin, lProducto_Ini, lProducto_Fin, lUnidadMedida_Ini, lUnidadMedida_Fin, lLote_Ini, lLote_Fin, CHECK_MSEXCEL.Checked);
//    4 : lOk := UtReporte_Execute_Tercero         (WebApplication, FCNX, UserSession.CODIGO_USUARIO, lFecha_Ini, lFecha_Fin, lTercero_Ini, lTercero_Fin, CHECK_MSEXCEL.Checked);
//  End;
  If lOk Then
  Begin
    If OPCIONES.Items[OPCIONES.ItemIndex] <> 'CARGA DE DATOS' Then
    Begin
      If Not Form_Plantilla_Reporte_TEST_TR(WebApplication, lError2) Then
        If Not Vacio(lError) Then
          UserSession.SetMessage(lError, True);
    End
    Else
      WebApplication.ShowMessage('Proceso terminado');
  End
  Else
  Begin
    WebApplication.ShowMessage('No hay datos que cumpla para realizar la generación del informe');
  End;
end;

Procedure TFrIWManager_Report.BTNTERCERO_INIAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Buscar_Info(Id_Buyer, Resultado_TerceroIni);
end;

procedure TFrIWManager_Report.PRODUCTO_FINAsyncKeyUp(Sender: TObject; EventParams: TStringList);
begin
  SetLabels;
end;

procedure TFrIWManager_Report.PRODUCTO_INIAsyncKeyUp(Sender: TObject; EventParams: TStringList);
begin
  SetLabels;
end;

procedure TFrIWManager_Report.IWAppFormCreate(Sender: TObject);
begin
  Caption := 'Administrador de Informes';
  Self.Name := 'REPORTES' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FMC := TMananger_Control.Create;
  FCNX := UserSession.CNX;
  FECHA.AsDateTime := Now;
  SetLabels;
end;

procedure TFrIWManager_Report.IWAppFormDestroy(Sender: TObject);
begin
  If Assigned(FMC) Then
    FreeAndNil(FMC);
end;

procedure TFrIWManager_Report.IWRadioGroup1AsyncClick(Sender: TObject;  EventParams: TStringList);
begin
//  PAG_FECHA.Visible := (OPCIONES.Items[OPCIONES.ItemIndex] = 'CARGA DE DATOS');
//
//  PAG_BUYER.Visible := (OPCIONES.Items[OPCIONES.ItemIndex] = 'HISTORIAL DE COMPRAS'            ) Or
//                       (OPCIONES.Items[OPCIONES.ItemIndex] = 'COMPRADORES QUE USAN LA MISMA IP') {Or
//                       (OPCIONES.Text = 'RECOMENDACION DE PRODUCTOS'      )} ;
//  If PAG_FECHA.Visible Then
//    PAGINAS.ActivePage := 0
//  Else
//    PAGINAS.ActivePage := 1;
//  PAGINAS.Visible := PAG_FECHA.Visible Or PAG_BUYER.Visible;
//  FMC.Update_Component(Self);
//UserSession.Refrescar;
end;

end.
