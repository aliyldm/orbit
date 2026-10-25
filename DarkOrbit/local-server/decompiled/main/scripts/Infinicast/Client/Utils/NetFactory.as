package Infinicast.Client.Utils
{
   import Infinicast.Runtime.APlayStringMessage;
   import Infinicast.Runtime.InfinicastServerAddress;
   
   public class NetFactory
   {
      
      public function NetFactory()
      {
         super();
      }
      
      public static function createMessage() : APlayStringMessage
      {
         return new APlayStringMessage();
      }
      
      public static function createServerAddress(param1:String) : InfinicastServerAddress
      {
         var _loc2_:InfinicastServerAddress = new InfinicastServerAddress();
         _loc2_.Address = param1;
         return _loc2_;
      }
   }
}

