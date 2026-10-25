package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CaptainPerkUpgradLevelCostCommand implements IModule
   {
      
      private static var _instance:CaptainPerkUpgradLevelCostCommand;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public function CaptainPerkUpgradLevelCostCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.lootId = param1;
         this.amount = param2;
      }
      
      public static function get instance() : CaptainPerkUpgradLevelCostCommand
      {
         return _instance || (_instance = new CaptainPerkUpgradLevelCostCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20695;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 12 % 32 | this.amount >>> 32 - 12 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-20695);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount >>> 12 % 32 | this.amount << 32 - 12 % 32);
      }
   }
}

