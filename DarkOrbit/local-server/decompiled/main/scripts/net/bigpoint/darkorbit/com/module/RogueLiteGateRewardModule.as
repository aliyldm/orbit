package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteGateRewardModule implements IModule
   {
      
      private static var _instance:RogueLiteGateRewardModule;
      
      public var level:int = 0;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public function RogueLiteGateRewardModule(param1:String = "", param2:int = 0, param3:int = 0)
      {
         super();
         this.level = param2;
         this.lootId = param1;
         this.amount = param3;
      }
      
      public static function get instance() : RogueLiteGateRewardModule
      {
         return _instance || (_instance = new RogueLiteGateRewardModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11730;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.level = param1.readInt();
         this.level = this.level << 7 % 32 | this.level >>> 32 - 7 % 32;
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 9 % 32 | this.amount >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11730);
         param1.writeInt(this.level >>> 7 % 32 | this.level << 32 - 7 % 32);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount >>> 9 % 32 | this.amount << 32 - 9 % 32);
      }
   }
}

