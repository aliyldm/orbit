package net.bigpoint.darkorbit.mvc.booster.model.boosterItems
{
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.BoosterDetailModule;
   import net.bigpoint.darkorbit.com.module.BoosterPlayerDetailModule;
   
   public class PlayerBoosterItem extends BoosterItem
   {
      
      public const countdown:BindableCountDown = new BindableCountDown();
      
      public function PlayerBoosterItem()
      {
         super();
         this.countdown.complete.add(this.handleTimerComplete);
      }
      
      private function handleTimerComplete() : void
      {
         _owned = false;
      }
      
      override public function update(param1:BoosterDetailModule) : void
      {
         var _loc2_:BoosterPlayerDetailModule = param1 as BoosterPlayerDetailModule;
         this.countdown.value = _loc2_.secondsLeft;
         super.update(param1);
      }
      
      override public function getEffectText(param1:String) : String
      {
         return this.countdown.value > 0 ? TimeFormatter.getSmartFormatedTimeSmall(this.countdown.value) : "";
      }
      
      override public function getPercentage(param1:String) : Number
      {
         if(this.countdown.value == 0)
         {
            return 0;
         }
         return super.getPercentage(param1);
      }
   }
}

