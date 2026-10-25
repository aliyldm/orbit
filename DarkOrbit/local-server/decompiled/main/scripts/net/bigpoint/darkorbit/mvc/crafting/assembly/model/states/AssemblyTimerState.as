package net.bigpoint.darkorbit.mvc.crafting.assembly.model.states
{
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.AssemblyRecipeBuildStatusModule;
   
   public class AssemblyTimerState extends AbstractAssemblyState
   {
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      public function AssemblyTimerState(param1:AssemblyRecipeBuildStatusModule)
      {
         this.timer.value = param1.remainingTimeMillis / 1000;
         super(param1);
      }
      
      public function get buildAmount() : int
      {
         return (status as AssemblyRecipeBuildStatusModule).buildAmount;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.timer.changed.removeAll();
      }
   }
}

