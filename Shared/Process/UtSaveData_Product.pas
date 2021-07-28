unit UtSaveData_Product;

interface
Uses
  UtConexion,
  Generics.Collections;

Type
  TItem_Product = Class
    Public
      id    : String ;
      name  : String ;
      price : Integer;
  End;
  TItems_Product = TList<TItem_Product>;

  TSaveData_Product = Class
    Private
      FCNX : TConexion;
      FERROR : String;
      FItems : TItems_Product;
      Procedure Insert(pItem : TItem_Product);
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

{ TSaveData_Product }
constructor TSaveData_Product.Create(pCNX : TConexion; Const pData : String);
Var
  lJ : Integer;
  lI : TItem_Product;
  lLinea : String;
  lLista : TStringList;
  lCampo : TStringList;
begin
  Try
    FCNX := pCNX;
    lLista := TStringList.Create;
    lCampo := TStringList.Create;
    FItems := TItems_Product.Create;
    lLista.Text := pData;
    For lLinea In lLista Do
    Begin
      lI := TItem_Product.Create;
      FItems.Add(lI);
      Desglosar_Texto_Caracter(lLinea, #39, lCampo);
      If lCampo.Count > 0 Then
        lI.id := Depurar_Texto(lCampo[0]);

      If lI.id = '75de8a1f' Then
        lI.id := lI.id;
      If lCampo.Count > 1 Then
        lI.name := Depurar_Texto(lCampo[1]);
      If lCampo.Count > 2 Then
        lI.price := SetToInt(lCampo[2]);
    End;
    lCampo.Clear;
    FreeAndNil(lCampo);
    lLista.Clear;
    FreeAndNil(lLista);
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Product.Create, ' + E.Message;
    End;
  End;
  Save;
End;

Procedure TSaveData_Product.Insert(pItem : TItem_Product);
Begin
  Try
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
    FCNX.TMP.SQL.Add(' INSERT INTO ' + Retornar_Info_Tabla(Id_Product).Name + ' ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('   ID '  );
    FCNX.TMP.SQL.Add('   ,NAME ');
    FCNX.TMP.SQL.Add('   ,PRICE ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.SQL.Add(' SELECT ');
    FCNX.TMP.SQL.Add('        '   + QuotedStr(pItem.id));
    FCNX.TMP.SQL.Add('        , ' + QuotedStr(pItem.name));
    FCNX.TMP.SQL.Add('        , ' + IntToStr(pItem.price));
    FCNX.TMP.SQL.Add(' WHERE NOT EXISTS ');
    FCNX.TMP.SQL.Add(' ( ');
    FCNX.TMP.SQL.Add('    SELECT  ');
    FCNX.TMP.SQL.Add('    ID  ');
    FCNX.TMP.SQL.Add('    FROM ' + Retornar_Info_Tabla(Id_Product).Name + ' ');
    FCNX.TMP.SQL.Add('    WHERE ID = ' + QuotedStr(pItem.id) + ' ');
    FCNX.TMP.SQL.Add(' ) ');
    FCNX.TMP.ExecSQL;
    FCNX.TMP.Active := False;
    FCNX.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Product.Save, ' + E.Message;
    End;
  End;
End;


Procedure TSaveData_Product.Save;
Var
  lI : TItem_Product;
Begin
  Try
    For lI In FItems Do
      Insert(lI);
  Except
    On E: Exception Do
    Begin
      FERROR := 'TSaveData_Product.Save, ' + E.Message;
    End;
  End;
End;

destructor TSaveData_Product.Destroy;
Var
  lI : TItem_Product;
begin
  For lI In FItems Do
    lI.Free;
  FItems.Clear;
  FreeAndNil(FItems);
end;

end.
