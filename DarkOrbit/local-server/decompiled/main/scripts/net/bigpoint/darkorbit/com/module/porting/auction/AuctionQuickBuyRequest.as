package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AuctionQuickBuyRequest implements IModule
   {
      
      private static var _instance:AuctionQuickBuyRequest;
      
      public var lootId:String = "";
      
      public var type:String = "";
      
      public function AuctionQuickBuyRequest(param1:String = "", param2:String = "")
      {
         super();
         this.lootId = param2;
         this.type = param1;
      }
      
      public static function get instance() : AuctionQuickBuyRequest
      {
         return _instance || (_instance = new AuctionQuickBuyRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24829;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.type = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24829);
         param1.writeUTF(this.lootId);
         param1.writeUTF(this.type);
      }
   }
}

