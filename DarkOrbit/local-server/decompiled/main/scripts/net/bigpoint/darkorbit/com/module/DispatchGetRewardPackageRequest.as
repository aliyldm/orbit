package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchGetRewardPackageRequest implements IModule
   {
      
      private static var _instance:DispatchGetRewardPackageRequest;
      
      public var dispatchId:int = 0;
      
      public function DispatchGetRewardPackageRequest(param1:int = 0)
      {
         super();
         this.dispatchId = param1;
      }
      
      public static function get instance() : DispatchGetRewardPackageRequest
      {
         return _instance || (_instance = new DispatchGetRewardPackageRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -31483;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.dispatchId = param1.readInt();
         this.dispatchId = this.dispatchId << 13 % 32 | this.dispatchId >>> 32 - 13 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-31483);
         param1.writeInt(this.dispatchId >>> 13 % 32 | this.dispatchId << 32 - 13 % 32);
      }
   }
}

