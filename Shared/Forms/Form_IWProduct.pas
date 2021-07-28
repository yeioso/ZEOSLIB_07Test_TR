unit Form_IWProduct;
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
  TFrIWProduct = class(TIWAppForm)
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
    CODIGO: TIWDBLabel;
    BTNNAME: TIWImage;
    NOMBRE: TIWDBLabel;
    BTNID: TIWImage;
    IWRegion_Navegador: TIWRegion;
    IWLabel2: TIWLabel;
    BTNPRICE: TIWImage;
    PRECIO: TIWDBLabel;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNIDAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNNAMEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNPRICEAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCNX : TConexion;
    FINFO : String;
    FQRMAESTRO : TMANAGER_DATA;
    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;
    FCODIGO_BODEGA : String;
    Procedure Release_Me;
    Function Existe_Product(Const pID : String) : Boolean;
    procedure Resultado_ID(EventParams: TStringList);
    procedure Resultado_NAME(EventParams: TStringList);
    procedure Resultado_PRICE(EventParams: TStringList);
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

procedure TFrIWProduct.Resultado_ID(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('ID').AsString := Justificar(EventParams.Values['InputStr'], '0', FQRMAESTRO.QR.FieldByName('ID').Size);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProduct.Resultado_ID, ' + e.Message);
  End;
End;
procedure TFrIWProduct.Resultado_NAME(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('NAME').AsString := AnsiUpperCase(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProduct.Resultado_NAME, ' + e.Message);
  End;
End;
procedure TFrIWProduct.Resultado_PRICE(EventParams: TStringList);
Begin
  Try
    If FQRMAESTRO.Mode_Edition And (Result_Is_OK(EventParams.Values['RetValue'])) Then
    Begin
      FQRMAESTRO.QR.FieldByName('PRICE').AsFloat := SetToFloat(Trim(EventParams.Values['InputStr']));
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProduct.Resultado_PRICE, ' + e.Message);
  End;
End;
Procedure TFrIWProduct.Release_Me;
Begin
  Self.Release;
End;
Function TFrIWProduct.Existe_Product(Const pID : String) : Boolean;
Begin
  Result := UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Product).Name, ['ID'], [pID]);
End;
Procedure TFrIWProduct.Validar_Campos_Master(pSender : TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    CODIGO.BGColor := UserSession.COLOR_OK;
    NOMBRE.BGColor := UserSession.COLOR_OK;
    If FQRMAESTRO.Mode_Edition And (Not Vacio(FQRMAESTRO.QR.FieldByName('NAME').AsString)) Then
      FQRMAESTRO.QR.FieldByName('NAME').AsString := AnsiUpperCase(FQRMAESTRO.QR.FieldByName('NAME').AsString);
    If BTNID.Visible And UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Product).Name, ['ID'], [FQRMAESTRO.QR.FieldByName('ID').AsString]) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'ID exist';
      CODIGO.BGColor := UserSession.COLOR_ERROR;
    End;
    If BTNID.Visible And Vacio(FQRMAESTRO.QR.FieldByName('ID').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'ID empty';
      CODIGO.BGColor := UserSession.COLOR_ERROR;
    End;
    If BTNNAME.Visible And Vacio(FQRMAESTRO.QR.FieldByName('NAME').AsString) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'NAME empty';
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
      UtLog_Execute('TFrIWProduct.Validar_Campos_Master, ' + E.Message);
  End;
End;

Procedure TFrIWProduct.Estado_Controles;
Begin
  BTNID.Visible    := (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  BTNNAME.Visible  := FQRMAESTRO.Mode_Edition And Documento_Activo;
  BTNPRICE.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;
  DATO.Visible     := (Not FQRMAESTRO.Mode_Edition);
  PAG_00.Visible   := (Not FQRMAESTRO.Mode_Edition);
  PAG_01.Visible   := True;
End;
Procedure TFrIWProduct.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProduct.SetLabel, ' + E.Message);
    End;
  End;
End;
Function TFrIWProduct.Documento_Activo : Boolean;
Begin
  Try
    Result := True;
    //Result := (FQRMAESTRO.RecordCount >= 1) {And (Trim(FQRMAESTRO.FieldByName('ID_ANULADO').AsString) <> 'S')};
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProduct.Documento_Activo, ' + E.Message);
    End;
  End;
End;
procedure TFrIWProduct.DsDataChangeMaster(pSender: TObject);
begin
  FNAVEGADOR.UpdateState;
  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + FQRMAESTRO.QR.FieldByName('ID').AsString + ', ' + FQRMAESTRO.QR.FieldByName('NAME').AsString + ' ] ';
  Try
    SetLabel;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProduct.DsDataChangeMaster, ' + E.Message);
    End;
  End;
end;
Procedure TFrIWProduct.DsStateMaster(pSender: TObject);
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
Function TFrIWProduct.AbrirMaestro(Const pDato : String = '') : Boolean;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(Id_Product).Caption;
  Result := False;
  Try
    FQRMAESTRO.Active := False;
    FQRMAESTRO.WHERE := '';
    FQRMAESTRO.SENTENCE := ' SELECT ' + UserSession.CNX.Top_Sentence(UserSession.Const_Max_Record) + ' * FROM ' + Retornar_Info_Tabla(Id_Product).Name + ' ';
    If Trim(pDato) <> '' Then
    Begin
      FQRMAESTRO.WHERE := ' WHERE ID LIKE ' + QuotedStr('%' + Trim(pDato) + '%') ;
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' OR NAME LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
    End;
    FQRMAESTRO.ORDER := ' ORDER BY ID ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
    If Result Then
    Begin
    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProduct.AbrirMaestro, ' + E.Message);
    End;
  End;
  FGRID_MAESTRO.RefreshData;
End;

procedure TFrIWProduct.IWAppFormCreate(Sender: TObject);
Var
  lI : Integer;
begin
  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(Id_Product).Caption;
  Randomize;
  Self.Name := Self.Name + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FCNX := UserSession.CNX;
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_ID'  , Resultado_ID  );
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_NAME', Resultado_NAME);
  WebApplication.RegisterCallBack(Self.Name + '.Resultado_PRICE' , Resultado_PRICE );
  Try
    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;
    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;
    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Product).Name, Retornar_Info_Tabla(Id_Product).Caption);
    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_BEFORE_POST  := Validar_Campos_Master;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;
    CODIGO.DataSource := FQRMAESTRO.DS;
    NOMBRE.DataSource := FQRMAESTRO.DS;
    PRECIO.DataSource := FQRMAESTRO.DS;
    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['ID'           , 'NAME'       ],
                                         ['ID'           , 'NAME'       ],
                                         ['S'            , 'N'          ],
                                         [100            , 200          ],
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
      UtLog_Execute('TFrIWProduct.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;
procedure TFrIWProduct.IWAppFormDestroy(Sender: TObject);
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
        UtLog_Execute('TFrIWProduct.IWAppFormDestroy, ' + e.Message);
    End;
end;
procedure TFrIWProduct.NewRecordMaster(pSender: TObject);
begin
  Try
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWProduct.NewRecordMaster, ' + E.Message);
    End;
  End;
end;
procedure TFrIWProduct.BTNPRICEAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el precio ', Self.Name + '.Resultado_PRICE', 'PRICE', FQRMAESTRO.QR.FieldByName('PRICE').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProduct.BTNPRICEAsyncClick, ' + e.Message);
  End;
end;

Procedure TFrIWProduct.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Release_Me;
end;
procedure TFrIWProduct.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;
procedure TFrIWProduct.BTNIDAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el ID', Self.Name + '.Resultado_ID', 'ID', FQRMAESTRO.QR.FieldByName('ID').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProduct.BTNCODIGOAsyncClick, ' + e.Message);
  End;
end;
procedure TFrIWProduct.BTNNAMEAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Try
    If FQRMAESTRO.Mode_Edition Then
    Begin
      WebApplication.ShowPrompt('Ingrese el nombre', Self.Name + '.Resultado_NAME', 'NAME', FQRMAESTRO.QR.FieldByName('NAME').AsString);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWProduct.BTNNOMBREAsyncClick, ' + e.Message);
  End;
end;
end.
