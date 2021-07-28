unit Form_IWMenu;

interface

uses
  Classes, SysUtils, IWAppForm, IWApplication, IWColor, IWTypes, Vcl.Controls,
  Vcl.Forms, IWVCLBaseContainer, IWContainer, IWHTMLContainer,
  IWHTML40Container, IWRegion, Vcl.Imaging.pngimage, IWVCLBaseControl,
  IWBaseControl, IWBaseHTMLControl, IWControl, IWCompExtCtrls, IWCompButton,
  IWCompLabel, IWBaseComponent, IWBaseHTMLComponent, IWBaseHTML40Component,
  IWCompEdit, IWCompListbox, IWCompMemo, IWHTMLControls, IWCompTreeview,
  UtInfoTablas;

type
  TFrIWMenu = class(TIWAppForm)
    IWRegion1: TIWRegion;
    IWRegionMensaje: TIWRegion;
    IWModalWindow1: TIWModalWindow;
    IWRegion2: TIWRegion;
    lbInfo: TIWLabel;
    SESIONES_ACTIVAS: TIWMemo;
    IWCambiarPassword: TIWRegion;
    IWLabel35: TIWLabel;
    IWLabel36: TIWLabel;
    IWLabel37: TIWLabel;
    ACTUAL: TIWEdit;
    NUEVO: TIWEdit;
    CONFIRMACION: TIWEdit;
    IWLabel38: TIWLabel;
    NOMBRE_USUARIO: TIWEdit;
    IWLabel42: TIWLabel;
    EMAIL: TIWEdit;
    IWLabel43: TIWLabel;
    IWURL1: TIWURL;
    IWRegion3: TIWRegion;
    IWRAYUDA: TIWRegion;
    BTNAYUDA: TIWImage;
    IWLabel1: TIWLabel;
    IWRegion4: TIWRegion;
    BTNPERFIL: TIWImage;
    IWLabel2: TIWLabel;
    IWRegion5: TIWRegion;
    BTNUSUARIO: TIWImage;
    IWLabel3: TIWLabel;
    IWRegion6: TIWRegion;
    BTNBODEGA: TIWImage;
    IWLabel4: TIWLabel;
    IWRegion9: TIWRegion;
    BTNREPORTE: TIWImage;
    IWLabel7: TIWLabel;
    IWRegion10: TIWRegion;
    BTNCAMBIO_CONTRASENA: TIWImage;
    IWLabel8: TIWLabel;
    IWRegion11: TIWRegion;
    BTNCONEXION_ACTIVA: TIWImage;
    IWLabel9: TIWLabel;
    IWRegion12: TIWRegion;
    BTNSALIR: TIWImage;
    IWLabel10: TIWLabel;
    IWRegion7: TIWRegion;
    BTNPRODUCT: TIWImage;
    IWLabel5: TIWLabel;
    procedure IWAppFormCreate(Sender: TObject);
    procedure BTNPERFILAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNUSUARIOAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNBODEGAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNAYUDAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNREPORTEAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCAMBIO_CONTRASENAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNCONEXION_ACTIVAAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNSALIRAsyncClick(Sender: TObject; EventParams: TStringList);
    procedure BTNPRODUCTAsyncClick(Sender: TObject; EventParams: TStringList);
  Private
    procedure Ejecutar_Salida(EventParams: TStringList);
    Procedure Actualizar_Info;
    Procedure ReleaseMe;
    procedure CheckSessions;
    Function Password_Valido : Boolean;
    Function Actualizar_Password : Boolean;
    Procedure Mostrar_Conectados;
    Procedure Cambiar_Paswword;
    procedure Execute_Change_Password(Sender: TObject; EventParams: TStringList);
  public
  end;

implementation
{$R *.dfm}
Uses
  UtLog,
  UtFuncion,
  UtConexion,
  Criptografia,
  ServerController;

procedure TFrIWMenu.Ejecutar_Salida(EventParams: TStringList);
var
  Response: Boolean;
  InputValue: string;
  SelectedButton: string;
  MsgType: TIWNotifyType;
  Msg: string;
begin
  Try
    // Prompt callback has 2 main parameters:
    // RetValue (Boolean), indicates if the first button (Yes/OK/custom) was choosen
    // InputStr, contains the string entered in the input box
    Response := Result_Is_OK(EventParams.Values['RetValue']);
    InputValue := EventParams.Values['InputStr'];
    if Response then
    begin
      SelectedButton := 'OK';
      MsgType := ntSuccess;
      WebApplication.Terminate('Gracias por utilizar la plataforma');
    end
    else begin
      SelectedButton := 'Cancel';
      MsgType := ntError;
    end;
  //  Msg := 'This is the callback. The selected button was: ' + SelectedButton;
  //  if Response then
  //    Msg := Msg + ', and the string entered was: ' + InputValue;
  //
  //  WebApplication.ShowNotification(Msg, MsgType);
  Except
    On E : Exception Do
      UtLog_Execute('TFrIWMenu.Ejecutar_Salida, ' + E.Message);
  End;
end;


Procedure TFrIWMenu.Actualizar_Info;
Begin
  lbInfo.Caption := 'Bienvenido(a) ' + Trim(UserSession.NOMBRE_USUARIO);
  lbInfo.Caption := lbInfo.Caption + ', Versión 2021.05.15 Rev 1.0';
End;

Procedure TFrIWMenu.ReleaseMe;
begin
  If Assigned(Self) Then
    Self.Release;
End;

Function TFrIWMenu.Password_Valido : Boolean;
Var
  lHash : String;
  lPassword : String;
Begin
  Result := False;
  If Vacio(ACTUAL.Text) Or Vacio(NUEVO.Text) Or Vacio(CONFIRMACION.Text) Then
  Begin
    WebApplication.ShowNotification('Debe ingresar todos los campos para proceder con el cambio de contraseña', ntError);
    Exit;
  End;

  If Trim(NUEVO.Text) <> Trim(CONFIRMACION.Text) Then
  Begin
    WebApplication.ShowNotification('La contraseña nueva y la confirmaciòn no coinciden', ntError);
    Exit;
  End;

  Try
    Try
      UserSession.CNX.AUX.Active := False;
      UserSession.CNX.AUX.SQL.Clear;
      UserSession.CNX.AUX.SQL.Add(' SELECT * FROM ' + Retornar_Info_Tabla(Id_Usuario).Name + ' ');
      UserSession.CNX.AUX.SQL.Add(' WHERE ID_SISTEMA = ' + QuotedStr('S'));
      UserSession.CNX.AUX.SQL.Add(' AND ' + UserSession.CNX.Trim_Sentence('CODIGO_USUARIO') + ' = ' + QuotedStr(Trim(UserSession.CODIGO_USUARIO)));
      UserSession.CNX.AUX.Active := True;
      If UserSession.CNX.AUX.Active And (UserSession.CNX.AUX.RecordCount > 0) Then
      Begin
        lPassword := RetornarDecodificado(Const_KEY, UserSession.CNX.AUX.FieldByName('CONTRASENA').AsString, lHash);
        Result := Trim(AnsiUpperCase(lPassword)) = Trim(AnsiUpperCase(ACTUAL.Text));
        If Not Result Then
          WebApplication.ShowNotification('Autenticación no valida', ntError)
      End
      Else
        WebApplication.ShowNotification('Usuario no existe', ntError);
      UserSession.CNX.AUX.Active := False;
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWMenu.Password_Valido, A: ' + E.Message);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMenu.Password_Valido, B: ' + E.Message);
  End;
End;

Function TFrIWMenu.Actualizar_Password : Boolean;
Var
  lHash : String;
  lPassword : String;
Begin
  Try
    Try
      UserSession.CNX.AUX.Active := False;
      UserSession.CNX.AUX.SQL.Clear;
      UserSession.CNX.AUX.SQL.Add(' SELECT * FROM ' + Retornar_Info_Tabla(Id_Usuario).Name + ' ');
      UserSession.CNX.AUX.SQL.Add(' WHERE ID_SISTEMA = ' + QuotedStr('S'));
      UserSession.CNX.AUX.SQL.Add(' AND ' + UserSession.CNX.Trim_Sentence('CODIGO_USUARIO') + ' = ' + QuotedStr(Trim(UserSession.CODIGO_USUARIO)));
      UserSession.CNX.AUX.Active := True;
      If UserSession.CNX.AUX.Active And (UserSession.CNX.AUX.RecordCount > 0) Then
      Begin
        lPassword := RetornarCodificado(Const_KEY, Trim(CONFIRMACION.Text), lHash);
        UserSession.CNX.AUX.Edit;
        UserSession.CNX.AUX.FieldByName('CONTRASENA').AsString := Trim(lPassword);
        UserSession.CNX.AUX.FieldByName('EMAIL'     ).AsString := Trim(AnsiUpperCase(EMAIL.Text         ));
        UserSession.CNX.AUX.FieldByName('NOMBRE'    ).AsString := Trim(AnsiUpperCase(NOMBRE_USUARIO.Text));
        UserSession.CNX.AUX.Post;
        Result := True;
        ACTUAL.Text       := '';
        NUEVO.Text        := '';
        CONFIRMACION.Text := '';
        UserSession.SetInfoUsuario(UserSession.CODIGO_USUARIO, NOMBRE_USUARIO.Text);
        WebApplication.ShowNotification('Contraseña actualizada', ntSuccess);
        Actualizar_Info;
      End
      Else
        WebApplication.ShowNotification('Usuario no existe', ntError);
      UserSession.CNX.AUX.Active := False;
    Except
      On E: Exception Do
        UtLog_Execute('TFrIWMenu.Actualizar_Password, A: ' + E.Message);
    End;
  Except
    On E: Exception Do
      UtLog_Execute('TFrIWMenu.Actualizar_Password, B: ' + E.Message);
  End;
End;

procedure TFrIWMenu.Execute_Change_Password(Sender: TObject; EventParams: TStringList);
begin
  Case IWModalWindow1.ButtonIndex Of
    1 : Begin
          If Password_Valido Then
            Actualizar_Password;
        End;
    3 : Begin
        End;
  End;
end;

Procedure TFrIWMenu.Mostrar_Conectados;
Begin
  CheckSessions;
  IWModalWindow1.Reset;
  IWModalWindow1.Buttons.CommaText := '&Aceptar';
  IWModalWindow1.Title := 'Usuarios Conectados';
  IWModalWindow1.ContentElement := IWRegionMensaje;
  IWModalWindow1.Autosize := True;
  IWModalWindow1.Draggable := True;
  IWModalWindow1.WindowTop := 10;
  IWModalWindow1.WindowLeft := 10;
  IWModalWindow1.WindowWidth := IWRegionMensaje.Width;
  IWModalWindow1.WindowHeight := IWRegionMensaje.Height;
//IWModalWindow1.OnAsyncClick := pEvent;
  IWModalWindow1.SizeUnit := suPixel;
  IWModalWindow1.Show;
End;


procedure TFrIWMenu.BTNAYUDAAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Ayuda(False, 'UPL');
end;

procedure TFrIWMenu.BTNBODEGAAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  UserSession.ShowForm_Buyer;
end;

procedure TFrIWMenu.BTNCAMBIO_CONTRASENAAsyncClick(Sender: TObject; EventParams: TStringList);
begin
Cambiar_Paswword;
end;

procedure TFrIWMenu.BTNCONEXION_ACTIVAAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  Mostrar_Conectados;
end;

procedure TFrIWMenu.BTNPERFILAsyncClick(Sender: TObject;  EventParams: TStringList);
begin
  UserSession.ShowForm_Perfil;
end;

procedure TFrIWMenu.BTNPRODUCTAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Product;
end;

Procedure TFrIWMenu.BTNUSUARIOAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Usuario;
end;

Procedure TFrIWMenu.Cambiar_Paswword;
Begin
  NOMBRE_USUARIO.Text := AnsiUpperCase(Trim(UserSession.NOMBRE_USUARIO));
  EMAIL.Text          := UserSession.CNX.GetValue(Retornar_Info_Tabla(Id_Usuario).Name, ['CODIGO_USUARIO'], [UserSession.CODIGO_USUARIO], ['EMAIL']);
  EMAIL.Text          := Trim(LowerCase(EMAIL.Text));
  IWModalWindow1.Reset;
  IWModalWindow1.Buttons.CommaText := '&Aceptar,&Cancelar';
  IWModalWindow1.Title := 'Cambio de Contraseña';
  IWModalWindow1.ContentElement := IWCambiarPassword;
  IWModalWindow1.Autosize := True;
  IWModalWindow1.Draggable := True;
  IWModalWindow1.WindowTop := (Screen.Height DIV 2) - (IWCambiarPassword.Height Div 2);
  IWModalWindow1.WindowLeft := (Screen.Width DIV 2) - (IWCambiarPassword.Width Div 2);
  IWModalWindow1.WindowWidth := IWCambiarPassword.Width;
  IWModalWindow1.WindowHeight := IWCambiarPassword.Height;
  IWModalWindow1.OnAsyncClick := Execute_Change_Password;
  IWModalWindow1.SizeUnit := suPixel;
  IWModalWindow1.Show;
End;

procedure TFrIWMenu.CheckSessions;
var
  LSessionList: TStringList;
  i: Integer;
  begin
  SESIONES_ACTIVAS.Lines.Clear;
  // First, create a session list to hold the session IDs
  LSessionList := TStringList.Create;
  try
    gSessions.GetList(LSessionList);
    SESIONES_ACTIVAS.Lines.Add('SESIONES ACTIVAS=' + IntToStr(lSessionList.Count) + '.');
    for i := 0 to LSessionList.Count - 1 do begin
      gSessions.Execute(LSessionList[i],
        procedure(aSession: TObject)
        var
          LSession: TIWApplication absolute aSession;
        begin
          SESIONES_ACTIVAS.Lines.Add(StringOfChar('=', 50));
          SESIONES_ACTIVAS.Lines.Add(Trim(LSession.AuthUser) + ', ' + Trim(UserSession.CNX.GetValue(Retornar_Info_Tabla(Id_Usuario).Name, ['CODIGO_USUARIO'], [Trim(LSession.AuthUser)], ['NOMBRE'])));
          SESIONES_ACTIVAS.Lines.Add(StringOfChar(' ', 03) + Trim(FormatDateTime('YYYY-MM-DD, HH:NN:SS', LSession.SessionTimeStamp)));
          SESIONES_ACTIVAS.Lines.Add(StringOfChar(' ', 03) + 'Ultimo Acceso=' + DateTimeToStr(LSession.LastAccess));
          SESIONES_ACTIVAS.Lines.Add(StringOfChar(' ', 03) + 'IP=' + LSession.IP );
          SESIONES_ACTIVAS.Lines.Add(StringOfChar(' ', 03) + 'Browser=' + LSession.Browser.BrowserName);
        end
      );
    end;
  finally
    LSessionList.Free;
  end;
end;

procedure TFrIWMenu.IWAppFormCreate(Sender: TObject);
begin
  Randomize;
  Self.Name := 'MENU' + FormatDateTime('YYYYMMDDHHNNSSZZZ', Now) + IntToStr(Random(1000));
  WebApplication.RegisterCallBack(Self.Name + '.Ejecutar_Salida', Ejecutar_Salida);
  Actualizar_Info;
  Try
//    Create_Menu;
  Except
    On E : Exception Do
      UtLog_Execute('TFrIWMenu.IWAppFormCreate, ' + E.Message);
  End;
End;

procedure TFrIWMenu.BTNREPORTEAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  UserSession.ShowForm_Manager_Report;
end;

procedure TFrIWMenu.BTNSALIRAsyncClick(Sender: TObject; EventParams: TStringList);
begin
  WebApplication.ShowConfirm('Está seguro(a) de salir?', Self.Name + '.Ejecutar_Salida', 'Salir', 'Sí', 'No');
end;

end.
