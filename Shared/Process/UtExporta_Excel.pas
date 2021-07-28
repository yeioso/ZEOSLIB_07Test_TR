unit UtExporta_Excel;

interface
Uses
  UtConexion,
  IWApplication;

Function UtExporta_Excel_Execute(pApp : TIWApplication; pSQL : TQUERY) : Boolean;

implementation
Uses
  UtLog,
  Classes,
  SysUtils,
  StrUtils,
  UtFuncion,
  IWInfoCfg,
  IWAppCache,
  IWMimeTypes,
  UtInfoTablas,
  System.UITypes,
  IW.CacheStream,
  ServerController,
  IW.Common.System;

Function UtExporta_Excel_Generate_Text(pSQL : TQUERY; Var pOut : TStringList) : Boolean;
Const
  Const_Separador = ';';
Var
  lI : Integer;
  lLine : String;
  lSeparador : String;
Begin
  Result := False;
  pOut.Clear;
  lSeparador := Const_Separador;
  If UserSession.DELIMITADOR_COMA Then
    lSeparador := ',';
  Try
    pSQL.Connection := UserSession.CNX;
    pSQL.Active := True;
    If pSQL.Active And (pSQL.RecordCount > 0) Then
    Begin
      lLine := '';
      For lI := 0 To pSQL.Fields.Count-1 Do
        lLine := lLine + IfThen(Trim(lLine) <> '', lSeparador) + pSQL.Fields[lI].FullName;
      pOut.Add(lLine);
      pSQL.First;
      While Not pSQL.Eof Do
      Begin
        lLine := '';
        For lI := 0 To pSQL.Fields.Count-1 Do
          lLine := lLine + IfThen(Trim(lLine) <> '', lSeparador) + pSQL.Fields[lI].AsString;
        pOut.Add(lLine);
        pSQL.Next;
      End;
    End;
    pSQL.Active := False;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('UtExporta_Excel_Generate_Text, ' + E.Message);
    End;
  End;
  Result := pOut.Count > 0;
End;


Function UtExporta_Excel_Execute(pApp : TIWApplication; pSQL : TQUERY) : Boolean;
Var
  lURL : String;
  lDestino : String;
  lSalida : TStringList;
Begin
  Result := False;
  Try
    If pSQL.SQL.Count > 0 Then
    Begin
      lSalida := TStringList.Create;
      Result := UtExporta_Excel_Generate_Text(pSQL, lSalida);
      lDestino := TIWAppCache.NewTempFileName('.csv');
      lSalida.SaveToFile(lDestino);
      lSalida.Clear;
      FreeAndNil(lSalida);
      If Result Then
      Begin
        lURL := TIWAppCache.AddFileToCache(pApp, lDestino, TIWMimeTypes.GetAsString(mtICO), ctSession);
        pApp.NewWindow(lURL);
      End;
    End;
    pSQL.Active := False;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('UtExporta_Excel_Execute, ' + E.Message);
    End;
  End;
End;

end.
