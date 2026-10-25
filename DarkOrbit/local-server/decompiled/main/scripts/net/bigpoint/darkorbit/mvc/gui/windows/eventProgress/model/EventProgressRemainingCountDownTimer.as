package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   
   public class EventProgressRemainingCountDownTimer
   {
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      public function EventProgressRemainingCountDownTimer()
      {
         super();
      }
      
      public function start(param1:Number) : void
      {
         this.timer.value = param1 / 1000;
      }
   }
}

