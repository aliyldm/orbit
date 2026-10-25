package net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.uistructures
{
   import net.bigpoint.darkorbit.fui.system.modules.UISetupModule;
   
   public class HintOverviewWindowSetup extends UISetupModule
   {
      
      public function HintOverviewWindowSetup()
      {
         super();
      }
      
      override protected function registerTextStyles() : void
      {
         HintWindowOverviewTextStyles.init();
      }
   }
}

