unit UserSessionUnit;

{
  This is a DataModule where you can add components or declare fields that are specific to
  ONE user. Instead of creating global variables, it is better to use this datamodule. You can then
  access the it using UserSession.
}
interface

Uses
  IWColor,
  Classes,
  SysUtils,
  StrUtils,
  IWInfoCfg,
  UtConexion,
  Form_IWMenu,
  Vcl.Graphics,
  Form_IWBuyer,
  Form_IWLogin,
  Form_IWAyuda,
  Form_IWPerfil,
  Form_IWProduct,
  Form_IWUsuario,
  IWUserSessionBase,
  Generics.Collections,
  Form_IWManager_Report,
  Form_IWPerfil_Permiso;

Type
  TPERMISOS_APP = Array Of String;

  TData_Msg = Class
    Mensaje : String;
    Error   : Boolean;
  End;
  TList_Msg = TList<TData_Msg>;

  TIWUserSession = class(TIWUserSessionBase)
    procedure IWUserSessionBaseCreate(Sender: TObject);
    procedure IWUserSessionBaseDestroy(Sender: TObject);
  private
    { Private declarations }
    FDB : TDB       ;
    FCNX : TConexion;
    FMenu : TFrIWMenu;
    FBuyer : TFrIWBuyer;
    FAyuda : TFrIWAyuda;
    FLogin : TFrIWLogin;
    FPerfil : TFrIWPerfil;
    FProduct : TFrIWProduct;
    FUsuario : TFrIWUsuario;
    FLISTA_MENSAJE : TList_Msg;
    FManager_Report : TFrIWManager_Report;
    FPerfil_Permiso : TFrIWPerfil_Permiso;
    FFULL_INFO : String;
    FESTACION : String;
    FPATH_LOG : String;
    FConnected : Boolean;
    FPATH_CACHE : String;
    FPATH_CONFIG : String;
    FPERMISOS_APP : TPERMISOS_APP;
    FCODIGO_PERFIL : String;
    FCODIGO_USUARIO : String;
    FNOMBRE_USUARIO : String;
    FDELIMITADOR_COMA : Boolean;
    FUSUARIO_ADMINISTRADOR : Boolean;
    Procedure Mostrar_Mensajes(pCaption : String; pError : Boolean = False);
  public
    { Public declarations }
    Const COLOR_OK = cl3DLight;
    Const COLOR_ERROR = IWColor.clWebAQUA;
    Const Const_Max_Record = 100;

    Property DB : TDB Read FDB;
    Property CNX : TConexion Read FCNX Write FCNX;
    Property ESTACION : String Read FESTACION;
    Property Connected : Boolean Read FConnected;
    Property FULL_INFO : String Read FFULL_INFO Write FFULL_INFO;
    Property PERMISOS_APP : TPERMISOS_APP Read FPERMISOS_APP;
    Property CODIGO_PERFIL : String Read FCODIGO_PERFIL;
    Property CODIGO_USUARIO : String Read FCODIGO_USUARIO;
    Property NOMBRE_USUARIO : String Read FNOMBRE_USUARIO;
    Property DELIMITADOR_COMA : Boolean Read FDELIMITADOR_COMA;
    Property USUARIO_ADMINISTRADOR : Boolean Read FUSUARIO_ADMINISTRADOR;
    Procedure Refrescar;
    Procedure Refrescar2;
    Function Create_Manager_Data(Const pName, pCaption : String) : TMANAGER_DATA;
    Procedure ShowForm_Ayuda(Const pConsulta : Boolean; Const pFiltro : String);
    Procedure ShowForm_Menu;
    Procedure ShowForm_Login;
    Procedure ShowForm_Perfil(Const pCodigo_Perfil : String = '');
    Procedure ShowForm_Perfil_Permiso(Const pCodigo_Perfil : String);
    Procedure ShowForm_Usuario(Const pCodigo_Usuario : String = '');
    Procedure ShowForm_Buyer;
    Procedure ShowForm_Product;
    Procedure ShowForm_Manager_Report;
    Procedure SetInfoUsuario(Const pCode, pName : String);
    Procedure SetEstacion(Const pValue : String);
    Procedure SetCODIGO_PERFIL(Const pValue : String);
    Procedure Validar_Perfil(pCodigo_Perfil : String);
    Procedure Generar_Log_Bloque(pAction: String; pQR: TQUERY);
    Procedure SetAmbiente;
    Procedure SetMessage(Const pValue : String; Const pError : Boolean);
  end;

implementation
{$R *.dfm}
Uses
  UtLog,
  IWTypes,
  Data.DB,
  UtFuncion,
  UtInfoTablas,
  ServerController;

Function TIWUserSession.Create_Manager_Data(Const pName, pCaption : String) : TMANAGER_DATA;
Begin
  Try
    Result := TMANAGER_DATA.Create(pName, pCaption);
    Result.QR.Connection := Self.FCNX;
    Result.USER_NAME := CODIGO_USUARIO;
    Result.ESTACION := FESTACION;
  Except
    On E: Exception Do
      UtLog_Execute('TIWUserSession.Create_Manager_Data, ' + E.Message);
  End;
End;

Procedure TIWUserSession.Refrescar;
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecute('location.reload(true);');
end;

Procedure TIWUserSession.Refrescar2;
begin
  WebApplication.CallBackResponse.AddJavaScriptToExecuteAsCDATA('location.reload(true);');
end;


procedure TIWUserSession.IWUserSessionBaseCreate(Sender: TObject);
Var
  lI : Integer;
  lJ : Integer;
begin
  FLISTA_MENSAJE := TList_Msg.Create;;
  TFrIWLogin.SetAsMainForm;
  SetLength(FPERMISOS_APP, 2);
  FPERMISOS_APP[0] := 'USUARIO_ADMINISTRADOR';
  FPERMISOS_APP[1] := 'DELIMITADOR_COMA'     ;
  lJ := 1;
  For lI := Id_MainIni To Id_MainFin Do
    If Retornar_Info_Tabla(lI).Menu Then
    Begin
      Inc(lJ);
      SetLength(FPERMISOS_APP, lJ);
      FPERMISOS_APP[lJ - 1] := Retornar_Info_Tabla(lI).Caption;
    End;
  FillChar(FDB, SizeOf(FDB), #0);
  Try
    FDB := IWServerController.DB;
    FCNX := TConexion.Create(Nil);
    If (Not IWServerController.Connected) Or (Not IWServerController.Loaded) Then
    Begin
      WebApplication.Terminate('No hay configuración establecida');
      Exit;
    End;
    Self.FPATH_LOG := IWServerController.PATH_LOG;
    Self.FPATH_CACHE := IWServerController.PATH_CACHE;
    Self.FPATH_CONFIG := IWServerController.PATH_CONFIG;
    FCNX.SetConnection  (Conn_SQLSERVER  );
    FCNX.SetServer      (FDB.ServerName  );
    FCNX.SetDatabase    (FDB.DatabaseName);
    FCNX.SetUser        (FDB.UserName    );
    FCNX.SetPassword    (FDB.Password    );
    FCNX.SetDLL_DATABASE(FDB.DLL_DATABASE);
    Self.FCONNECTED := FCNX.Connect(True);
  Except
    On E: Exception Do
      UtLog_Execute('TIWUserSession.IWUserSessionBaseCreate, ' + E.Message);
  End;
end;

Procedure TIWUserSession.Generar_Log_Bloque(pAction: String; pQR: TQUERY);
Const
  LINE_START = '<-----!';
  LINE_FINISH = '!----->';
Var
  lI: Integer;
  lLog : String;
  lTexto : String;
Begin
  lTexto := '';
  For lI := 0 To pQR.Fields.Count - 1 Do
    If pQR.Fields[lI].DataType In  [ftSmallint, ftString, ftWideString, ftMemo, ftWideMemo, ftFloat, ftInteger, ftCurrency] Then
      If Not Vacio(pQR.Fields[lI].AsString) Then
        lTexto := lTexto + IfThen(Not Vacio(lTexto), #13 + StringOfChar(' ', 22)) + Trim(pQR.Fields[lI].FullName) + ' = ' + Trim(pQR.Fields[lI].AsString) ;
  lLog := LINE_START + #13 +
          StringOfChar(' ', 20) + pAction                  + #13 +
          StringOfChar(' ', 20) + 'USUARIO: ' + FNOMBRE_USUARIO + #13 +
          StringOfChar(' ', 20) + 'ESTACION: ' + FESTACION + #13 +
          StringOfChar(' ', 22) + lTexto                   + #13 +
          StringOfChar(' ', 20) + LINE_FINISH;
  UtLog_Execute(lLog);
End;

Procedure TIWUserSession.ShowForm_Ayuda(Const pConsulta : Boolean; Const pFiltro : String);
Begin
  FAyuda := TFrIWAyuda.Create(WebApplication);
  FAyuda.CONSULTA := pConsulta;
  FAyuda.FILTRO := pFiltro;
  FAyuda.AbrirMaestro;
  FAyuda.Show;
End;

Procedure TIWUserSession.ShowForm_Menu;
Begin
  FMenu := TFrIWMenu.Create(WebApplication);
  FMenu.SetAsMainForm;
  FMenu.Show;
End;

Procedure TIWUserSession.ShowForm_Login;
Begin
  FLogin := TFrIWLogin.Create(WebApplication);
  FLogin.SetAsMainForm;
  FLogin.Show;
End;

Procedure TIWUserSession.ShowForm_Perfil(Const pCodigo_Perfil : String = '');
Begin
  FPerfil := TFrIWPerfil.Create(WebApplication, pCodigo_Perfil);
  FPerfil.Show;
End;

Procedure TIWUserSession.ShowForm_Perfil_Permiso(Const pCodigo_Perfil : String);
Begin
  FPerfil_Permiso := TFrIWPerfil_Permiso.Create(WebApplication, pCodigo_Perfil);
  FPerfil_Permiso.Show;
End;


Procedure TIWUserSession.ShowForm_Usuario(Const pCodigo_Usuario : String = '');
Begin
  FUsuario := TFrIWUsuario.Create(WebApplication, pCodigo_Usuario);
  FUsuario.Show;
End;

Procedure TIWUserSession.ShowForm_Buyer;
Begin
  FBuyer := TFrIWBuyer.Create(WebApplication);
  FBuyer.Show;
End;

Procedure TIWUserSession.ShowForm_Product;
Begin
  FProduct := TFrIWProduct.Create(WebApplication);
  FProduct.Show;
End;

Procedure TIWUserSession.ShowForm_Manager_Report;
Begin
  FManager_Report := TFrIWManager_Report.Create(WebApplication);
  FManager_Report.Show;
End;

Procedure TIWUserSession.SetInfoUsuario(Const pCode, pName : String);
Begin
  FCODIGO_USUARIO := pCode;
  FNOMBRE_USUARIO := pName;
End;

Procedure TIWUserSession.SetEstacion(Const pValue : String);
Begin
  FESTACION := pValue;
End;

Procedure TIWUserSession.SetCODIGO_PERFIL(Const pValue : String);
Begin
  FCODIGO_PERFIL := pValue;
End;

Procedure TIWUserSession.Validar_Perfil(pCodigo_Perfil : String);
Begin
  FUSUARIO_ADMINISTRADOR := FCNX.GetValue(Retornar_Info_Tabla(Id_Permiso_App).Name, ['CODIGO_PERFIL', 'NOMBRE'], [pCodigo_Perfil, 'USUARIO_ADMINISTRADOR'], ['HABILITA_OPCION']) = 'S';
  FDELIMITADOR_COMA      := FCNX.GetValue(Retornar_Info_Tabla(Id_Permiso_App).Name, ['CODIGO_PERFIL', 'NOMBRE'], [pCodigo_Perfil, 'DELIMITADOR_COMA'     ], ['HABILITA_OPCION']) = 'S';
End;

Procedure TIWUserSession.SetAmbiente;
Begin

End;

procedure TIWUserSession.IWUserSessionBaseDestroy(Sender: TObject);
begin
  If Assigned(FCNX) Then
  Begin
    If FCNX.Connected Then
      FCNX.Connect(False);
    FreeAndNil(FCNX);
  End;
  If Assigned(FLISTA_MENSAJE) Then
  Begin
    FLISTA_MENSAJE.Clear;
    FreeAndNil(FLISTA_MENSAJE);
  End;
end;

Procedure TIWUserSession.Mostrar_Mensajes(pCaption : String; pError : Boolean = False);
Begin
  If pError Then
    WebApplication.ShowNotification(pCaption, ntError)
  Else
    WebApplication.ShowNotification(pCaption, ntSuccess);
End;


Procedure TIWUserSession.SetMessage(Const pValue : String; Const pError : Boolean);
Var
  lItem : TData_Msg;
Begin
  Try
    If Not Vacio(pValue) Then
       Self.Mostrar_Mensajes(pValue, pError);
    lItem := TData_Msg.Create;
    lItem.Mensaje := pValue;
    lItem.Error   := pError;
    FLISTA_MENSAJE.Add(lItem);
    While FLISTA_MENSAJE.Count > 0 Do
      FLISTA_MENSAJE.Delete(0);
  Except
    On E: Exception Do
      UtLog_Execute('TIWUserSession.SetMessage, ' +E.Message);
  End;
End;

end.