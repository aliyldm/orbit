package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class RogueLiteModifierSelectionView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _title:String;
      
      private var _view:Coreponent;
      
      private var _visible:Boolean;
      
      private var _active:Boolean;
      
      public function RogueLiteModifierSelectionView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("root.modifier_select_body") as Coreponent;
      }
      
      public function get title() : String
      {
         return "astral_ascension_tab_hazard_select";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
   }
}

