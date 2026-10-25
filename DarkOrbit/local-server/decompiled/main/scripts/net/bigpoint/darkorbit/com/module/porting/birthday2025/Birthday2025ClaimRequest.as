package net.bigpoint.darkorbit.com.module.porting.birthday2025
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class Birthday2025ClaimRequest implements IModule
   {
      
      private static var _instance:Birthday2025ClaimRequest;
      
      public var rewardLevel:int = 0;
      
      public function Birthday2025ClaimRequest(param1:int = 0)
      {
         super();
         this.rewardLevel = param1;
      }
      
      public static function get instance() : Birthday2025ClaimRequest
      {
         return _instance || (_instance = new Birthday2025ClaimRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5351;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.rewardLevel = param1.readInt();
         this.rewardLevel = this.rewardLevel << 2 % 32 | this.rewardLevel >>> 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5351);
         param1.writeInt(this.rewardLevel >>> 2 % 32 | this.rewardLevel << 32 - 2 % 32);
      }
   }
}

