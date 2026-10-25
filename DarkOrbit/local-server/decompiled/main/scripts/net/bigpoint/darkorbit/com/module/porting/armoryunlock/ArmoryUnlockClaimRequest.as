package net.bigpoint.darkorbit.com.module.porting.armoryunlock
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ArmoryUnlockClaimRequest implements IModule
   {
      
      private static var _instance:ArmoryUnlockClaimRequest;
      
      public var index:int = 0;
      
      public function ArmoryUnlockClaimRequest(param1:int = 0)
      {
         super();
         this.index = param1;
      }
      
      public static function get instance() : ArmoryUnlockClaimRequest
      {
         return _instance || (_instance = new ArmoryUnlockClaimRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -2172;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.index = param1.readInt();
         this.index = this.index >>> 14 % 32 | this.index << 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-2172);
         param1.writeInt(this.index << 14 % 32 | this.index >>> 32 - 14 % 32);
      }
   }
}

