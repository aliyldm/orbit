package net.bigpoint.darkorbit.com.module.porting.activityevent.unityclientreward
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ClaimUnityClientRewardRequest implements IModule
   {
      
      private static var _instance:ClaimUnityClientRewardRequest;
      
      public var questId:int = 0;
      
      public function ClaimUnityClientRewardRequest(param1:int = 0)
      {
         super();
         this.questId = param1;
      }
      
      public static function get instance() : ClaimUnityClientRewardRequest
      {
         return _instance || (_instance = new ClaimUnityClientRewardRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19132;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.questId = param1.readInt();
         this.questId = this.questId >>> 3 % 32 | this.questId << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19132);
         param1.writeInt(this.questId << 3 % 32 | this.questId >>> 32 - 3 % 32);
      }
   }
}

