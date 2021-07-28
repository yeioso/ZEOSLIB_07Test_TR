unit UtReporte;
interface
Uses
  UtConexion,
  IWApplication;
Function UtReporte_Execute_Lote_Producto(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pDocumentos, pMSExcel : Boolean) : Boolean;
Function UtReporte_Execute_Producto_Lote(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pDocumentos, pMSExcel : Boolean) : Boolean;
Function UtReporte_Execute_Resumen_Producto(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pDocumentos, pMSExcel : Boolean) : Boolean;
Function UtReporte_Execute_Lote_Bodega(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pMSExcel : Boolean) : Boolean;
Function UtReporte_Execute_Tercero(pApp : TIWApplication; pCnx : TConexion; Const pCodigo_Usuario, pFechaIni, pFechaFin, pTerceroIni, pTerceroFin : String; pMSExcel : Boolean) : Boolean;
implementation
Uses
  Math,
  UtLog,
  Dialogs,
  Classes,
  SysUtils,
  StrUtils,
  UtFuncion,
  UtDatabase,
  UtInfoTablas,
  UtExporta_Excel;
Function UtReporte_Save(pCnx : TConexion; Var pLinea : Integer; Const pCodigo_Usuario, pContenido : String) : Boolean;
Begin
  Inc(pLinea);
  Try
    pCnx.TMP.Active := False;
    pCnx.TMP.SQL.Clear;
    pCnx.TMP.SQL.Add(' INSERT INTO ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' ');
    pCnx.TMP.SQL.Add(' (CODIGO_USUARIO, LINEA, CONTENIDO) ');
    pCnx.TMP.SQL.Add(' VALUES (:CODIGO_USUARIO, :LINEA, :CONTENIDO) ');
    pCnx.TMP.ParamByName('CODIGO_USUARIO').AsString := pCodigo_Usuario;
    pCnx.TMP.ParamByName('LINEA'         ).AsString := Justificar(IntToStr(pLinea), '0', 5);
    pCnx.TMP.ParamByName('CONTENIDO'     ).AsString := pContenido;
    pCnx.TMP.ExecSQL;
    Result := pCnx.TMP.RowsAffected > 0;
    pCnx.TMP.Active := False;
    pCnx.TMP.SQL.Clear;
  Except
    On E: Exception Do
    Begin
      UtLog_Execute('UtReporte_Execute, ' + E.Message);
    End;
  End;
End;
Function UtReporte_Linea_Lote_Producto(pCodigo_Producto, pNombre_Producto, pUnidad_Medida, pBodega, pDocumento, pFecha, pHora, pCantidad, pSaldo : String) : String;
Begin
  Result := Copy(Trim(pCodigo_Producto) + StringOfChar(' ', 10), 01, 10) + ' ' +
            Copy(Trim(pNombre_Producto) + StringOfChar(' ', 20), 01, 20) + ' ' +
            Copy(Trim(pUnidad_Medida  ) + StringOfChar(' ', 10), 01, 10) + ' ' +
            Copy(Trim(pBodega         ) + StringOfChar(' ', 10), 01, 10) + ' ' +
            Copy(Trim(pDocumento      ) + StringOfChar(' ', 30), 01, 30) + ' ' +
            Copy(Trim(pFecha          ) + StringOfChar(' ', 10), 01, 10) + ' ' +
            Copy(Trim(pHora           ) + StringOfChar(' ', 10), 01, 10) + ' ' +
            Copy(Justificar(pCantidad, ' ', 05), 01, 05) + ' ' +
            Copy(Justificar(pSaldo   , ' ', 05), 01, 05) ;
End;

Function UtReporte_Linea_Producto_Lote(pLote, pBodega, pDocumento, pFecha, pHora, pCantidad, pSaldo : String) : String;
Begin
  Result := Copy(Trim(pLote     ) + StringOfChar(' ', 20), 01, 20) + ' ' +
            Copy(Trim(pBodega   ) + StringOfChar(' ', 20), 01, 20) + ' ' +
            Copy(Trim(pDocumento) + StringOfChar(' ', 30), 01, 30) + ' ' +
            Copy(Trim(pFecha    ) + StringOfChar(' ', 10), 01, 10) + ' ' +
            Copy(Trim(pHora     ) + StringOfChar(' ', 10), 01, 10) + ' ' +
            Copy(Justificar(pCantidad, ' ', 10), 01, 10) + ' ' +
            Copy(Justificar(pSaldo   , ' ', 10), 01, 10) ;
End;
Function UtReporte_Execute_Lote_Producto(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pDocumentos, pMSExcel : Boolean) : Boolean;
Var
  lAux : String;
  lText : String;
  lLinea : String;
  lSaldo : Double;
  lTotal : Double;
  lSigno : Integer;
  lIndex : Integer;
Begin
  If Execute_SQL_Boolean('DELETE FROM ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' WHERE ' + pCnx.Trim_Sentence('CODIGO_USUARIO')  + ' = ' + QuotedStr(Trim(pCodigo_Usuario)) + ' ', 'UtReporte_Execute') Then
  Begin
    lTotal := 0;
    lIndex := 0;
    Try
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
      pCnx.AUX.SQL.Add(' SELECT ' );
      pCnx.AUX.SQL.Add('   A.LOTE ');
      pCnx.AUX.SQL.Add(' , C.NOMBRE AS NOMBRE_PRODUCTO ');
      pCnx.AUX.SQL.Add(' , C.CODIGO_PRODUCTO ');
      pCnx.AUX.SQL.Add(' , C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add(' , D.NOMBRE AS NOMBRE_BODEGA ');
      pCnx.AUX.SQL.Add(' , B.CODIGO_DOCUMENTO_ADM ');
      pCnx.AUX.SQL.Add(' , B.FECHA_MOVIMIENTO ');
      pCnx.AUX.SQL.Add(' , B.HORA_MOVIMIENTO ');
      pCnx.AUX.SQL.Add(' , B.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add(' , A.CANTIDAD ');
      pCnx.AUX.SQL.Add(' FROM ' + Retornar_Info_Tabla(pDet).Name + ' A ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(pEnc).Name + ' B ');
      pCnx.AUX.SQL.Add(' ON A.NUMERO_DOCUMENTO = B.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' C ');
      pCnx.AUX.SQL.Add(' ON A.CODIGO_PRODUCTO = C.CODIGO_PRODUCTO AND A.UNIDAD_MEDIDA = C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' D ');
      pCnx.AUX.SQL.Add(' ON A.CODIGO_BODEGA = D.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add(' WHERE A.CODIGO_PRODUCTO + A.UNIDAD_MEDIDA BETWEEN ' + QuotedStr(pProductoIni + pUnidadMedidaIni) + ' AND ' + QuotedStr(pProductoFin + pUnidadMedidaFin) + ' ');
      If Not Vacio(pFechaIni + pFechaFin) Then
        pCnx.AUX.SQL.Add(' AND B.FECHA_MOVIMIENTO BETWEEN ' + QuotedStr(pFechaIni) + ' AND ' + QuotedStr(pFechaFin) + ' ');
      If Not Vacio(pLoteIni + pLoteFin) Then
        pCnx.AUX.SQL.Add(' AND A.LOTE BETWEEN ' + QuotedStr(pLoteIni) + ' AND ' + QuotedStr(pLoteFin) + ' ');
      pCnx.AUX.SQL.Add(' ORDER BY A.LOTE, C.NOMBRE, C.CODIGO_PRODUCTO, C.UNIDAD_MEDIDA, B.FECHA_MOVIMIENTO DESC, B.HORA_MOVIMIENTO DESC, B.NUMERO_DOCUMENTO, A.CANTIDAD ');
      If pMSExcel Then
      Begin
        Result := UtExporta_Excel_Execute(pApp, pCnx.AUX);
      End
      Else
      Begin
        pCnx.AUX.Active := True;
        If pCnx.AUX.Active And (pCnx.AUX.RecordCount > 0) Then
        Begin
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'PRODUCTOS POR LOTE');
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'FECHA DESDE ' + pFechaIni + ' HASTA ' + pFechaFin + ', LOTE DESDE ' + pLoteIni + ' HASTA ' + pLoteFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'PRODUCTO DESDE ' + pProductoIni + ' HASTA ' + pProductoFin + ', UNIDAD DE MEDIDA DESDE ' + pUnidadMedidaIni + ' HASTA ' + pUnidadMedidaFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, '');
          If Not pDocumentos Then
          Begin
            lLinea := Copy(StringOfChar('.', 200), 01, 110);
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            lLinea := Copy('LOTE' + StringOfChar(' ', 100), 01, 100) + Copy(Justificar('SALDO', ' ', 010), 01, 010) ;
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            lLinea := Copy(StringOfChar('.', 200), 01, 110);
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
          End;
          pCnx.AUX.First;
          While Not pCnx.AUX.Eof Do
          Begin
            lSaldo := 0;
            lAux := pCnx.AUX.FieldByName('LOTE').AsString;
            lText := Trim(pCnx.AUX.FieldByName('LOTE').AsString);
            If pDocumentos Then
            Begin
              lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Lote_Producto(StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030));
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
              lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Lote_Producto('PRODUCTO' ,
                                                                             'NOMBRE'   ,
                                                                             'MEDIDA'   ,
                                                                             'BODEGA'   ,
                                                                             'DOCUMENTO',
                                                                             'FECHA'    ,
                                                                             'HORA'     ,
                                                                             'CANTIDAD' ,
                                                                             'SALDO'    );
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
              lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Lote_Producto(StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030),
                                                                             StringOfChar('.', 030));
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            End;
            While (Not pCnx.AUX.Eof) And (Trim(lAux) = Trim(pCnx.AUX.FieldByName('LOTE').AsString)) Do
            Begin
              lSigno := 1;
              If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'EN') Then
                lSigno := 1
              Else
                If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'SA') Then
                  lSigno := -1;
              lSaldo := lSaldo + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
              lTotal := lTotal + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
              If pDocumentos Then
              Begin
                lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Lote_Producto(pCnx.AUX.FieldByName('CODIGO_PRODUCTO' ).AsString,
                                                                               pCnx.AUX.FieldByName('NOMBRE_PRODUCTO' ).AsString,
                                                                               pCnx.AUX.FieldByName('UNIDAD_MEDIDA'   ).AsString,
                                                                               pCnx.AUX.FieldByName('NOMBRE_BODEGA'   ).AsString,
                                                                               pCnx.AUX.FieldByName('NUMERO_DOCUMENTO').AsString,
                                                                               pCnx.AUX.FieldByName('FECHA_MOVIMIENTO').AsString,
                                                                               pCnx.AUX.FieldByName('HORA_MOVIMIENTO' ).AsString,
                                                                               FormatFloat('#,##0', pCnx.AUX.FieldByName('CANTIDAD' ).AsFloat),
                                                                               FormatFloat('#,##0', lSaldo));
                UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
              End;
              Result := True;
              pCnx.AUX.Next;
            End;
            If pDocumentos Then
            Begin
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('-', 200));
              lLinea := 'TOTAL LOTE ' + Trim(lText) + ': ' + FormatFloat('###,###,##0.#0', lSaldo);
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            End
            Else
            Begin
              lLinea := Copy(Trim(lText) + StringOfChar(' ', 100), 01, 100) + Copy(Justificar(FormatFloat('###,###,##0', lSaldo), ' ', 10), 01, 10);
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            End;
          End;
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('=', 200));
          lLinea := 'TOTAL GENERAL: ' + FormatFloat('###,###,##0', lTotal);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
        End;
      End;
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
    Except
      On E: Exception Do
      Begin
        UtLog_Execute('UtReporte_Execute_Lote_Producto, ' + E.Message);
      End;
    End;
  End;
End;
Function UtReporte_Execute_Producto_Lote(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pDocumentos, pMSExcel : Boolean) : Boolean;
Var
  lAux : String;
  lText : String;
  lLinea : String;
  lSaldo : Double;
  lTotal : Double;
  lSigno : Integer;
  lIndex : Integer;
Begin
  If Execute_SQL_Boolean('DELETE FROM ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' WHERE ' + pCnx.Trim_Sentence('CODIGO_USUARIO')  + ' = ' + QuotedStr(Trim(pCodigo_Usuario)) + ' ', 'UtReporte_Execute') Then
  Begin
    lTotal := 0;
    lIndex := 0;
    Try
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
      pCnx.AUX.SQL.Add(' SELECT ' );
      pCnx.AUX.SQL.Add('   A.LOTE ');
      pCnx.AUX.SQL.Add(' , C.NOMBRE AS NOMBRE_PRODUCTO ');
      pCnx.AUX.SQL.Add(' , C.CODIGO_PRODUCTO ');
      pCnx.AUX.SQL.Add(' , C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add(' , D.NOMBRE AS NOMBRE_BODEGA ');
      pCnx.AUX.SQL.Add(' , B.CODIGO_DOCUMENTO_ADM ');
      pCnx.AUX.SQL.Add(' , B.FECHA_MOVIMIENTO ');
      pCnx.AUX.SQL.Add(' , B.HORA_MOVIMIENTO ');
      pCnx.AUX.SQL.Add(' , B.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add(' , A.CANTIDAD ');
      pCnx.AUX.SQL.Add(' FROM ' + Retornar_Info_Tabla(pDet).Name + ' A ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(pEnc).Name + ' B ');
      pCnx.AUX.SQL.Add(' ON A.NUMERO_DOCUMENTO = B.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' C ');
      pCnx.AUX.SQL.Add(' ON A.CODIGO_PRODUCTO = C.CODIGO_PRODUCTO AND A.UNIDAD_MEDIDA = C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' D ');
      pCnx.AUX.SQL.Add(' ON A.CODIGO_BODEGA = D.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add(' WHERE A.CODIGO_PRODUCTO + A.UNIDAD_MEDIDA BETWEEN ' + QuotedStr(pProductoIni + pUnidadMedidaIni) + ' AND ' + QuotedStr(pProductoFin + pUnidadMedidaFin) + ' ');
      If Not Vacio(pFechaIni + pFechaFin) Then
        pCnx.AUX.SQL.Add(' AND B.FECHA_MOVIMIENTO BETWEEN ' + QuotedStr(pFechaIni) + ' AND ' + QuotedStr(pFechaFin) + ' ');
      If Not Vacio(pLoteIni + pLoteFin) Then
        pCnx.AUX.SQL.Add(' AND A.LOTE BETWEEN ' + QuotedStr(pLoteIni) + ' AND ' + QuotedStr(pLoteFin) + ' ');
      pCnx.AUX.SQL.Add(' ORDER BY C.NOMBRE, C.CODIGO_PRODUCTO, C.UNIDAD_MEDIDA, A.LOTE, B.FECHA_MOVIMIENTO DESC, B.HORA_MOVIMIENTO DESC, B.NUMERO_DOCUMENTO, A.CANTIDAD ');
      If pMSExcel Then
      Begin
        Result := UtExporta_Excel_Execute(pApp, pCnx.AUX);
      End
      Else
      Begin
        pCnx.AUX.Active := True;
        If pCnx.AUX.Active And (pCnx.AUX.RecordCount > 0) Then
        Begin
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'LOTES POR PRODUCTO');
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'FECHA DESDE ' + pFechaIni + ' HASTA ' + pFechaFin + ', LOTE DESDE ' + pLoteIni + ' HASTA ' + pLoteFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'PRODUCTO DESDE ' + pProductoIni + ' HASTA ' + pProductoFin + ', UNIDAD DE MEDIDA DESDE ' + pUnidadMedidaIni + ' HASTA ' + pUnidadMedidaFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, '');
          If Not pDocumentos Then
          Begin
            lLinea := Copy(StringOfChar('.', 200), 01, 110);
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            lLinea := Copy('PRODUCTO' + StringOfChar(' ', 100), 01, 100) + Copy(Justificar('SALDO', ' ', 010), 01, 010) ;
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            lLinea := Copy(StringOfChar('.', 200), 01, 110);
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
          End;
          pCnx.AUX.First;
          While Not pCnx.AUX.Eof Do
          Begin
            lSaldo := 0;
            lAux := pCnx.AUX.FieldByName('NOMBRE_PRODUCTO').AsString + pCnx.AUX.FieldByName('UNIDAD_MEDIDA').AsString;
            lText := Trim(pCnx.AUX.FieldByName('NOMBRE_PRODUCTO').AsString) + '(' + Trim(pCnx.AUX.FieldByName('CODIGO_PRODUCTO').AsString) + ' - ' + Trim(pCnx.AUX.FieldByName('UNIDAD_MEDIDA').AsString) + ')';
            If pDocumentos Then
            Begin
              lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Producto_Lote(StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200));
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
              lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Producto_Lote('LOTE'     ,
                                                                             'BODEGA'   ,
                                                                             'DOCUMENTO',
                                                                             'FECHA'    ,
                                                                             'HORA'     ,
                                                                             'CANTIDAD' ,
                                                                             'SALDO'    );
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
              lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Producto_Lote(StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200),
                                                                             StringOfChar('.', 200));
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            End;
            While (Not pCnx.AUX.Eof) And (Trim(lAux) = Trim(pCnx.AUX.FieldByName('NOMBRE_PRODUCTO').AsString + pCnx.AUX.FieldByName('UNIDAD_MEDIDA').AsString)) Do
            Begin
              lSigno := 1;
              If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'EN') Then
                lSigno := 1
              Else
                If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'SA') Then
                  lSigno := -1;
              lSaldo := lSaldo + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
              lTotal := lTotal + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
              If pDocumentos Then
              Begin
                lLinea := StringOfChar(' ', 5) + UtReporte_Linea_Producto_Lote(pCnx.AUX.FieldByName('LOTE'            ).AsString,
                                                                               pCnx.AUX.FieldByName('NOMBRE_BODEGA'   ).AsString,
                                                                               pCnx.AUX.FieldByName('NUMERO_DOCUMENTO').AsString,
                                                                               pCnx.AUX.FieldByName('FECHA_MOVIMIENTO').AsString,
                                                                               pCnx.AUX.FieldByName('HORA_MOVIMIENTO' ).AsString,
                                                                               FormatFloat('###,###,##0.#0', pCnx.AUX.FieldByName('CANTIDAD' ).AsFloat),
                                                                               FormatFloat('###,###,##0.#0', lSaldo));
                UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
              End;
              Result := True;
              pCnx.AUX.Next;
            End;
            If pDocumentos Then
            Begin
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('-', 255));
              lLinea := ' TOTAL PRODUCTO ' + Trim(lText) + ': ' + FormatFloat('###,###,##0.#0', lSaldo);
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            End
            Else
            Begin
              lLinea := Copy(Trim(lText) + StringOfChar(' ', 100), 01, 100) + Copy(Justificar(FormatFloat('###,###,##0.#0', lSaldo), ' ', 10), 01, 10);
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            End;
          End;
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('=', 255));
          lLinea := ' TOTAL GENERAL: ' + FormatFloat('###,###,##0.#0', lTotal);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
        End;
      End;
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
    Except
      On E: Exception Do
      Begin
        UtLog_Execute('UtReporte_Execute_Lote_Producto, ' + E.Message);
      End;
    End;
  End;
End;

Function UtReporte_Execute_Resumen_Producto(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pDocumentos, pMSExcel : Boolean) : Boolean;
Var
  lAux : String;
  lText : String;
  lSaldo : Double;
  lIndex : Integer;
Begin
  Result := False;
  If Execute_SQL_Boolean('DELETE FROM ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' WHERE ' + pCnx.Trim_Sentence('CODIGO_USUARIO')  + ' = ' + QuotedStr(Trim(pCodigo_Usuario)) + ' ', 'UtReporte_Execute') Then
  Begin
    lSaldo := 0;
    lIndex := 0;
    Try
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
      pCnx.AUX.SQL.Add('  SELECT CODIGO_PRODUCTO, NOMBRE_PRODUCTO, UNIDAD_MEDIDA, SUM(ENTRADAS) AS ENTRADAS, SUM(SALIDAS) AS SALIDAS , SUM(ENTRADAS - SALIDAS) AS SALDO ');
      pCnx.AUX.SQL.Add('  FROM ');
      pCnx.AUX.SQL.Add('  ( ');
      pCnx.AUX.SQL.Add('    SELECT ');
      pCnx.AUX.SQL.Add('        C.CODIGO_PRODUCTO ');
      pCnx.AUX.SQL.Add('      , C.NOMBRE AS NOMBRE_PRODUCTO ');
      pCnx.AUX.SQL.Add('      , C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('      , SUM(A.CANTIDAD) AS ENTRADAS ');
      pCnx.AUX.SQL.Add('      , 0 AS SALIDAS ');
      pCnx.AUX.SQL.Add('      , 0 AS SALDO ');
      pCnx.AUX.SQL.Add('      FROM ' + Retornar_Info_Tabla(pDet).Name + ' A ');
      pCnx.AUX.SQL.Add('      INNER JOIN ' + Retornar_Info_Tabla(pEnc).Name + ' B ');
      pCnx.AUX.SQL.Add('      ON A.NUMERO_DOCUMENTO = B.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add('      INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' C ');
      pCnx.AUX.SQL.Add('      ON A.CODIGO_PRODUCTO = C.CODIGO_PRODUCTO AND A.UNIDAD_MEDIDA = C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('      INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' D ');
      pCnx.AUX.SQL.Add('      ON A.CODIGO_BODEGA = D.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add(' WHERE A.CODIGO_PRODUCTO + A.UNIDAD_MEDIDA BETWEEN ' + QuotedStr(pProductoIni + pUnidadMedidaIni) + ' AND ' + QuotedStr(pProductoFin + pUnidadMedidaFin) + ' ');
      If Not Vacio(pFechaIni + pFechaFin) Then
        pCnx.AUX.SQL.Add(' AND B.FECHA_MOVIMIENTO BETWEEN ' + QuotedStr(pFechaIni) + ' AND ' + QuotedStr(pFechaFin) + ' ');
      If Not Vacio(pLoteIni + pLoteFin) Then
        pCnx.AUX.SQL.Add(' AND A.LOTE BETWEEN ' + QuotedStr(pLoteIni) + ' AND ' + QuotedStr(pLoteFin) + ' ');
      pCnx.AUX.SQL.Add('      AND B.CODIGO_DOCUMENTO_ADM LIKE ' + QuotedStr('EN%') + ' ');
      pCnx.AUX.SQL.Add('      GROUP BY C.CODIGO_PRODUCTO, C.NOMBRE, C.UNIDAD_MEDIDA, B.CODIGO_DOCUMENTO_ADM ');
      pCnx.AUX.SQL.Add('   UNION ALL ');
      pCnx.AUX.SQL.Add('    SELECT ');
      pCnx.AUX.SQL.Add('        C.CODIGO_PRODUCTO ');
      pCnx.AUX.SQL.Add('      , C.NOMBRE AS NOMBRE_PRODUCTO ');
      pCnx.AUX.SQL.Add('      , C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('      , 0 AS ENTRADAS ');
      pCnx.AUX.SQL.Add('      , SUM(A.CANTIDAD) AS SALIDAS ');
      pCnx.AUX.SQL.Add('      , 0 AS SALDO ');
      pCnx.AUX.SQL.Add('      FROM ' + Retornar_Info_Tabla(pDet).Name + ' A ');
      pCnx.AUX.SQL.Add('      INNER JOIN ' + Retornar_Info_Tabla(pEnc).Name + ' B ');
      pCnx.AUX.SQL.Add('      ON A.NUMERO_DOCUMENTO = B.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add('      INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' C ');
      pCnx.AUX.SQL.Add('      ON A.CODIGO_PRODUCTO = C.CODIGO_PRODUCTO AND A.UNIDAD_MEDIDA = C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('      INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' D ');
      pCnx.AUX.SQL.Add('      ON A.CODIGO_BODEGA = D.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add(' WHERE A.CODIGO_PRODUCTO + A.UNIDAD_MEDIDA BETWEEN ' + QuotedStr(pProductoIni + pUnidadMedidaIni) + ' AND ' + QuotedStr(pProductoFin + pUnidadMedidaFin) + ' ');
      If Not Vacio(pFechaIni + pFechaFin) Then
        pCnx.AUX.SQL.Add(' AND B.FECHA_MOVIMIENTO BETWEEN ' + QuotedStr(pFechaIni) + ' AND ' + QuotedStr(pFechaFin) + ' ');
      If Not Vacio(pLoteIni + pLoteFin) Then
        pCnx.AUX.SQL.Add(' AND A.LOTE BETWEEN ' + QuotedStr(pLoteIni) + ' AND ' + QuotedStr(pLoteFin) + ' ');
      pCnx.AUX.SQL.Add('      AND B.CODIGO_DOCUMENTO_ADM LIKE ' + QuotedStr('SA%') + ' ');
      pCnx.AUX.SQL.Add('      GROUP BY C.CODIGO_PRODUCTO, C.NOMBRE, C.UNIDAD_MEDIDA, B.CODIGO_DOCUMENTO_ADM ');
      pCnx.AUX.SQL.Add(' ) X ');
      pCnx.AUX.SQL.Add(' GROUP BY CODIGO_PRODUCTO, NOMBRE_PRODUCTO, UNIDAD_MEDIDA ');
      If pMSExcel Then
      Begin
        Result := UtExporta_Excel_Execute(pApp, pCnx.AUX);
      End
      Else
      Begin
        pCnx.AUX.Active := True;
        If pCnx.AUX.Active And (pCnx.AUX.RecordCount > 0) Then
        Begin
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 10) + 'RESUMEN POR PRODUCTO');
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 10) + 'FECHA DESDE ' + pFechaIni + ' HASTA ' + pFechaFin + ', LOTE DESDE ' + pLoteIni + ' HASTA ' + pLoteFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 10) + 'PRODUCTO DESDE ' + pProductoIni + ' HASTA ' + pProductoFin + ', UNIDAD DE MEDIDA DESDE ' + pUnidadMedidaIni + ' HASTA ' + pUnidadMedidaFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, '');
          lText := StringOfChar(' ', 10) + Copy(StringOfChar('.', 105), 01, 86);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lText);
          If pCnx.AUX.RecordCount > 0 Then
          Begin
            lText := StringOfChar(' ', 10) +
                     Copy('PRODUCTO' + StringOfChar(' ',  50), 01, 50) + ' ' +
                     Copy(Justificar('ENTRADAS'    , ' ', 11), 01, 11) + ' ' +
                     Copy(Justificar('SALIDAS'     , ' ', 11), 01, 11) + ' ' +
                     Copy(Justificar('SALDO'       , ' ', 11), 01, 11) ;
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lText);
            pCnx.AUX.First;
            While Not pCnx.AUX.Eof Do
            Begin
              lSaldo := lSaldo + pCnx.AUX.FieldByName('SALDO').AsFloat;
              lAux := pCnx.AUX.FieldByName('NOMBRE_PRODUCTO').AsString + pCnx.AUX.FieldByName('UNIDAD_MEDIDA').AsString;
              lText := StringOfChar(' ', 10) +
                       Copy(lAux + StringOfChar(' ', 50), 01, 50) +                                                                         ' ' +
                       Copy(Justificar(FormatFloat('###,###,##0', pCnx.AUX.FieldByName('ENTRADAS').AsFloat), ' ', 11), 01, 11) + ' ' +
                       Copy(Justificar(FormatFloat('###,###,##0', pCnx.AUX.FieldByName('SALIDAS' ).AsFloat), ' ', 11), 01, 11) + ' ' +
                       Copy(Justificar(FormatFloat('###,###,##0', pCnx.AUX.FieldByName('SALDO'   ).AsFloat), ' ', 11), 01, 11) ;
              UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lText);
              pCnx.AUX.Next;
              Result := True;
            End;
          End;
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 10) + StringOfChar('=', 86));
          lText := StringOfChar(' ', 10) +
                   Copy('TOTAL GENERAL: '+ StringOfChar(' ', 50),  01, 50) +  ' ' +
                   Copy(Justificar(''                  , ' ', 11), 01, 11) +  ' ' +
                   Copy(Justificar(''                  , ' ', 11), 01, 11) +  ' ' +
                   Copy(Justificar(FormatFloat('###,###,##0', lSaldo), ' ', 11), 01, 11) ;
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lText);
        End;
      End;
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
    Except
      On E: Exception Do
      Begin
        UtLog_Execute('UtReporte_Execute_Resumen_Producto, ' + E.Message);
      End;
    End;
  End;
End;
Function UtReporte_Execute_Lote_Bodega(pApp : TIWApplication; pCnx : TConexion; Const pEnc, pDet : Integer; Const pCodigo_Usuario, pFechaIni, pFechaFin, pProductoIni, pProductoFin, pUnidadMedidaIni, pUnidadMedidaFin, pLoteIni, pLoteFin : String; pMSExcel : Boolean) : Boolean;
Var
  lAux : String;
  lText : String;
  lLinea : String;
  lSaldo : Double;
  lTotal : Double;
  lSigno : Integer;
  lIndex : Integer;
Begin
  If Execute_SQL_Boolean('DELETE FROM ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' WHERE ' + pCnx.Trim_Sentence('CODIGO_USUARIO')  + ' = ' + QuotedStr(Trim(pCodigo_Usuario)) + ' ', 'UtReporte_Execute') Then
  Begin
    lTotal := 0;
    lIndex := 0;
    Try
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
      pCnx.AUX.SQL.Add(' SELECT ' );
      pCnx.AUX.SQL.Add('   A.LOTE ');
      pCnx.AUX.SQL.Add(' , B.CODIGO_DOCUMENTO_ADM ');
      pCnx.AUX.SQL.Add(' , A.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add(' , D.NOMBRE AS NOMBRE_BODEGA ');
      pCnx.AUX.SQL.Add(' , A.CANTIDAD ');
      pCnx.AUX.SQL.Add(' FROM ' + Retornar_Info_Tabla(pDet).Name + ' A ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(pEnc).Name + ' B ');
      pCnx.AUX.SQL.Add(' ON A.NUMERO_DOCUMENTO = B.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' C ');
      pCnx.AUX.SQL.Add(' ON A.CODIGO_PRODUCTO = C.CODIGO_PRODUCTO AND A.UNIDAD_MEDIDA = C.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add(' INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' D ');
      pCnx.AUX.SQL.Add(' ON A.CODIGO_BODEGA = D.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add(' WHERE A.CODIGO_PRODUCTO + A.UNIDAD_MEDIDA BETWEEN ' + QuotedStr(pProductoIni + pUnidadMedidaIni) + ' AND ' + QuotedStr(pProductoFin + pUnidadMedidaFin) + ' ');
      If Not Vacio(pFechaIni + pFechaFin) Then
        pCnx.AUX.SQL.Add(' AND B.FECHA_MOVIMIENTO BETWEEN ' + QuotedStr(pFechaIni) + ' AND ' + QuotedStr(pFechaFin) + ' ');
      If Not Vacio(pLoteIni + pLoteFin) Then
        pCnx.AUX.SQL.Add(' AND A.LOTE BETWEEN ' + QuotedStr(pLoteIni) + ' AND ' + QuotedStr(pLoteFin) + ' ');
      pCnx.AUX.SQL.Add(' ORDER BY A.LOTE, A.CODIGO_BODEGA, D.NOMBRE, A.CANTIDAD ');
      If pMSExcel Then
      Begin
        Result := UtExporta_Excel_Execute(pApp, pCnx.AUX);
      End
      Else
      Begin
        pCnx.AUX.Active := True;
        If pCnx.AUX.Active And (pCnx.AUX.RecordCount > 0) Then
        Begin
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'BODEGAS POR LOTE');
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'FECHA DESDE ' + pFechaIni + ' HASTA ' + pFechaFin + ', LOTE DESDE ' + pLoteIni + ' HASTA ' + pLoteFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'PRODUCTO DESDE ' + pProductoIni + ' HASTA ' + pProductoFin + ', UNIDAD DE MEDIDA DESDE ' + pUnidadMedidaIni + ' HASTA ' + pUnidadMedidaFin);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, '');
          lLinea := Copy('LOTE - BODEGA' + StringOfChar(' ', 105), 001, 105) + Justificar('SALDO', ' ', 15);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('-', 200));
          pCnx.AUX.First;
          While Not pCnx.AUX.Eof Do
          Begin
            lSaldo := 0;
            lAux := pCnx.AUX.FieldByName('LOTE').AsString + pCnx.AUX.FieldByName('CODIGO_BODEGA').AsString;
            lText := Trim(pCnx.AUX.FieldByName('LOTE').AsString) + ' - ' + Trim(pCnx.AUX.FieldByName('NOMBRE_BODEGA').AsString);
            While (Not pCnx.AUX.Eof) And (Trim(lAux) = Trim(pCnx.AUX.FieldByName('LOTE').AsString + pCnx.AUX.FieldByName('CODIGO_BODEGA').AsString)) Do
            Begin
              lSigno := 1;
              If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'EN') Then
                lSigno := 1
              Else
                If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'SA') Then
                  lSigno := -1;
              lSaldo := lSaldo + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
              lTotal := lTotal + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
              Result := True;
              pCnx.AUX.Next;
            End;
            lLinea := Copy(lText + StringOfChar(' ', 105), 001, 105) +  Justificar(FormatFloat('###,###,##0.#0', lSaldo), ' ', 15);
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
          End;
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('=', 200));
          lLinea := Copy('TOTAL GENERAL' + StringOfChar(' ', 105), 001, 105) +  Justificar(FormatFloat('###,###,##0.#0', lTotal), ' ', 15);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
        End;
      End;
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
    Except
      On E: Exception Do
      Begin
        UtLog_Execute('UtReporte_Execute_Lote_Bodega, ' + E.Message);
      End;
    End;
  End;
End;
Function UtReporte_Linea_Tercero_Detalle(pFecha_Movimiento_Bodega, pNumero_Documento_Referencia, pFecha_Fabricacion_Cantidad, pFecha_Vencimiento_Unidad_Medida , pNombre_Producto_pLote : String) : String;
Begin
  Result :=            Copy(Trim(pFecha_Movimiento_Bodega        ) + StringOfChar(' ', 10), 01, 10) + '  ' +
                       Copy(Trim(pNumero_Documento_Referencia    ) + StringOfChar(' ', 30), 01, 30) + '  ' +
            Justificar(Copy(Trim(pFecha_Fabricacion_Cantidad     ) + StringOfChar(' ', 11), 01, 11), ' ', 11) + '  ' +
                       Copy(Trim(pFecha_Vencimiento_Unidad_Medida) + StringOfChar(' ', 11), 01, 11) + '  ' +
                       Copy(Trim(pNombre_Producto_pLote          ) + StringOfChar(' ', 10), 01, 50);
End;
Function UtReporte_Execute_Tercero(pApp : TIWApplication; pCnx : TConexion; Const pCodigo_Usuario, pFechaIni, pFechaFin, pTerceroIni, pTerceroFin : String; pMSExcel : Boolean) : Boolean;
Var
  lAux : String;
  lText : String;
  lLinea : String;
  lSaldo : Double;
  lTotal : Double;
  lSigno : Integer;
  lIndex : Integer;
Begin
  If Execute_SQL_Boolean('DELETE FROM ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' WHERE ' + pCnx.Trim_Sentence('CODIGO_USUARIO')  + ' = ' + QuotedStr(Trim(pCodigo_Usuario)) + ' ', 'UtReporte_Execute') Then
  Begin
    lTotal := 0;
    lIndex := 0;
    Try
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
      pCnx.AUX.SQL.Add('   SELECT  NOMBRE_TERCERO ');
      pCnx.AUX.SQL.Add('          ,CODIGO_DOCUMENTO_ADM');
      pCnx.AUX.SQL.Add('          ,FECHA_MOVIMIENTO ');
      pCnx.AUX.SQL.Add('          ,NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add('          ,DOCUMENTO_REFERENCIA ');
      pCnx.AUX.SQL.Add('          ,NOMBRE_PRODUCTO ');
      pCnx.AUX.SQL.Add('          ,NOMBRE_BODEGA ');
      pCnx.AUX.SQL.Add('          ,UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('          ,LOTE ');
      pCnx.AUX.SQL.Add('          ,FECHA_FABRICACION ');
      pCnx.AUX.SQL.Add('          ,FECHA_VENCIMIENTO ');
      pCnx.AUX.SQL.Add('          ,CANTIDAD ');
      pCnx.AUX.SQL.Add('   FROM ');
      pCnx.AUX.SQL.Add('   ( ');
      pCnx.AUX.SQL.Add('       SELECT ');
      pCnx.AUX.SQL.Add('            TER.NOMBRE AS NOMBRE_TERCERO ');
      pCnx.AUX.SQL.Add('           ,ENC.CODIGO_DOCUMENTO_ADM ');
      pCnx.AUX.SQL.Add('           ,ENC.FECHA_MOVIMIENTO ');
      pCnx.AUX.SQL.Add('           ,ENC.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add('           ,ENC.DOCUMENTO_REFERENCIA ');
      pCnx.AUX.SQL.Add('           ,PRO.NOMBRE AS NOMBRE_PRODUCTO ');
      pCnx.AUX.SQL.Add('           ,BOD.NOMBRE AS NOMBRE_BODEGA ');
      pCnx.AUX.SQL.Add('           ,DET.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('           ,DET.LOTE ');
      pCnx.AUX.SQL.Add('           ,DET.FECHA_FABRICACION ');
      pCnx.AUX.SQL.Add('           ,DET.FECHA_VENCIMIENTO ');
      pCnx.AUX.SQL.Add('           ,DET.CANTIDAD ');
      pCnx.AUX.SQL.Add('       FROM ' + Retornar_Info_Tabla(Id_Movimiento_Det).Name + ' DET (NOLOCK) ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc).Name + ' ENC (NOLOCK)ON ENC.NUMERO_DOCUMENTO = DET.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Tercero).Name + ' TER (NOLOCK) ON TER.CODIGO_TERCERO = ENC.CODIGO_TERCERO ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' PRO (NOLOCK) ON PRO.CODIGO_PRODUCTO = DET.CODIGO_PRODUCTO AND  PRO.UNIDAD_MEDIDA = DET.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' BOD (NOLOCK) ON BOD.CODIGO_BODEGA = DET.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add('       WHERE ENC.CODIGO_TERCERO BETWEEN ' + QuotedStr(pTerceroIni) + ' AND ' + QuotedStr(pTerceroFin));
      pCnx.AUX.SQL.Add('       AND ENC.FECHA_MOVIMIENTO BETWEEN ' + QuotedStr(pFechaIni  ) + ' AND ' + QuotedStr(pFechaFin  ));
      pCnx.AUX.SQL.Add('     UNION ALL ');
      pCnx.AUX.SQL.Add('       SELECT ');
      pCnx.AUX.SQL.Add('            TER.NOMBRE AS NOMBRE_TERCERO ');
      pCnx.AUX.SQL.Add('           ,ENC.CODIGO_DOCUMENTO_ADM ');
      pCnx.AUX.SQL.Add('           ,ENC.FECHA_MOVIMIENTO ');
      pCnx.AUX.SQL.Add('           ,ENC.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add('           ,ENC.DOCUMENTO_REFERENCIA ');
      pCnx.AUX.SQL.Add('           ,PRO.NOMBRE AS NOMBRE_PRODUCTO ');
      pCnx.AUX.SQL.Add('           ,BOD.NOMBRE AS NOMBRE_BODEGA ');
      pCnx.AUX.SQL.Add('           ,DET.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('           ,DET.LOTE ');
      pCnx.AUX.SQL.Add('           ,DET.FECHA_FABRICACION ');
      pCnx.AUX.SQL.Add('           ,DET.FECHA_VENCIMIENTO ');
      pCnx.AUX.SQL.Add('           ,DET.CANTIDAD ');
      pCnx.AUX.SQL.Add('       FROM ' + Retornar_Info_Tabla(Id_Movimiento_Det_H).Name + ' DET (NOLOCK) ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Movimiento_Enc_H).Name + ' ENC (NOLOCK)ON ENC.NUMERO_DOCUMENTO = DET.NUMERO_DOCUMENTO ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Tercero).Name + ' TER (NOLOCK) ON TER.CODIGO_TERCERO = ENC.CODIGO_TERCERO ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Producto).Name + ' PRO (NOLOCK) ON PRO.CODIGO_PRODUCTO = DET.CODIGO_PRODUCTO AND  PRO.UNIDAD_MEDIDA = DET.UNIDAD_MEDIDA ');
      pCnx.AUX.SQL.Add('       INNER JOIN ' + Retornar_Info_Tabla(Id_Bodega).Name + ' BOD (NOLOCK) ON BOD.CODIGO_BODEGA = DET.CODIGO_BODEGA ');
      pCnx.AUX.SQL.Add('       WHERE ENC.CODIGO_TERCERO BETWEEN ' + QuotedStr(pTerceroIni) + ' AND ' + QuotedStr(pTerceroFin));
      pCnx.AUX.SQL.Add('       AND ENC.FECHA_MOVIMIENTO BETWEEN ' + QuotedStr(pFechaIni  ) + ' AND ' + QuotedStr(pFechaFin  ));
      pCnx.AUX.SQL.Add('   ) AS X ');
      pCnx.AUX.SQL.Add('   ORDER BY NOMBRE_TERCERO, FECHA_MOVIMIENTO ');
      If pMSExcel Then
      Begin
        Result := UtExporta_Excel_Execute(pApp, pCnx.AUX);
      End
      Else
      Begin
        pCnx.AUX.Active := True;
        If pCnx.AUX.Active And (pCnx.AUX.RecordCount > 0) Then
        Begin
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'INFORMACION DE TERCEROS');
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, 'FECHA DESDE ' + pFechaIni + ' HASTA ' + pFechaFin);
          pCnx.AUX.First;
          While Not pCnx.AUX.Eof Do
          Begin
            lSaldo := 0;
            lAux := pCnx.AUX.FieldByName('NOMBRE_TERCERO').AsString;
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('_', 200));
            lLinea := pCnx.AUX.FieldByName('NOMBRE_TERCERO').AsString;
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
            lLinea := UtReporte_Linea_Tercero_Detalle('MOVIMIENTO',
                                                      'NUMERO DOCUMENTO',
                                                      'FABRICACION',
                                                      'VENCIMIENTO',
                                                      'PRODUCTO');
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 5) + lLinea);
            lLinea := UtReporte_Linea_Tercero_Detalle('BODEGA',
                                                      'REFERENCIA DOCUMENTO',
                                                      'CANTIDAD',
                                                      'U/M',
                                                      'LOTE');
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 5) + lLinea);
            //lText := Trim(pCnx.AUX.FieldByName('LOTE').AsString) + ' - ' + Trim(pCnx.AUX.FieldByName('NOMBRE_BODEGA').AsString);
            While (Not pCnx.AUX.Eof) And (Trim(lAux) = Trim(pCnx.AUX.FieldByName('NOMBRE_TERCERO').AsString)) Do
            Begin
              lSigno := 0;
              If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'EN') Then
                lSigno := 1
              Else
                If (Copy(pCnx.AUX.FieldByName('CODIGO_DOCUMENTO_ADM').AsString, 01, 02) = 'SA') Then
                  lSigno := -1;
              If lSigno <> 0 Then
              Begin
                lLinea := UtReporte_Linea_Tercero_Detalle(pCnx.AUX.FieldByName('FECHA_MOVIMIENTO' ).AsString,
                                                          pCnx.AUX.FieldByName('NUMERO_DOCUMENTO' ).AsString,
                                                          pCnx.AUX.FieldByName('FECHA_FABRICACION').AsString,
                                                          pCnx.AUX.FieldByName('FECHA_VENCIMIENTO').AsString,
                                                          pCnx.AUX.FieldByName('NOMBRE_PRODUCTO'  ).AsString);
                UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 5) + lLinea);
                lLinea := UtReporte_Linea_Tercero_Detalle(pCnx.AUX.FieldByName('NOMBRE_BODEGA'       ).AsString,
                                                          pCnx.AUX.FieldByName('DOCUMENTO_REFERENCIA').AsString,
                                                          FormatFloat('###,##0.#0', pCnx.AUX.FieldByName('CANTIDAD').AsFloat),
                                                          pCnx.AUX.FieldByName('UNIDAD_MEDIDA'    ).AsString,
                                                          pCnx.AUX.FieldByName('LOTE'             ).AsString);
                UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar(' ', 5) + lLinea);
                UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, '');
                lSaldo := lSaldo + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
                lTotal := lTotal + (pCnx.AUX.FieldByName('CANTIDAD').AsFloat * lSigno);
                Result := True;
              End;
              pCnx.AUX.Next;
            End;
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('*', 200));
            lLinea := Copy('TOTAL ' +lAux + StringOfChar(' ', 109), 001, 109) +  Justificar(FormatFloat('###,###,##0.#0', lSaldo), ' ', 15);
            UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
          End;
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, StringOfChar('=', 200));
          lLinea := Copy('TOTAL GENERAL' + StringOfChar(' ', 109), 001, 109) +  Justificar(FormatFloat('###,###,##0.#0', lTotal), ' ', 15);
          UtReporte_Save(pCnx, lIndex, pCodigo_Usuario, lLinea);
        End;
      End;
      pCnx.AUX.Active := False;
      pCnx.AUX.SQL.Clear;
    Except
      On E: Exception Do
      Begin
        UtLog_Execute('UtReporte_Execute_Tercero, ' + E.Message);
      End;
    End;
  End;
End;

end.
