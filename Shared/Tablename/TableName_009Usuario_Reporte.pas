unit TableName_009Usuario_Reporte;

interface
Uses
  UtConexion;


Function Create_Tablename_009Usuario_Reporte(pCnx : TConexion; pSQl : TQuery) : Boolean;

implementation

Uses
  UtLog,
  UtError,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;

Function Create_Tablename_009Usuario_Reporte(pCnx : TConexion; pSQl : TQuery) : Boolean;
Begin
  Result := True;
  If Not pCnx.TableExists(Retornar_Info_Tabla(Id_Usuario_Reporte).Name) then
  Begin
    Try
      pSQl.SQL.Clear;
      pSQl.SQL.Add('   CREATE TABLE ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ' '             );
      pSQl.SQL.Add('   (   '                                                                           );
      pSQl.SQL.Add('      CODIGO_USUARIO  ' + pCnx.Return_Type(TYPE_VARCHAR ) + '(020)' + ' NOT NULL, ');
      pSQl.SQL.Add('      LINEA '           + pCnx.Return_Type(TYPE_VARCHAR ) + '(005)' + ' NOT NULL, ');
      pSQl.SQL.Add('      CONTENIDO '       + pCnx.Return_Type(TYPE_VARCHAR ) + '(255)' + ' NULL, '    );
      pSQl.SQL.Add('      ID_ACTIVO '       + pCnx.Return_Type(TYPE_VARCHAR ) + '(001)' + ' NULL, '    );
      pSQl.SQL.Add('      TAG_INFO '        + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      PRIMARY KEY (CODIGO_USUARIO, LINEA), '                        + '  '         );
      pSQl.SQL.Add('  ' + pCnx.FOREINGKEY(Retornar_Info_Tabla(Id_Usuario_Reporte).Fk[1],'CODIGO_USUARIO', Retornar_Info_Tabla(Id_Usuario).Name, 'CODIGO_USUARIO') + '  ');
      pSQl.SQL.Add('   ) '                                                                             );
      pSQl.ExecSQL;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(MessageError(IE_ERROR_CREATE) + ' Tabla ' + Retornar_Info_Tabla(Id_Usuario_Reporte).Name + ', Create_Tablename_009Usuario_Reporte, ' + E.Message);
      End;
    End;
  End;
End;


end.
