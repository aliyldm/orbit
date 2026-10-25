package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArmoryUnlockSelectGroupRequest implements IModule
   {
      
      private static var _instance:ArmoryUnlockSelectGroupRequest;
      
      public var group:int = 0;
      
      public function ArmoryUnlockSelectGroupRequest(param1:int = 0)
      {
         super();
         this.group = param1;
      }
      
      public static function get instance() : ArmoryUnlockSelectGroupRequest
      {
         return _instance || (_instance = new ArmoryUnlockSelectGroupRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28987;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.group = param1.readInt();
         this.group = this.group >>> 4 % 32 | this.group << 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(28987);
         param1.writeInt(this.group << 4 % 32 | this.group >>> 32 - 4 % 32);
      }
   }
}

