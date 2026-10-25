package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.RzoneConfirmationStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   
   public class ConfirmationCrossServerState extends BaseCrossServerState
   {
      
      public const timer:BindableCountDown = new BindableCountDown(60);
      
      public function ConfirmationCrossServerState()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.timer.stop();
      }
      
      private function get currentState() : RzoneConfirmationStatusModule
      {
         return _state as RzoneConfirmationStatusModule;
      }
      
      override public function set state(param1:RzoneStatusModule) : void
      {
         super.state = param1;
         this.timer.value = this.currentState.timer;
      }
   }
}

