package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReturneeLoginRewardClaimRequest implements IModule
   {
      
      private static var _instance:ReturneeLoginRewardClaimRequest;
      
      public var isClaimDaily:Boolean = false;
      
      public function ReturneeLoginRewardClaimRequest(param1:Boolean = false)
      {
         super();
         this.isClaimDaily = param1;
      }
      
      public static function get instance() : ReturneeLoginRewardClaimRequest
      {
         return _instance || (_instance = new ReturneeLoginRewardClaimRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10357;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isClaimDaily = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10357);
         param1.writeBoolean(this.isClaimDaily);
      }
   }
}

