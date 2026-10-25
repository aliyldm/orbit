package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionRewardCommand implements IModule
   {
      
      private static var _instance:ExpeditionRewardCommand;
      
      public var lootId:String = "";
      
      public var amount:int = 0;
      
      public function ExpeditionRewardCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.lootId = param1;
         this.amount = param2;
      }
      
      public static function get instance() : ExpeditionRewardCommand
      {
         return _instance || (_instance = new ExpeditionRewardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17648;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootId = param1.readUTF();
         this.amount = param1.readInt();
         this.amount = this.amount << 8 % 32 | this.amount >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17648);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.amount >>> 8 % 32 | this.amount << 32 - 8 % 32);
      }
   }
}

