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
   
   public class Connector2EpsMessageTypeConverter
   {
      
      private static var _stringToInt:Dictionary = null;
      
      private static var _intToString:Dictionary = null;
      
      public function Connector2EpsMessageTypeConverter()
      {
         super();
      }
      
      public static function init() : void
      {
         if(Connector2EpsMessageTypeConverter._stringToInt == null)
         {
            Connector2EpsMessageTypeConverter._stringToInt = new Dictionary();
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(1),1);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(0),2);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(2),3);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(3),4);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(4),5);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(5),6);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(6),7);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(7),8);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(8),9);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(9),10);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(10),11);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(11),12);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(12),13);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(13),14);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(14),15);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(15),16);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(16),17);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(17),18);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(18),19);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(19),20);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(20),21);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(21),22);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(22),23);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(23),24);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(24),25);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(25),26);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(26),27);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(27),28);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(28),29);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(29),30);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(30),31);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(31),32);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(32),33);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(33),34);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(34),35);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(35),36);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(36),37);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(37),38);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(38),39);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(39),40);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(40),41);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(43),42);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(42),43);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(41),44);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(44),45);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(45),46);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(46),47);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(47),48);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(48),49);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(49),50);
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._stringToInt,Connector2EpsMessageType.toString(50),51);
            Connector2EpsMessageTypeConverter._intToString = new Dictionary();
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,1,Connector2EpsMessageType.toString(1));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,2,Connector2EpsMessageType.toString(0));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,3,Connector2EpsMessageType.toString(2));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,4,Connector2EpsMessageType.toString(3));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,5,Connector2EpsMessageType.toString(4));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,6,Connector2EpsMessageType.toString(5));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,7,Connector2EpsMessageType.toString(6));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,8,Connector2EpsMessageType.toString(7));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,9,Connector2EpsMessageType.toString(8));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,10,Connector2EpsMessageType.toString(9));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,11,Connector2EpsMessageType.toString(10));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,12,Connector2EpsMessageType.toString(11));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,13,Connector2EpsMessageType.toString(12));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,14,Connector2EpsMessageType.toString(13));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,15,Connector2EpsMessageType.toString(14));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,16,Connector2EpsMessageType.toString(15));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,17,Connector2EpsMessageType.toString(16));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,18,Connector2EpsMessageType.toString(17));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,19,Connector2EpsMessageType.toString(18));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,20,Connector2EpsMessageType.toString(19));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,21,Connector2EpsMessageType.toString(20));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,22,Connector2EpsMessageType.toString(21));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,23,Connector2EpsMessageType.toString(22));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,24,Connector2EpsMessageType.toString(23));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,25,Connector2EpsMessageType.toString(24));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,26,Connector2EpsMessageType.toString(25));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,27,Connector2EpsMessageType.toString(26));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,28,Connector2EpsMessageType.toString(27));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,29,Connector2EpsMessageType.toString(28));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,30,Connector2EpsMessageType.toString(29));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,31,Connector2EpsMessageType.toString(30));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,32,Connector2EpsMessageType.toString(31));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,33,Connector2EpsMessageType.toString(32));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,34,Connector2EpsMessageType.toString(33));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,35,Connector2EpsMessageType.toString(34));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,36,Connector2EpsMessageType.toString(35));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,37,Connector2EpsMessageType.toString(36));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,38,Connector2EpsMessageType.toString(37));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,39,Connector2EpsMessageType.toString(38));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,40,Connector2EpsMessageType.toString(39));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,41,Connector2EpsMessageType.toString(40));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,42,Connector2EpsMessageType.toString(43));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,43,Connector2EpsMessageType.toString(42));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,44,Connector2EpsMessageType.toString(41));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,45,Connector2EpsMessageType.toString(44));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,46,Connector2EpsMessageType.toString(45));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,47,Connector2EpsMessageType.toString(46));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,48,Connector2EpsMessageType.toString(47));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,49,Connector2EpsMessageType.toString(48));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,50,Connector2EpsMessageType.toString(49));
            DictionaryExtensions.add(Connector2EpsMessageTypeConverter._intToString,51,Connector2EpsMessageType.toString(50));
         }
      }
      
      public static function messageTypeToInt(param1:int) : int
      {
         return Connector2EpsMessageTypeConverter._stringToInt[Connector2EpsMessageType.toString(param1)];
      }
      
      public static function intToMessageType(param1:int) : int
      {
         return Connector2EpsMessageType.parse(Connector2EpsMessageTypeConverter._intToString[param1]);
      }
   }
}

