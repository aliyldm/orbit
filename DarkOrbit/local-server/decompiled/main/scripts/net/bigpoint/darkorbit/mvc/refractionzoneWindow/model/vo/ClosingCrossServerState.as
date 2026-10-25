package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.RzoneClosingMapStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   
   public class ClosingCrossServerState extends BaseCrossServerState
   {
      
      public const timer:BindableCountDown = new BindableCountDown(60);
      
      public function ClosingCrossServerState()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.timer.stop();
      }
      
      private function get currentState() : RzoneClosingMapStatusModule
      {
         return _state as RzoneClosingMapStatusModule;
      }
      
      override public function set state(param1:RzoneStatusModule) : void
      {
         super.state = param1;
         this.timer.value = this.currentState.timeLeft;
      }
   }
}

