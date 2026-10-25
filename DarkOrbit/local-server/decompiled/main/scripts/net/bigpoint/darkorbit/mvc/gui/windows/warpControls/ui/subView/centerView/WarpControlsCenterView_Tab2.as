package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.ui.subView.centerView
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class WarpControlsCenterView_Tab2
   {
      
      private var _up_list:ItemList;
      
      private var _down_list:ItemList;
      
      private var _uiCache:FuiComponentSelectorCache;
      
      private var _up_title_label:Label;
      
      private var _down_title_label:Label;
      
      private var _view:Sprite;
      
      public function WarpControlsCenterView_Tab2(param1:Sprite)
      {
         super();
         this._view = param1;
         this._uiCache = new FuiComponentSelectorCache(param1);
         this._up_list = this._uiCache.selectComponent("up_list_view.center_view_up_list") as ItemList;
         this._down_list = this._uiCache.selectComponent("down_list_view.center_view_down_list") as ItemList;
         this._up_title_label = this._uiCache.selectComponent("up_list_view.center_view_up_label") as Label;
         this._down_title_label = this._uiCache.selectComponent("down_list_view.center_view_down_label") as Label;
         this.drawCenterLine();
      }
      
      public function drawCenterLine() : void
      {
         var _loc1_:Object = {
            "startP":new Point(0,0),
            "endP":new Point(0,308)
         };
         var _loc2_:Object = {
            "startP":new Point(0,150),
            "endP":new Point(260,150)
         };
         var _loc3_:Object = {
            "startP":new Point(260,0),
            "endP":new Point(260,308)
         };
         var _loc4_:Shape = new Shape();
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.lineStyle(1,2651280);
         _loc5_.beginFill(2651280,1);
         _loc5_.moveTo(_loc1_.startP.x,_loc1_.startP.y);
         _loc5_.lineTo(_loc1_.endP.x,_loc1_.endP.y);
         _loc5_.moveTo(_loc2_.startP.x,_loc2_.startP.y);
         _loc5_.lineTo(_loc2_.endP.x,_loc2_.endP.y);
         _loc5_.moveTo(_loc3_.startP.x,_loc3_.startP.y);
         _loc5_.lineTo(_loc3_.endP.x,_loc3_.endP.y);
         _loc5_.endFill();
         this._view.addChild(_loc4_);
      }
      
      public function get up_scroll_bar() : Scrollbar
      {
         return this._uiCache.selectComponent("up_list_view.up_scroll_bar") as Scrollbar;
      }
      
      public function get down_scroll_bar() : Scrollbar
      {
         return this._uiCache.selectComponent("down_list_view.down_scroll_bar") as Scrollbar;
      }
      
      public function get up_title_label() : Label
      {
         return this._up_title_label;
      }
      
      public function get down_title_label() : Label
      {
         return this._down_title_label;
      }
      
      public function get upList() : ItemList
      {
         return this._up_list;
      }
      
      public function get dowList() : ItemList
      {
         return this._down_list;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._view.visible = param1;
      }
   }
}

