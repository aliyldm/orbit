package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LootModule implements IModule
   {
      
      private static var _instance:LootModule;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public var modifier:String = "";
      
      public function LootModule(param1:String = "", param2:int = 0, param3:String = "")
      {
         super();
         this.lootId = param1;
         this.amount = param2;
         this.modifier = param3;
      }
      
      public static function get instance() : LootModule
      {
         return _instance || (_instance = new LootModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2016;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 6 % 32 | this.amount >>> 32 - 6 % 32;
         this.modifier = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(2016);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount >>> 6 % 32 | this.amount << 32 - 6 % 32);
         param1.writeUTF(this.modifier);
      }
   }
}

