unit Form_IWManager_Process;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompGradButton, IWCompEdit, IWCompGrids, IWDBGrids, UtConexion, UtTypeUPL,
  IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component, IWCompCheckbox,
  IWCompListbox, IWCompProgressIndicator, UtBusqueda_UPL_IWjQDBGrid;

type
  TFrIWManager_Process = class(TIWAppForm)
    RREGRESAR: TIWRegion;
    BTNBACK: TIWImage;
    IWModalWindow1: TIWModalWindow;
    BTNPROCESAR: TIWImage;
    IWLabel4: TIWLabel;
    CODIGO_TERCERO: TIWEdit;
    BTNTERCERO: TIWImage;
    lbNombre_Tercero: TIWLabel;
    PROCESO: TIWComboBox;
    IWLabel1: TIWLabel;
    IWProgressIndicator1: TIWProgressIndicator;
    BTNPREVISUALIZAR: TIWImage;
    VERIFICAR: TIWCheckBox;
    IWLabel2: TIWLabel;
    CODIGO_DOCUMENTO_ADM: TIWEdit;
    BTNDOCUMENTO: TIWImage;
    lbNombre_Documento: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNTERCEROAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDOCUMENTOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNPROCESARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNPREVISUALIZARAsyncClick(Sender: TObject;
      EventParams: TStringList);
  Private
    FCNX : TConexion;
    procedure Buscar_Info(pSD : TSD; pEvent : TIWAsyncEvent);
    Procedure SetLabels;
    Procedure Resultado_Tercero(Sender: TObject; EventParams: TStringList);
    Procedure Resultado_Documento(Sender: TObject; EventParams: TStringList);
    procedure Ejecutar_Cerrado(EventParams: TStringList);
    Procedure Realizar_Cierre;
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
  UtFuncion,
  UtInfoTablas,
  System.UITypes,
  UtExporta_Excel,
  ServerController,
  UtCierre_Inventario;

procedure TFrIWManager_Process.Buscar_Info(pSD : TSD; pEvent : TIWAsyncEvent);
Var
  lBusqueda : TBusqueda_Ercol_WjQDBGrid;
begin
  Try
    lBusqueda := TBusqueda_Ercol_WjQDBGrid.Create(Self);
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
      UtLog_Execute('TFrIWManager_Process.Buscar_Info, ' + e.Message);
  End;
End;

Procedure TFrIWManager_Process.SetLabels;
Begin
  lbNombre_Tercero.Caption := FCNX.GetValue(Retornar_Info_Tabla(Id_Tercero).Name, ['CODIGO_TERCERO'], [CODIGO_TERCERO.Text], ['NOMBRE']);
  lbNombre_Documento.Caption := FCNX.GetValue(Retornar_Info_Tabla(Id_Documento_ADM).Name, ['CODIGO_DOCUMENTO_ADM'], [CODIGO_DOCUMENTO_ADM.Text], ['NOMBRE']);
End;

procedure TFrIWManager_Process.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Self.Release;
end;

Procedure TFrIWManager_Process.Resultado_Tercero(Sender: TObject; EventParams: TStringList);
Begin
  Try
    CODIGO_TERCERO.Text := EventParams.Values['CODIGO_TERCERO'];
    SetLabels;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWManager_Process.Resultado_Tercero, ' + e.Message);
  End;
End;

Procedure TFrIWManager_Process.Resultado_Documento(Sender: TObject; EventParams: TStringList);
Begin
  Try
    CODIGO_DOCUMENTO_ADM.Text := EventParams.Values['CODIGO_DOCUMENTO_ADM'];
    SetLabels;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWManager_Process.Resultado_Documento, ' + e.Message);
  End;
End;


Procedure TFrIWManager_Process.Ejecutar_Cerrado(EventParams: TStringList);
Begin
  Try
    If Result_Is_OK(EventParams.Values['RetValue']) Then
    Begin
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWManager_Process.BTNBACKAsyncClick, ' + e.Message);
  End;
End;

Procedure TFrIWManager_Process.Realizar_Cierre;
Var
  lError : String;
Begin
  If Vacio(CODIGO_TERCERO.Text) Then
  Begin
    UserSession.SetMessage('Debe ingresar un tercero para realizar el proceso de ' + PROCESO.Text, True);
    Exit;
  End;

  If Vacio(CODIGO_DOCUMENTO_ADM.Text) Then
  Begin
    UserSession.SetMessage('Debe ingresar un tipo de documento para realizar el proceso de ' + PROCESO.Text, True);
    Exit;
  End;

  If VERIFICAR.Checked And (Not UtCierre_Inventario_Validar_Documentos_Cerrados(lError)) Then
  Begin
    UserSession.WebApplication.ShowMessage('Existen documentos sin cerrar para realizar el proceso de ' + PROCESO.Text + #13 + lError);
    Exit;
  End;

  If VERIFICAR.Checked And (Not UtCierre_Inventario_Validar_Detalle(lError)) Then
  Begin
    UserSession.WebApplication.ShowMessage('Existen documentos sin detalles, los cuales son necesarios para realizar el proceso de ' + PROCESO.Text + #13 + lError);
    Exit;
  End;

  CODIGO_TERCERO.Text := Justificar(CODIGO_TERCERO.Text, ' ', 20);
  If UtCierre_Inventario_Execute(CODIGO_DOCUMENTO_ADM.Text, CODIGO_TERCERO.Text, lError) Then
    UserSession.SetMessage('Proceso terminado', False)
  Else
    UserSession.SetMessage(lError, True);
End;

procedure TFrIWManager_Process.BTNDOCUMENTOAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  Buscar_Info(TSD.TSD_Documento_ADM, Resultado_Documento);
end;

procedure TFrIWManager_Process.BTNPREVISUALIZARAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    FCNX.AUX.Active := False;
    FCNX.AUX.SQL.Clear;
    FCNX.AUX.SQL.Add(UtCierre_Inventario_GetSQL);
    UtExporta_Excel_Execute(WebApplication, FCNX.AUX);
    FCNX.AUX.Active := False;
    FCNX.AUX.SQL.Clear;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWManager_Process.BTNPREVISUALIZARClick, ' + e.Message);
  End;
end;

procedure TFrIWManager_Process.BTNPROCESARAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Realizar_Cierre;
end;

procedure TFrIWManager_Process.BTNTERCEROAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Buscar_Info(TSD.TSD_Tercero, Resultado_Tercero);
end;

procedure TFrIWManager_Process.IWAppFormCreate(Sender: TObject);
begin
  Caption := 'Administrador de Procesos';
  Self.Name := 'PROCESOS' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  SetLabels;
  SetLabels;
  WebApplication.RegisterCallBack(Self.Name + '.Ejecutar_Cerrado',  Ejecutar_Cerrado);
end;

end.
