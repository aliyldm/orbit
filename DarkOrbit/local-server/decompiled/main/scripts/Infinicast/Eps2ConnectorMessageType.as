package Infinicast
{
   public class Eps2ConnectorMessageType
   {
      
      public static var Message:int = 0;
      
      public static var Request:int = 1;
      
      public static var RequestResponse:int = 2;
      
      public static var RegisterHandler:int = 3;
      
      public static var JsonQueryResult:int = 4;
      
      public static var CreateChildSuccess:int = 5;
      
      public static var IntroduceObject:int = 6;
      
      public static var MessageValidate:int = 7;
      
      public static var ListAdd:int = 8;
      
      public static var ListChange:int = 9;
      
      public static var InitConnector:int = 10;
      
      public static var SetObjectData:int = 11;
      
      public static var DataChangeValidate:int = 12;
      
      public static var GetOrCreate:int = 13;
      
      public static var CreateOrUpdateRole:int = 14;
      
      public static var DestroyRole:int = 15;
      
      public static var GetRoleForPathResult:int = 16;
      
      public static var ListeningStarted:int = 17;
      
      public static var ListeningEnded:int = 18;
      
      public static var ListeningChanged:int = 19;
      
      public static var ListenTerminate:int = 20;
      
      public static var EndpointDisconnected:int = 21;
      
      public static var DebugStatistics:int = 22;
      
      public static var PathRoleSetup:int = 23;
      
      public static var Reminder:int = 24;
      
      public static var ListRemove:int = 25;
      
      public static var DebugObserverMessage:int = 26;
      
      public function Eps2ConnectorMessageType()
      {
         super();
      }
      
      public static function toString(param1:int) : String
      {
         switch(param1)
         {
            case 0:
               return "Message";
            case 1:
               return "Request";
            case 2:
               return "RequestResponse";
            case 3:
               return "RegisterHandler";
            case 4:
               return "JsonQueryResult";
            case 5:
               return "CreateChildSuccess";
            case 6:
               return "IntroduceObject";
            case 7:
               return "MessageValidate";
            case 8:
               return "ListAdd";
            case 9:
               return "ListChange";
            case 10:
               return "InitConnector";
            case 11:
               return "SetObjectData";
            case 12:
               return "DataChangeValidate";
            case 13:
               return "GetOrCreate";
            case 14:
               return "CreateOrUpdateRole";
            case 15:
               return "DestroyRole";
            case 16:
               return "GetRoleForPathResult";
            case 17:
               return "ListeningStarted";
            case 18:
               return "ListeningEnded";
            case 19:
               return "ListeningChanged";
            case 20:
               return "ListenTerminate";
            case 21:
               return "EndpointDisconnected";
            case 22:
               return "DebugStatistics";
            case 23:
               return "PathRoleSetup";
            case 24:
               return "Reminder";
            case 25:
               return "ListRemove";
            case 26:
               return "DebugObserverMessage";
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
      
      public static function parse(param1:String) : int
      {
         switch(param1)
         {
            case "Message":
               return 0;
            case "Request":
               return 1;
            case "RequestResponse":
               return 2;
            case "RegisterHandler":
               return 3;
            case "JsonQueryResult":
               return 4;
            case "CreateChildSuccess":
               return 5;
            case "IntroduceObject":
               return 6;
            case "MessageValidate":
               return 7;
            case "ListAdd":
               return 8;
            case "ListChange":
               return 9;
            case "InitConnector":
               return 10;
            case "SetObjectData":
               return 11;
            case "DataChangeValidate":
               return 12;
            case "GetOrCreate":
               return 13;
            case "CreateOrUpdateRole":
               return 14;
            case "DestroyRole":
               return 15;
            case "GetRoleForPathResult":
               return 16;
            case "ListeningStarted":
               return 17;
            case "ListeningEnded":
               return 18;
            case "ListeningChanged":
               return 19;
            case "ListenTerminate":
               return 20;
            case "EndpointDisconnected":
               return 21;
            case "DebugStatistics":
               return 22;
            case "PathRoleSetup":
               return 23;
            case "Reminder":
               return 24;
            case "ListRemove":
               return 25;
            case "DebugObserverMessage":
               return 26;
            default:
               throw new ArgumentError("Unknown enumeration value");
         }
      }
   }
}

