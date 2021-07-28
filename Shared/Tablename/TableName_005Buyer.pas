unit TableName_005Buyer;

interface
Uses
  UtConexion;


Function Create_Tablename_005Buyer(pCnx : TConexion; pSQl : TQuery) : Boolean;

implementation

Uses
  UtLog,
  UtError,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;

Function Create_Tablename_005Buyer(pCnx : TConexion; pSQl : TQuery) : Boolean;
Begin
  Result := True;
  If Not pCnx.TableExists(Retornar_Info_Tabla(Id_Buyer).Name) then
  Begin
    Try
      pSQl.SQL.Clear;
      pSQl.SQL.Add('   CREATE TABLE ' + Retornar_Info_Tabla(Id_Buyer).Name + ' '                    );
      pSQl.SQL.Add('   (   '                                                                         );
      pSQl.SQL.Add('      ID '            + pCnx.Return_Type(TYPE_VARCHAR ) + '(008)' + ' NOT NULL, ');
      pSQl.SQL.Add('      NAME '          + pCnx.Return_Type(TYPE_VARCHAR ) + '(100)' + ' NULL, '    );
      pSQl.SQL.Add('      AGE '           + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      TAG_INFO '      + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      PRIMARY KEY (ID) '                               + '  '         );
      pSQl.SQL.Add('   ) '                                                                           );
      pSQl.ExecSQL;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(MessageError(IE_ERROR_CREATE) + ' Tabla ' + Retornar_Info_Tabla(Id_Buyer).Name + ', Create_Tablename_005Buyer, ' + E.Message);
      End;
    End;
  End;
End;


end.
