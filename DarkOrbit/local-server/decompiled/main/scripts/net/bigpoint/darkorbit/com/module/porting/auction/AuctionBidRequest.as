package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AuctionBidRequest implements IModule
   {
      
      private static var _instance:AuctionBidRequest;
      
      public var lootId:String = "";
      
      public var type:String = "";
      
      public var price:Number = 0;
      
      public function AuctionBidRequest(param1:String = "", param2:String = "", param3:Number = 0)
      {
         super();
         this.lootId = param2;
         this.type = param1;
         this.price = param3;
      }
      
      public static function get instance() : AuctionBidRequest
      {
         return _instance || (_instance = new AuctionBidRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 22621;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.type = param1.readUTF();
         this.price = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(22621);
         param1.writeUTF(this.lootId);
         param1.writeUTF(this.type);
         param1.writeDouble(this.price);
      }
   }
}

