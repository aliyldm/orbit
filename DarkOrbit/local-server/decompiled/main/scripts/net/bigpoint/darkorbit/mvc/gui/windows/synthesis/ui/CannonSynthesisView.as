package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui
{
   import flash.display.Shape;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.CannonNormalCostGroup;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.CannonShipCostGroup;
   
   public class CannonSynthesisView extends SimpleWindow
   {
      
      private var _uiCache:*;
      
      private var select_item_list_title_label:Label;
      
      private var _selectItemList:Grid;
      
      private var _cannonShipCostGroup:CannonShipCostGroup;
      
      private var _cannonNormalCostGroup:CannonNormalCostGroup;
      
      private var _leftView:Coreponent;
      
      private var _buttonList:ItemList;
      
      private var _upPage:Button;
      
      private var _nextPage:Button;
      
      private var _cannonTypeList:Grid;
      
      private var _selectListScrollBar:Scrollbar;
      
      private var _main:Coreponent;
      
      public function CannonSynthesisView(param1:SimpleWindow)
      {
         super();
         this._uiCache = new FuiComponentSelectorCache(param1.getUIContainer());
         this.init();
      }
      
      public function get buttonList() : ItemList
      {
         return this._buttonList;
      }
      
      public function get upPage() : Button
      {
         return this._upPage;
      }
      
      public function get nextPage() : Button
      {
         return this._nextPage;
      }
      
      public function get cannonTypeList() : Grid
      {
         return this._cannonTypeList;
      }
      
      public function get selectListScrollBar() : Scrollbar
      {
         return this._selectListScrollBar;
      }
      
      public function get main() : Coreponent
      {
         return this._main;
      }
      
      public function get selectTitleLabel() : Label
      {
         return this.select_item_list_title_label;
      }
      
      public function get selectItemLsit() : Grid
      {
         return this._selectItemList;
      }
      
      public function get shipCostGroup() : CannonShipCostGroup
      {
         return this._cannonShipCostGroup;
      }
      
      public function get normalCostGroup() : CannonNormalCostGroup
      {
         return this._cannonNormalCostGroup;
      }
      
      public function set showTypeButtons(param1:Boolean) : void
      {
         this._leftView.visible = param1;
      }
      
      private function init() : void
      {
         this._main = this.getCoreponentById("",Coreponent);
         this._buttonList = this.getCoreponentById("left_btn_group.btn_list",ItemList);
         this._leftView = this.getCoreponentById("left_btn_group",Coreponent);
         this._upPage = this.getCoreponentById("right_view.all_cannon_type_list.all_cannon_type_list_line_group.up_page",Button);
         this._nextPage = this.getCoreponentById("right_view.all_cannon_type_list.all_cannon_type_list_line_group.next_page",Button);
         this._cannonTypeList = this.getCoreponentById("right_view.all_cannon_type_list.cannon_type_list",Grid);
         this._selectItemList = this.getCoreponentById("right_view.select_item_list_group.cannon_items_list",Grid);
         this._selectListScrollBar = this.getCoreponentById("right_view.select_item_list_group.scroll_bar",Scrollbar);
         this._cannonShipCostGroup = new CannonShipCostGroup(this.getCoreponentById("right_view.item_ship_group",Coreponent));
         this._cannonNormalCostGroup = new CannonNormalCostGroup(this.getCoreponentById("right_view.normal_cost_group",Coreponent));
         this.select_item_list_title_label = this.getCoreponentById("right_view.select_item_list_group.items_list_bg_group.title_label",Label);
         this.drawLeftViewLine();
      }
      
      private function drawLeftViewLine() : *
      {
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.lineStyle(1,3265018,1);
         _loc1_.graphics.beginFill(3265018,1);
         _loc1_.graphics.moveTo(this._leftView.width - 10,30);
         _loc1_.graphics.lineTo(this._leftView.width - 10,this._leftView.height - 20);
         _loc1_.graphics.endFill();
         this._leftView.addChild(_loc1_);
      }
      
      private function getCoreponentById(param1:String, param2:Class) : *
      {
         if(param1 == "")
         {
            return this._uiCache.selectComponent("root.main") as param2;
         }
         return this._uiCache.selectComponent("root.main." + param1) as param2;
      }
   }
}

