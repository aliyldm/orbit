package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   
   public class ExpeditionInfoTabView4 implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      private var _view:Coreponent;
      
      private var _rank_list:ItemList;
      
      private var _self_rank_label:Label;
      
      private var _self_name_label:Label;
      
      private var _self_level_label:Label;
      
      private var _self_time_label:Label;
      
      public function ExpeditionInfoTabView4(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab4") as Coreponent;
         this._rank_list = this._cache.selectComponent("tab4.rank_list") as ItemList;
         this._self_rank_label = this._cache.selectComponent("tab4.self_rank.self_rank_label") as Label;
         this._self_name_label = this._cache.selectComponent("tab4.self_rank.self_name_label") as Label;
         this._self_level_label = this._cache.selectComponent("tab4.self_rank.self_level_label") as Label;
         this._self_time_label = this._cache.selectComponent("tab4.self_rank.self_time_label") as Label;
         this.drawLine();
      }
      
      private function drawLine() : void
      {
         var _loc1_:Shape = null;
         _loc1_ = new Shape();
         _loc1_.graphics.lineStyle(2,16771584,1);
         _loc1_.graphics.beginFill(16771584,1);
         _loc1_.graphics.moveTo(1,0);
         _loc1_.graphics.lineTo(814,0);
         _loc1_.graphics.endFill();
         _loc1_.x = 15;
         _loc1_.y = 449;
         this._view.addChild(_loc1_);
      }
      
      public function get title() : String
      {
         return "window_dse_rank";
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
      
      public function get rank_list() : ItemList
      {
         return this._rank_list;
      }
      
      public function get self_rank_label() : Label
      {
         return this._self_rank_label;
      }
      
      public function get self_name_label() : Label
      {
         return this._self_name_label;
      }
      
      public function get self_level_label() : Label
      {
         return this._self_level_label;
      }
      
      public function get self_time_label() : Label
      {
         return this._self_time_label;
      }
   }
}

