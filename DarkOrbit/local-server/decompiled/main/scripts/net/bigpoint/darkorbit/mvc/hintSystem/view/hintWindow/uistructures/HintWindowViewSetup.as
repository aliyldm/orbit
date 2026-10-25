package net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.uistructures
{
   import net.bigpoint.darkorbit.fui.system.modules.UISetupModule;
   
   public class HintWindowViewSetup extends UISetupModule
   {
      
      public function HintWindowViewSetup()
      {
         super();
      }
      
      override protected function registerTextStyles() : void
      {
         HintWindowTextStylesStructure.init();
      }
   }
}

