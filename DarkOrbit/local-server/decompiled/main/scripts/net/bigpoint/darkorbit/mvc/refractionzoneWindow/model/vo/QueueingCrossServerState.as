package net.bigpoint.darkorbit.mvc.refractionzoneWindow.model.vo
{
   import com.bigpoint.utils.bindables.BindableCounter;
   import net.bigpoint.darkorbit.com.module.RzoneStatusModule;
   
   public class QueueingCrossServerState extends BaseCrossServerState
   {
      
      public const timer:BindableCounter = new BindableCounter();
      
      public function QueueingCrossServerState()
      {
         super();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.timer.stop();
      }
      
      override public function set state(param1:RzoneStatusModule) : void
      {
         super.state = param1;
      }
   }
}

