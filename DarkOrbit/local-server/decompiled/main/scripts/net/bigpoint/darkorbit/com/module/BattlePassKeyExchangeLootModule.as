package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BattlePassKeyExchangeLootModule implements IModule
   {
      
      private static var _instance:BattlePassKeyExchangeLootModule;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public function BattlePassKeyExchangeLootModule(param1:String = "", param2:int = 0)
      {
         super();
         this.lootId = param1;
         this.amount = param2;
      }
      
      public static function get instance() : BattlePassKeyExchangeLootModule
      {
         return _instance || (_instance = new BattlePassKeyExchangeLootModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -814;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 9 % 32 | this.amount >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-814);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount >>> 9 % 32 | this.amount << 32 - 9 % 32);
      }
   }
}

