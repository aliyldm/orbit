package Infinicast.Runtime.Network.Protocol
{
   public class APlayMessageType
   {
      
      public static var PAYLOAD:int = 80;
      
      public static var MSGTYPE_PAYLOAD_BINARY_JSON:int = 83;
      
      public static var PAYLOADGZIP:int = 97;
      
      public static var LOWLEVEL_INTRODUCTION:int = 16;
      
      public static var LOWLEVEL_PING:int = 17;
      
      public static var LOWLEVEL_PONG:int = 18;
      
      public function APlayMessageType()
      {
         super();
      }
   }
}

