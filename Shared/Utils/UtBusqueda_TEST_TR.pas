unit UtBusqueda_UPL;

interface
Uses
  UtConexion;

Function UtBusqueda_UPL_Execute(pSQL : TQUERY; Const pDato : String; Var pResult : String) : Boolean;

implementation
Uses
  UtLog,
  UtFuncion,
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  ServerController;

Function UtBusqueda_UPL_Execute(pSQL : TQUERY; Const pDato : String; Var pResult : String) : Boolean;
Var
  lI : Integer;
  lLista : TStringList;
  lResultA : String;
  lResultB : String;
  lConnector : String;
Begin
  Result := False;
  Try
    pResult := '';
    lLista := TStringList.Create;
    Desglosar_Texto_Caracter(pDato, ';', lLista);
    If Pos('=', pDato) > 0 Then
    Begin
      For lI := 0 To lLista.Count - 1 Do
      Begin
        Retornar_Texto_Intermedio(lLista[lI], '=', lResultA, lResultB);
        If pSQL.FindField(Trim(lResultA)) <> Nil Then
        Begin
          lConnector := ' = ';
          If Pos('%', lResultB) > 0 Then
            lConnector := ' LIKE ';
          pResult := pResult +  IfThen(lI = 0, ' WHERE ', ' AND ')  + UserSession.CNX.Trim_Sentence(Trim(lResultA)) + lConnector + QuotedStr(Trim(lResultB));
          Result := True;
        End;
      End;
    End;
    lLista.Clear;
    FreeAndNil(lLista);
  Except
    On E: Exception Do
      UtLog_Execute('UtBusqueda_UPL_Execute, ' + E.Message);
  End;
End;

end.
