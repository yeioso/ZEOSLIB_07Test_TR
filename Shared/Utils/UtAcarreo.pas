unit UtAcarreo;

interface
Uses
  UtConexion;

Procedure UtAcarreo_Execute(Const pTable : String; Const pFields, pValues : Array Of String; pDestine : TQUERY);

implementation
Uses
  UtLog,
  StrUtils,
  SysUtils,
  ServerController;

Procedure UtAcarreo_Execute(Const pTable : String; Const pFields, pValues : Array Of String; pDestine : TQUERY);
Var
  lI : Integer;
  lSQL : TQUERY;
Begin
  Try
    lSQL := TQUERY.Create(Nil);
    lSQL.Connection := UserSession.CNX;
    lSQL.SQL.Add(' SELECT * FROM ' + pTable + ' ');
    For lI := Low(pFields) To High(pFields) Do
      lSQL.SQL.Add(IfThen(lI = Low(pFields), ' WHERE ', ' AND ') + UserSession.CNX.Trim_Sentence(pFields[lI]) + ' = ' + QuotedStr(Trim(pValues[lI])));
    lSQL.Active := True;
    If lSQL.Active And (lSQL.RecordCount > 0) Then
    Begin
      For lI := 0 To lSQL.Fields.Count-1 Do
      Begin
        If pDestine.FindField(lSQL.Fields[lI].FullName) <> Nil Then
          pDestine.FieldByName(lSQL.Fields[lI].FullName).AsVariant := lSQL.FieldByName(lSQL.Fields[lI].FullName).AsVariant;
      End;
    End;
    lSQL.Active := False;
    FreeAndNil(lSQL);
  Except
    On E: Exception Do
      UtLog_Execute('UtAcarreo_Execute, ' + E.Message);
  End;
End;

end.
