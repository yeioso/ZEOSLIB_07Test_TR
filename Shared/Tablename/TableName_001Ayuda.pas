unit TableName_001Ayuda;

interface
Uses
  UtConexion;


Function Create_Tablename_001Ayuda(pCnx : TConexion; pSQl : TQuery) : Boolean;

implementation

Uses
  UtLog,
  UtError,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;

Function Create_Tablename_001Ayuda(pCnx : TConexion; pSQl : TQuery) : Boolean;
Begin
  Result := True;
  If Not pCnx.TableExists(Retornar_Info_Tabla(Id_Ayuda).Name) then
  Begin
    Try
      pSQl.SQL.Clear;
      pSQl.SQL.Add('   CREATE TABLE ' + Retornar_Info_Tabla(Id_Ayuda).Name + ' '                     );
      pSQl.SQL.Add('   (   '                                                                         );
      pSQl.SQL.Add('      CODIGO_AYUDA '  + pCnx.Return_Type(TYPE_VARCHAR ) + '(020)' + ' NOT NULL, ');
      pSQl.SQL.Add('      NOMBRE '        + pCnx.Return_Type(TYPE_VARCHAR ) + '(255)' + ' NULL, '    );
      pSQl.SQL.Add('      MODULO '        + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      DESCRIPCION '   + pCnx.Return_Type(TYPE_TEXT    ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      ACTUALIZACION ' + pCnx.Return_Type(TYPE_TEXT    ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      IMAGEN '        + pCnx.Return_Type(TYPE_IMAGE   ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      TAG_INFO '      + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      PRIMARY KEY (CODIGO_AYUDA) '                                + '  '         );
      pSQl.SQL.Add('   ) '                                                                           );
      pSQl.ExecSQL;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(MessageError(IE_ERROR_CREATE) + ' Tabla ' + Retornar_Info_Tabla(Id_Ayuda).Name + ', Create_Tablename_001Ayuda, ' + E.Message);
      End;
    End;
  End;
End;


end.
