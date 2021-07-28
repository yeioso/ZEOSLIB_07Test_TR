unit TableName_002Perfil;

interface
Uses
  UtConexion;


Function Create_Tablename_002Perfil(pCnx : TConexion; pSQl : TQuery) : Boolean;

implementation

Uses
  UtLog,
  UtError,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;

Function Create_Tablename_002Perfil(pCnx : TConexion; pSQl : TQuery) : Boolean;
Begin
  Result := True;
  If Not pCnx.TableExists(Retornar_Info_Tabla(Id_Perfil).Name) then
  Begin
    Try
      pSQl.SQL.Clear;
      pSQl.SQL.Add('   CREATE TABLE ' + Retornar_Info_Tabla(Id_Perfil).Name + ' '                    );
      pSQl.SQL.Add('   (   '                                                                         );
      pSQl.SQL.Add('      CODIGO_PERFIL ' + pCnx.Return_Type(TYPE_VARCHAR ) + '(004)' + ' NOT NULL, ');
      pSQl.SQL.Add('      NOMBRE '        + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      ID_ACTIVO '     + pCnx.Return_Type(TYPE_VARCHAR ) + '(001)' + ' NULL, '    );
      pSQl.SQL.Add('      TAG_INFO '      + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      PRIMARY KEY (CODIGO_PERFIL) '                               + '  '         );
      pSQl.SQL.Add('   ) '                                                                           );
      pSQl.ExecSQL;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(MessageError(IE_ERROR_CREATE) + ' Tabla ' + Retornar_Info_Tabla(Id_Perfil).Name + ', Create_Tablename_002Perfil, ' + E.Message);
      End;
    End;
  End;
End;


end.
