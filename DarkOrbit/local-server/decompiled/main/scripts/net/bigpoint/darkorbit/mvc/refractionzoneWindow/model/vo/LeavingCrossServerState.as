package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.RzoneLeavingStatusModule;
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   
   public class LeavingCrossServerState extends BaseCrossServerState
   {
      
      public const countDown:BindableCountDown = new BindableCountDown();
      
      public function LeavingCrossServerState()
      {
         super();
      }
      
      override public function set state(param1:RzoneStatusModule) : void
      {
         super.state = param1;
         this.countDown.value = (param1 as RzoneLeavingStatusModule).timeInSec;
      }
   }
}

