package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer.Tab3ItemList;
   
   public class ExpeditionInfoTabView3 implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _rest_time_label:Label;
      
      private var _list_title:Coreponent;
      
      private var _reward_items_list:ScrollContainer;
      
      private var _scroll_bar:Scrollbar;
      
      private var _tab3List:Tab3ItemList;
      
      public function ExpeditionInfoTabView3(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab3") as Coreponent;
         this._rest_time_label = this._cache.selectComponent("tab3.rest_time_label") as Label;
         this._list_title = this._cache.selectComponent("tab3.list_title") as Coreponent;
         this._reward_items_list = this._cache.selectComponent("tab3.expedition_tab3_reward_items_list") as ScrollContainer;
         this._scroll_bar = this._cache.selectComponent("tab3.expedition_tab3_scroll_bar") as Scrollbar;
         this._tab3List = new Tab3ItemList(this._reward_items_list,this._scroll_bar,{
            "w":835,
            "h":425
         });
         this.drawLine();
      }
      
      private function drawLine() : void
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.lineStyle(1,3265018,0.6);
         _loc1_.graphics.beginFill(3265018,0.6);
         _loc1_.graphics.moveTo(124,1);
         _loc1_.graphics.lineTo(124,18);
         _loc1_.graphics.endFill();
         this._list_title.addChild(_loc1_);
      }
      
      public function get title() : String
      {
         return "window_dse_reward_reward";
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
      
      public function get tab3List() : Tab3ItemList
      {
         return this._tab3List;
      }
      
      public function get scroll_bar() : Scrollbar
      {
         return this._scroll_bar;
      }
      
      public function get rest_time_label() : Label
      {
         return this._rest_time_label;
      }
   }
}

