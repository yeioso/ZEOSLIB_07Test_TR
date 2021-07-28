unit UtUpdateFields;

interface
Uses
  UtConexion;

Function UtUpdateFields_Execute(pCNX : TConexion) : Boolean;

implementation
Uses
  UtLog,
  Classes,
  SysUtils,
  UtInfoTablas;

Function Exist_Field(pCNX : TConexion; pTable, pField : String) : Boolean;
Var
  lI : Integer;
  lLista : TStringList;
Begin
  Result := False;
  lLista := pCNX.LoadFieldsnames(pTable);
  If Assigned(lLista) Then
  Begin
    lI := 0;
    While (lI < lLista.Count) And (Not Result) Do
    Begin
      Result := Trim(UpperCase(pField)) = Trim(UpperCase(lLista[lI]));
      Inc(lI);
    End;
    lLista.Clear;
    lLista.Free;
  End;
End;

Function Actualizar_Estructura(pCNX : TConexion; pTable, pField : String; pType : TTIPO_CAMPO; pSize : Integer) : Boolean;
Var
  lSQL : TQuery;
  lTexto : String;
Begin
  Result := True;
  If Not pCNX.TableExists(pTable) Then
  Begin
    Result := False;
    Exit;
  End;

  If Not Exist_Field(pCNX, pTable, pField) Then
  Begin
    Try
      lSQL := TQuery.Create(Nil);
      lSQL.Connection := pCNX;

      If pSize <= 0 Then
        lTexto := 'ALTER TABLE ' + pTable + ' ADD ' + pField + ' '+ pCNX.Return_Type(pType) + ' '
      Else
        lTexto := 'ALTER TABLE ' + pTable + ' ADD ' + pField + ' '+ pCNX.Return_Type(pType) + '(' + IntToStr(pSize) + ')';
      lSQL.SQL.Add(lTexto);
      lSQL.ExecSQL;
      lSQL.Free;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(lTexto + ', Actualizar_Estructura, ' + E.Message);
      End;
    End;
  End;
End;

Function UtUpdateFields_Execute(pCNX : TConexion) : Boolean;
Begin
  Result := Assigned(pCNX) And  pCNX.Connected;
  If Result Then
  Begin
//    Result := Actualizar_Estructura(pCNX, Retornar_Info_Tabla(Id_Movimiento_Enc  ).Name, 'DOCUMENTO_REFERENCIA' , TYPE_VARCHAR, 030);
//    Result := Actualizar_Estructura(pCNX, Retornar_Info_Tabla(Id_Movimiento_Enc_H).Name, 'DOCUMENTO_REFERENCIA' , TYPE_VARCHAR, 030);
  End;

End;

end.
