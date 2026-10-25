package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AuctionDataCommand implements IModule
   {
      
      private static var _instance:AuctionDataCommand;
      
      public var instantBuy:Boolean = false;
      
      public var price:Number = 0;
      
      public var highestBid:Number = 0;
      
      public var highestBidderName:String = "";
      
      public var id:String = "";
      
      public var myBid:Number = 0;
      
      public var type:String = "";
      
      public var highestBidderId:int = 0;
      
      public var group:String = "";
      
      public var amount:int = 0;
      
      public function AuctionDataCommand(param1:String = "", param2:String = "", param3:String = "", param4:int = 0, param5:Number = 0, param6:Number = 0, param7:Boolean = false, param8:Number = 0, param9:String = "", param10:int = 0)
      {
         super();
         this.instantBuy = param7;
         this.price = param8;
         this.highestBid = param5;
         this.highestBidderName = param3;
         this.id = param1;
         this.myBid = param6;
         this.type = param9;
         this.highestBidderId = param4;
         this.group = param2;
         this.amount = param10;
      }
      
      public static function get instance() : AuctionDataCommand
      {
         return _instance || (_instance = new AuctionDataCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -8103;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 41;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.instantBuy = param1.readBoolean();
         this.price = param1.readDouble();
         this.highestBid = param1.readDouble();
         this.highestBidderName = param1.readUTF();
         this.id = param1.readUTF();
         this.myBid = param1.readDouble();
         this.type = param1.readUTF();
         this.highestBidderId = param1.readInt();
         this.highestBidderId = this.highestBidderId << 3 % 32 | this.highestBidderId >>> 32 - 3 % 32;
         this.group = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount >>> 2 % 32 | this.amount << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-8103);
         param1.writeBoolean(this.instantBuy);
         param1.writeDouble(this.price);
         param1.writeDouble(this.highestBid);
         param1.writeUTF(this.highestBidderName);
         param1.writeUTF(this.id);
         param1.writeDouble(this.myBid);
         param1.writeUTF(this.type);
         param1.writeInt(this.highestBidderId >>> 3 % 32 | this.highestBidderId << 32 - 3 % 32);
         param1.writeUTF(this.group);
         param1.writeInt(this.amount << 2 % 32 | this.amount >>> 32 - 2 % 32);
      }
   }
}

