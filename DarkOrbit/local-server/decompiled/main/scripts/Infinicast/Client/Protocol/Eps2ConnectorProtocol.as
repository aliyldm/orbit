package Infinicast.Client.Protocol
{
   import Infinicast.Client.Api.Errors.ICError;
   import Infinicast.Client.Protocol.Messages.Eps2ConnectorMessage;
   import Infinicast.Client.Utils.PathUtils;
   import Infinicast.Eps2ConnectorMessageType;
   import Infinicast.Runtime.APlayStringMessage;
   import Infinicast.Runtime.NotImplementedException;
   import Infinicast.Runtime.ObjectExtensions;
   
   public class Eps2ConnectorProtocol
   {
      
      public function Eps2ConnectorProtocol()
      {
         super();
      }
      
      public function decodeStringMessage(param1:APlayStringMessage, param2:IEndpoint2ConnectorProtocolHandler) : void
      {
         var _loc3_:Eps2ConnectorMessage = Eps2ConnectorMessage.parseString(param1);
         this.handleMessage(param2,_loc3_);
      }
      
      private function handleMessage(param1:IEndpoint2ConnectorProtocolHandler, param2:Eps2ConnectorMessage) : void
      {
         var _loc3_:int = param2.type;
         var _loc4_:* = null;
         if(param2.endpointObject != null)
         {
            _loc4_ = ObjectExtensions.clone(param2.endpointObject);
         }
         var _loc5_:* = null;
         if(param2.data != null)
         {
            _loc5_ = ObjectExtensions.clone(param2.data);
         }
         var _loc6_:ICError = param2.error;
         switch(_loc3_)
         {
            case Eps2ConnectorMessageType.InitConnector:
               param1.onInitConnector(_loc6_,_loc5_,_loc4_);
               break;
            case Eps2ConnectorMessageType.IntroduceObject:
               param1.onIntroduceObject(_loc6_,_loc5_,param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.Message:
               param1.onReceiveMessage(_loc6_,_loc5_,param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.MessageValidate:
               param1.onReceiveMessageValidate(_loc6_,_loc5_,param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.DataChangeValidate:
               param1.onReceiveDataChangeValidate(_loc6_,_loc5_,param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.Request:
               param1.onReceiveRequest(_loc6_,_loc5_,param2.path,int(param2.requestId),_loc4_);
               break;
            case Eps2ConnectorMessageType.RequestResponse:
               param1.onReceiveRequestResponse(_loc6_,_loc5_,int(param2.requestId),_loc4_);
               break;
            case Eps2ConnectorMessageType.JsonQueryResult:
               param1.onReceiveJsonQueryResult(_loc6_,param2.list,int(param2.fullCount),int(param2.requestId));
               break;
            case Eps2ConnectorMessageType.CreateChildSuccess:
               param1.onCreateChildSuccess(_loc6_,_loc5_,param2.path,int(param2.requestId));
               break;
            case Eps2ConnectorMessageType.SetObjectData:
               param1.onSetObjectData(_loc6_,_loc5_,param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.ListAdd:
               param1.onListAdd(_loc6_,_loc5_,PathUtils.getParentPath(param2.path),param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.ListRemove:
               param1.onListRemove(_loc6_,_loc5_,PathUtils.getParentPath(param2.path),param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.ListChange:
               param1.onListChange(_loc6_,_loc5_,PathUtils.getParentPath(param2.path),param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.GetOrCreate:
               param1.onGetOrCreate(_loc6_,_loc5_,param2.path,int(param2.requestId),Boolean(param2.newlyCreated));
               break;
            case Eps2ConnectorMessageType.PathRoleSetup:
               param1.onPathRoleSetup(_loc6_,_loc5_,int(param2.requestId));
               break;
            case Eps2ConnectorMessageType.CreateOrUpdateRole:
               param1.onCreateOrUpdateRole(_loc6_,_loc5_,int(param2.requestId));
               break;
            case Eps2ConnectorMessageType.DestroyRole:
               param1.onDestroyRole(_loc6_,_loc5_,int(param2.requestId));
               break;
            case Eps2ConnectorMessageType.GetRoleForPathResult:
               param1.onGetRoleForPathResult(_loc6_,param2.list,_loc5_,int(param2.requestId));
               break;
            case Eps2ConnectorMessageType.ListeningStarted:
               param1.onListeningStarted(_loc6_,param2.path,_loc4_,param2.data);
               break;
            case Eps2ConnectorMessageType.ListeningEnded:
               param1.onListeningEnded(_loc6_,param2.path,_loc4_,Boolean(param2.disconnected),param2.data);
               break;
            case Eps2ConnectorMessageType.EndpointDisconnected:
               param1.onEndpointDisconnected(_loc6_,param2.path,_loc4_);
               break;
            case Eps2ConnectorMessageType.ListenTerminate:
               param1.onListenTerminate(_loc6_,param2.data);
               break;
            case Eps2ConnectorMessageType.DebugObserverMessage:
               param1.onDebugObserverMessage(_loc6_,param2.path,param2.data);
               break;
            case Eps2ConnectorMessageType.ListeningChanged:
               param1.onListeningChanged(_loc6_,param2.path,_loc4_,param2.data);
               break;
            case Eps2ConnectorMessageType.Reminder:
               param1.onReminderTriggered(_loc6_,param2.path,param2.data);
               break;
            case Eps2ConnectorMessageType.DebugStatistics:
               param1.onDebugStatistics(_loc6_,param2.data,int(param2.requestId));
               break;
            default:
               throw new NotImplementedException("not yet implemented messageType " + _loc3_);
         }
      }
   }
}

