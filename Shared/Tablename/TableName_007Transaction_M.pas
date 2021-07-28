unit TableName_007Transaction_M;

interface
Uses
  UtConexion;


Function Create_Tablename_007Transaction_M(pCnx : TConexion; pSQl : TQuery) : Boolean;

implementation

Uses
  UtLog,
  UtError,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;

Function Create_Tablename_007Transaction_M(pCnx : TConexion; pSQl : TQuery) : Boolean;
Begin
  Result := True;
  If Not pCnx.TableExists(Retornar_Info_Tabla(Id_Transaction_M).Name) then
  Begin
    Try
      pSQl.SQL.Clear;
      pSQl.SQL.Add('   CREATE TABLE ' + Retornar_Info_Tabla(Id_Transaction_M).Name + ' '          );
      pSQl.SQL.Add('   (   '                                                                      );
      pSQl.SQL.Add('      ID '         + pCnx.Return_Type(TYPE_VARCHAR ) + '(012)' + ' NOT NULL, ');
      pSQl.SQL.Add('      BUYER_ID '   + pCnx.Return_Type(TYPE_VARCHAR ) + '(008)' + ' NULL, '    );
      pSQl.SQL.Add('      IP '         + pCnx.Return_Type(TYPE_VARCHAR ) + '(015)' + ' NULL, '    );
      pSQl.SQL.Add('      DEVICE '     + pCnx.Return_Type(TYPE_VARCHAR ) + '(010)' + ' NULL, '    );
      pSQl.SQL.Add('      TAG_INFO '   + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      PRIMARY KEY (ID), '                            + '  '                   );
      pSQl.SQL.Add('  ' + pCnx.FOREINGKEY(Retornar_Info_Tabla(Id_Transaction_M).Fk[1],'BUYER_ID'  , Retornar_Info_Tabla(Id_Buyer  ).Name, 'ID') + '  ');
      pSQl.SQL.Add('   ) '                                                                        );
      pSQl.ExecSQL;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(MessageError(IE_ERROR_CREATE) + ' Tabla ' + Retornar_Info_Tabla(Id_Transaction_M).Name + ', Create_Tablename_007Transaction_M, ' + E.Message);
      End;
    End;
  End;
End;


end.
