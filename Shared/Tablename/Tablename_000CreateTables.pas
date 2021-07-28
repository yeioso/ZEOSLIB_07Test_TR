unit Tablename_000CreateTables;

interface
Uses
  UtConexion;

Function Tablename_000CreateTables_Execute(pCNX : TConexion) : Boolean;

implementation
Uses
  UtLog,
  UtInfoTablas,
  UtUpdateFields,
  System.SysUtils,
  ServerController,
  TableName_001Ayuda,
  TableName_002Perfil,
  TableName_003Permiso_App,
  TableName_004Usuario,
  TableName_005Buyer,
  TableName_006Product,
  TableName_007Transaction_M,
  TableName_008Transaction_D,
  TableName_009Usuario_Reporte;

Function Tablename_000CreateTables_Execute(pCNX : TConexion) : Boolean;
Var
  lSQL : TQuery;
Begin
  Result := True;
  Try
    lSQl := TQuery.Create(Nil);
    lSQl.Connection := pCNX;
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Ayuda).Caption + '...');
    Result := Result And Create_Tablename_001Ayuda         (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Perfil).Caption + '...');
    Result := Result And Create_Tablename_002Perfil        (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Permiso_App).Caption + '...');
    Result := Result And Create_Tablename_003Permiso_App   (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Usuario).Caption + '...');
    Result := Result And Create_Tablename_004Usuario       (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Buyer).Caption + '...');
    Result := Result And Create_Tablename_005Buyer         (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Product).Caption + '...');
    Result := Result And Create_Tablename_006Product       (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Transaction_M).Caption + '...');
    Result := Result And Create_Tablename_007Transaction_M (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Transaction_D).Caption + '...');
    Result := Result And Create_Tablename_008Transaction_D (pCNX, lSQL);
    UtLog_Execute('UtCreateTables_Execute, Verificando ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Caption + '...');
    Result := Result And Create_Tablename_009Usuario_Reporte(pCNX, lSQL);
    If Result Then
      UtUpdateFields_Execute(pCNX);
     FreeAndNil(lSQL);
  Except
    On E: Exception Do
      UtLog_Execute('UtCreateTables_Execute, ' + E.Message)
  End;
End;

end.
