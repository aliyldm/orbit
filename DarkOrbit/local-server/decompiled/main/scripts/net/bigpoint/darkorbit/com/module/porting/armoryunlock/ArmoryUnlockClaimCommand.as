package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArmoryUnlockClaimCommand implements IModule
   {
      
      private static var _instance:ArmoryUnlockClaimCommand;
      
      public var claimed:Boolean = false;
      
      public var index:int = 0;
      
      public function ArmoryUnlockClaimCommand(param1:int = 0, param2:Boolean = false)
      {
         super();
         this.claimed = param2;
         this.index = param1;
      }
      
      public static function get instance() : ArmoryUnlockClaimCommand
      {
         return _instance || (_instance = new ArmoryUnlockClaimCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -16650;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.claimed = param1.readBoolean();
         this.index = param1.readInt();
         this.index = this.index >>> 2 % 32 | this.index << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-16650);
         param1.writeBoolean(this.claimed);
         param1.writeInt(this.index << 2 % 32 | this.index >>> 32 - 2 % 32);
      }
   }
}

