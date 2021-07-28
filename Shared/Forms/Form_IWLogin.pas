unit Form_IWLogin;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes,
  Vcl.Imaging.pngimage, IWCompExtCtrls, IWCompButton, IWCompEdit,
  IWVCLBaseControl, IWBaseControl, IWBaseHTMLControl, IWControl, IWCompLabel,
  Vcl.Controls, Vcl.Forms, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, IWCompListbox, IWCompMemo, IWHTMLControls;

type
  TFrIWLogin = class(TIWAppForm)
    IWLOGIN: TIWRegion;
    IWLabel1: TIWLabel;
    IWLabel2: TIWLabel;
    USUARIO: TIWEdit;
    PASSWORD: TIWEdit;
    BtnOK: TIWButton;
    IWLabel3: TIWLabel;
    CAPTCHA: TIWEdit;
    IWRegion1: TIWRegion;
    IWImageCaptcha: TIWImage;
    IWRegion2: TIWRegion;
    IWImage3: TIWImage;
    IWLabel4: TIWLabel;
    BTNRECUPERAR: TIWButton;
    BtnCancel: TIWButton;
    BTNAYUDA: TIWImage;
    IWURL1: TIWURL;
    IWLabel43: TIWLabel;
    procedure IWImage3AsyncClick(Sender: TObject; EventParams: TStringList);
    procedure IWAppFormCreate(Sender: TObject);
    procedure BtnOKAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BtnCancelAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNRECUPERARAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNAYUDAAsyncClick(Sender: TObject; EventParams: TStringList);
  private
    FCaptcha : String;
    Function Usuario_Valido : Boolean;
    Procedure Refrescar;
    Function Authentication_Validated : Boolean;
    Function Enviar_Notificacion : Boolean;
    Procedure Recuperar_Password(EventParams: TStringList);
  public
  end;

implementation
{$R *.dfm}
Uses
  UtLog,
  IWInfoCfg,
  UtCaptcha,
  UtFuncion,
  UtConexion,
  UtInfoTablas,
  Criptografia,
  UtManager_Mail,
  ServerController,
  IW.Common.AppInfo;

Function TFrIWLogin.Enviar_Notificacion : Boolean;
Var
  lBody : String;
Begin
  lBody := 'Usuario: '     + UserSession.NOMBRE_USUARIO + #13 +
           'I.P.: '        + UserSession.WebApplication.IP + #13 +
           'AppID: '       + UserSession.WebApplication.AppID + #13 +
           'UserAgent: '   + UserSession.WebApplication.Browser.UserAgent + #13 +
           'BrowserName: ' + UserSession.WebApplication.Browser.BrowserName;
  Result := False;
  UtManager_Mail_Send(IWServerController.DB.SMTP_USER, 'TRANSFERENCIA - NOTIFICACION DE INGRESO AL SISTEMA', lBody);
End;

Procedure TFrIWLogin.Recuperar_Password(EventParams: TStringList);
var
  lE : Integer;
  lV : Double;
  lEmail : String;
  lError : String;
  lNombre : String;
  lResult : Boolean;
  Response : Boolean;
  lPassword : String;
  InputValue : string;
begin
  // Prompt callback has 2 main parameters:
  // RetValue (Boolean), indicates if the first button (Yes/OK/custom) was choosen
  // InputStr, contains the string entered in the input box
  Response := SameText(EventParams.Values['RetValue'], 'True');
  InputValue := EventParams.Values['InputStr'];
  If Response Then
  Begin
    If IWServerController.GetPassword_Items(InputValue, lNombre, lEmail, lPassword, lError) Then
    Begin
      If UtManager_Mail_Send(lEmail, 'AUTENTICACION DE USUARIO', Trim(lNombre) + ', su autenticacion es ' + lPassword) Then
        WebApplication.ShowNotification('Recuperación realizada', TIWNotifyType.ntSuccess)
      Else
        WebApplication.ShowNotification('Hay problema para recuperar la contraseña', TIWNotifyType.ntError)
    End
    Else
      UserSession.SetMessage(lError, True);
  End
  Else
  Begin
    WebApplication.ShowNotification('Recuperación no realizada', TIWNotifyType.ntError);
  End;
End;

Function TFrIWLogin.Usuario_Valido : Boolean;
Var
  lHash : String;
  lPassword : String;
Begin
  Result := False;
  Try
    Try
      UserSession.CNX.AUX.Active := False;
      UserSession.CNX.AUX.SQL.Clear;
      UserSession.CNX.AUX.SQL.Add(' SELECT * FROM ' + Retornar_Info_Tabla(Id_Usuario).Name + ' ');
      UserSession.CNX.AUX.SQL.Add(' WHERE ID_SISTEMA = ' + QuotedStr('S'));
      UserSession.CNX.AUX.SQL.Add(' AND ' );
      UserSession.CNX.AUX.SQL.Add(' ( ' );
      UserSession.CNX.AUX.SQL.Add(' '   + UserSession.CNX.Trim_Sentence('CODIGO_USUARIO') + ' = ' + QuotedStr(Trim(USUARIO.Text)));
      UserSession.CNX.AUX.SQL.Add('   OR ');
      UserSession.CNX.AUX.SQL.Add('   ' + UserSession.CNX.Trim_Sentence('EMAIL'         ) + ' = ' + QuotedStr(Trim(USUARIO.Text)));
      UserSession.CNX.AUX.SQL.Add(' ) ' );
      UserSession.CNX.AUX.Active := True;
      If UserSession.CNX.AUX.Active And (UserSession.CNX.AUX.RecordCount > 0) Then
      Begin
        lPassword := RetornarDecodificado(Const_KEY, UserSession.CNX.AUX.FieldByName('CONTRASENA').AsString, lHash);
        Result := Trim(AnsiUpperCase(lPassword)) = Trim(AnsiUpperCase(PASSWORD.Text));
        If Not Result Then
          WebApplication.ShowMessage('Autenticación no valida')
        Else
        Begin
          UserSession.SetCODIGO_PERFIL(UserSession.CNX.AUX.FieldByName('CODIGO_PERFIL').AsString);
          UserSession.SetInfoUsuario(UserSession.CNX.AUX.FieldByName('CODIGO_USUARIO').AsString, Trim(UserSession.CNX.AUX.FieldByName('NOMBRE').AsString));
          UserSession.Validar_Perfil(UserSession.CODIGO_PERFIL);
          If Result Then
          Begin
            UserSession.SetAmbiente;
            WebApplication.SetUserNameAndPassword(UserSession.CODIGO_USUARIO, Trim(PASSWORD.Text));
            UserSession.SetEstacion(WebApplication.IP + ' - ' + TIWAppInfo.GetComputerName);
          End;
        End;
      End
      Else
        WebApplication.ShowMessage('Usuario no existe');
      UserSession.CNX.AUX.Active := False;
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWLogin.Usuario_Valido, A: ' + E.Message);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWLogin.Usuario_Valido, B: ' + E.Message);
  End;
End;

Function TFrIWLogin.Authentication_Validated : Boolean;
Var
  lIP : String;
Begin
  Result := False;
  If Vacio(USUARIO.Text) Or Vacio(PASSWORD.Text) Then
  Begin
    WebApplication.ShowMessage('Debe ingresar el usuario y la contraseña');
    Exit;
  End;

  If Vacio(CAPTCHA.Text) Or (Not (AnsiUpperCase(Trim(FCaptcha)) = AnsiUpperCase(Trim(CAPTCHA.Text)))) Then
  Begin
    WebApplication.ShowMessage('Captcha invalido');
    Exit;
  End;

//  If (IWServerController <> Nil) And IWServerController.Session_Active(USUARIO.Text, lIP) Then
//  Begin
//    WebApplication.ShowMessage('Este usuario se encuentra activo en esta direccion IP:' + lIP +  '; por favor verifique esta infrormación');
//    Exit;
//  End;

  Result := Usuario_Valido;
End;

procedure TFrIWLogin.BTNAYUDAAsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  If UserSession <> Nil Then
    UserSession.ShowForm_Ayuda(True, 'LOGIN');
end;

procedure TFrIWLogin.BtnCancelAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  WebApplication.Terminate('Gracias por usar la plataforma');
end;

procedure TFrIWLogin.BtnOKAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  BtnOK.Enabled := False;
  If Authentication_Validated Then
  Begin
    BtnOK.Caption := 'Ingresando, espere por favor...';
    UserSession.ShowForm_Menu;
    Self.Release;
  End
  Else
   BtnOK.Enabled := True;
end;

procedure TFrIWLogin.BTNRECUPERARAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  WebApplication.ShowPrompt('Identificación', Self.Name + '.Recuperar_Password', 'Digite su identificación', '', 'Recuperar', 'Cancelar');
end;

procedure TFrIWLogin.IWAppFormCreate(Sender: TObject);
begin
  Randomize;
  Self.Name := 'MENU' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  WebApplication.RegisterCallBack(Self.Name + '.Recuperar_Password', Recuperar_Password);
  UtCaptcha_Generate(FCaptcha, IWImageCaptcha);
  {$IFDEF DEBUG}
    USUARIO.Text := '15458469';
    PASSWORD.Text := '0';
    CAPTCHA.Text := '0';
    FCaptcha := '0';
  {$ENDIF}
end;

procedure TFrIWLogin.IWImage3AsyncClick(Sender: TObject;
  EventParams: TStringList);
begin
  UtCaptcha_Generate(FCaptcha, IWImageCaptcha);
end;

Procedure TFrIWLogin.Refrescar;
begin
  Self.Invalidate;
  WebApplication.CallBackResponse.AddJavaScriptToExecute('location.reload(true);');
end;

//Procedure Form_IWLogin_Show;
//Begin
//  TFrIWLogin.SetAsMainForm;
//  TFrIWLogin.Create(gWebApplication).Show;
//End;

Initialization
  TFrIWLogin.SetAsMainForm;

end.

