package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class DispatchRewardModule extends RewardContentModule
   {
      
      private static var _instance:DispatchRewardModule;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public var chance:int = 0;
      
      public function DispatchRewardModule(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.lootId = param1;
         this.amount = param2;
         this.chance = param3;
      }
      
      public static function get instance() : DispatchRewardModule
      {
         return _instance || (_instance = new DispatchRewardModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -24143;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 11 % 32 | this.amount >>> 32 - 11 % 32;
         this.chance = param1.readShort();
         this.chance = 0xFFFF & ((0xFFFF & this.chance) >>> 9 % 16 | (0xFFFF & this.chance) << 16 - 9 % 16);
         this.chance = this.chance > 32767 ? int(this.chance - 65536) : this.chance;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-24143);
         super.write(param1);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount >>> 11 % 32 | this.amount << 32 - 11 % 32);
         param1.writeShort(0xFFFF & ((0xFFFF & this.chance) << 9 % 16 | (0xFFFF & this.chance) >>> 16 - 9 % 16));
      }
   }
}

