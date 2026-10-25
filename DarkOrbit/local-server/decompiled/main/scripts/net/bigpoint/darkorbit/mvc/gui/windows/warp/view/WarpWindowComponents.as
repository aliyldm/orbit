package net.bigpoint.darkorbit.mvc.gui.windows.warp.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   
   public class WarpWindowComponents
   {
      
      private var _view:Sprite;
      
      public function WarpWindowComponents(param1:Sprite)
      {
         super();
         this._view = param1;
      }
      
      public function get shipsItemList() : ItemList
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.itemListContainer.ships",this._view) as ItemList;
      }
      
      public function get rightListButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.itemListContainer.right",this._view) as Button;
      }
      
      public function get leftListButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.itemListContainer.left",this._view) as Button;
      }
      
      public function get confirmButton() : Button
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.warpButtons.btnWarpConformation",this._view) as Button;
      }
      
      public function get warpCost() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.warpButtons.warpPrice.warpCost",this._view) as Label;
      }
      
      public function get jumpCreditCost() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.jumpCreditCostContainer.jumpCreditCost",this._view) as Label;
      }
      
      public function get warpInfo() : Label
      {
         return FuiComponentSelectorUtil.selectComponent("contentContainer.warpInfo",this._view) as Label;
      }
   }
}

