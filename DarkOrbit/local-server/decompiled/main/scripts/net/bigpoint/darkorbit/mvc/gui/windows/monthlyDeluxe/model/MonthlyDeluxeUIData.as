package net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeDayInfoCommand;
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeInfoCommand;
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeRewardModule;
   import net.bigpoint.darkorbit.com.module.MonthlyDeluxeTimeInfoCommand;
   
   public class MonthlyDeluxeUIData extends EventDispatcher
   {
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      public const hasPass:BindableBoolean = new BindableBoolean();
      
      public const claimable:BindableBoolean = new BindableBoolean();
      
      private var _rewards:Vector.<MonthlyDeluxeVO> = new Vector.<MonthlyDeluxeVO>(0);
      
      public function MonthlyDeluxeUIData()
      {
         super();
      }
      
      public function updateInfo(param1:MonthlyDeluxeInfoCommand) : void
      {
         this.updateTimeInfo(param1.timeInfoCommand);
         this.updateReward(param1.rewardList);
         this.updateDayInfo(param1.dayInfoCommand);
      }
      
      public function updateDayInfo(param1:MonthlyDeluxeDayInfoCommand) : void
      {
         if(this.hasPass.value)
         {
            this.claimable.value = param1.isClaimable;
            this.updateRewardClaimed(param1.daysClaimed,param1.today);
         }
      }
      
      public function updateTimeInfo(param1:MonthlyDeluxeTimeInfoCommand) : void
      {
         this.timer.value = param1.timeToPassEnd;
         this.hasPass.value = param1.timeToPassEnd > 0 ? true : false;
      }
      
      private function updateReward(param1:Vector.<MonthlyDeluxeRewardModule>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._rewards[_loc2_] = new MonthlyDeluxeVO(param1[_loc2_].lootId,param1[_loc2_].amount,_loc2_ + 1);
            _loc2_++;
         }
      }
      
      private function updateRewardClaimed(param1:Vector.<int>, param2:int) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ <= param2)
         {
            if(param1.indexOf(_loc3_) == -1)
            {
               if(_loc3_ == param2 && this.claimable.value)
               {
                  this._rewards[_loc3_].state = MonthlyDeluxeVO.TODAY;
               }
               else
               {
                  this._rewards[_loc3_].state = MonthlyDeluxeVO.MISSED;
               }
            }
            else
            {
               this._rewards[_loc3_].state = MonthlyDeluxeVO.CLAIMED;
            }
            _loc3_++;
         }
      }
      
      public function get rewardList() : Vector.<MonthlyDeluxeVO>
      {
         return this._rewards;
      }
   }
}

