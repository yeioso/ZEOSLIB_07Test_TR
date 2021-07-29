unit UtRest_TEST_TR;

interface

Function UtRest_Datetime_To_Unix_Timestamp(Const pDate : TDateTime) : String;
Function UtRest_Execute(Const pFunction, pDate : String; Var pOut : String) : Boolean;

implementation
Uses
  UtLog,
  REST.Types,
  REST.Client,
  System.SysUtils,
  System.DateUtils;

Function UtRest_Datetime_To_Unix_Timestamp(Const pDate : TDateTime) : String;
Begin
  Result := IntToStr(DateTimeToUnix(Now));
End;

Function UtRest_Execute(Const pFunction, pDate : String; Var pOut : String) : Boolean;
Const
  Const_BAse_URL = 'https://kqxty15mpg.execute-api.us-east-1.amazonaws.com/';
Var
  lClient : TRESTClient;
  lRequest : TRESTRequest;
  lResponse : TRESTResponse;
Begin
  Result := False;
  Try
    lClient := TRESTClient.Create(Nil);
    lRequest := TRESTRequest.Create(Nil);
    lResponse := TRESTResponse.Create(Nil);
    lRequest.Client := lClient;
    lRequest.Response := lResponse;
    lClient.BaseURL := Const_BAse_URL + pFunction;
    lRequest.AddAuthParameter('date', pDate, TRESTRequestParameterKind.pkGETorPOST);
    lRequest.Execute;
    pOut := lResponse.Content;
    Result := lResponse.StatusCode = 200;
  Except
    On E: Exception Do
    Begin
      pOut := E.Message;
      UtLog_Execute('UtRest_Execute, ' + lClient.BaseURL + ', ' + E.Message);
    End;
  End;
End;

end.
