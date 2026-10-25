package Infinicast
{
   public class Connector2EpsMessageType
   {
      
      public static var RequestResponse:int = 0;
      
      public static var Request:int = 1;
      
      public static var InitConnector:int = 2;
      
      public static var JsonQuery:int = 3;
      
      public static var CreateChildRequest:int = 4;
      
      public static var SetObjectData:int = 5;
      
      public static var IntroduceObject:int = 6;
      
      public static var Message:int = 7;
      
      public static var MessageValidate:int = 8;
      
      public static var MessageValidated:int = 9;
      
      public static var ListAdd:int = 10;
      
      public static var ListRemove:int = 11;
      
      public static var ListChange:int = 12;
      
      public static var RemoveHandlers:int = 13;
      
      public static var RegisterHandler:int = 14;
      
      public static var CreateOrUpdateRole:int = 15;
      
      public static var DestroyRole:int = 16;
      
      public static var ModifyRoleForPath:int = 17;
      
      public static var GetRoleForPath:int = 18;
      
      public static var GetOrCreate:int = 19;
      
      public static var ListeningEnded:int = 20;
      
      public static var ListeningStarted:int = 21;
      
      public static var DeleteFromCollection:int = 22;
      
      public static var DebugPingInfo:int = 23;
      
      public static var DebugInfoMessage:int = 24;
      
      public static var DebugStatistics:int = 25;
      
      public static var PathRoleSetup:int = 26;
      
      public static var SetDebugName:int = 27;
      
      public static var GetObjectData:int = 28;
      
      public static var GetListeningList:int = 29;
      
      public static var UpdateData:int = 30;
      
      public static var SetChildData:int = 31;
      
      public static var ModifyChildData:int = 32;
      
      public static var RemoveChildren:int = 33;
      
      public static var GetEndpointConnectionInfo:int = 34;
      
      public static var Reminder:int = 35;
      
      public static var AddReminder:int = 36;
      
      public static var DeleteReminder:int = 37;
      
      public static var GetAndListenOnChildren:int = 38;
      
      public static var DataListenUpdate:int = 39;
      
      public static var ListeningChanged:int = 40;
      
      public static var GetAndListenOnListeners:int = 41;
      
      public static var ListenTerminate:int = 42;
      
      public static var SystemCommand:int = 43;
      
      public static var DataChangeValidate:int = 44;
      
      public static var DataChangeValidated:int = 45;
      
      public static var EndpointDisconnected:int = 46;
      
      public static var DebugObserverMessage:int = 47;
      
      public static var GetEPSubscriptionList:int = 48;
      
      public static var GetMatchingPathsWithListeners:int = 49;
      
      public static var RequestResponseFailed:int = 50;
      
      public function Connector2EpsMessageType()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "RequestResponse";
            case 1:
               return "Request";
            case 2:
               return "InitConnector";
            case 3:
               return "JsonQuery";
            case 4:
               return "CreateChildRequest";
            case 5:
               return "SetObjectData";
            case 6:
               return "IntroduceObject";
            case 7:
               return "Message";
            case 8:
               return "MessageValidate";
            case 9:
               return "MessageValidated";
            case 10:
               return "ListAdd";
            case 11:
               return "ListRemove";
            case 12:
               return "ListChange";
            case 13:
               return "RemoveHandlers";
            case 14:
               return "RegisterHandler";
            case 15:
               return "CreateOrUpdateRole";
            case 16:
               return "DestroyRole";
            case 17:
               return "ModifyRoleForPath";
            case 18:
               return "GetRoleForPath";
            case 19:
               return "GetOrCreate";
            case 20:
               return "ListeningEnded";
            case 21:
               return "ListeningStarted";
            case 22:
               return "DeleteFromCollection";
            case 23:
               return "DebugPingInfo";
            case 24:
               return "DebugInfoMessage";
            case 25:
               return "DebugStatistics";
            case 26:
               return "PathRoleSetup";
            case 27:
               return "SetDebugName";
            case 28:
               return "GetObjectData";
            case 29:
               return "GetListeningList";
            case 30:
               return "UpdateData";
            case 31:
               return "SetChildData";
            case 32:
               return "ModifyChildData";
            case 33:
               return "RemoveChildren";
            case 34:
               return "GetEndpointConnectionInfo";
            case 35:
               return "Reminder";
            case 36:
               return "AddReminder";
            case 37:
               return "DeleteReminder";
            case 38:
               return "GetAndListenOnChildren";
            case 39:
               return "DataListenUpdate";
            case 40:
               return "ListeningChanged";
            case 41:
               return "GetAndListenOnListeners";
            case 42:
               return "ListenTerminate";
            case 43:
               return "SystemCommand";
            case 44:
               return "DataChangeValidate";
            case 45:
               return "DataChangeValidated";
            case 46:
               return "EndpointDisconnected";
            case 47:
               return "DebugObserverMessage";
            case 48:
               return "GetEPSubscriptionList";
            case 49:
               return "GetMatchingPathsWithListeners";
            case 50:
               return "RequestResponseFailed";
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
      
      public static function parse(param1:String) : int
      {
         switch(param1)
         {
            case "RequestResponse":
               return 0;
            case "Request":
               return 1;
            case "InitConnector":
               return 2;
            case "JsonQuery":
               return 3;
            case "CreateChildRequest":
               return 4;
            case "SetObjectData":
               return 5;
            case "IntroduceObject":
               return 6;
            case "Message":
               return 7;
            case "MessageValidate":
               return 8;
            case "MessageValidated":
               return 9;
            case "ListAdd":
               return 10;
            case "ListRemove":
               return 11;
            case "ListChange":
               return 12;
            case "RemoveHandlers":
               return 13;
            case "RegisterHandler":
               return 14;
            case "CreateOrUpdateRole":
               return 15;
            case "DestroyRole":
               return 16;
            case "ModifyRoleForPath":
               return 17;
            case "GetRoleForPath":
               return 18;
            case "GetOrCreate":
               return 19;
            case "ListeningEnded":
               return 20;
            case "ListeningStarted":
               return 21;
            case "DeleteFromCollection":
               return 22;
            case "DebugPingInfo":
               return 23;
            case "DebugInfoMessage":
               return 24;
            case "DebugStatistics":
               return 25;
            case "PathRoleSetup":
               return 26;
            case "SetDebugName":
               return 27;
            case "GetObjectData":
               return 28;
            case "GetListeningList":
               return 29;
            case "UpdateData":
               return 30;
            case "SetChildData":
               return 31;
            case "ModifyChildData":
               return 32;
            case "RemoveChildren":
               return 33;
            case "GetEndpointConnectionInfo":
               return 34;
            case "Reminder":
               return 35;
            case "AddReminder":
               return 36;
            case "DeleteReminder":
               return 37;
            case "GetAndListenOnChildren":
               return 38;
            case "DataListenUpdate":
               return 39;
            case "ListeningChanged":
               return 40;
            case "GetAndListenOnListeners":
               return 41;
            case "ListenTerminate":
               return 42;
            case "SystemCommand":
               return 43;
            case "DataChangeValidate":
               return 44;
            case "DataChangeValidated":
               return 45;
            case "EndpointDisconnected":
               return 46;
            case "DebugObserverMessage":
               return 47;
            case "GetEPSubscriptionList":
               return 48;
            case "GetMatchingPathsWithListeners":
               return 49;
            case "RequestResponseFailed":
               return 50;
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
   }
}

