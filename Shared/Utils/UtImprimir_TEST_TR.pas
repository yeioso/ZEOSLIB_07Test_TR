unit UtImprimir_UPL;

interface

Uses
  IWApplication;

Function UtImprimir_UPL_Documento(pApp : TIWApplication; Const pCODIGO_DOCUMENTO_ADM, pNumero_Documento : AnsiString; Var pError : AnsiString) : Boolean;

implementation
Uses
  DB,
  UtLog,
  UtXML,
  IWTypes,
  UtFuncion,
  UtConexion,

  IdContext,
  IdComponent,
  IdTCPClient,

  IWAppCache,
  IWMimeTypes,
  UtInfoTablas,
  Winapi.Windows,
  System.UITypes,
  IW.CacheStream,
  System.Classes,
  UserSessionUnit,
  System.SysUtils,
  ServerController,
  IW.Common.System,
  TableName_006Documento_ADM;

Function UtImprimir_UPL_Windows_Service(pNumero_Documento, pTemplate, pFilename : AnsiString; Var pError : AnsiString) : Boolean;
Var
  lLen : Integer;
  lData : String;
  lXML : TECGXmlFast;
  lCliente_TCP : TIdTCPClient;
begin
  Result := False;
  Try
    If UserSession.DB.WS_PORT > 0 Then
    Begin
      lCliente_TCP := TIdTCPClient.Create(Nil);
      lCliente_TCP.Port := UserSession.DB.WS_PORT;
      lCliente_TCP.Host := '127.0.0.1';
      lCliente_TCP.Connect;
      lXML := TECGXmlFast.Create;
      lXML.AsString['NUMERO_DOCUMENTO'] := pNumero_Documento                 ;
      lXML.AsString['ARCHIVO_FORMATO' ] := pTemplate                         ;
      lXML.AsString['ARCHIVO_SALIDA'  ] := pFilename                         ;
      lXML.AsString['CODIGO_USUARIO'  ] := UserSession.CODIGO_USUARIO        ;
      lXML.AsString['NOMBRE_USUARIO'  ] := UserSession.NOMBRE_USUARIO        ;
      lLen := Length(Trim(lXML.Value));
      lData := Justificar(IntToStr(lLen), '0', 7) + Trim(lXML.Value);
      lCliente_TCP.IOHandler.WriteLn(lData);
      lData := lCliente_TCP.IOHandler.ReadString(7);
      lLen := SetToInt(lData);
      If lLen > 0 Then
      Begin
        lData := lCliente_TCP.IOHandler.ReadString(lLen);
        lXML.Decode(lData);
        pError := lXML.AsString['ERROR'];
      End;
      lCliente_TCP.Disconnect;
      FreeAndNil(lCliente_TCP);
      FreeAndNil(lXML);
    End
    Else
    Begin
      pError := 'No esta configurado la direccion y/o el puerto IP';
    End;
  Except
    On E: Exception Do
      UtLog_Execute('UtImprimir_UPL_Windows_Service, ' + E.Message);
  End;
  Result := FileExists(pFilename);
End;

Function UtImprimir_UPL_Documento(pApp : TIWApplication; Const pCODIGO_DOCUMENTO_ADM, pNumero_Documento : AnsiString; Var pError : AnsiString) : Boolean;
Var
  lURL : String;
  lDestino : AnsiString;
  lFileName : AnsiString;
begin
  lDestino := TIWAppCache.NewTempFileName('.pdf');
  UtLog_Execute('UtImprimir_UPL_Documento, lDestino: ' + lDestino);
  lFileName := TableName_006Documento_ADM_Template(pCODIGO_DOCUMENTO_ADM);
  UtLog_Execute('UtImprimir_UPL_Documento, lFileName: ' + lFileName);
  If FileExists(lFileName) Then
  Begin
    UtLog_Execute('UtImprimir_UPL_Documento, Antes: UtImprimir_UPL_Windows_Service ');
    UtImprimir_UPL_Windows_Service(pNumero_Documento,
                                   lFileName,
                                   lDestino,
                                   pError);
    UtLog_Execute('UtImprimir_UPL_Documento, Despues: UtImprimir_UPL_Windows_Service ');
    If Not FileExists(lDestino) Then
    Begin
      UtLog_Execute('UtImprimir_UPL_Documento, lDestino: ' + lDestino);
      pError := pError + ', no es posible generar el documento: ' + lFileName + ', destino: ' + lDestino;
    End
    Else
    Begin
      lURL := TIWAppCache.AddFileToCache(pApp, lDestino, TIWMimeTypes.GetAsString(mtPDF), ctSession);
      pApp.NewWindow(lURL);
      pError := '';
    End;
  End
  Else
  Begin
    pError := pError + ', no se encuenta el formato: ' + lFileName + ', destino: ' + lDestino;
  End;
end;

end.
