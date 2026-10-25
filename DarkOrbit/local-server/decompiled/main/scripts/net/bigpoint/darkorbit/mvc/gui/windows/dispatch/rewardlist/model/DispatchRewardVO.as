package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.rewardlist.model
{
   import net.bigpoint.darkorbit.com.module.DispatchRewardModule;
   
   public class DispatchRewardVO
   {
      
      private var _rewardModule:DispatchRewardModule;
      
      public function DispatchRewardVO()
      {
         super();
      }
      
      public function get rewardModule() : DispatchRewardModule
      {
         return this._rewardModule;
      }
      
      public function set rewardModule(param1:DispatchRewardModule) : void
      {
         this._rewardModule = param1;
      }
   }
}

