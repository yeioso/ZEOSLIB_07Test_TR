unit Form_IWAyuda;

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
  IWCompFileUploader, UtGrid_JQ, UtNavegador_ASE;

type
  TFrIWAyuda = class(TIWAppForm)
    RINFO: TIWRegion;
    lbInfo: TIWLabel;
    IWRegion1: TIWRegion;
    PAGINAS: TIWTabControl;
    PAG_00: TIWTabPage;
    PAG_01: TIWTabPage;
    RNAVEGADOR: TIWRegion;
    lbCodigo: TIWLabel;
    IWLabel8: TIWLabel;
    DATO: TIWEdit;
    NOMBRE: TIWDBEdit;
    CODIGO_AYUDA: TIWDBEdit;
    lbModulo: TIWLabel;
    MODULO: TIWDBEdit;
    IWLabel3: TIWLabel;
    DESCRIPCION: TIWDBMemo;
    lbActualizado: TIWLabel;
    ACTUALIZACION: TIWDBMemo;
    IMAGEN: TIWDBImage;
    IWFileUploader1: TIWFileUploader;
    IWRegion_Navegador: TIWRegion;
    procedure BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure IWAppFormDestroy(Sender: TObject);
    procedure BTNBUSCARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BtnAcarreoAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWFileUploader1AsyncUploadCompleted(Sender: TObject; var DestPath, FileName: string; var SaveFile, Overwrite: Boolean);
    procedure IWFileUploader1AsyncUploadSuccess(Sender: TObject; EventParams: TStringList);
    procedure NOMBREAsyncExit(Sender: TObject; EventParams: TStringList);
    procedure MODULOAsyncExit(Sender: TObject; EventParams: TStringList);
  private
    FINFO : String;
    FFILTRO : String;
    FCONSULTA : Boolean;

    FQRMAESTRO : TMANAGER_DATA;

    FNAVEGADOR : TNavegador_ASE;
    FGRID_MAESTRO : TGRID_JQ;

    FEJECUTANDO_ONCHANGE : Boolean;
    Procedure Release_Me;

    Function Existe_Ayuda(Const pCODIGO_AYUDA : String) : Boolean;

    Procedure Prellenar_Informacion_Master(Sender: TObject; EventParams: TStringList);

    Procedure Validar_Campos_Master(pSender : TObject);
    Function Documento_Activo : Boolean;

    Procedure NewRecordMaster(pSender : TObject);
    Procedure BeforePostMaster(pSender : TObject);
    Procedure DsDataChangeMaster(pSender : TObject);
    Procedure DsStateMaster(pSender : TObject);

    Procedure SetLabel;
    Procedure Estado_Controles;
  public
    Property FILTRO : String Read FFILTRO Write FFILTRO;
    Property CONSULTA : Boolean Read FCONSULTA Write FCONSULTA;
    Function AbrirMaestro(Const pDato : String = '') : Boolean;
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

procedure TFrIWAyuda.IWAppFormCreate(Sender: TObject);
begin
  Randomize;
  Self.Name := 'Ayuda' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  FEJECUTANDO_ONCHANGE := False;
  FINFO := UserSession.FULL_INFO + Retornar_Info_Tabla(Id_Ayuda).Caption;
  Try
    FGRID_MAESTRO        := TGRID_JQ.Create(PAG_00);
    FGRID_MAESTRO.Parent := PAG_00;

    FGRID_MAESTRO.Top    := 010;
    FGRID_MAESTRO.Left   := 010;
    FGRID_MAESTRO.Width  := 700;
    FGRID_MAESTRO.Height := 500;

    FQRMAESTRO := UserSession.Create_Manager_Data(Retornar_Info_Tabla(Id_Ayuda).Name, Retornar_Info_Tabla(Id_Ayuda).Caption);

    FQRMAESTRO.ON_NEW_RECORD   := NewRecordMaster;
    FQRMAESTRO.ON_DATA_CHANGE  := DsDataChangeMaster;
    FQRMAESTRO.ON_STATE_CHANGE := DsStateMaster;

    CODIGO_AYUDA.DataSource  := FQRMAESTRO.DS;
    NOMBRE.DataSource        := FQRMAESTRO.DS;
    MODULO.DataSource        := FQRMAESTRO.DS;
    DESCRIPCION.DataSource   := FQRMAESTRO.DS;
    IMAGEN.DataSource        := FQRMAESTRO.DS;
    ACTUALIZACION.DataSource := FQRMAESTRO.DS;

    FGRID_MAESTRO.SetGrid(FQRMAESTRO.DS, ['CODIGO_AYUDA', 'NOMBRE'     ],
                                         ['Código'      , 'Nombre'     ],
                                         ['S'           , 'N'          ],
                                         [100           , 550          ],
                                         [taRightJustify, taLeftJustify]);

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
      UtLog_Execute('TFrIWAyuda_Enc.IWAppFormCreate, ' + E.Message);
    End;
  End;
end;

procedure TFrIWAyuda.IWAppFormDestroy(Sender: TObject);
begin
    Try
      If Assigned(FQRMAESTRO) Then
      Begin
        FQRMAESTRO.Active := False;
        FreeAndNil(FQRMAESTRO);
      End;

      If Assigned(FGRID_MAESTRO) Then
        FreeAndNil(FGRID_MAESTRO);

    Except
      On E: Exception Do
        UtLog_Execute('TFrIWAyuda_Enc.IWAppFormDestroy, ' + e.Message);
    End;
end;

procedure TFrIWAyuda.MODULOAsyncExit(Sender: TObject; EventParams: TStringList);
begin
  If FQRMAESTRO.Mode_Edition Then
    FQRMAESTRO.QR.FieldByName('MODULO').AsString := AnsiUpperCase(Trim(FQRMAESTRO.QR.FieldByName('MODULO').AsString));
end;

Procedure TFrIWAyuda.Release_Me;
Begin
  Self.Release;
End;

Function TFrIWAyuda.Existe_Ayuda(Const pCODIGO_AYUDA : String) : Boolean;
Begin
  Result := UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Ayuda).Name, ['CODIGO_AYUDA'], [pCODIGO_AYUDA]);
End;

Procedure TFrIWAyuda.Prellenar_Informacion_Master(Sender: TObject; EventParams: TStringList);
Begin
  If FQRMAESTRO.Mode_Edition Then
    FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA').AsString := Justificar(FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA').AsString, '0', FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA').Size);
  Validar_Campos_Master(Nil);
End;

Procedure TFrIWAyuda.Validar_Campos_Master(pSender : TObject);
Var
  lMensaje : String;
Begin
  FQRMAESTRO.ERROR := 0;
  Try
    lMensaje := '';
    NOMBRE.BGColor := UserSession.COLOR_OK;
    CODIGO_AYUDA.BGColor := UserSession.COLOR_OK;

    If CODIGO_AYUDA.Enabled And UserSession.CNX.Record_Exist(Retornar_Info_Tabla(Id_Ayuda).Name, ['CODIGO_AYUDA'], [FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA').AsString]) Then
    Begin
      lMensaje := lMensaje + IfThen(Not Vacio(lMensaje), ', ') + 'Ayuda invalido';
      CODIGO_AYUDA.BGColor := UserSession.COLOR_ERROR;
    End;

    If NOMBRE.Enabled And Vacio(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString) Then
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
      UtLog_Execute('TFrIWAyuda_Enc.Validar_Campos_Master, ' + E.Message);
  End;
End;


Procedure TFrIWAyuda.Estado_Controles;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;

  CODIGO_AYUDA.Enabled    :=  (FQRMAESTRO.DS.State In [dsInsert]) And Documento_Activo;
  NOMBRE.Enabled          :=  FQRMAESTRO.Mode_Edition And Documento_Activo;
  MODULO.Enabled          :=  FQRMAESTRO.Mode_Edition And Documento_Activo;
  DESCRIPCION.Enabled     :=  FQRMAESTRO.Mode_Edition And Documento_Activo;
  ACTUALIZACION.Enabled   :=  False;
  IMAGEN.Enabled          := FQRMAESTRO.Mode_Edition And Documento_Activo;
  IWFileUploader1.Visible := FQRMAESTRO.Mode_Edition And Documento_Activo;
//  BtnAcarreo.Visible      := (Not FQRMAESTRO.Mode_Edition) And (FQRMAESTRO.QR.RecordCount > 0) And (Not FCONSULTA);
  If FCONSULTA Then
  Begin
    FNAVEGADOR.HideButtons;
//    IWRegion_Navegador.Visible := False;
//    NAVEGADOR.VisibleButtons := NAVEGADOR.VisibleButtons - [TNavigateBtn.nbInsert];
//    NAVEGADOR.VisibleButtons := NAVEGADOR.VisibleButtons - [TNavigateBtn.nbEdit  ];
//    NAVEGADOR.VisibleButtons := NAVEGADOR.VisibleButtons - [TNavigateBtn.nbDelete];
//    NAVEGADOR.VisibleButtons := NAVEGADOR.VisibleButtons - [TNavigateBtn.nbCancel];
//    NAVEGADOR.VisibleButtons := NAVEGADOR.VisibleButtons - [TNavigateBtn.nbPost  ];
    lbCodigo.Visible         := False;
    lbModulo.Visible         := False;
    lbActualizado.Visible    := False;
    CODIGO_AYUDA.Visible     := False;
    ACTUALIZACION.Visible    := False;
    MODULO.Visible           := False;
    DATO.Visible             := (Not FQRMAESTRO.Mode_Edition);
//    BTNBUSCAR.Visible        := (Not FQRMAESTRO.Mode_Edition);
    PAG_00.Visible           := (Not FQRMAESTRO.Mode_Edition);
    PAG_01.Visible           := True;
    If FILTRO = 'LOGIN' Then
    Begin
//      BTNBUSCAR.Visible := False;
      DATO.Visible      := False;
    End;
  End;
End;

Procedure TFrIWAyuda.SetLabel;
Begin
  If Not FQRMAESTRO.Active Then
    Exit;
  Try

  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAyuda_Enc.SetLabel, ' + E.Message);
    End;
  End;
End;

Function TFrIWAyuda.Documento_Activo : Boolean;
Begin
  Try
    Result := True;
    //Result := (FQRMAESTRO.RecordCount >= 1) {And (Trim(FQRMAESTRO.FieldByName('ID_ANULADO').AsString) <> 'S')};
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAyuda_Enc.Documento_Activo, ' + E.Message);
    End;
  End;
End;

procedure TFrIWAyuda.DsDataChangeMaster(pSender : TObject);
begin
  FNAVEGADOR.UpdateState;
  FNAVEGADOR.HideButtons;
  If FEJECUTANDO_ONCHANGE Or (Not FQRMAESTRO.Active)Then
    Exit;

  If FQRMAESTRO.Active Then
    lbInfo.Caption := FINFO + ' [ ' + FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA').AsString + ', ' + FQRMAESTRO.QR.FieldByName('NOMBRE').AsString + ' ] ';
  SetLabel;
  FEJECUTANDO_ONCHANGE := True;
  Try
    If FQRMAESTRO.Mode_Edition Then
      Prellenar_Informacion_Master(Nil, Nil);
//    If FNEW_RECORD And Modo_Edicion_Master Then
//      UserSession.PutInfoData(FQRMAESTRO);
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAyuda_Enc.DsDataChangeMaster, ' + E.Message);
    End;
  End;
  FEJECUTANDO_ONCHANGE := False;
end;

Procedure TFrIWAyuda.DsStateMaster(pSender : TObject);
Begin
  If Not FQRMAESTRO.Active Then
    Exit;

  Estado_Controles;

  If FQRMAESTRO.Mode_Edition Then
    PAGINAS.ActivePage := 1;
  Case FQRMAESTRO.DS.State Of
    dsInsert : Begin
                 If CODIGO_AYUDA.Enabled Then
                   CODIGO_AYUDA.SetFocus;
               End;
    dsEdit   : Begin
                 If NOMBRE.Enabled Then
                   NOMBRE.SetFocus;
               End;
  End;
End;

Function TFrIWAyuda.AbrirMaestro(Const pDato : String = '') : Boolean;
Var
  lWhere : Boolean;
Begin
  FGRID_MAESTRO.Caption := Retornar_Info_Tabla(Id_Ayuda).Caption;
  Try
    FQRMAESTRO.Active := False;
    FQRMAESTRO.SENTENCE := ' SELECT * FROM ' + Retornar_Info_Tabla(Id_Ayuda).Name + ' ';
    If Not Vacio(FILTRO) Then
      FQRMAESTRO.WHERE := ' WHERE MODULO LIKE  ' + QuotedStr('%' + Trim(FILTRO) + '%') ;
    If Trim(pDato) <> '' Then
    Begin
      lWhere := Pos('WHERE', FQRMAESTRO.WHERE) <= 0;
      If Not lWhere Then
        FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' WHERE '
      Else
      Begin
        FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' AND ';
        FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' ( ';
      End;
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + '  CODIGO_AYUDA LIKE '     + QuotedStr('%' + Trim(pDato) + '%');
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + '  OR NOMBRE LIKE '        + QuotedStr('%' + Trim(pDato) + '%');
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + '  OR DESCRIPCION LIKE '   + QuotedStr('%' + Trim(pDato) + '%');
      FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + '  OR ACTUALIZACION LIKE ' + QuotedStr('%' + Trim(pDato) + '%');
      If lWhere Then
        FQRMAESTRO.WHERE := FQRMAESTRO.WHERE + ' ) ';
    End;
    FQRMAESTRO.ORDER := ' ORDER BY NOMBRE ';
    FQRMAESTRO.Active := True;
    Result := FQRMAESTRO.Active;
    If Result Then
    Begin

    End;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAyuda_Enc.AbrirMaestro, ' + E.Message);
    End;
  End;
End;



procedure TFrIWAyuda.IWFileUploader1AsyncUploadCompleted(Sender: TObject;
  var DestPath, FileName: string; var SaveFile, Overwrite: Boolean);
var
  MS: TMemoryStream;
begin
  // Create any TStream descendant
  MS := TMemoryStream.Create;
  try
    // Save the file content to that stream
    IWFileUploader1.SaveToStream(FileName, MS);
    // inform IWFileUploader that we are handling it ourselves. No need to save the file
    SaveFile := False;
    // do whatever you want here with the TStream containing the file. For instance, save to the ClientDataSet
      // set to the start of the Stream
    MS.Position := 0;
      // save to the blob field
    TBlobField(FQRMAESTRO.QR.FieldByName('IMAGEN')).LoadFromStream(MS);
  finally
    // Release the stream
    MS.Free;
  end;
end;

procedure TFrIWAyuda.IWFileUploader1AsyncUploadSuccess(Sender: TObject;
  EventParams: TStringList);
var
  js: string;
begin
  // this will force the page reload, so the image in IWDBImage control will be rendered
  js := 'location.reload(true);';
  WebApplication.CallBackResponse.AddJavaScriptToExecuteAsCDATA(js);
end;

procedure TFrIWAyuda.NewRecordMaster(pSender : TObject);
begin
  Inherited;
  Try
    FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA' ).AsString := UserSession.CNX.Next(Retornar_Info_Tabla(Id_Ayuda).Name, '0', ['CODIGO_AYUDA'], [],[], FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA').Size);
    FQRMAESTRO.QR.FieldByName('MODULO' ).AsString := AnsiUpperCase(Trim(FFILTRO));
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TFrIWAyuda_Enc.NewRecordMaster, ' + E.Message);
    End;
  End;
end;

procedure TFrIWAyuda.NOMBREAsyncExit(Sender: TObject; EventParams: TStringList);
begin
  If FQRMAESTRO.Mode_Edition Then
    FQRMAESTRO.QR.FieldByName('NOMBRE').AsString := AnsiUpperCase(Trim(FQRMAESTRO.QR.FieldByName('NOMBRE').AsString));
end;

procedure TFrIWAyuda.BeforePostMaster(pSender : TObject);
begin
  Inherited;

  If FQRMAESTRO.Mode_Edition Then
    FQRMAESTRO.QR.FieldByName('ACTUALIZACION').AsString := FQRMAESTRO.QR.FieldByName('ACTUALIZACION').AsString + IfThen(Not Vacio(FQRMAESTRO.QR.FieldByName('ACTUALIZACION').AsString), #13);
end;

procedure TFrIWAyuda.BtnAcarreoAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  FQRMAESTRO.SetAcarreo(Not FQRMAESTRO.ACARREO, ['CODIGO_AYUDA'], [FQRMAESTRO.QR.FieldByName('CODIGO_AYUDA').AsString]);
//  If Not FQRMAESTRO.ACARREO Then
//    BtnAcarreo.Hint := 'Acarreo Inactivo'
//  Else
//    BtnAcarreo.Hint := 'Acarreo Activo';
end;

procedure TFrIWAyuda.BTNBACKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  If FQRMAESTRO.Mode_Edition Then
    FQRMAESTRO.QR.Cancel;
  Release_Me;
end;

procedure TFrIWAyuda.BTNBUSCARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  AbrirMaestro(DATO.Text);
end;

end.
