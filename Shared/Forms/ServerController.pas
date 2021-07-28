unit ServerController;

interface

uses
  SysUtils, Classes, IWServerControllerBase, IWBaseForm, HTTPApp,
  // For OnNewSession Event
  UserSessionUnit, IWApplication, IWAppForm, IW.Browser.Browser,
  IW.HTTP.Request, IW.HTTP.Reply, UtConexion, IWInfoCfg;

Type
  TIWServerController = class(TIWServerControllerBase)
    procedure IWServerControllerBaseNewSession(ASession: TIWApplication);
    procedure IWServerControllerBaseCreate(Sender: TObject);
    procedure IWServerControllerBaseDestroy(Sender: TObject);
    procedure IWServerControllerBaseConfig(Sender: TObject);

  private
    { Private declarations }
     FDB : TDB;
     FCNX : TConexion;
     FLoaded : Boolean;
     FPATH_LOG : String;
     FConnected : Boolean;
     FPATH_CACHE : String;
     FPATH_CONFIG : String;
  public
    { Public declarations }
    Property DB : TDB Read FDB;
    Property Loaded : Boolean Read FLoaded;
    Property PATH_LOG : String Read FPATH_LOG;
    Property Connected : Boolean Read FConnected;
    Property PATH_CACHE : String Read FPATH_CACHE;
    Property PATH_CONFIG : String Read FPATH_CONFIG;
    Function GetPassword_Items(Const pCodigo_Usuario : String; Var pNombre, pEmail, pPassword, pError : string) : Boolean;
    Function Session_Active(Const pAuthUse : String; Var pIP : String)  : Boolean;
  end;

  function UserSession: TIWUserSession;
  function IWServerController: TIWServerController;

implementation

{$R *.dfm}

Uses
  UtLog,
  IWInit,
  IWGlobal,
  UtFuncion,
  UtInfoTablas,
  Criptografia,
  IW.Common.AppInfo,
  Tablename_000CreateTables;

function IWServerController: TIWServerController;
begin
  Result := TIWServerController(GServerController);
end;

function UserSession: TIWUserSession;
begin
  Result := TIWUserSession(WebApplication.Data);
end;

{ TIWServerController }

procedure TIWServerController.IWServerControllerBaseConfig(Sender: TObject);
Var
  lPath : String;
begin
  Try
    lPath := IncludeTrailingPathDelimiter(TIWAppInfo.GetAppPath);
    Self.FPATH_CACHE := IncludeTrailingPathDelimiter(lPath + 'cache');
    ForceDirectories(Self.FPATH_CACHE);
    lPath := IncludeTrailingPathDelimiter(Self.FPATH_CACHE);
    lPath := IncludeTrailingPathDelimiter(lPath + FormatDateTime('YYYYMMDD', Now));
    lPath := IncludeTrailingPathDelimiter(lPath + FormatDateTime('HHNNSSZZ', Now));
    ForceDirectories(lPath);
    Self.CacheDir := lPath;
  Except
    On E: Exception Do
      UtLog_Execute('TIWServerController.Prepare_Container, ' + E.Message);
  End;
end;

procedure TIWServerController.IWServerControllerBaseCreate(Sender: TObject);
Var
  lPath : String;
begin
  FLoaded := False;
  FConnected := False;
  Try
    lPath := IncludeTrailingPathDelimiter(TIWAppInfo.GetAppPath);
//  lPath := IncludeTrailingBackslash(ExtractFilePath(GetModuleName(HInstance)));
    UtLog_Execute('TIWServerController.IWServerControllerBaseConfig, Cargando ruta de trabajo: ' + lPath);

    Self.FPATH_LOG    := IncludeTrailingPathDelimiter(lPath + 'log');
    ForceDirectories(Self.FPATH_LOG);

    Self.FPATH_CONFIG := IncludeTrailingPathDelimiter(lPath + 'config');
    ForceDirectories(Self.FPATH_CONFIG);

    Self.ExceptionLogger.Enabled := True;
    Self.ExceptionLogger.FilePath := Self.FPATH_LOG;
    Self.ExceptionLogger.FileName := ChangeFileExt(ExtractFileName(TIWAppInfo.GetAppFullFileName), '.log');
    UtLog_Execute('TIWServerController.IWServerControllerBaseConfig, Cargando ruta de configuración: ' + lPath);
    FCNX := TConexion.Create(Nil);
    If IWInfoCfg_Load(FDB, FPATH_CONFIG) Then
    Begin
      SetCurrentDir(FPATH_CONFIG);
      FLoaded := True;
      FCNX.SetConnection  (Conn_SQLSERVER  );
      FCNX.SetServer      (FDB.ServerName  );
      FCNX.SetDatabase    (FDB.DatabaseName);
      FCNX.SetUser        (FDB.UserName    );
      FCNX.SetPassword    (FDB.Password    );
      FCNX.SetDLL_DATABASE(FDB.DLL_DATABASE);
      Self.FCONNECTED := FCNX.Connect(True);
      If Self.FCONNECTED Then
      Begin
        Tablename_000CreateTables_Execute(FCNX);
      End;
    End
    Else
    Begin
      UtLog_Execute('No hay archivo de configuración, ' + FPATH_CONFIG);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TIWServerController.Prepare_Container, ' + E.Message);
  End;
end;

Function TIWServerController.GetPassword_Items(Const pCodigo_Usuario : String; Var pNombre, pEmail, pPassword, pError : string) : Boolean;
Var
  lHash : String;
  lPassword : String;
Begin
  Result := False;
  pError := '';
  Try
    FCNX.AUX.Active := False;
    FCNX.AUX.SQL.Clear;
    FCNX.AUX.SQL.Add(' SELECT * FROM ' + Retornar_Info_Tabla(Id_Usuario).Name + ' ');
    FCNX.AUX.SQL.Add(' WHERE ' + FCNX.Trim_Sentence('CODIGO_USUARIO') + ' = ' + QuotedStr(Trim(pCodigo_Usuario)));
    FCNX.AUX.SQL.Add(' and ID_SISTEMA = ' + QuotedStr(Trim('S')));
    FCNX.AUX.Active := True;
    If FCNX.AUX.Active And (FCNX.AUX.RecordCount > 0) Then
    Begin
      If Not Vacio(FCNX.AUX.FieldByName('EMAIL').AsString) Then
      Begin
        If Not Vacio(FCNX.AUX.FieldByName('CONTRASENA').AsString) Then
        Begin
          lPassword := RetornarDecodificado(Const_KEY, FCNX.AUX.FieldByName('CONTRASENA').AsString, lHash);
          pEmail := Trim(FCNX.AUX.FieldByName('EMAIL').AsString);
          pNombre := Trim(FCNX.AUX.FieldByName('NOMBRE').AsString);
          If Not Vacio(lPassword) Then
          Begin
            pPassword := Trim(lPassword);
            Result := True;
          End
          Else
            pError := 'No es posible definir la contraseña almacenada';
        End
        Else
          pError := 'No tiene una contraseña asociada, por favor comuniquese con el personal de soporte';
      End
      Else
        pError := 'El identificador no tiene asociado un correo electronico, por favor comuniquese con el personal de soporte';
    End
    Else
      pError := 'No hay usuario asociado a ese identificador o se encuentra inactivo';
    FCNX.AUX.Active := False;
    FCNX.AUX.SQL.Clear;
  Except
    On E : Exception Do
      UtLog_Execute('TIWServerController.GetPassword_Items, ' + E.Message);
  End;
End;

Function TIWServerController.Session_Active(Const pAuthUse : String; Var pIP : String)  : Boolean;
var
  i: Integer;
  lExiste : Boolean;
  LSessionList: TStringList;
begin
  Result := False;
  lExiste := False;
  // First, create a session list to hold the session IDs
  LSessionList := TStringList.Create;
  try
    gSessions.GetList(LSessionList);
    for i := 0 to LSessionList.Count - 1 do
    begin
      gSessions.Execute(LSessionList[i],procedure(aSession: TObject)
                        var
                          LSession : TIWApplication absolute aSession;
                        begin
                          If Not lExiste Then
                            lExiste := AnsiUpperCase(Trim(LSession.AuthUser)) = AnsiUpperCase(Trim(pAuthUse));
                        end
                       );

    end;
     Result := lExiste;
  finally
    LSessionList.Free;
  end;
End;

procedure TIWServerController.IWServerControllerBaseDestroy(Sender: TObject);
begin
  If Assigned(FCNX) Then
  Begin
//    If FCNX.Connected Then
//      FCNX.Connect(False);
//    FreeAndNil(FCNX);
  End;
end;

procedure TIWServerController.IWServerControllerBaseNewSession(
  ASession: TIWApplication);
begin
  ASession.Data := TIWUserSession.Create(nil, ASession);
end;

initialization
  TIWServerController.SetServerControllerClass;

end.

