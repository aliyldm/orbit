package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.porting.events.EventLootShowCommand;
   
   public class ArmoryUnlockLootShowCommand extends EventLootShowCommand
   {
      
      private static var _instance:ArmoryUnlockLootShowCommand;
      
      public var showShipIcon:Boolean = false;
      
      public var line:int = 0;
      
      public function ArmoryUnlockLootShowCommand(param1:String = "", param2:int = 0, param3:String = "", param4:int = 0, param5:Boolean = false)
      {
         super(param1,param2,param3);
         this.showShipIcon = param5;
         this.line = param4;
      }
      
      public static function get instance() : ArmoryUnlockLootShowCommand
      {
         return _instance || (_instance = new ArmoryUnlockLootShowCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 27718;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.showShipIcon = param1.readBoolean();
         this.line = param1.readInt();
         this.line = this.line >>> 7 % 32 | this.line << 32 - 7 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(27718);
         super.write(param1);
         param1.writeBoolean(this.showShipIcon);
         param1.writeInt(this.line << 7 % 32 | this.line >>> 32 - 7 % 32);
      }
   }
}

