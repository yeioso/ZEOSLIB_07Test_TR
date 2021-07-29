program Test_TR;
uses
  FastMM4,
  IWRtlFix,
  IWJclStackTrace,
  IWJclDebug,
  IWStart,
  ServerController in '..\Shared\Forms\ServerController.pas' {IWServerController: TIWServerControllerBase},
  UserSessionUnit in '..\Shared\Forms\UserSessionUnit.pas' {IWUserSession: TIWUserSessionBase},
  Form_IWLogin in '..\Shared\Forms\Form_IWLogin.pas' {FrIWLogin: TIWAppForm};

{$R *.res}
begin
  TIWStart.Execute(True);
end.
