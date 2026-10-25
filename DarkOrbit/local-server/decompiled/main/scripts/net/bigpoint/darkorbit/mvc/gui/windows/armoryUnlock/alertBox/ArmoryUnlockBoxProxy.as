package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.alertBox
{
   import net.bigpoint.darkorbit.com.module.RewardModule;
   import net.bigpoint.darkorbit.com.module.porting.armoryunlock.ArmoryUnlockDrawCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   
   public class ArmoryUnlockBoxProxy extends SimpleWindowProxy
   {
      
      public function ArmoryUnlockBoxProxy(param1:String)
      {
         super(param1,new ArmoryUnlockBoxData());
      }
      
      public function get viewData() : ArmoryUnlockBoxData
      {
         return this.data as ArmoryUnlockBoxData;
      }
      
      public function updateViewData(param1:ArmoryUnlockDrawCommand) : void
      {
         var _loc3_:RewardModule = null;
         this.viewData._type = param1.type;
         this.viewData._count = param1.count;
         this.viewData.rewardModuleList.length = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.rewardModuleList.length)
         {
            _loc3_ = param1.rewardModuleList[_loc2_];
            this.viewData.rewardModuleList.push(_loc3_);
            _loc2_++;
         }
         this.viewData.changed.dispatch();
      }
   }
}

