unit UtInfoTablas;

interface
Uses
  Classes,
  Generics.Collections;

Const
  Id_MainIni              = 001;
  Id_Ayuda                = 001;
  Id_Perfil               = 002;
  Id_Permiso_App          = 003;
  Id_Usuario              = 004;
  Id_Buyer                = 005;
  Id_Product              = 006;
  Id_Transaction_M        = 007;
  Id_Transaction_D        = 008;
  Id_Usuario_Reporte      = 009;
  Id_MainFin              = 009;

Type
 TA_PK = Array Of String;
 TInfo_Tabla = Class
   Id        : Integer;
   Name      : String ;
   Caption   : String ;
   CodeField : String ;
   NameField : String ;
   Menu      : Boolean;
   Fk        : Array[1..15] Of String;
   Pk        : TA_PK;
 End;
 TInfo_Tablas = TList<TInfo_Tabla>;

Function Retornar_Id_Tabla(pTableName : String) : Integer;
Function Retornar_Id_Caption(pTableName : String) : Integer;
Function Retornar_Id_Field(pCodeField : String) : Integer;
Function Retornar_Info_Tabla(pId : Integer) : TInfo_Tabla;
Procedure Retornar_Caption_Tablas(pTablas : TStrings);
Procedure Retornar_Name_Tablas(pTablas : TStrings);

Var
  gInfo_Tablas : TInfo_Tablas;

implementation

Uses
  SysUtils,
  Generics.Defaults;


Procedure Cargar_Tablas(pId : Integer; pName, pCaption : String; pMenu : Boolean; pPK : TA_PK);
Var
  lI : Integer;
  lItem : TInfo_Tabla;
Begin
  lItem := TInfo_Tabla.Create;
  lItem.Id      := pId     ;
  lItem.Name    := pName   ;
  lItem.Caption := pCaption;
  lItem.Menu    := pMenu   ;
  lItem.Pk      := pPK     ;
  For lI := 1 To 15 Do
    lItem.Fk[lI] := 'FK' + IntToStr(pId) + '_' + IntToStr(lI) + IntToStr(Random(100));
  gInfo_Tablas.Add(lItem);
End;

Procedure Preparar_Tablas;
Begin
  Cargar_Tablas(Id_Ayuda                , 'T001_AYUDA'           , 'Ayuda'                          , True , ['CODIGO_AYUDA']);
  Cargar_Tablas(Id_Perfil               , 'T002_PERFIL'          , 'Perfil'                         , True , ['CODIGO_PERFIL']);
  Cargar_Tablas(Id_Permiso_App          , 'T003_PERMISO_APP'     , 'Permisos'                       , False, ['CONSECUTIVO']);
  Cargar_Tablas(Id_Usuario              , 'T004_USUARIO'         , 'Usuario'                        , True , ['CODIGO_USUARIO']);
  Cargar_Tablas(Id_Buyer                , 'T005_BUYER'           , 'Buyer'                          , True , ['ID']);
  Cargar_Tablas(Id_Product              , 'T006_PRODUCT'         , 'Product'                        , True , ['ID']);
  Cargar_Tablas(Id_Transaction_M        , 'T007_TRANSACTION_M'   , 'Transaction M'                  , True , ['ID']);
  Cargar_Tablas(Id_Transaction_D        , 'T008_TRANSACTION_D'   , 'Transaction D'                  , True , ['ID', 'PRODUCT_ID']);
  Cargar_Tablas(Id_Usuario_Reporte      , 'T009_USUARIO_REPORTE' , 'Reporte de Usuario'             , True , ['CODIGO_USUARIO', 'LINEA']);
End;

Procedure UtInfoTablas_Sort(pLista : TInfo_Tablas);
Begin
  pLista.Sort(TComparer<TInfo_Tabla>.Construct(
              Function(const Item1,Item2:TInfo_Tabla): Integer
              Begin
                Result := Item1.Id - Item2.Id;
              End)
              );
End;

Function UtInfoTablas_Search(pLista : TInfo_Tablas; Const pId : Integer; Var pIndex : Integer) : Boolean;
Var
  lTarget: TInfo_Tabla;
  lComparer: IComparer<TInfo_Tabla>;
  lComparison: TComparison<TInfo_Tabla>;
Begin
  lComparison := Function(const Left, Right: TInfo_Tabla) : Integer
  Begin
    Result := Left.Id - Right.Id;
  End;
  lComparer := TComparer<TInfo_Tabla>.Construct(lComparison);
  lTarget := TInfo_Tabla.Create;
  lTarget.Id  := pId;
  Result := pLista.BinarySearch(lTarget, pIndex, lComparer);
  lTarget.Free;
End;

Function Retornar_Id_Tabla(pTableName : String) : Integer;
Var
  lI : Integer;
Begin
  lI := 1;
  Result := -1;
  While (lI <= Id_MainFin) And (Result = -1) Do
  Begin
    If AnsiUpperCase(gInfo_Tablas[lI].Name) = AnsiUpperCase(pTableName) then
      Result := lI;
    Inc(lI);
  End;
End;

Function Retornar_Id_Caption(pTableName : String) : Integer;
Var
  lI : Integer;
Begin
  lI := 0;
  Result := -1;
  While (lI  < gInfo_Tablas.Count) And (Result = -1) Do
  Begin
    If AnsiUpperCase(gInfo_Tablas[lI].Caption) = AnsiUpperCase(pTableName) then
      Result := gInfo_Tablas[lI].Id;
    Inc(lI);
  End;
End;

Function Retornar_Id_Field(pCodeField : String) : Integer;
Var
  lI : Integer;
Begin
  lI := 1;
  Result := -1;
  While (lI <= Id_MainFin) And (Result = -1) Do
  Begin
    If AnsiUpperCase(gInfo_Tablas[lI].CodeField) = AnsiUpperCase(pCodeField) then
      Result := lI;
    Inc(lI);
  End;
End;

Function Retornar_Info_Tabla(pId : Integer) : TInfo_Tabla;
Var
  lIndex : Integer;
Begin
  Result := Nil;
  If (pId >= Id_MainIni) And (pId <= Id_MainFin) then
    If UtInfoTablas_Search(gInfo_Tablas,  pId, lIndex) Then
    Result := gInfo_Tablas[lIndex];
End;

Procedure Retornar_Info_Tablas(pLista : TStringList; pInfo, pLimiteIni, pLimiteFin : Integer);
Var
  lI : Integer;
Begin
  pLista.Clear;
  For lI := Id_MainIni To Id_MainFin Do
    If (lI >= pLimiteIni) And (lI <= pLimiteFin) Then
      Case pInfo Of
        1 : pLista.Add(gInfo_Tablas[lI].Caption);
        2 : pLista.Add(gInfo_Tablas[lI].Name   );
      End;
End;

Procedure Retornar_Caption_Tablas(pTablas : TStrings);
Var
  lI : Integer;
Begin
  pTablas.Clear;
  For lI := Id_MainIni To Id_MainFin Do
    pTablas.Add(Retornar_Info_Tabla(lI).Caption);
End;

Procedure Retornar_Name_Tablas(pTablas : TStrings);
Var
  lI : Integer;
Begin
  pTablas.Clear;
  For lI := Id_MainIni To Id_MainFin Do
    pTablas.Add(Retornar_Info_Tabla(lI).Name);
End;

Initialization
  gInfo_Tablas := TInfo_Tablas.Create;
  Preparar_Tablas;

end.
