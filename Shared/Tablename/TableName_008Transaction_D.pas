unit TableName_008Transaction_D;

interface
Uses
  UtConexion;


Function Create_Tablename_008Transaction_D(pCnx : TConexion; pSQl : TQuery) : Boolean;

implementation

Uses
  UtLog,
  UtError,
  SysUtils,
  UtFuncion,
  UtInfoTablas,
  ServerController;

Function Create_Tablename_008Transaction_D(pCnx : TConexion; pSQl : TQuery) : Boolean;
Begin
  Result := True;
  If Not pCnx.TableExists(Retornar_Info_Tabla(Id_Transaction_D).Name) then
  Begin
    Try
      pSQl.SQL.Clear;
      pSQl.SQL.Add('   CREATE TABLE ' + Retornar_Info_Tabla(Id_Transaction_D).Name + ' '          );
      pSQl.SQL.Add('   (   '                                                                      );
      pSQl.SQL.Add('      ID '         + pCnx.Return_Type(TYPE_VARCHAR ) + '(012)' + ' NOT NULL, ');
      pSQl.SQL.Add('      PRODUCT_ID ' + pCnx.Return_Type(TYPE_VARCHAR ) + '(008)' + ' NOT NULL, ');
      pSQl.SQL.Add('      TAG_INFO '   + pCnx.Return_Type(TYPE_INT     ) + ' '     + ' NULL, '    );
      pSQl.SQL.Add('      PRIMARY KEY (ID, PRODUCT_ID), '                + '  '                   );
      pSQl.SQL.Add('  ' + pCnx.FOREINGKEY(Retornar_Info_Tabla(Id_Transaction_D).Fk[1],'ID'        , Retornar_Info_Tabla(Id_Transaction_M).Name, 'ID') + ', ');
      pSQl.SQL.Add('  ' + pCnx.FOREINGKEY(Retornar_Info_Tabla(Id_Transaction_D).Fk[1],'PRODUCT_ID', Retornar_Info_Tabla(Id_Product      ).Name, 'ID') + '  ');
      pSQl.SQL.Add('   ) '                                                                        );
      pSQl.ExecSQL;
    Except
      On E : Exception Do
      Begin
        Result := False;
        UtLog_Execute(MessageError(IE_ERROR_CREATE) + ' Tabla ' + Retornar_Info_Tabla(Id_Transaction_D).Name + ', Create_Tablename_008Transaction_D, ' + E.Message);
      End;
    End;
  End;
End;


end.
