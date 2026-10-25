package net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.MiniClientItemRewardModule;
   import net.bigpoint.darkorbit.com.module.MiniClientRewardDayInfoCommand;
   import net.bigpoint.darkorbit.com.module.MiniClientRewardInfoCommand;
   
   public class MiniClientRewardUIData extends EventDispatcher
   {
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      public const claimable:BindableBoolean = new BindableBoolean();
      
      private var dayClaimed:int;
      
      private var _rewards:Vector.<MiniClientRewardVO> = new Vector.<MiniClientRewardVO>(0);
      
      public function MiniClientRewardUIData()
      {
         super();
      }
      
      public function updateInfo(param1:MiniClientRewardInfoCommand) : void
      {
         this.updateTimer(param1.timeToEndEvent);
         this.updateReward(param1.rewardList);
         this.updateRewardClaimed(param1.daysClaimed);
         this.dayClaimed = param1.daysClaimed;
         this.claimable.value = param1.isClaimable;
      }
      
      public function updateDay(param1:MiniClientRewardDayInfoCommand) : void
      {
         this.updateRewardClaimed(param1.daysClaimed);
         this.dayClaimed = param1.daysClaimed;
         this.claimable.value = param1.isClaimable;
      }
      
      private function updateReward(param1:Vector.<MiniClientItemRewardModule>) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            this._rewards[_loc2_] = new MiniClientRewardVO(param1[_loc2_].lootId,param1[_loc2_].amount,_loc2_ + 1,_loc2_ + 1 == param1.length,param1[_loc2_].special);
            _loc2_++;
         }
      }
      
      private function updateRewardClaimed(param1:int) : void
      {
         var _loc2_:* = 0;
         while(_loc2_ < this._rewards.length)
         {
            this._rewards[_loc2_].isClaimed = _loc2_ + 1 <= param1;
            _loc2_++;
         }
      }
      
      private function updateTimer(param1:Number) : void
      {
         this.timer.value = param1;
      }
      
      public function get rewardList() : Vector.<MiniClientRewardVO>
      {
         return this._rewards;
      }
   }
}

