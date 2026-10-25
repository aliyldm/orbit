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
   
   public class WarpControlsCenterView
   {
      
      private var _up_list:ItemList;
      
      private var _down_list:ItemList;
      
      private var _quantum_list:ItemList;
      
      private var _uiCache:FuiComponentSelectorCache;
      
      private var _up_title_label:Label;
      
      private var _down_title_label:Label;
      
      private var _quantum_title_label:Label;
      
      private var _view:Sprite;
      
      public function WarpControlsCenterView(param1:Sprite)
      {
         super();
         this._view = param1;
         this._uiCache = new FuiComponentSelectorCache(param1);
         this._up_list = this._uiCache.selectComponent("up_list_view.center_view_up_list") as ItemList;
         this._down_list = this._uiCache.selectComponent("down_list_view.center_view_down_list") as ItemList;
         this._quantum_list = this._uiCache.selectComponent("quantum_list_view.center_view_quantum_list") as ItemList;
         this._up_title_label = this._uiCache.selectComponent("up_list_view.center_view_up_label") as Label;
         this._down_title_label = this._uiCache.selectComponent("down_list_view.center_view_down_label") as Label;
         this._quantum_title_label = this._uiCache.selectComponent("quantum_list_view.center_view_quantum_label") as Label;
         this.drawCenterLine();
      }
      
      public function drawCenterLine() : void
      {
         var _loc1_:Object = {
            "startP":new Point(0,0),
            "endP":new Point(0,308)
         };
         var _loc2_:Object = {
            "startP":new Point(0,100),
            "endP":new Point(260,100)
         };
         var _loc3_:Object = {
            "startP":new Point(0,205),
            "endP":new Point(260,205)
         };
         var _loc4_:Object = {
            "startP":new Point(260,0),
            "endP":new Point(260,308)
         };
         var _loc5_:Shape = new Shape();
         var _loc6_:Graphics = _loc5_.graphics;
         _loc6_.lineStyle(1,2651280);
         _loc6_.beginFill(2651280,1);
         _loc6_.moveTo(_loc1_.startP.x,_loc1_.startP.y);
         _loc6_.lineTo(_loc1_.endP.x,_loc1_.endP.y);
         _loc6_.moveTo(_loc2_.startP.x,_loc2_.startP.y);
         _loc6_.lineTo(_loc2_.endP.x,_loc2_.endP.y);
         _loc6_.moveTo(_loc3_.startP.x,_loc3_.startP.y);
         _loc6_.lineTo(_loc3_.endP.x,_loc3_.endP.y);
         _loc6_.moveTo(_loc4_.startP.x,_loc4_.startP.y);
         _loc6_.lineTo(_loc4_.endP.x,_loc4_.endP.y);
         _loc6_.endFill();
         this._view.addChild(_loc5_);
      }
      
      public function get up_scroll_bar() : Scrollbar
      {
         return this._uiCache.selectComponent("up_list_view.up_scroll_bar") as Scrollbar;
      }
      
      public function get down_scroll_bar() : Scrollbar
      {
         return this._uiCache.selectComponent("down_list_view.down_scroll_bar") as Scrollbar;
      }
      
      public function get quantum_scroll_bar() : Scrollbar
      {
         return this._uiCache.selectComponent("quantum_list_view.quantum_scroll_bar") as Scrollbar;
      }
      
      public function get up_title_label() : Label
      {
         return this._up_title_label;
      }
      
      public function get down_title_label() : Label
      {
         return this._down_title_label;
      }
      
      public function get quantum_title_label() : Label
      {
         return this._quantum_title_label;
      }
      
      public function get quantumList() : ItemList
      {
         return this._quantum_list;
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

