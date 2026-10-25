package Infinicast.Runtime.Network.Protocol
{
   import Infinicast.Runtime.APlayBinaryMessage;
   import Infinicast.Runtime.APlayStringMessage;
   import flash.utils.ByteArray;
   
   public class ProtocolDecoder
   {
      
      public function ProtocolDecoder()
      {
         super();
      }
      
      public function DoDecode(param1:MessageReader) : Object
      {
         var _loc4_:String = null;
         var _loc5_:APlayStringMessage = null;
         var _loc6_:ByteArray = null;
         var _loc7_:APlayBinaryMessage = null;
         var _loc8_:Object = null;
         var _loc9_:APlayStringMessage = null;
         var _loc10_:String = null;
         var _loc11_:LowLevelIntroductionMessage = null;
         var _loc12_:int = 0;
         var _loc13_:LowLevelPongMessage = null;
         var _loc14_:int = 0;
         if(param1.getBytesAvailable() < 5)
         {
            return null;
         }
         var _loc2_:uint = param1.getPosition();
         var _loc3_:int = param1.read_int8();
         switch(_loc3_)
         {
            case APlayMessageType.PAYLOADGZIP:
               return true;
            case APlayMessageType.PAYLOAD:
               if(param1.PrefixedDataAvailable())
               {
                  _loc4_ = param1.read_String();
                  _loc5_ = new APlayStringMessage();
                  _loc5_.DataAsString = _loc4_;
                  return _loc5_;
               }
               param1.setPosition(_loc2_);
               return null;
               break;
            case APlayMessageType.MSGTYPE_PAYLOAD_BINARY_JSON:
               if(param1.PrefixedDataAvailable())
               {
                  _loc6_ = param1.read_ByteArray();
                  _loc7_ = new APlayBinaryMessage();
                  _loc7_.startReading(_loc6_);
                  _loc8_ = _loc7_.readJson();
                  _loc9_ = new APlayStringMessage();
                  _loc9_.DataAsJson = _loc8_;
                  return _loc9_;
               }
               param1.setPosition(_loc2_);
               return null;
               break;
            case APlayMessageType.LOWLEVEL_INTRODUCTION:
               if(param1.PrefixedDataAvailable())
               {
                  _loc10_ = param1.read_String();
                  _loc11_ = new LowLevelIntroductionMessage();
                  _loc11_.AddressString = _loc10_;
                  return _loc11_;
               }
               param1.setPosition(_loc2_);
               return null;
               break;
            case APlayMessageType.LOWLEVEL_PING:
               if(param1.PrefixedDataAvailable())
               {
                  _loc12_ = param1.read_int32();
                  _loc13_ = new LowLevelPongMessage();
                  _loc13_.SendTime = param1.read_int64();
                  _loc14_ = param1.read_int32();
                  return _loc13_;
               }
               param1.setPosition(_loc2_);
               return null;
               break;
            default:
               throw new Error("unsupported message type");
         }
      }
   }
}

