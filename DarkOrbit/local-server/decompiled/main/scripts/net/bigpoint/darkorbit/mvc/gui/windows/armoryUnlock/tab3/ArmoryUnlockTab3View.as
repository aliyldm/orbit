package net.bigpoint.darkorbit.mvc.gui.windows.armoryUnlock.tab3
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class ArmoryUnlockTab3View implements ITabItem
   {
      
      public var _body:Coreponent;
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public function ArmoryUnlockTab3View(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab3") as Coreponent;
         this._body = this._view.selectChild("body") as Coreponent;
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function get title() : String
      {
         return "armoryunlock_tab_reward";
      }
      
      public function get availableExchangeItemList() : ItemList
      {
         return this._cache.selectComponent("tab3.body.list") as ItemList;
      }
      
      public function get shipName() : Label
      {
         return this._cache.selectComponent("tab3.body.shipName") as Label;
      }
      
      public function get visible() : Boolean
      {
         return this._view.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
   }
}

