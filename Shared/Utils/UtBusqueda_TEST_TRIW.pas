unit UtBusqueda_UPLIW;

interface

Uses
  UtType,
  IWControl,
  UtConexion,
  UtSearch_IW,
  System.Classes;

Type
  TSD = (TSD_Perfil, TSD_Usuario, TSD_Documento_ADM, TSD_Tercero, TSD_Bodega, TSD_Producto, TSD_LOTE);

Procedure UtBusqueda_UPLIW_Execute(pSD : TSD; pSearch_IW : TSearch_IW; pEvento : TIWAsyncEvent);

implementation
Uses
  UtLog,
  UtInfoTablas,
  System.SysUtils,
  ServerController;

Function UtGetSQL_Saldo_Inventario : String;
Begin
  Result := ' SELECT LOTE, ' +
            '        NOMBRE_PRODUCTO, ' +
            '        CODIGO_PRODUCTO, ' +
            '        UNIDAD_MEDIDA, ' +
            '        SUM(SALDO_INICIAL) AS SALDO_INICIAL, ' +
            '        SUM(ENTRADAS) AS ENTRADAS, ' +
            '        SUM(SALIDAS) AS SALIDAS, ' +
            '        SUM(SALDO_INICIAL + ENTRADAS - SALIDAS) AS EXISTENCIA ' +
            ' FROM ' +
            ' ( ' +
            '      SELECT D.LOTE, ' +
            '             D.CODIGO_PRODUCTO, ' +
            '             P.NOMBRE AS NOMBRE_PRODUCTO, ' +
            '             D.UNIDAD_MEDIDA, ' +
            '             SUM(D.CANTIDAD) AS SALDO_INICIAL, ' +
            '             0 AS ENTRADAS, ' +
            '             0 AS SALIDAS ' +
            '      FROM  ' + Retornar_Info_Tabla(Id_Movimiento_Det).Name + ' D ' +
            '      INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc).Name + ' E ON E.NUMERO_DOCUMENTO = D.NUMERO_DOCUMENTO ' +
            '      INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' P ON P.CODIGO_PRODUCTO = D.CODIGO_PRODUCTO AND P.UNIDAD_MEDIDA = D.UNIDAD_MEDIDA' +
            '      WHERE SUBSTRING(E.CODIGO_DOCUMENTO_ADM, 1, 2) = ' + QuotedStr('SI') + ' ' +
            '      GROUP BY D.LOTE, D.CODIGO_PRODUCTO, P.NOMBRE, D.UNIDAD_MEDIDA ' +
            '   UNION ALL ' +
            '      SELECT D.LOTE, ' +
            '             D.CODIGO_PRODUCTO, ' +
            '             P.NOMBRE AS NOMBRE_PRODUCTO, ' +
            '             D.UNIDAD_MEDIDA, ' +
            '             0 AS SALDO_INICIAL, ' +
            '             SUM(D.CANTIDAD) AS ENTRADAS, ' +
            '             0 AS SALIDAS ' +
            '      FROM  ' + Retornar_Info_Tabla(Id_Movimiento_Det).Name + ' D ' +
            '      INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc).Name + ' E ON E.NUMERO_DOCUMENTO = D.NUMERO_DOCUMENTO ' +
            '      INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' P ON P.CODIGO_PRODUCTO = D.CODIGO_PRODUCTO AND P.UNIDAD_MEDIDA = D.UNIDAD_MEDIDA' +
            '      WHERE SUBSTRING(E.CODIGO_DOCUMENTO_ADM, 1, 2) = ' + QuotedStr('EN') + ' ' +
            '      GROUP BY D.LOTE, D.CODIGO_PRODUCTO, P.NOMBRE, D.UNIDAD_MEDIDA ' +
            '   UNION ALL ' +
            '      SELECT D.LOTE, ' +
            '             D.CODIGO_PRODUCTO, ' +
            '             P.NOMBRE AS NOMBRE_PRODUCTO, ' +
            '             D.UNIDAD_MEDIDA, ' +
            '             0 AS SALDO_INICIAL, ' +
            '             0 AS ENTRADAS, ' +
            '             SUM(D.CANTIDAD) AS SALIDAS ' +
            '      FROM  ' + Retornar_Info_Tabla(Id_Movimiento_Det).Name + ' D ' +
            '      INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc).Name + ' E ON E.NUMERO_DOCUMENTO = D.NUMERO_DOCUMENTO ' +
            '      INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' P ON P.CODIGO_PRODUCTO = D.CODIGO_PRODUCTO AND P.UNIDAD_MEDIDA = D.UNIDAD_MEDIDA' +
            '      WHERE SUBSTRING(E.CODIGO_DOCUMENTO_ADM, 1, 2) = ' + QuotedStr('SA') + ' ' +
            '      GROUP BY D.LOTE, D.CODIGO_PRODUCTO, P.NOMBRE, D.UNIDAD_MEDIDA ' +
            ' ) AS X ' +
            ' WHERE ((X.SALDO_INICIAL + X.ENTRADAS - X.SALIDAS) > 0) ' +
            ' GROUP BY X.LOTE, X.CODIGO_PRODUCTO, X.NOMBRE_PRODUCTO, X.UNIDAD_MEDIDA ' +
            ' ORDER BY X.LOTE, X.CODIGO_PRODUCTO, X.NOMBRE_PRODUCTO, X.UNIDAD_MEDIDA ';
End;


Procedure UtBusqueda_UPLIW_Execute(pSD : TSD; pSearch_IW : TSearch_IW; pEvento : TIWAsyncEvent);
Var
  lS : String;
  lE : TIWAsyncEvent;
begin
  lE := Nil;
  If Assigned(pEvento) Then
    lE := pEvento;
  pSearch_IW.TABLA     := '';
  pSearch_IW.SENTENCIA := '';
  Case pSD Of
      TSD_Perfil                 : Begin
                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Perfil).Name;
                                     pSearch_IW.TITULO_ORIGEN  := ['Código'        , 'Nombre'];
                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_PERFIL', 'NOMBRE'];
                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_PERFIL', 'NOMBRE'];
                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000100, 00000500];
                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_PERFIL'];
                                     pSearch_IW.EVENTO         := lE;
                                   End;
      TSD_Documento_ADM          : Begin
                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Documento_ADM).Name;
                                     pSearch_IW.TITULO_ORIGEN  := ['Código'              , 'Nombre'];
                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_DOCUMENTO_ADM', 'NOMBRE'];
                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_DOCUMENTO_ADM', 'NOMBRE'];
                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000100      , 00000500];
                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_DOCUMENTO_ADM'];
                                     pSearch_IW.EVENTO         := lE;
                                   End;
      TSD_Usuario                : Begin
                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Usuario).Name;
                                     pSearch_IW.TITULO_ORIGEN  := ['Código'        , 'Nombre'];
                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_USUARIO', 'NOMBRE'];
                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_USUARIO', 'NOMBRE'];
                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000100, 00000500];
                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_USUARIO'];
                                     pSearch_IW.EVENTO         := lE;
                                   End;
      TSD_Tercero                : Begin
                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Tercero).Name;
                                     pSearch_IW.TITULO_ORIGEN  := ['Tercero'       , 'Nombre'];
                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_TERCERO', 'NOMBRE'];
                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_TERCERO', 'NOMBRE'];
                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000100, 00000500];
                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_TERCERO'];
                                     pSearch_IW.EVENTO         := lE;
                                   End;
      TSD_Lote                   : Begin
                                     lS := UtGetSQL_Saldo_Inventario;
                                     pSearch_IW.SENTENCIA      := lS;
                                     pSearch_IW.TITULO_ORIGEN  := ['Lote'  , 'Nombre'         , 'Producto'         , 'Unidad de medida', 'Existencia'];
                                     pSearch_IW.CAMPOS_ORIGEN  := ['LOTE'  , 'NOMBRE_PRODUCTO', 'CODIGO_PRODUCTO'  , 'UNIDAD_MEDIDA'   , 'EXISTENCIA'];
                                     pSearch_IW.CAMPOS_LIKE    := ['X.LOTE', 'X.NOMBRE'       , 'X.CODIGO_PRODUCTO', 'X.UNIDAD_MEDIDA'];
                                     pSearch_IW.SIZE_ORIGEN    := [00000100, 00000000000000100, 0000000000000000100, 00000000000000100 , 000000000100];
                                     pSearch_IW.CAMPOS_DESTINO := ['LOTE'];
                                     pSearch_IW.EVENTO         := lE;
                                   End;
//      TSD_Sinonimo               ,
//      TSD_Transferencia_Origen   ,
//      TSD_Transferencia_Destino  : Begin
//                                     lS := ' SELECT  ' + pSearch_IW.CNX.Top_Sentence(20) +
//                                                     '  T.CODIGO_TERCERO ' +
//                                                     ' ,T.NOMBRE AS NOMBRE_TERCERO ' +
//                                                     ' ,TS.CODIGO_SINONIMO ' +
//                                                     ' ,TS.NOMBRE AS NOMBRE_SINONIMO ' +
//                                                     ' ,T.DIRECCION AS DIRECCION_TERCERO ' +
//                                                     ' ,TS.DIRECCION AS DIRECCION_SINONIMO ' +
//                                                     ' ,TS.CODIGO_BODEGA ' +
//                                             ' FROM TERCERO_SINONIMO TS ' +
//                                             ' INNER JOIN TERCERO T ' +
//                                             ' ON  T.CODIGO_TERCERO =  TS.CODIGO_TERCERO ' +
//                                             ' ORDER BY T.NOMBRE, TS.NOMBRE ' ;
//                                     pSearch_IW.SENTENCIA      := lS;
//                                     pSearch_IW.TITULO_ORIGEN  := ['Nombre Tercero', 'Nombre Sinonimo', 'sinonimo'          , 'Bodega'          , 'Tercero'         ];
//                                     pSearch_IW.CAMPOS_ORIGEN  := ['NOMBRE_TERCERO', 'NOMBRE_SINONIMO', 'CODIGO_SINONIMO'   , 'CODIGO_BODEGA'   , 'CODIGO_TERCERO'  ];
//                                     pSearch_IW.CAMPOS_LIKE    := ['T.NOMBRE'      , 'TS.NOMBRE'      , 'TS.CODIGO_SINONIMO', 'TS.CODIGO_BODEGA', 'T.CODIGO_TERCERO'];
//                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000200, 00000000000000200, 0000000000000000100 , 00000000000000100 ];
//                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_TERCERO', 'CODIGO_SINONIMO', 'NOMBRE_TERCERO', 'NOMBRE_SINONIMO', 'DIRECCION_TERCERO', 'DIRECCION_SINONIMO', 'CODIGO_BODEGA'];
//                                     pSearch_IW.EVENTO         := lE;
//                                   End;
      TSD_Bodega                 : Begin
                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Bodega).Name;
                                     pSearch_IW.TITULO_ORIGEN  := ['Código'        , 'Nombre'];
                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_BODEGA' , 'NOMBRE'];
                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_BODEGA' , 'NOMBRE'];
                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000100, 00000500];
                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_BODEGA'];
                                     pSearch_IW.EVENTO         := lE;
                                   End;
//      TSD_Vehiculo               : Begin
//                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Vehiculo).Name;
//                                     pSearch_IW.TITULO_ORIGEN  := ['Código'         , 'Nombre'];
//                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_VEHICULO', 'NOMBRE'];
//                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_VEHICULO', 'NOMBRE'];
//                                     pSearch_IW.SIZE_ORIGEN    := [00000000000000100, 00000500];
//                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_VEHICULO'];
//                                     pSearch_IW.EVENTO         := lE;
//                                   End;
      TSD_Producto               : Begin
                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Producto).Name;
                                     pSearch_IW.TITULO_ORIGEN  := ['Código'        , 'Nombre', 'Unidad de Medida'];
                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_PRODUCTO', 'NOMBRE', 'UNIDAD_MEDIDA'  ];
                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_PRODUCTO', 'NOMBRE', 'UNIDAD_MEDIDA'  ];
                                     pSearch_IW.SIZE_ORIGEN    := [00000000000000100, 00000400, 00000000000000100];
                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_PRODUCTO', 'UNIDAD_MEDIDA'];
                                     pSearch_IW.EVENTO         := lE;
                                   End;
//      TSD_Referencia             : Begin
//                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Referencia).Name;
//                                     pSearch_IW.TITULO_ORIGEN  := ['Código'           , 'Nombre'];
//                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_REFERENCIA', 'NOMBRE'];
//                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_REFERENCIA', 'NOMBRE'];
//                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000100, 00000500];
//                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_REFERENCIA'];
//                                     pSearch_IW.EVENTO         := lE;
//                                   End;
//      TSD_Generacion_Enc         : Begin
//                                     pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Generacion_Enc).Name;
//                                     pSearch_IW.TITULO_ORIGEN  := ['Código'           , 'Nombre'];
//                                     pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_GENERACION', 'NOMBRE'];
//                                     pSearch_IW.CAMPOS_LIKE    := ['CODIGO_GENERACION', 'NOMBRE'];
//                                     pSearch_IW.SIZE_ORIGEN    := [0000000000000100, 00000500];
//                                     pSearch_IW.CAMPOS_DESTINO := ['CODIGO_GENERACION'];
//                                     pSearch_IW.EVENTO         := lE;
//                                   End;
//      TSD_Municipio              : Begin
//                                    pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Municipio).Name;
//                                    pSearch_IW.TITULO_ORIGEN  := ['Código'          , 'Municipio'       , 'Departamento' ];
//                                    pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_MUNICIPIO', 'NOMBRE_MUNICIPIO', 'NOMBRE_ESTADO'];
//                                    pSearch_IW.CAMPOS_LIKE    := ['CODIGO_MUNICIPIO', 'NOMBRE_MUNICIPIO', 'NOMBRE_ESTADO'];
//                                    pSearch_IW.SIZE_ORIGEN    := [0000000000000100  , 000000000000000250, 000000000000250];
//                                    pSearch_IW.CAMPOS_DESTINO := ['CODIGO_MUNICIPIO'];
//                                    pSearch_IW.EVENTO         := lE;
//                                  End;
//      TSD_Movimiento_Salida     : Begin
//                                    pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Salida_Enc).Name;
//                                    pSearch_IW.TITULO_ORIGEN  := ['Documento'    , 'Tercero'       , 'Sinonimo'       , 'Nombre'];
//                                    pSearch_IW.CAMPOS_ORIGEN  := ['CODIGO_SALIDA', 'CODIGO_TERCERO', 'CODIGO_SINONIMO', 'NOMBRE'];
//                                    pSearch_IW.CAMPOS_LIKE    := ['CODIGO_SALIDA', 'CODIGO_TERCERO', 'CODIGO_SINONIMO', 'NOMBRE'];
//                                    pSearch_IW.SIZE_ORIGEN    := [000000000000100, 0000000000000100, 00000000000000100, 00000300];
//                                    pSearch_IW.CAMPOS_DESTINO := ['CODIGO_SALIDA'];
//                                    pSearch_IW.EVENTO         := lE;
//                                  End;
//      TSD_Orden_Pedido_Enc      : Begin
//                                    pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Orden_Pedido_Enc).Name;
//                                    pSearch_IW.TITULO_ORIGEN  := ['Nombre', 'O.P.'               , 'Documento'           , 'Fecha'];
//                                    pSearch_IW.CAMPOS_ORIGEN  := ['NOMBRE', 'CODIGO_ORDEN_PEDIDO', 'DOCUMENTO_REFERENCIA', 'FECHA'];
//                                    pSearch_IW.CAMPOS_LIKE    := ['NOMBRE', 'CODIGO_ORDEN_PEDIDO', 'DOCUMENTO_REFERENCIA', 'FECHA'];
//                                    pSearch_IW.SIZE_ORIGEN    := [00000200, 000000000000000000100, 0000000000000000000100, 0000100];
//                                    pSearch_IW.CAMPOS_DESTINO := ['CODIGO_ORDEN_PEDIDO_ENC'];
//                                    pSearch_IW.EVENTO         := lE;
//                                  End;
//      TSD_Orden_Pedido_Det      : Begin
//                                    pSearch_IW.TABLA          := Retornar_Info_Tabla(Id_Orden_Pedido_Det).Name;
//                                    pSearch_IW.TITULO_ORIGEN  := ['Nombre',        'Novedad',        'Detalle',        'Referencia',           'Cantidad',                'O.P.'];
//                                    pSearch_IW.CAMPOS_ORIGEN  := ['NOMBRE', 'CODIGO_NOVEDAD', 'CODIGO_DETALLE', 'CODIGO_REFERENCIA', 'CANTIDAD_PENDIENTE', 'CODIGO_ORDEN_PEDIDO'];
//                                    pSearch_IW.CAMPOS_LIKE    := ['NOMBRE', 'CODIGO_NOVEDAD', 'CODIGO_DETALLE', 'CODIGO_REFERENCIA', 'CANTIDAD_PENDIENTE', 'CODIGO_ORDEN_PEDIDO'];
//                                    pSearch_IW.SIZE_ORIGEN    := [00000200, 000000000000000000100, 0000000000000000000100, 0000100];
//                                    pSearch_IW.CAMPOS_DESTINO := ['CANTIDAD_PENDIENTE', 'CODIGO_NOVEDAD', 'CODIGO_DETALLE', 'CODIGO_REFERENCIA', 'CODIGO_REFERENCIA', 'CODIGO_ORDEN_PEDIDO'];
//                                    pSearch_IW.EVENTO         := lE;
//                                  End;
//      TSD_Movimientos           : Begin
//                                    lS := ' SELECT ' + pSearch_IW.CNX.Top_Sentence(50) +
//                                          '        NUMERO_DOCUMENTO, NOMBRE, FECHA, CODIGO_TERCERO, CODIGO_SINONIMO ' +
//                                          '        FROM ' +
//                                          '        ( ' +
//                                          '          SELECT ' + pSearch_IW.CNX.Top_Sentence(20) +
//                                          '              CODIGO_ENTRADA AS NUMERO_DOCUMENTO ' +
//                                          '              ,NOMBRE ' +
//                                          '              ,FECHA ' +
//                                          '              ,CODIGO_TERCERO ' +
//                                          '              ,CODIGO_SINONIMO ' +
//                                          '           FROM ENTRADA_ENC ' +
//                                          '         UNION ' +
//                                          '          SELECT ' + pSearch_IW.CNX.Top_Sentence(20) +
//                                          '             CODIGO_SALIDA AS NUMERO_DOCUMENTO ' +
//                                          '            ,NOMBRE ' +
//                                          '            ,FECHA ' +
//                                          '            ,CODIGO_TERCERO ' +
//                                          '            ,CODIGO_SINONIMO ' +
//                                          '          FROM SALIDA_ENC ' +
//                                          '      ) ' +
//                                          '      AS X ';
//                                     pSearch_IW.SENTENCIA      := lS;
//                                     pSearch_IW.TITULO_ORIGEN  := ['Documento'         , 'Nombre'         , 'Fecha'  , 'Tercero'         , 'Sinonimo'         ];
//                                     pSearch_IW.CAMPOS_ORIGEN  := ['NUMERO_DOCUMENTO'  , 'NOMBRE'         , 'FECHA'  , 'CODIGO_TERCERO'  , 'CODIGO_SINONIMO'  ];
//                                     pSearch_IW.CAMPOS_LIKE    := ['X.NUMERO_DOCUMENTO', 'X.NOMBRE'       , 'X.FECHA', 'X.CODIGO_TERCERO', 'X.CODIGO_SINONIMO'];
//                                     pSearch_IW.SIZE_ORIGEN    := [00000000000000000100, 00000000000000200, 00000100 , 00000000000000100 , 00000000000000100  ];
//                                     pSearch_IW.CAMPOS_DESTINO := ['NUMERO_DOCUMENTO'];
//                                     pSearch_IW.EVENTO         := lE;
//                                  End;
  End;
  pSearch_IW.Execute;
End;



end.
