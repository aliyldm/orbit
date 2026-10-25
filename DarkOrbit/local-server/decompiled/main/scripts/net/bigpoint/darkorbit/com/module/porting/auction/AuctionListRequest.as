package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AuctionListRequest implements IModule
   {
      
      private static var _instance:AuctionListRequest;
      
      public var auctionType:String = "";
      
      public function AuctionListRequest(param1:String = "")
      {
         super();
         this.auctionType = param1;
      }
      
      public static function get instance() : AuctionListRequest
      {
         return _instance || (_instance = new AuctionListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4874;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.auctionType = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4874);
         param1.writeUTF(this.auctionType);
      }
   }
}

