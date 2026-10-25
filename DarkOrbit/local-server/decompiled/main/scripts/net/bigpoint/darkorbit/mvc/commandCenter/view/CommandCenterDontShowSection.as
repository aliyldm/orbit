package net.bigpoint.darkorbit.mvc.commandCenter.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class CommandCenterDontShowSection
   {
      
      private var _viewCache:FuiComponentSelectorCache;
      
      public function CommandCenterDontShowSection(param1:Sprite)
      {
         super();
         this._viewCache = new FuiComponentSelectorCache(param1);
      }
      
      public function get checkbox() : CheckBox
      {
         return this._viewCache.selectComponent("contentContainer.dontShowContainer.wrapper.dontShowCheckbox") as CheckBox;
      }
   }
}

