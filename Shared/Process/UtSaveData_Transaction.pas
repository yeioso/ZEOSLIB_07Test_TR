unit UtSaveData_Transaction;

interface
Uses
  UtConexion,
  Generics.Collections;

Type
  TItem_Transaction = Class
    Public
      id         : String;
      buyer_id   : String;
      ip         : String;
      device     : String;
      product_id : String;
  End;
  TItems_Transaction = TList<TItem_Transaction>;

  TSaveData_Transaction = Class
    Private
      FCNX : TConexion;
      FERROR : String;
      FItems : TItems_Transaction;
      Procedure Insert_M(pItem : TItem_Transaction);
      Procedure Insert_D(pItem : TItem_Transaction);
      Function Get_Pos(Const pValue : String) : Integer;
      Procedure Save;
    Public
      Property ERROR : String Read FERROR;
      Constructor Create(pCNX : TConexion; Const pData : String);
      Destructor Destroy;
  End;

implementation
Uses
  UtLog,
  UtFuncion,
  UtInfoTablas,
  System.Classes,
  System.SysUtils;

{ TSaveData_Transaction }

Function TSaveData_Transaction.Get_Pos(Const pValue : String) : Integer;
Begin
  Result := Pos('I', AnsiUpperCase(pValue));
  If Result <= 0 Then
    Result := Pos('A', AnsiUpperCase(pValue));
  If Result <= 0 Then
    Result := Pos('W', AnsiUpperCase(pValue));
  If Result <= 0 Then
    Result := Pos('L', AnsiUpperCase(pValue));
  If Result <= 0 Then
    Result := Pos('M', AnsiUpperCase(pValue));
End;

constructor TSaveData_Transaction.Create(pCNX : TConexion; Const pData : String);
Var
  lJ : Integer;
  lL : Integer;
  lI : TItem_Transaction;
  lK : TItem_Transaction;
  lPos : Integer;
  lAux : String;
  lLinea : String;
  lLista : TStringList;
  lCampo : TStringList;
  lid_product : TStringList;
begin
  Try
    lL := 0;
    FCNX := pCNX;
    lLista := TStringList.Create;
    lCampo := TStringList.Create;
    FItems := TItems_Transaction.Create;
    lid_product := TStringList.Create;
    Desglosar_Texto_Caracter(pData, #0#0, lLista);
    For lAux In lLista Do
    Begin
      Inc(lL);
      UtLog_Execute('TSaveData_Transaction.Create, ' + FormatFloat('###,###,###', lL) + ' / ' + FormatFloat('###,###,###', lLista.Count));
      Desglosar_Texto_Caracter(lAux, #0, lCampo);
      lI := TItem_Transaction.Create;
      FItems.Add(lI);

      If lCampo.Count > 0 Then
        lI.id := Copy(lCampo[0], 2, 12);

      If lCampo.Count > 1 Then
        lI.buyer_id := lCampo[1];

      If lCampo.Count > 2 Then
        lI.ip := lCampo[2];

      If lCampo.Count > 3 Then
        lI.device := lCampo[3];

      If lCampo.Count > 4 Then
      Begin
        lLinea := lCampo[4];
        lLinea := StringReplace(lLinea, '(', '', [rfReplaceAll]);
        lLinea := StringReplace(lLinea, ')', '', [rfReplaceAll]);
        Desglosar_Texto_Caracter(lLinea, ',', lid_product);
        If lid_product.Count > 0 Then
        Begin
          lI.product_id := lid_product[0];
          For lJ := 1 To lid_product.Count-1 Do
          Begin
            lK := TItem_Transaction.Create;
            FItems.Add(lK);
            lK.id         := lI.id          ;
            lK.buyer_id   := lI.buyer_id    ;
            lK.ip         := lI.ip          ;
            lK.device     := lI.device      ;
            lK.product_id := lid_product[lJ];
          End;
        End;
      End;
    End;
    lid_product.Clear;
    FreeAndNil(lid_product);
    lCampo.Clear;
    FreeAndNil(lCampo);
    lLista.Clear;
    FreeAndNil(lLista);
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Transaction.Create, ' + E.Message;
    End;
  End;
  Save;
End;

Procedure TSaveData_Transaction.Insert_M(pItem : TItem_Transaction);
Begin
  If Vacio(pItem.id) Or Vacio(pItem.buyer_id) Then
    Exit;
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' INSERT INTO ' + Retornar_Info_Tabla(Id_Transaction_M).Name + ' ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('    ID '  );
    FCNX.TMP.SQL.Add('   ,BUYER_ID ');
    FCNX.TMP.SQL.Add('   ,IP ');
    FCNX.TMP.SQL.Add('   ,DEVICE ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.SQL.Add(' SELECT ');
    FCNX.TMP.SQL.Add('        '   + QuotedStr(pItem.id));
    FCNX.TMP.SQL.Add('        , ' + QuotedStr(pItem.buyer_id));
    FCNX.TMP.SQL.Add('        , ' + QuotedStr(pItem.ip));
    FCNX.TMP.SQL.Add('        , ' + QuotedStr(pItem.device));
    FCNX.TMP.SQL.Add(' WHERE NOT EXISTS ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('    SELECT  ');
    FCNX.TMP.SQL.Add('    ID  ');
    FCNX.TMP.SQL.Add('    FROM ' + Retornar_Info_Tabla(Id_Transaction_M).Name + ' ');
    FCNX.TMP.SQL.Add('    WHERE ID = ' + QuotedStr(pItem.id) + ' ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.ExecSQL;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Transaction.Insert_M, ' + E.Message;
    End;
  End;
End;

Procedure TSaveData_Transaction.Insert_D(pItem : TItem_Transaction);
Begin
  If Vacio(pItem.id) Or Vacio(pItem.product_id) Then
    Exit;
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' INSERT INTO ' + Retornar_Info_Tabla(Id_Transaction_D).Name + ' ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('    ID '  );
    FCNX.TMP.SQL.Add('   ,PRODUCT_ID ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.SQL.Add(' SELECT ');
    FCNX.TMP.SQL.Add('        '   + QuotedStr(pItem.id));
    FCNX.TMP.SQL.Add('        , ' + QuotedStr(pItem.product_id));
    FCNX.TMP.SQL.Add(' WHERE NOT EXISTS ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('    SELECT  ');
    FCNX.TMP.SQL.Add('    ID  ');
    FCNX.TMP.SQL.Add('    FROM ' + Retornar_Info_Tabla(Id_Transaction_D).Name + ' ');
    FCNX.TMP.SQL.Add('    WHERE ID = ' + QuotedStr(pItem.id) + ' ');
    FCNX.TMP.SQL.Add('    AND PRODUCT_ID = ' + QuotedStr(pItem.product_id) + ' ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.ExecSQL;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Transaction.Insert_D, ' + E.Message;
    End;
  End;
End;


Procedure TSaveData_Transaction.Save;
Var
  lO : String;
  lK : Integer;
  lI : TItem_Transaction;
Begin
  Try
    lO := '';
    lK := 0;
    For lI In FItems Do
    Begin
      Inc(lK);
      UtLog_Execute('TSaveData_Transaction.Save, ' + FormatFloat('###,###,##0', lK) + '/' + FormatFloat('###,###,##0', FItems.Count));
      If lO <> lI.id Then
      Begin
        lO := lI.id;
        Insert_M(lI);
      End;
      Insert_D(lI);
    End;
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Transaction.Save, ' + E.Message;
    End;
  End;
End;

destructor TSaveData_Transaction.Destroy;
Var
  lI : TItem_Transaction;
begin
  For lI In FItems Do
    lI.Free;
  FItems.Clear;
  FreeAndNil(FItems);
end;

end.
