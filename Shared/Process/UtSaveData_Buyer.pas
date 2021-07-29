unit UtSaveData_Buyer;

interface
Uses
  UtConexion,
  Generics.Collections;

Type
  TItem_Buyer = Class
    Public
      id   : String ;
      name : String ;
      age  : Integer;
  End;
  TItems_Buyer = TList<TItem_Buyer>;

  TSaveData_Buyer = Class
    Private
      FCNX : TConexion;
      FERROR : String;
      FItems : TItems_Buyer;
      Procedure Insert(pItem : TItem_Buyer);
      Procedure Save;
    Public
      Property ERROR : String Read FERROR;
      Constructor Create(pCNX : TConexion; Const pData : String);
      Destructor Destroy;
  End;

implementation
Uses
  JSON,
  UtLog,
  UtFuncion,
  UtInfoTablas,
  System.SysUtils;

{ TSaveData_Buyer }
constructor TSaveData_Buyer.Create(pCNX : TConexion; Const pData : String);
Var
  lK : Integer;
  lI : TItem_Buyer;
  JSonValue : TJSONValue;
  JsonArray : TJSONArray;
  ArrayElement: TJSonValue;
begin
  Try
    lK := 0;
    FCNX := pCNX;
    FItems := TItems_Buyer.Create;
    JSonValue := TJSONObject.ParseJSONValue(pData);
    JsonArray := JsonValue As TJSONArray;
    For ArrayElement In JsonArray Do
    Begin
      Inc(lK);
      UtLog_Execute('TSaveData_Buyer.Create, ' + FormatFloat('###,###,##0', lK) + '/' + FormatFloat('###,###,##0', JsonArray.Count));
      lI := TItem_Buyer.Create;
      FItems.Add(lI);
      lI.id   := StringReplace(ArrayElement.P['id'].ToString, '"', '', [rfReplaceAll]);
      lI.name := StringReplace(ArrayElement.P['name'].ToString, '"', '', [rfReplaceAll]);
      lI.age  := SetToInt(ArrayElement.P['age'].ToString);
    End;
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Buyer.Create, ' + E.Message;
    End;
  End;
  Save;
End;

Procedure TSaveData_Buyer.Insert(pItem : TItem_Buyer);
Begin
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' INSERT INTO ' + Retornar_Info_Tabla(Id_Buyer).Name + ' ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('   ID '  );
    FCNX.TMP.SQL.Add('   ,NAME ');
    FCNX.TMP.SQL.Add('   ,AGE ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.SQL.Add(' SELECT ');
    FCNX.TMP.SQL.Add('        '   + QuotedStr(pItem.id));
    FCNX.TMP.SQL.Add('        , ' + QuotedStr(pItem.name));
    FCNX.TMP.SQL.Add('        , ' + IntToStr(pItem.age));
    FCNX.TMP.SQL.Add(' WHERE NOT EXISTS ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('    SELECT  ');
    FCNX.TMP.SQL.Add('    ID  ');
    FCNX.TMP.SQL.Add('    FROM ' + Retornar_Info_Tabla(Id_Buyer).Name + ' ');
    FCNX.TMP.SQL.Add('    WHERE ID = ' + QuotedStr(pItem.id) + ' ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.ExecSQL;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Buyer.Save, ' + E.Message;
    End;
  End;
End;


Procedure TSaveData_Buyer.Save;
Var
  lK : Integer;
  lI : TItem_Buyer;
Begin
  Try
    lK := 0;
    For lI In FItems Do
    Begin
      Inc(lK);
      UtLog_Execute('TSaveData_Buyer.Save, ' + FormatFloat('###,###,##0', lK) + '/' + FormatFloat('###,###,##0', FItems.Count));
      Insert(lI);
    End;
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Buyer.Save, ' + E.Message;
    End;
  End;
End;

destructor TSaveData_Buyer.Destroy;
Var
  lI : TItem_Buyer;
begin
  For lI In FItems Do
    lI.Free;
  FItems.Clear;
  FreeAndNil(FItems);
end;

end.
