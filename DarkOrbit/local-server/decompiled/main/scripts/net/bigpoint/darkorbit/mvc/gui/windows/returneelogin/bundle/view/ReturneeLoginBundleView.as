package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class ReturneeLoginBundleView implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      public function ReturneeLoginBundleView(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("bundle") as Coreponent;
         this.bundleList.itemDataAssigner = ReturneeLoginBundleItemAssigner;
      }
      
      public function get title() : String
      {
         return "returnee_login_tab_bundle";
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
      
      public function get header() : Label
      {
         return this._cache.selectComponent("bundle.header") as Label;
      }
      
      public function get info() : Label
      {
         return this._cache.selectComponent("bundle.info") as Label;
      }
      
      private function get bundleList() : ItemList
      {
         return this._cache.selectComponent("bundle.bundle_list") as ItemList;
      }
      
      public function set bundleGrid(param1:Vector.<String>) : void
      {
         this.bundleList.list = new VectorCollection(param1);
      }
      
      public function get countdownTimer() : Label
      {
         return this._cache.selectComponent("bundle.bottom.countdown_timer") as Label;
      }
      
      public function get buyBtn() : Button
      {
         return this._cache.selectComponent("bundle.bottom.buy_btn") as Button;
      }
   }
}

