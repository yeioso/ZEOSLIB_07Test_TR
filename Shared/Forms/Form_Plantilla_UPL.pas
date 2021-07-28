unit Form_Plantilla_UPL;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, PReport,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg, PRJpegImage, PdfDoc, Generics.Collections,
  UtPowerPDF, UtPowerPDF_TEST_TR, UtConexion, IWApplication;

type
  TFrPlantilla_Documento = class(TForm)
    PAGINA: TPRPage;
    HEAD: TPRLayoutPanel;
    IMAGEN: TPRJpegImage;
    PRLabel1: TPRLabel;
    PRLabel2: TPRLabel;
    PRLabel3: TPRLabel;
    TIPO_DOCUMENTO: TPRLabel;
    PRLabel7: TPRLabel;
    PRLabel8: TPRLabel;
    PRRect1: TPRRect;
    PRLabel6: TPRLabel;
    PRLabel4: TPRLabel;
    PRLabel5: TPRLabel;
    PRLabel9: TPRLabel;
    PRLabel10: TPRLabel;
    PRLabel11: TPRLabel;
    PRLabel12: TPRLabel;
    DAY: TPRLabel;
    MONTH: TPRLabel;
    YEAR: TPRLabel;
    NOMBRE_SINONIMO: TPRLabel;
    DIRECCION: TPRLabel;
    CONCEPTO: TPRLabel;
    PRRect3: TPRRect;
    PRRect4: TPRRect;
    PRRect5: TPRRect;
    PRRect2: TPRRect;
    PRLayoutPanel1: TPRLayoutPanel;
    PRLabel13: TPRLabel;
    PRLabel14: TPRLabel;
    PRLabel15: TPRLabel;
    PRLabel16: TPRLabel;
    NOMBRE_DESPACHADO: TPRLabel;
    NOMBRE_TRANSPORTADOR: TPRLabel;
    PLACAS: TPRLabel;
    PRRect6: TPRRect;
    PRLabel17: TPRLabel;
    PRLayoutPanel2: TPRLayoutPanel;
    PRLabel18: TPRLabel;
    PRText1: TPRText;
    PReport1: TPReport;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FPages : TPages;
    Procedure SetPages;
    Procedure SetHead(pTitle : TTITLE; pQR : TQUERY; Const pNumero_Documento : String; Var pError : String);
  public
    { Public declarations }
  end;


Var
  FrPlantilla_Documento : TFrPlantilla_Documento;

Function Form_Plantilla_Reporte_TEST_TR(pApp : TIWApplication; Var pError : String) : Boolean;

implementation
{$R *.dfm}
Uses
  UtLog,
  UtFecha,
  StrUtils,
  UtFuncion,
  IWAppCache,
  IWMimeTypes,
  UtInfoTablas,
  IW.CacheStream,
  ServerController;

Procedure TFrPlantilla_Documento.SetPages;
Var
  lI : Integer;
  lJ : Integer;
  lPagina : TPRPage;
Begin
  For lI := 0 To FPages.Count - 1 Do
  Begin
    lPagina := FPages[lI];
    For lJ := 0 To lPagina.ComponentCount - 1 Do
      If lPagina.Components[lJ] Is TTITLE Then
        (lPagina.Components[lJ] As TTITLE).PAGINA.Caption := 'Pagina: ' + FormatFloat('###,##0', lI + 1) + ' / ' + FormatFloat('###,##0', FPages.Count);
  End;
End;

Procedure TFrPlantilla_Documento.SetHead(pTitle : TTITLE; pQR : TQUERY; Const pNumero_Documento : String; Var pError : String);
Begin
  Try
    pTitle.IMAGEN.Picture.Assign(Self.IMAGEN.Picture);
    pTitle.TIPO_DOCUMENTO.Caption := '';
    pTitle.NUMERO_DOCUMENTO.Caption := '';
    pTitle.MUNICIPIO.Caption := '';
    pTitle.TELEFONO.Caption := '';
    pTitle.DIRECCION.Caption := '';
    pTitle.NIT_NOMBRE.Caption := '';
    pTitle.NUMERO_DOCUMENTO.Caption := '';
    If Not Vacio(pNumero_Documento) Then
    Begin
      If Copy(pQR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'SI' Then
        pTitle.TIPO_DOCUMENTO.Caption := 'SALDO INICIAL'
      Else
        If Copy(pQR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'EN' Then
          pTitle.TIPO_DOCUMENTO.Caption := 'ENTRADA'
        Else
         If Copy(pQR.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'SA' Then
          pTitle.TIPO_DOCUMENTO.Caption := 'SALIDA';
      pTitle.TIPO_DOCUMENTO.FontSize := 9;
      pTitle.NUMERO_DOCUMENTO.Caption := pNumero_Documento;
      pTitle.NUMERO_DOCUMENTO.FontSize := 8;
    End;
  Except
    On E: Exception Do
    Begin
      pError := E.Message;
      UtLog_Execute('TFrPlantilla_Documento.SetHead, ' + E.Message);
    End;
  End;
End;

Function Form_Plantilla_Reporte_TEST_TR(pApp : TIWApplication; Var pError : String) : Boolean;
Var
  lI : Integer;
  lF : TFrPlantilla_Documento;
  lM : TQUERY;
  lURL : String;
  lTop : Integer;
  lTITLE  : TTITLE;
  lDETAIL : TDETAIL_TEST_TR  ;
  lFOOT   : TFOOT_FINAL;
  lPagina : TPRPage;
  lDestino : String;
Begin
  Result := False;
  pError := '';
  lDestino := TIWAppCache.NewTempFileName('.pdf');
  Try
    lM := TQUERY.Create(Nil);
    lM.Connection := UserSession.CNX;
    lM.SQL.Add(' SELECT * FROM ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' (NOLOCK) ');
    lM.SQL.Add(' WHERE ' + UserSession.CNX.Trim_Sentence('CODIGO_USUARIO') + ' = ' + QuotedStr(Trim(UserSession.CODIGO_USUARIO)));
    lM.SQL.Add(' ORDER BY LINEA ');
    lM.Active := True;
    If lM.Active And (lM.RecordCount > 0) Then
    Begin
      lTop := 3;
      lF := TFrPlantilla_Documento.Create(Nil);
      lPagina := TPRPage.Create(lF);
      lPagina.Parent := lF;
      lF.FPages.Add(lPagina);

      lTITLE := TTITLE.Create(lPagina);
      lTITLE.Parent := lPagina;
      lDETAIL        := TDETAIL_TEST_TR.Create(lPagina);
      lDETAIL.Parent := lPagina;

      lTop := lTITLE.Height;

      lM.First;
      lF.SetHead(lTITLE, lM, '', pError);

      lTITLE.Top   := 001;
      lTITLE.Left  := 007;
      lTITLE.Width := lPagina.Width - 2;

      lDETAIL.Top    := lTITLE.Height;
      lDETAIL.Left   := 007;
      lDETAIL.Width  := lPagina.Width - 2;
      lDETAIL.Top    := lTITLE.Height;

      lTop := lTITLE.Height + lTITLE.Height;

      lM.First;
      While Not lM.Eof Do
      Begin
        lDETAIL.SetLine(lM.FieldByName('CONTENIDO').AsString, False);
        If (lTop + lDETAIL.CURRENT_TOP + lDETAIL.LAST_HEIGHT) > (lPagina.Height) Then
        Begin
          lPagina := TPRPage.Create(lF);
          lPagina.Parent := lF;
          lF.FPages.Add(lPagina);

          lTITLE := TTITLE.Create(lPagina);
          lTITLE.Parent := lPagina;
          lTITLE.Top   := 001;
          lTITLE.Left  := 007;
          lTITLE.Width := lPagina.Width - 2;
          lF.SetHead(lTITLE, lM, '', pError);

          lDETAIL        := TDETAIL_TEST_TR.Create(lPagina);
          lDETAIL.Parent := lPagina;
          lDETAIL.Left   := 007;
          lDETAIL.Width  := lPagina.Width - 2;
          lDETAIL.Top    := lTITLE.Height;
          lTop := lTITLE.Height;
        End;
        lM.Next;
      End;

      lFOOT        := TFOOT_FINAL.Create(lPagina);
      lFOOT.Parent := lPagina;
      lFOOT.Top    := lPagina.Height - lFOOT.Height;
      lFOOT.Left   := 007;
      lFOOT.Width  := lPagina.Width - 2;

      lF.SetPages;
      lF.PReport1.FileName := lDestino;
      lF.PReport1.BeginDoc;
      For lI := 0 To lF.FPages.Count-1 Do
      Begin
        lF.PReport1.Print(lF.FPages[lI]);
      End;
      lF.PReport1.EndDoc;
      FreeAndNil(lFOOT);
      FreeAndNil(lDETAIL);
      FreeAndNil(lTITLE);
      FreeAndNil(lF);
      Result := True;
    End;
    lM.Active := False;
    FreeAndNil(lM);
    If FileExists(lDestino) Then
    Begin
      lURL := TIWAppCache.AddFileToCache(pApp, lDestino, TIWMimeTypes.GetAsString(mtPDF), ctSession);
      pApp.NewWindow(lURL);
    End;
  Except
    On E: Exception Do
    Begin
      pError := E.Message;
      UtLog_Execute('Form_Plantilla_Documento_TEST_TR, ' + E.Message);
    End;
  End;
End;

procedure TFrPlantilla_Documento.FormCreate(Sender: TObject);
begin
  FPages := TPages.Create;
end;

procedure TFrPlantilla_Documento.FormDestroy(Sender: TObject);
Var
  lPage : TPRPage;
begin
  For lPage In FPages Do
    lPage.Free;
  FPages.Clear;
  FreeAndNil(FPages);
end;

end.
