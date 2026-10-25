package Infinicast.Client.Protocol
{
   import Infinicast.Client.Api.Errors.ICError;
   
   public interface IEndpoint2ConnectorProtocolHandler
   {
      
      function onInitConnector(param1:ICError, param2:*, param3:*) : void;
      
      function onReceiveRequestResponse(param1:ICError, param2:*, param3:int, param4:*) : void;
      
      function onReceiveRequest(param1:ICError, param2:*, param3:String, param4:int, param5:*) : void;
      
      function onReceiveJsonQueryResult(param1:ICError, param2:Vector.<Object>, param3:int, param4:int) : void;
      
      function onCreateChildSuccess(param1:ICError, param2:*, param3:String, param4:int) : void;
      
      function onIntroduceObject(param1:ICError, param2:*, param3:String, param4:*) : void;
      
      function onReceiveMessage(param1:ICError, param2:*, param3:String, param4:*) : void;
      
      function onReceiveMessageValidate(param1:ICError, param2:*, param3:String, param4:*) : void;
      
      function onListAdd(param1:ICError, param2:*, param3:String, param4:String, param5:*) : void;
      
      function onListRemove(param1:ICError, param2:*, param3:String, param4:String, param5:*) : void;
      
      function onListChange(param1:ICError, param2:*, param3:String, param4:String, param5:*) : void;
      
      function onSetObjectData(param1:ICError, param2:*, param3:String, param4:*) : void;
      
      function onGetOrCreate(param1:ICError, param2:*, param3:String, param4:int, param5:Boolean) : void;
      
      function onCreateOrUpdateRole(param1:ICError, param2:*, param3:int) : void;
      
      function onDestroyRole(param1:ICError, param2:*, param3:int) : void;
      
      function onGetRoleForPathResult(param1:ICError, param2:Vector.<Object>, param3:*, param4:int) : void;
      
      function onListeningEnded(param1:ICError, param2:String, param3:*, param4:Boolean, param5:*) : void;
      
      function onListeningStarted(param1:ICError, param2:String, param3:*, param4:*) : void;
      
      function onListeningChanged(param1:ICError, param2:String, param3:*, param4:*) : void;
      
      function onDebugStatistics(param1:ICError, param2:*, param3:int) : void;
      
      function onPathRoleSetup(param1:ICError, param2:*, param3:int) : void;
      
      function onReminderTriggered(param1:ICError, param2:String, param3:*) : void;
      
      function onReceiveDataChangeValidate(param1:ICError, param2:*, param3:String, param4:*) : void;
      
      function onListenTerminate(param1:ICError, param2:*) : void;
      
      function onEndpointDisconnected(param1:ICError, param2:String, param3:*) : void;
      
      function onDebugObserverMessage(param1:ICError, param2:String, param3:*) : void;
   }
}

