unit Form_IWDocumento_ADM;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl,
  IWControl, IWCompExtCtrls, Vcl.Controls, Vcl.Forms, IWVCLBaseContainer,
  IWContainer, IWHTMLContainer, IWHTML40Container, IWRegion, IWCompLabel,
  IWCompTabControl, IWCompJQueryWidget, IWBaseComponent,
  IWBaseHTMLComponent, IWBaseHTML40Component, UtConexion, Data.DB, IWCompGrids,
  IWDBGrids, IWDBStdCtrls, IWCompEdit, IWCompCheckbox, IWCompMemo, IWDBExtCtrls,
  IWCompButton, IWCompListbox, IWCompGradButton, UtGrid_JQ, UtNavegador_ASE;

type
  TFrIWAdm_Documento = class(TIWAppForm)
    RINFO: TIWRegion;
    lbInfo: TIWLabel;
    IWRegion1: TIWRegion;
    PAGINAS: TIWTabControl;
    PAG_00: TIWTabPage;
    PAG_01: TIWTabPage;
    RNAVEGADOR: TIWRegion;
    IWLabel7: TIWLabel;
    IWLabel8: TIWLabel;
    DATO: TIWEdit;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    IWLabel3: TIWLabel;
    IWLabel6: TIWLabel;
    CODIGO_DOCUMENTO_ADM: TIWDBLabel;
    NOMBRE: TIWDBLabel;
    DOCUMENTO_INICIAL: TIWDBLabel;
    DOCUMENTO_ACTUAL: TIWDBLabel;
    DOCUMENTO_FINAL: TIWDBLabel;
    FORMATO: TIWDBLabel;
    BTNCODIGO_DOCUMENTO_ADM: TIWImage;
    BTNNOMBRE: TIWImage;
    BTNDOCUMENTO_INICIAL: TIWImage;
    BTNDOCUMENTO_ACTUAL: TIWImage;
    BTNDOCUMENTO_FINAL: TIWImage;
    BTNFORMATO: TIWImage;
    BTNACTIVO: TIWImage;
    lbNombre_Activo: TIWLabel;
    IWRegion_Navegador: TIWRegion;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BtnAcarreoAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCODIGO_DOCUMENTO_ADMAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDOCUMENTO_INICIALAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDOCUMENTO_ACTUALAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNDOCUMENTO_FINALAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNPREFIJO_DOCUMENTOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNUEVO_PREFIJOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNFORMATOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNFORMATO2AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNFORMATO3AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCNX : TConexion;
    FINFO : String;
    FQRMAESTRO : TMANAGER_DATA;

    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;

    Procedure Release_Me;

    Procedure Resultado_Codigo(EventParams: TStringList);
    Procedure Resultado_Nombre(EventParams: TStringList);
    Procedure Resultado_Inicial(EventParams: TStringList);
    Procedure Resultado_Actual(EventParams: TStringList);
    Procedure Resultado_Final(EventParams: TStringList);
    Procedure Resultado_Formato(EventParams: TStringList);
    Procedure Resultado_Activo(EventParams: TStringList);

    Procedure Validar_Campos_Master(pSender: TObject);

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
  Vcl.Graphics,
  UtInfoTablas,
  Winapi.Windows,
  System.UITypes,
  System.StrUtils,
  ServerController;

Procedure TFrIWAdm_Documento.Release_Me;
Begin
  Self.Release;
End;

Procedure TFrIWAdm_Documento.Resultado_Codigo(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString := Justificar(EventParams.Values['InputStr'], '0', FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').Size);
      FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString := AnsiUpperCase(Trim(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString));
      FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString := Copy(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.Resultado_Codigo, ' + e.Message);
  End;
End;

Procedure TFrIWAdm_Documento.Resultado_Nombre(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
      FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.Resultado_Nombre, ' + e.Message);
  End;
End;

Procedure TFrIWAdm_Documento.Resultado_Inicial(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('DOCUMENTO_INICIAL').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
      FQRMAESTRO.QR.FieldByName('DOCUMENTO_INICIAL').AsString := Justificar(FQRMAESTRO.QR.FieldByName('DOCUMENTO_INICIAL').AsString, '0', FQRMAESTRO.QR.FieldByName('DOCUMENTO_INICIAL').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.Resultado_Inicial, ' + e.Message);
  End;
End;

Procedure TFrIWAdm_Documento.Resultado_Actual(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('DOCUMENTO_ACTUAL').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
      FQRMAESTRO.QR.FieldByName('DOCUMENTO_ACTUAL').AsString := Justificar(FQRMAESTRO.QR.FieldByName('DOCUMENTO_ACTUAL').AsString, '0', FQRMAESTRO.QR.FieldByName('DOCUMENTO_ACTUAL').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.Resultado_Actual, ' + e.Message);
  End;
End;

Procedure TFrIWAdm_Documento.Resultado_Final(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('DOCUMENTO_FINAL').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
      FQRMAESTRO.QR.FieldByName('DOCUMENTO_FINAL').AsString := Justificar(FQRMAESTRO.QR.FieldByName('DOCUMENTO_FINAL').AsString, '0', FQRMAESTRO.QR.FieldByName('DOCUMENTO_FINAL').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.Resultado_Final, ' + e.Message);
  End;
End;

Procedure TFrIWAdm_Documento.Resultado_Formato(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
      FQRMAESTRO.QR.FieldByName('FORMATO').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.Resultado_Formato, ' + e.Message);
  End;
End;

Procedure TFrIWAdm_Documento.Resultado_Activo(EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
      FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString := IfThen(Result_Is_OK(EventParams.Values['RetValue']), 'S', 'N');
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.Resultado_Activo, ' + E.Message);
  End;
end;


Procedure TFrIWAdm_Documento.Validar_Campos_Master(pSender: TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    CODIGO_DOCUMENTO_ADM.BGColor := UserSession.COLOR_OK;
    NOMBRE.BGColor               := UserSession.COLOR_OK;

    If BTNCODIGO_DOCUMENTO_ADM.Visible And UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Documento_ADM).Name, ['CODIGO_DOCUMENTO_ADM'], [FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString]) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Documento invalido';
      CODIGO_DOCUMENTO_ADM.BGColor := UserSession.COLOR_ERROR;
    End;

    If BTNCODIGO_DOCUMENTO_ADM.Visible And
       (Copy(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) <> 'SI'  ) And
       (Copy(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) <> 'EN'  ) And
       (Copy(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) <> 'SA'  ) And
       (Trim(FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString)         <> 'BASE') Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Documento debe tener prefijo SI: Saldo inicial o EN: Entrada o SA : Salida, BASE: Base (Reportes) ';
      CODIGO_DOCUMENTO_ADM.BGColor := UserSession.COLOR_ERROR;
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
      UtLog_Execute('TFrIWAdm_Documento.Validar_Campos_Master, ' + E.Message);
  End;
End;


Procedure TFrIWAdm_Documento.Estado_Controles;
Begin
  BTNCODIGO_DOCUMENTO_ADM.Visible := FQRMAESTRO.DS.State In [dsInsert];
  BTNNOMBRE.Visible               := FQRMAESTRO.Mode_Edition;
  BTNDOCUMENTO_INICIAL.Visible    := FQRMAESTRO.Mode_Edition;
  BTNDOCUMENTO_ACTUAL.Visible     := FQRMAESTRO.Mode_Edition;
  BTNDOCUMENTO_FINAL.Visible      := FQRMAESTRO.Mode_Edition;
  BTNFORMATO.Visible              := FQRMAESTRO.Mode_Edition;
  BTNACTIVO.Visible               := FQRMAESTRO.Mode_Edition;
//  BtnAcarreo.Visible              := FQRMAESTRO.Active And (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount > 0);

  DATO.Visible       := (Not FQRMAESTRO.Mode_Edition);
//  BTNBUSCAR.Visible  := (Not FQRMAESTRO.Mode_Edition);
  PAG_00.Visible     := (Not FQRMAESTRO.Mode_Edition);
  PAG_01.Visible     := True;
End;


Procedure TFrIWAdm_Documento.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try
    lbNombre_Activo.Caption := IfThen(FQRMAESTRO.QR.FieldByName('ID_ACTIVO').AsString = 'S', 'Activo', 'No activo');
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAdm_Documento.SetLabel, ' + E.Message);
    End;
  End;
End;

procedure TFrIWAdm_Documento.DsDataChangeMaster(pSender : TObject);
begin
  If (Not FQRMAESTRO.Active)Then
    Exit;

  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString + ', '+ FQRMAESTRO.QR.FieldByName('NOMBRE').AsString  + ' ] ';

  SetLabel;
  Try
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAdm_Documento.DsDataChangeMaster, ' + E.Message);
    End;
  End;
end;

Procedure TFrIWAdm_Documento.DsStateMaster(pSender : TObject);
Begin
  If Not FQRMAESTRO.Active Then
    Exit;

  Estado_Controles;
  If FQRMAESTRO.Mode_Edition Then
    PAGINAS.ActivePage := 1;
  Case FQRMAESTRO.DS.State Of
    dsInsert : Begin
//                 If CODIGO_DOCUMENTO_ADM.Enabled Then
//                   CODIGO_DOCUMENTO_ADM.SetFocus;
               End;
    dsEdit   : Begin
//                 If NOMBRE.Enabled Then
//                   NOMBRE.SetFocus;
               End;
  End;
End;

Function TFrIWAdm_Documento.AbrirMaestro(Const pDato : String = '') : Boolean;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(Id_Documento_ADM).Caption;
  Result := False;
  Try
    FQRMAESTRO.Active := False;
    FQRMAESTRO.SENTENCE := ' SELECT * FROM ' + Retornar_Info_Tabla(Id_Documento_ADM).Name + ' ';
    FQRMAESTRO.WHERE    := '';
    If Trim(pDato) <> '' Then
    Begin
      FQRMAESTRO.WHERE := ' WHERE CODIGO_DOCUMENTO_ADM LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' OR NOMBRE LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
    End;
    FQRMAESTRO.ORDER := ' ORDER BY CODIGO_DOCUMENTO_ADM ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAdm_Documento.AbrirMaestro, ' + E.Message);
    End;
  End;
  FGRID_MAESTRO.RefreshData;
End;

procedure TFrIWAdm_Documento.IWAppFormCreate(Sender: TObject);
begin
  Randomize;
  Self.Name := 'DOCUMENTO' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Codigo'           , Resultado_Codigo           );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Nombre'           , Resultado_Nombre           );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Inicial'          , Resultado_Inicial          );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Actual'           , Resultado_Actual           );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Final'            , Resultado_Final            );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Formato'          , Resultado_Formato          );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_Activo'           , Resultado_Activo           );
  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(Id_Documento_ADM).Caption;
  Try
    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;
    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;

    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Documento_ADM).Name, Retornar_Info_Tabla(Id_Documento_ADM).Caption);

    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_BEFORE_POST  := Validar_Campos_Master;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;

    CODIGO_DOCUMENTO_ADM.DataSource := FQRMAESTRO.DS;
    NOMBRE.DataSource               := FQRMAESTRO.DS;
    DOCUMENTO_INICIAL.DataSource    := FQRMAESTRO.DS;
    DOCUMENTO_ACTUAL.DataSource     := FQRMAESTRO.DS;
    DOCUMENTO_FINAL.DataSource      := FQRMAESTRO.DS;
    FORMATO.DataSource              := FQRMAESTRO.DS;

    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['CODIGO_DOCUMENTO_ADM', 'NOMBRE'     ],
                                         ['Usuario'             , 'Nombre'     ],
                                         ['S'                   , 'N'          ],
                                         [100                   , 550          ],
                                         [taRightJustify        , taLeftJustify]);


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

    If AbrirMaestro Then
    Begin
    End
    Else
      Release_Me
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAdm_Documento.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWAdm_Documento.IWAppFormDestroy(Sender: TObject);
begin
  Try
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
      UtLog_Execute('TFrIWAdm_Documento.IWAppFormDestroy, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.NewRecordMaster(pSender: TObject);
begin
  Inherited;
  Try
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAdm_Documento.NewRecordMaster, ' + E.Message);
    End;
  End;
end;

procedure TFrIWAdm_Documento.BtnAcarreoAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  FQRMAESTRO.SetAcarreo(Not FQRMAESTRO.ACARREO, ['CODIGO_DOCUMENTO_ADM'], [FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString]);
//  If Not FQRMAESTRO.ACARREO Then
//    BtnAcarreo.Hint := 'Acarreo Inactivo'
//  Else
//    BtnAcarreo.Hint := 'Acarreo Activo';
end;

procedure TFrIWAdm_Documento.BTNACTIVOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Está seguro(a) de activar el registro?', Self.Name + '.Resultado_Activo', 'Activar', 'Sí', 'No')
end;

procedure TFrIWAdm_Documento.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  If FQRMAESTRO.Mode_Edition Then
    FQRMAESTRO.QR.Cancel;
  Release_Me;
end;

procedure TFrIWAdm_Documento.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;

procedure TFrIWAdm_Documento.BTNCODIGO_DOCUMENTO_ADMAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el código del documento', Self.Name + '.Resultado_Codigo', 'Código', FQRMAESTRO.QR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNCODIGO_DOCUMENTO_ADMAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNDOCUMENTO_ACTUALAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el documento actual', Self.Name + '.Resultado_Actual', 'Documento actual', FQRMAESTRO.QR.FieldByName('DOCUMENTO_ACTUAL').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNDOCUMENTO_ACTUALAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNDOCUMENTO_FINALAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el documento final', Self.Name + '.Resultado_Final', 'Documento final', FQRMAESTRO.QR.FieldByName('DOCUMENTO_FINAL').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNDOCUMENTO_FINALAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNDOCUMENTO_INICIALAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el documento inicial', Self.Name + '.Resultado_Inicial', 'Documento inicial', FQRMAESTRO.QR.FieldByName('DOCUMENTO_INICIAL').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNDOCUMENTO_INICIALAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNFORMATO2AsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el archivo formato 2', Self.Name + '.Resultado_Formato2', 'Formato 2', FQRMAESTRO.QR.FieldByName('FORMATO2').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNFORMATO2AsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNFORMATO3AsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el archivo formato 3', Self.Name + '.Resultado_Formato3', 'Formato 3', FQRMAESTRO.QR.FieldByName('FORMATO3').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNFORMATO3AsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNFORMATOAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el archivo formato', Self.Name + '.Resultado_Formato', 'Formato', FQRMAESTRO.QR.FieldByName('FORMATO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNFORMATOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNNOMBREAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre del documento', Self.Name + '.Resultado_Nombre', 'Nombre', FQRMAESTRO.QR.FieldByName('NOMBRE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNNUEVO_PREFIJOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nuevo prefijo', Self.Name + '.Resultado_Nuevo_Prefijo', 'Nuevo prefijo', FQRMAESTRO.QR.FieldByName('NUEVO_PREFIJO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNNUEVO_PREFIJOAsyncClick, ' + e.Message);
  End;
end;

procedure TFrIWAdm_Documento.BTNPREFIJO_DOCUMENTOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el prefijo del documento', Self.Name + '.Resultado_Prefijo_Documento', 'Prefijo del documento', FQRMAESTRO.QR.FieldByName('PREFIJO_DOCUMENTO').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWAdm_Documento.BTNPREFIJO_DOCUMENTOAsyncClick, ' + e.Message);
  End;
end;

end.
