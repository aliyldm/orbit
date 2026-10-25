package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class OfferRequest implements IModule
   {
      
      private static var _instance:OfferRequest;
      
      public var packageName:String = "";
      
      public var acceptedOffer:Boolean = false;
      
      public function OfferRequest(param1:String = "", param2:Boolean = false)
      {
         super();
         this.packageName = param1;
         this.acceptedOffer = param2;
      }
      
      public static function get instance() : OfferRequest
      {
         return _instance || (_instance = new OfferRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5390;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.packageName = param1.readUTF();
         this.acceptedOffer = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5390);
         param1.writeUTF(this.packageName);
         param1.writeBoolean(this.acceptedOffer);
      }
   }
}

