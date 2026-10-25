package Infinicast.Client.Protocol
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
   import Infinicast.Client.Api.Errors.*;
   import Infinicast.Client.Api.Paths.*;
   import Infinicast.Client.Api.Paths.Handler.*;
   import Infinicast.Client.Api.Paths.Handler.Lists.*;
   import Infinicast.Client.Api.Paths.Handler.Messages.*;
   import Infinicast.Client.Api.Paths.Handler.Objects.*;
   import Infinicast.Client.Api.Paths.Handler.Reminders.*;
   import Infinicast.Client.Api.Paths.Handler.Requests.*;
   import Infinicast.Client.Api.Paths.Options.*;
   import Infinicast.Client.Api.Paths.TaskObjects.*;
   import Infinicast.Client.Api.Query.*;
   import Infinicast.Client.Impl.*;
   import Infinicast.Client.Impl.Contexts.*;
   import Infinicast.Client.Impl.Helper.*;
   import Infinicast.Client.Impl.Messaging.*;
   import Infinicast.Client.Impl.Messaging.Handlers.*;
   import Infinicast.Client.Impl.Messaging.Receiver.*;
   import Infinicast.Client.Impl.Messaging.sender.*;
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   import flash.utils.Dictionary;
   
   public class Eps2ConnectorMessageTypeConverter
   {
      
      private static var _stringToInt:Dictionary;
      
      private static var _intToString:Dictionary;
      
      public function Eps2ConnectorMessageTypeConverter()
      {
         super();
      }
      
      public static function init() : void
      {
         if(Eps2ConnectorMessageTypeConverter._stringToInt == null)
         {
            Eps2ConnectorMessageTypeConverter._stringToInt = new Dictionary();
            Eps2ConnectorMessageTypeConverter._intToString = new Dictionary();
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(1),1);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(2),2);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(10),3);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(11),6);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(6),7);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(0),8);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(7),9);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(8),11);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(25),12);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(9),13);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(3),15);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(14),16);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(15),17);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(13),20);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(18),21);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(17),22);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(22),26);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(23),27);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(24),36);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(19),41);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(20),43);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(12),45);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(21),47);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(26),48);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(4),1001);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(5),1002);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._stringToInt,Eps2ConnectorMessageType.toString(16),1003);
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,1,Eps2ConnectorMessageType.toString(1));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,2,Eps2ConnectorMessageType.toString(2));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,3,Eps2ConnectorMessageType.toString(10));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,6,Eps2ConnectorMessageType.toString(11));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,7,Eps2ConnectorMessageType.toString(6));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,8,Eps2ConnectorMessageType.toString(0));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,9,Eps2ConnectorMessageType.toString(7));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,11,Eps2ConnectorMessageType.toString(8));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,12,Eps2ConnectorMessageType.toString(25));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,13,Eps2ConnectorMessageType.toString(9));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,15,Eps2ConnectorMessageType.toString(3));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,16,Eps2ConnectorMessageType.toString(14));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,17,Eps2ConnectorMessageType.toString(15));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,20,Eps2ConnectorMessageType.toString(13));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,21,Eps2ConnectorMessageType.toString(18));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,22,Eps2ConnectorMessageType.toString(17));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,26,Eps2ConnectorMessageType.toString(22));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,27,Eps2ConnectorMessageType.toString(23));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,36,Eps2ConnectorMessageType.toString(24));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,41,Eps2ConnectorMessageType.toString(19));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,43,Eps2ConnectorMessageType.toString(20));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,45,Eps2ConnectorMessageType.toString(12));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,47,Eps2ConnectorMessageType.toString(21));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,48,Eps2ConnectorMessageType.toString(26));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,1001,Eps2ConnectorMessageType.toString(4));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,1002,Eps2ConnectorMessageType.toString(5));
            DictionaryExtensions.add(Eps2ConnectorMessageTypeConverter._intToString,1003,Eps2ConnectorMessageType.toString(16));
         }
      }
      
      public static function messageTypeToInt(param1:int) : int
      {
         return Eps2ConnectorMessageTypeConverter._stringToInt[Eps2ConnectorMessageType.toString(param1)];
      }
      
      public static function intToMessageType(param1:int) : int
      {
         return Eps2ConnectorMessageType.parse(Eps2ConnectorMessageTypeConverter._intToString[param1]);
      }
   }
}

