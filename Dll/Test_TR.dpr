library Test_TR;

uses
  FastMM4,
  IWRtlFix,
  IWJclStackTrace,
  IWJclDebug,
  IWInitISAPI,
  ServerController in '..\Shared\Forms\ServerController.pas' {IWServerController: TIWServerControllerBase},
  UserSessionUnit in '..\Shared\Forms\UserSessionUnit.pas' {IWUserSession: TIWUserSessionBase};

{$R *.RES}

exports
  GetExtensionVersion,
  HttpExtensionProc,
  TerminateExtension;

begin
  IWRun;
end.
