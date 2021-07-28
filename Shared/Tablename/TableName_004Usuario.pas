unit TableName_004Usuario;

interface
Uses
  UtConexion;


Function Create_Tablename_004Usuario(pCnx : TConexion; pSQl : TQuery) : Boolean;

implementation

Uses
  UtLog,
  UtError,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;



Function Create_Tablename_004Usuario(pCnx : TConexion; pSQl : TQuery) : Boolean;
Begin
  Result := True;
  If Not pCnx.TableExists(Retornar_Info_Tabla(Id_Usuario).Name) then
  Begin
    Try
      pSQl.SQL.Clear;
      pSQl.SQL.Add('   CREATE TABLE ' + Retornar_Info_Tabla(Id_Usuario).Name + ' '                    );
      pSQl.SQL.Add('   (   '                                                                          );
      pSQl.SQL.Add('      CODIGO_USUARIO ' + pCnx.Return_Type(TYPE_VARCHAR ) + '(020)' + ' NOT NULL, ');
      pSQl.SQL.Add('      NOMBRE '         + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      CONTRASENA '     + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      EMAIL '          + pCnx.Return_Type(TYPE_VARCHAR ) + '(255)' + ' NULL, '    );
      pSQl.SQL.Add('      DIRECCION '      + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      TELEFONO_1 '     + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      TELEFONO_2 '     + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      CODIGO_PERFIL '  + pCnx.Return_Type(TYPE_VARCHAR ) + '(004)' + ' NULL, '    );
      pSQl.SQL.Add('      ID_SISTEMA '     + pCnx.Return_Type(TYPE_VARCHAR ) + '(001)' + ' NULL, '    );
      pSQl.SQL.Add('      GRAFICO '        + pCnx.Return_Type(TYPE_IMAGE   ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      TAG_INFO '       + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      PRIMARY KEY (CODIGO_USUARIO), '                                             );
      pSQl.SQL.Add('  '+ pCnx.FOREINGKEY(Retornar_Info_Tabla(Id_Usuario).Fk[1], 'CODIGO_PERFIL', Retornar_Info_Tabla(Id_Perfil).Name, 'CODIGO_PERFIL') + '  ');
      pSQl.SQL.Add('   ) '                                                                            );
      pSQl.ExecSQL;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(MessageError(IE_ERROR_CREATE) + ' Tabla ' + Retornar_Info_Tabla(Id_Usuario).Name + ', Create_Tablename_004Usuario, ' + E.Message);
      End;
    End;
  End;
End;


end.
