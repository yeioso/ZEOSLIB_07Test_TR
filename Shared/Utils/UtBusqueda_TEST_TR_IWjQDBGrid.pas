unit UtBusqueda_TEST_TR_IWjQDBGrid;

interface
Uses
  UtConexion,
  System.Classes,
  UtBusqueda_WjQDBGrid;

Type
  TBusqueda_TEST_TR_WjQDBGrid = Class(TBusqueda_WjQDBGrid)
    Public
      Constructor Create(AOwner : TComponent); Override;
      Procedure SetTSD(pSD : Integer);
      Destructor Destroy; Override;
  End;

implementation
Uses
  StrUtils,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;

{ TBusqueda_Ercol_WjQDBGrid }
constructor TBusqueda_TEST_TR_WjQDBGrid.Create(AOwner: TComponent);
begin
  inherited;
end;

//Function UtGetSQL_Saldo_Inventario(Const pLote : String = ''; Const pCodigo_Producto : String = ''; Const pUnidad_Medida : String = '') : String;
//Var
//  lCondicion : String;
//Begin
//  lCondicion := '';
//  If (Not Vacio(pLote)) Then
//    lCondicion := lCondicion + IfThen(Pos(' WHERE ', lCondicion) <= 0, ' WHERE ', ' AND ') + UserSession.CNX.Trim_Sentence('X.LOTE') + ' = ' + QuotedStr(Trim(pLote)) + #13;
//  If (Not Vacio(pCodigo_Producto)) Then
//    lCondicion := lCondicion + IfThen(Pos(' WHERE ', lCondicion) <= 0, ' WHERE ', ' AND ') + UserSession.CNX.Trim_Sentence('X.CODIGO_PRODUCTO') + ' = ' +  QuotedStr(Trim(pCodigo_Producto)) + #13;
//  If (Not Vacio(pUnidad_Medida)) Then
//    lCondicion := lCondicion + IfThen(Pos(' WHERE ', lCondicion) <= 0, ' WHERE ', ' AND ') + UserSession.CNX.Trim_Sentence('X.UNIDAD_MEDIDA') + ' = ' +  QuotedStr(Trim(pUnidad_Medida))  + #13;
////
////  Result := ' SELECT '+ #13 +
////            ' LOTE, ' + #13 +
////            '  NOMBRE_PRODUCTO, ' + #13 +
////            '  CODIGO_PRODUCTO, ' + #13 +
////            '  UNIDAD_MEDIDA, ' + #13 +
////            '  NOMBRE_BODEGA, ' + #13 +
////            '  SUM(CANTIDAD) AS CANTIDAD ' + #13 +
////            ' FROM ' + #13 +
////            ' ( ' + #13 +
////            '     SELECT D.LOTE, ' + #13 +
////            '            P.NOMBRE AS NOMBRE_PRODUCTO, ' + #13 +
////            '            D.CODIGO_PRODUCTO, ' + #13 +
////            '            D.UNIDAD_MEDIDA, ' + #13 +
////            '            B.NOMBRE AS NOMBRE_BODEGA, ' + #13 +
////            '        SUM(D.CANTIDAD) AS CANTIDAD ' + #13 +
////            '     FROM ' + Retornar_Info_Tabla(Id_Movimiento_Det).Name + ' D (NOLOCK) ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc).Name + ' E (NOLOCK) ON E.NUMERO_DOCUMENTO = D.NUMERO_DOCUMENTO ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' P (NOLOCK) ON P.CODIGO_PRODUCTO = D.CODIGO_PRODUCTO AND P.UNIDAD_MEDIDA = D.UNIDAD_MEDIDA ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' B (NOLOCK) ON B.CODIGO_BODEGA = D.CODIGO_BODEGA ' + #13 +
////            '     WHERE SUBSTRING(E.CODIGO_DOCUMENTO_ADM, 1, 2) = ' + QuotedStr('SI') + ' ' + #13 +
////            '     GROUP BY D.LOTE, P.NOMBRE, D.CODIGO_PRODUCTO, D.UNIDAD_MEDIDA, B.NOMBRE ' + #13 +
////            '    UNION ALL ' + #13 +
////            '     SELECT D.LOTE, ' + #13 +
////            '            P.NOMBRE AS NOMBRE_PRODUCTO, ' + #13 +
////            '            D.CODIGO_PRODUCTO, ' + #13 +
////            '            D.UNIDAD_MEDIDA, ' + #13 +
////            '            B.NOMBRE AS NOMBRE_BODEGA, ' + #13 +
////            '        SUM(D.CANTIDAD) AS CANTIDAD ' + #13 +
////            '     FROM ' + Retornar_Info_Tabla(Id_Movimiento_Det).Name + ' D (NOLOCK) ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc).Name + ' E (NOLOCK) ON E.NUMERO_DOCUMENTO = D.NUMERO_DOCUMENTO ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' P (NOLOCK) ON P.CODIGO_PRODUCTO = D.CODIGO_PRODUCTO AND P.UNIDAD_MEDIDA = D.UNIDAD_MEDIDA ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' B (NOLOCK) ON B.CODIGO_BODEGA = D.CODIGO_BODEGA ' + #13 +
////            '     WHERE SUBSTRING(E.CODIGO_DOCUMENTO_ADM, 1, 2) = '+ QuotedStr('EN') + ' ' + #13 +
////            '     GROUP BY D.LOTE, P.NOMBRE, D.CODIGO_PRODUCTO, D.UNIDAD_MEDIDA, B.NOMBRE ' + #13 +
////            '    UNION ALL ' + #13 +
////            '     SELECT D.LOTE, ' + #13 +
////            '            P.NOMBRE AS NOMBRE_PRODUCTO, ' + #13 +
////            '            D.CODIGO_PRODUCTO, ' + #13 +
////            '            D.UNIDAD_MEDIDA, ' + #13 +
////            '            B.NOMBRE AS NOMBRE_BODEGA, ' + #13 +
////            '            SUM(D.CANTIDAD * -1) AS CANTIDAD ' + #13 +
////            '     FROM ' + Retornar_Info_Tabla(Id_Movimiento_Det).Name + ' D (NOLOCK) ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc).Name + ' E (NOLOCK) ON E.NUMERO_DOCUMENTO = D.NUMERO_DOCUMENTO ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' P (NOLOCK) ON P.CODIGO_PRODUCTO = D.CODIGO_PRODUCTO AND P.UNIDAD_MEDIDA = D.UNIDAD_MEDIDA ' + #13 +
////            '     INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' B (NOLOCK) ON B.CODIGO_BODEGA = D.CODIGO_BODEGA ' + #13 +
////            '     WHERE SUBSTRING(E.CODIGO_DOCUMENTO_ADM, 1, 2) = ' + QuotedStr('SA') + ' ' + #13 +
////            '     GROUP BY D.LOTE, P.NOMBRE, D.CODIGO_PRODUCTO, D.UNIDAD_MEDIDA, B.NOMBRE ' + #13 +
////            ' ) AS X ' + #13 +
////            ' ' + IfThen(Not Vacio(lCondicion), lCondicion + #13) + ' ' +
//////            ' WHERE (1 = 1) ' + #13 +
////            ' GROUP BY X.LOTE, X.NOMBRE_PRODUCTO, X.CODIGO_PRODUCTO, X.UNIDAD_MEDIDA, X.NOMBRE_BODEGA ' + #13 +
////            ' HAVING SUM(CANTIDAD) > 0 ';
//End;

Procedure TBusqueda_TEST_TR_WjQDBGrid.SetTSD(pSD : Integer);
Var
  lS : String;
begin
  Self.TABLA            := '';
  Self.FILTRO           := [];
  Self.CONECTOR         := [];
  Self.SENTENCIA        := '';
  Self.TITULO_ORIGEN    := [];
  Self.CAMPOS_ORIGEN    := [];
  Self.CAMPOS_LIKE      := [];
  Self.CAMPOS_ID        := [];
  Self.CAMPOS_ALIGNMENT := [];
  Self.SIZE_ORIGEN      := [];
  Self.CAMPOS_DESTINO   := [];
  Case pSD Of
      Id_Perfil                  : Begin
                                     Self.TABLA            := Retornar_Info_Tabla(Id_Perfil).Name;
                                     Self.TITULO_ORIGEN    := ['Código'                 , 'Nombre'                ];
                                     Self.CAMPOS_ORIGEN    := ['CODIGO_PERFIL'          , 'NOMBRE'                ];
                                     Self.CAMPOS_LIKE      := ['CODIGO_PERFIL'          , 'NOMBRE'                ];
                                     Self.CAMPOS_ID        := ['S'                      , 'N'                     ];
                                     Self.CAMPOS_ALIGNMENT := [TAlignment.taRightJustify, TAlignment.taLeftJustify];
                                     Self.SIZE_ORIGEN      := [0000000000000100         ,                 00000550];
                                     Self.CAMPOS_DESTINO   := ['CODIGO_PERFIL'];
                                   End;
      Id_Usuario                 : Begin
                                     Self.TABLA            := Retornar_Info_Tabla(Id_Usuario).Name;
                                     Self.TITULO_ORIGEN    := ['Código'                 , 'Nombre'                ];
                                     Self.CAMPOS_ORIGEN    := ['CODIGO_USUARIO'         , 'NOMBRE'                ];
                                     Self.CAMPOS_LIKE      := ['CODIGO_USUARIO'         , 'NOMBRE'                ];
                                     Self.CAMPOS_ID        := ['S'                      , 'N'                     ];
                                     Self.CAMPOS_ALIGNMENT := [TAlignment.taRightJustify, TAlignment.taLeftJustify];
                                     Self.SIZE_ORIGEN      := [0000000000000100         , 00000550                ];
                                     Self.CAMPOS_DESTINO   := ['CODIGO_USUARIO'];
                                   End;
      Id_Buyer,
      Id_Product                 : Begin
                                     Self.TABLA            := Retornar_Info_Tabla(pSD).Name;
                                     Self.TITULO_ORIGEN    := ['Código'                 , 'Nombre'                ];
                                     Self.CAMPOS_ORIGEN    := ['ID'                     , 'NAME'                  ];
                                     Self.CAMPOS_LIKE      := ['ID'                     , 'NAME'                  ];
                                     Self.CAMPOS_ID        := ['S'                      , 'N'                     ];
                                     Self.CAMPOS_ALIGNMENT := [TAlignment.taRightJustify, TAlignment.taLeftJustify];
                                     Self.SIZE_ORIGEN      := [0000000000000100         , 00000550                ];
                                     Self.CAMPOS_DESTINO   := ['ID'];
                                   End;
  End;
  Self.SetGrid;
End;

destructor TBusqueda_TEST_TR_WjQDBGrid.Destroy;
begin

  inherited;
end;

end.
