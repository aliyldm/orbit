package net.bigpoint.darkorbit.com.module.porting.userMessage
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.LootModule;
   
   public class UserMessageAuctionInfoCommand extends AbsUserMessageInfoCommand
   {
      
      private static var _instance:UserMessageAuctionInfoCommand;
      
      public var lootId:String = "";
      
      public var auctionType:String = "";
      
      public var amount:int = 0;
      
      public var msgType:int = 0;
      
      public var auctionId:int = 0;
      
      public function UserMessageAuctionInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:String = "", param6:Boolean = false, param7:String = "", param8:Number = 0, param9:int = 0, param10:Vector.<LootModule> = null, param11:int = 0, param12:String = "", param13:int = 0, param14:String = "", param15:int = 0, param16:String = "", param17:int = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12);
         this.lootId = param14;
         this.auctionType = param16;
         this.amount = param15;
         this.msgType = param17;
         this.auctionId = param13;
      }
      
      public static function get instance() : UserMessageAuctionInfoCommand
      {
         return _instance || (_instance = new UserMessageAuctionInfoCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -32380;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.lootId = param1.readUTF();
         this.auctionType = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount >>> 16 % 32 | this.amount << 32 - 16 % 32;
         this.msgType = param1.readInt();
         this.msgType = this.msgType << 5 % 32 | this.msgType >>> 32 - 5 % 32;
         this.auctionId = param1.readInt();
         this.auctionId = this.auctionId >>> 1 % 32 | this.auctionId << 32 - 1 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-32380);
         super.write(param1);
         param1.writeUTF(this.lootId);
         param1.writeUTF(this.auctionType);
         param1.writeInt(this.amount << 16 % 32 | this.amount >>> 32 - 16 % 32);
         param1.writeInt(this.msgType >>> 5 % 32 | this.msgType << 32 - 5 % 32);
         param1.writeInt(this.auctionId << 1 % 32 | this.auctionId >>> 32 - 1 % 32);
      }
   }
}

