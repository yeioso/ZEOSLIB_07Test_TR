object IWServerController: TIWServerController
  OldCreateOrder = False
  OnCreate = IWServerControllerBaseCreate
  OnDestroy = IWServerControllerBaseDestroy
  AppName = 'MyApp'
  Description = 'My IntraWeb Application'
  DisplayName = 'IntraWeb Application'
  Port = 8888
  Version = '15.2.17'
  OnConfig = IWServerControllerBaseConfig
  OnNewSession = IWServerControllerBaseNewSession
  Height = 310
  Width = 342
end
