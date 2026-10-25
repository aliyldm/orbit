package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AuctionHistoryCommand implements IModule
   {
      
      private static var _instance:AuctionHistoryCommand;
      
      public var group:String = "";
      
      public var winnerId:int = 0;
      
      public var currendBid:Number = 0;
      
      public var auctionStartTime:String = "";
      
      public var lootId:String = "";
      
      public var type:String = "";
      
      public var winnerName:String = "";
      
      public function AuctionHistoryCommand(param1:String = "", param2:String = "", param3:String = "", param4:int = 0, param5:Number = 0, param6:String = "", param7:String = "")
      {
         super();
         this.group = param7;
         this.winnerId = param4;
         this.currendBid = param5;
         this.auctionStartTime = param6;
         this.lootId = param1;
         this.type = param2;
         this.winnerName = param3;
      }
      
      public static function get instance() : AuctionHistoryCommand
      {
         return _instance || (_instance = new AuctionHistoryCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 24589;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.group = param1.readUTF();
         this.winnerId = param1.readInt();
         this.winnerId = this.winnerId >>> 13 % 32 | this.winnerId << 32 - 13 % 32;
         this.currendBid = param1.readDouble();
         this.auctionStartTime = param1.readUTF();
         this.lootId = param1.readUTF();
         this.type = param1.readUTF();
         this.winnerName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(24589);
         param1.writeUTF(this.group);
         param1.writeInt(this.winnerId << 13 % 32 | this.winnerId >>> 32 - 13 % 32);
         param1.writeDouble(this.currendBid);
         param1.writeUTF(this.auctionStartTime);
         param1.writeUTF(this.lootId);
         param1.writeUTF(this.type);
         param1.writeUTF(this.winnerName);
      }
   }
}

