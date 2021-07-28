unit UtReporte;

interface
Uses
  UtConexion,
  System.Classes;

Type
  TReporte_Test = Class
    Private
      FCNX : TConexion;
      FUSER : String;
      FLINEA : Integer;
      FLISTA : TStringList;
      Function Save(Const pContenido : String) : Boolean;
      Function Line_Buyer(Const pId, pName : String) : String;
      Function Line_History(Const pTransaction, pProduct, pIP, pDevice : String) : String;
      Function Line_Rank(Const pId, pName, pQty : String) : String;
    Public
      Constructor Create(pCnx : TConexion; Const pUser : String);
      Function Execute_Buyer : Boolean;
      Function Execute_History(Const pBUYER_ID : String) : Boolean;
      Function Execute_Other_Buy(Const pBUYER_ID : String) : Boolean;
      Function Execute_Rank : Boolean;
      Destructor Destroy;
  End;

implementation
Uses
  UtLog,
  UtFuncion,
  UtInfoTablas,
  UtExporta_Excel,
  System.StrUtils,
  System.SysUtils;

{ TReporte_Test }

Constructor TReporte_Test.Create(pCnx: TConexion; Const pUser : String);
Begin
  FUSER := pUser;
  FLINEA := 0;
  FCNX := pCnx;
  FLISTA := TStringList.Create;;
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' DELETE FROM ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name);
    FCNX.TMP.SQL.Add(' WHERE ' + pCnx.Trim_Sentence('CODIGO_USUARIO')  + ' = ' + QuotedStr(Trim(pUser)) + ' ');
    FCNX.TMP.ExecSQL;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TReporte_Test.Create, ' + E.Message);
    End;
  End;
End;

Function TReporte_Test.Save(Const pContenido : String) : Boolean;
Begin
  Inc(FLINEA);
  Try
    FCNX.AUX.Active := False;
    FCNX.AUX.SQL.Clear;
    FCNX.AUX.SQL.Add(' INSERT INTO ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' ');
    FCNX.AUX.SQL.Add(' ( ');
    FCNX.AUX.SQL.Add('     CODIGO_USUARIO ');
    FCNX.AUX.SQL.Add('   , LINEA ');
    FCNX.AUX.SQL.Add('   , CONTENIDO ');
    FCNX.AUX.SQL.Add('  ) ');
    FCNX.AUX.SQL.Add(' VALUES  ');
    FCNX.AUX.SQL.Add(' ( ');
    FCNX.AUX.SQL.Add('    ' + QuotedStr(FUSER));
    FCNX.AUX.SQL.Add('  , ' + QuotedStr(Justificar(IntToStr(FLINEA), '0', 5)));
    FCNX.AUX.SQL.Add('  , ' + QuotedStr(pContenido));
    FCNX.AUX.SQL.Add('  ) ');
    FCNX.AUX.ExecSQL;
    Result := FCNX.AUX.RowsAffected > 0;
    FCNX.AUX.Active := False;
    FCNX.AUX.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TReporte_Test.Save, ' + E.Message);
    End;
  End;
End;

Function TReporte_Test.Line_Buyer(Const pId, pName : String) : String;
Begin
  Result := Copy(pId   + StringOfChar(' ', 010), 01, 010) + ' ' +
            Copy(pName + StringOfChar(' ', 100), 01, 100);
End;

Function TReporte_Test.Execute_Buyer : Boolean;
Begin
  Result := False;
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' SELECT ');
    FCNX.TMP.SQL.Add('         DETA.BUYER_ID ');
    FCNX.TMP.SQL.Add('        ,ENCA.NAME ');
    FCNX.TMP.SQL.Add(' FROM ' + Retornar_Info_Tabla(Id_Transaction_M).Name + ' DETA ' + FCNX.No_Lock + ' ');
    FCNX.TMP.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Buyer).Name + ' ENCA ' + FCNX.No_Lock + ' ON ENCA.ID = DETA.BUYER_ID ');
    FCNX.TMP.SQL.Add(' GROUP BY ENCA.NAME, DETA.BUYER_ID');
    FCNX.TMP.SQL.Add(' ORDER BY ENCA.NAME, DETA.BUYER_ID');
    FCNX.TMP.Active := True;
    If FCNX.TMP.Active And (FCNX.TMP.RecordCount > 0) Then
    Begin
      FCNX.TMP.First;
      Save('LISTADO DE COMPRADORES');
      Save('');
      Save(Line_Buyer('ID', 'NAME'));
      Save(Line_Buyer(StringOfChar('=', 10), StringOfChar('=', 100)));
      While Not FCNX.TMP.Eof Do
      Begin
        Save(Line_Buyer(FCNX.TMP.FieldByName('BUYER_ID').AsString, FCNX.TMP.FieldByName('NAME').AsString));
        FCNX.TMP.Next;
        Result := True;
      End;
    End;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TReporte_Test.Execute_Buyer, ' + E.Message);
    End;
  End;
End;

Function TReporte_Test.Line_History(Const pTransaction, pProduct, pIP, pDevice : String) : String;
Begin
  Result := Copy(pTransaction + StringOfChar(' ', 012), 01, 012) + ' ' +
            Copy(pProduct     + StringOfChar(' ', 030), 01, 030) + ' ' +
            Copy(pIP          + StringOfChar(' ', 015), 01, 015) + ' ' +
            Copy(pDevice      + StringOfChar(' ', 015), 01, 015);
End;

Function TReporte_Test.Execute_History(Const pBUYER_ID : String) : Boolean;
Begin
  Result := False;
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' SELECT ');
    FCNX.TMP.SQL.Add('          ENCA.BUYER_ID ');
    FCNX.TMP.SQL.Add('         ,BUYE.NAME AS COMPRADOR ');
    FCNX.TMP.SQL.Add('         ,DETA.ID ');
    FCNX.TMP.SQL.Add('         ,PROD.NAME  AS PRODUCTO');
    FCNX.TMP.SQL.Add('         ,ENCA.IP ');
    FCNX.TMP.SQL.Add('         ,ENCA.DEVICE ');
    FCNX.TMP.SQL.Add(' FROM '       + Retornar_Info_Tabla(Id_Transaction_D).Name + ' DETA ' + FCNX.No_Lock + ' ');
    FCNX.TMP.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Transaction_M).Name + ' ENCA ' + FCNX.No_Lock + ' ON ENCA.ID = DETA.ID ');
    FCNX.TMP.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Buyer        ).Name + ' BUYE ' + FCNX.No_Lock + ' ON BUYE.ID = ENCA.BUYER_ID ');
    FCNX.TMP.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Product      ).Name + ' PROD ' + FCNX.No_Lock + ' ON PROD.ID = DETA.PRODUCT_ID ');
    FCNX.TMP.SQL.Add(' WHERE BUYE.ID = ' + QuotedStr(pBUYER_ID));
    FCNX.TMP.Active := True;
    If FCNX.TMP.Active And (FCNX.TMP.RecordCount > 0) Then
    Begin
      FCNX.TMP.First;
      Save('HISTORIAL DE COMPRAS');
      Save('');
      Save(Line_Buyer('ID', 'NAME'));
      Save(Line_Buyer(StringOfChar('=', 10), StringOfChar('=', 100)));
      Save(Line_Buyer(FCNX.TMP.FieldByName('BUYER_ID').AsString, FCNX.TMP.FieldByName('COMPRADOR').AsString));
      Save(Line_Buyer(StringOfChar('=', 10), StringOfChar('=', 100)));

      Save(StringOfChar(' ', 10) + Line_History(StringOfChar('-', 50), StringOfChar('-', 050), StringOfChar('-', 050), StringOfChar('-', 050)));
      Save(StringOfChar(' ', 10) + Line_History('TRANSACTION', 'PRODUCT', 'IP', 'DEVIVE'));
      Save(StringOfChar(' ', 10) + Line_History(StringOfChar('-', 50), StringOfChar('-', 050), StringOfChar('-', 050), StringOfChar('-', 050)));
      While Not FCNX.TMP.Eof Do
      Begin
        Save(StringOfChar(' ', 10) + Line_History(FCNX.TMP.FieldByName('ID'      ).AsString,
                                                  FCNX.TMP.FieldByName('PRODUCTO').AsString,
                                                  FCNX.TMP.FieldByName('IP'      ).AsString,
                                                  FCNX.TMP.FieldByName('DEVICE'  ).AsString));
        FCNX.TMP.Next;
        Result := True;
      End;
    End;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TReporte_Test.Execute_History, ' + E.Message);
    End;
  End;
End;

Function TReporte_Test.Execute_Other_Buy(Const pBUYER_ID : String) : Boolean;
Var
  lI : Integer;
  lId : String;
Begin
  Result := False;
  FLISTA.Clear;
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' SELECT DISTINCT ');
    FCNX.TMP.SQL.Add('        ENCA.IP ');
    FCNX.TMP.SQL.Add(' FROM ' + Retornar_Info_Tabla(Id_Transaction_M).Name + ' ENCA' + FCNX.No_Lock + ' ');
    FCNX.TMP.SQL.Add(' WHERE ENCA.BUYER_ID = ' + QuotedStr(pBUYER_ID));
    FCNX.TMP.Active := True;
    If FCNX.TMP.Active And (FCNX.TMP.RecordCount > 0) Then
    Begin
      FCNX.TMP.First;
      While Not FCNX.TMP.Eof Do
      Begin
        FLISTA.Add(FCNX.TMP.FieldByName('IP').AsString);
        FCNX.TMP.Next;
      End;
    End;
    IF FLISTA.Count > 0 Then
    Begin
      FCNX.TMP.Active := False;
      FCNX.TMP.SQL.Clear;
      FCNX.TMP.SQL.Add(' SELECT DISTINCT ');
      FCNX.TMP.SQL.Add('          ENCA.BUYER_ID AS ID ');
      FCNX.TMP.SQL.Add('         ,ENCA.IP ');
      FCNX.TMP.SQL.Add('         ,BUYE.NAME ');
      FCNX.TMP.SQL.Add(' FROM '       + Retornar_Info_Tabla(Id_Transaction_M).Name + ' ENCA ' + FCNX.No_Lock + ' ');
      FCNX.TMP.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Buyer        ).Name + ' BUYE ' + FCNX.No_Lock + ' ON BUYE.ID = ENCA.BUYER_ID ');
      FCNX.TMP.SQL.Add(' WHERE BUYE.ID <> ' + QuotedStr(pBUYER_ID));
      If FLISTA.Count > 0 Then
      Begin
        FCNX.TMP.SQL.Add(' AND ');
        FCNX.TMP.SQL.Add(' ( ');
        For lI := 0 To FLISTA.Count-1 Do
          FCNX.TMP.SQL.Add(IfThen(lI <> 0, ' OR ')  + ' ENCA.IP = ' + QuotedStr(FLISTA[lI]));
        FCNX.TMP.SQL.Add(' ) ');
      End;
      FCNX.TMP.SQL.Add(' ORDER BY ENCA.IP, BUYE.NAME ');
      FCNX.TMP.Active := True;
      If FCNX.TMP.Active And (FCNX.TMP.RecordCount > 0) Then
      Begin
        Save('OTROS COMPRADORES USANDO LAS MISMA IP DE ' + pBUYER_ID + ' - ' + FCNX.GetValue(Retornar_Info_Tabla(Id_Buyer).Name, ['ID'], [pBUYER_ID], ['NAME']));
        FCNX.TMP.First;
        While Not FCNX.TMP.Eof Do
        Begin
          Save('');
          lId := FCNX.TMP.FieldByName('IP').AsString;
          Save('IP: ' + lId);
          Save(StringOfChar(' ', 10) + Line_Buyer(StringOfChar('=', 10), StringOfChar('=', 100)));
          Save(StringOfChar(' ', 10) + Line_Buyer('ID', 'NAME'));
          Save(StringOfChar(' ', 10) + Line_Buyer(StringOfChar('=', 10), StringOfChar('=', 100)));
          While (Not FCNX.TMP.Eof) And (lId = FCNX.TMP.FieldByName('IP').AsString) Do
          Begin
            Save(StringOfChar(' ', 10) + Line_Buyer(FCNX.TMP.FieldByName('ID').AsString, FCNX.TMP.FieldByName('NAME').AsString));
            FCNX.TMP.Next;
          End;
          Result := True;
        End;
      End;
    End;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TReporte_Test.Execute_Other_Buy, ' + E.Message);
    End;
  End;
End;

Function TReporte_Test.Line_Rank(Const pId, pName, pQty : String) : String;
Begin
  Result := Copy(pId   + StringOfChar(' ', 010), 01, 010) + ' ' +
            Copy(pName + StringOfChar(' ', 100), 01, 100) + ' ' +
            Copy(Justificar(pQty, ' ', 10     ), 01, 010);
End;

Function TReporte_Test.Execute_Rank : Boolean;
Begin
  Result := False;
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' SELECT ');
    FCNX.TMP.SQL.Add('         DETA.PRODUCT_ID AS ID ');
    FCNX.TMP.SQL.Add('        ,PROD.NAME ');
    FCNX.TMP.SQL.Add('        ,COUNT(*) AS CANTIDAD ');
    FCNX.TMP.SQL.Add(' FROM '        + Retornar_Info_Tabla(Id_Transaction_D).Name + ' DETA ' + FCNX.No_Lock);
    FCNX.TMP.SQL.Add(' INNER JOIN  ' + Retornar_Info_Tabla(Id_Product      ).Name + ' PROD ' + FCNX.No_Lock + ' ON PROD.ID = DETA.PRODUCT_ID ');
    FCNX.TMP.SQL.Add(' GROUP BY DETA.PRODUCT_ID, PROD.NAME ');
    FCNX.TMP.SQL.Add(' ORDER BY COUNT(*) DESC ');
    FCNX.TMP.Active := True;
    If FCNX.TMP.Active And (FCNX.TMP.RecordCount > 0) Then
    Begin
      Save('RECOMENDACION DE PRODUCTOS (LO MAS VENDIDO) ');
      Save('');
      Save(Line_Rank(StringOfChar('=', 10), StringOfChar('=', 100), StringOfChar('=', 100)));
      Save(Line_Rank('ID', 'NAME', 'QTY'));
      Save(Line_Rank(StringOfChar('=', 10), StringOfChar('=', 100), StringOfChar('=', 100)));
      FCNX.TMP.First;
      While Not FCNX.TMP.Eof Do
      Begin
        Save(Line_Rank(FCNX.TMP.FieldByName('ID').AsString,
                       FCNX.TMP.FieldByName('NAME').AsString,
                       FormatFloat('###,###,##0', FCNX.TMP.FieldByName('CANTIDAD').AsInteger)));
        FCNX.TMP.Next;
        Result := True;
      End;
    End;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('TReporte_Test.Execute_Rank, ' + E.Message);
    End;
  End;
End;

Destructor TReporte_Test.Destroy;
Begin
  If Assigned(FLISTA) Then
  Begin
    FLISTA.Clear;
    FreeAndNil(FLISTA);
  End;
End;

end.
