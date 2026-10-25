package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginItemRewardModule;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginRewardDayInfoCommand;
   import net.bigpoint.darkorbit.com.module.ReturneeLoginRewardInfoCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model.MiniClientRewardVO;
   
   public class ReturneeLoginCalendarData extends EventDispatcher
   {
      
      public const countdownTimer:BindableCountDown = new BindableCountDown();
      
      public const claimable:BindableBoolean = new BindableBoolean();
      
      private var _calendarList:Vector.<MiniClientRewardVO> = new Vector.<MiniClientRewardVO>(0);
      
      private var _daysClaimed:int;
      
      public function ReturneeLoginCalendarData()
      {
         super();
      }
      
      public function updateInfo(param1:ReturneeLoginRewardInfoCommand) : void
      {
         this.countdownTimer.value = param1.timeToEndEvent;
         this.updateCalendarList(param1.rewardList);
         this._daysClaimed = param1.daysClaimed;
         this.updateClaimed();
         this.claimable.value = param1.isClaimable;
      }
      
      public function updateDay(param1:ReturneeLoginRewardDayInfoCommand) : void
      {
         this._daysClaimed = param1.daysClaimed;
         this.updateClaimed();
         this.claimable.value = param1.isClaimable;
      }
      
      public function get calendarList() : Vector.<MiniClientRewardVO>
      {
         return this._calendarList;
      }
      
      private function updateCalendarList(param1:Vector.<ReturneeLoginItemRewardModule>) : void
      {
         this._calendarList = new Vector.<MiniClientRewardVO>();
         var _loc2_:* = 0;
         while(_loc2_ < param1.length)
         {
            this._calendarList.push(new MiniClientRewardVO(param1[_loc2_].lootId,param1[_loc2_].amount,_loc2_ + 1,_loc2_ + 1 == param1.length));
            _loc2_++;
         }
      }
      
      private function updateClaimed() : void
      {
         var _loc1_:MiniClientRewardVO = null;
         for each(_loc1_ in this._calendarList)
         {
            _loc1_.isClaimed = _loc1_.index <= this._daysClaimed;
         }
      }
   }
}

