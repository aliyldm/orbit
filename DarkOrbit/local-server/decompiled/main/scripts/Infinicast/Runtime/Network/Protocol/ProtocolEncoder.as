package Infinicast.Runtime.Network.Protocol
{
   import Infinicast.Runtime.APlayBinaryMessage;
   import Infinicast.Runtime.APlayStringMessage;
   import flash.utils.ByteArray;
   
   public class ProtocolEncoder
   {
      
      public function ProtocolEncoder()
      {
         super();
      }
      
      public function Encode(param1:Object, param2:MessageWriter) : void
      {
         var _loc3_:APlayStringMessage = null;
         var _loc4_:Object = null;
         var _loc5_:APlayBinaryMessage = null;
         var _loc6_:ByteArray = null;
         var _loc7_:LowLevelIntroductionMessage = null;
         var _loc8_:LowLevelPongMessage = null;
         if(param1 is APlayStringMessage)
         {
            _loc3_ = param1 as APlayStringMessage;
            _loc4_ = _loc3_.DataAsJson;
            _loc5_ = new APlayBinaryMessage();
            _loc5_.startWriting();
            _loc5_.writeJson(_loc4_);
            _loc6_ = _loc5_.getBinaryBytes();
            param2.write_int8(APlayMessageType.MSGTYPE_PAYLOAD_BINARY_JSON);
            param2.write_int32(_loc6_.length);
            param2.write_bytes(_loc6_);
         }
         else if(param1 is LowLevelIntroductionMessage)
         {
            _loc7_ = param1 as LowLevelIntroductionMessage;
            param2.write_int8(APlayMessageType.LOWLEVEL_INTRODUCTION);
            param2.write_String(_loc7_.AddressString);
         }
         else if(param1 is LowLevelPongMessage)
         {
            _loc8_ = param1 as LowLevelPongMessage;
            param2.write_int8(APlayMessageType.LOWLEVEL_PONG);
            param2.write_int32(8);
            param2.write_int64(_loc8_.SendTime);
         }
      }
   }
}

