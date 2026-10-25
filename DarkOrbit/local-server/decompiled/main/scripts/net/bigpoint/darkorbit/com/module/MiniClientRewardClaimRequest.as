package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class MiniClientRewardClaimRequest implements IModule
   {
      
      private static var _instance:MiniClientRewardClaimRequest;
      
      public function MiniClientRewardClaimRequest()
      {
         super();
      }
      
      public static function get instance() : MiniClientRewardClaimRequest
      {
         return _instance || (_instance = new MiniClientRewardClaimRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13545;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(13545);
      }
   }
}

