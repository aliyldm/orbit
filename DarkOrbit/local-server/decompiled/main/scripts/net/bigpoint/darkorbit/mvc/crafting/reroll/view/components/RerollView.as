package net.bigpoint.darkorbit.mvc.crafting.reroll.view.components
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollShipListAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollStatsGridAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollTargetGridAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollTargetTypeListAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.SalvageToolTipAssigner;
   
   public class RerollView
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function RerollView(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.filterList.itemDataAssigner = RerollTargetTypeListAssigner;
         this.moduleList.itemDataAssigner = RerollTargetGridAssigner;
         this.statsList.itemDataAssigner = RerollStatsGridAssigner;
         this.shipsList.itemDataAssigner = RerollShipListAssigner;
         this.salvageInfoTTip.tooltipDataAssigner = new SalvageToolTipAssigner();
      }
      
      public function get standardViewContainer() : Container
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer") as Container;
      }
      
      public function get emptyViewContainer() : Container
      {
         return this._cache.selectComponent("contentContainer.emptyViewContainer") as Container;
      }
      
      public function get filterList() : ItemList
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.itemGridContainer.itemListContainer.rerollTargetTypeList") as ItemList;
      }
      
      public function get moduleList() : Grid
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollItemGridContainer.rerollItemsGrid") as Grid;
      }
      
      public function get moduleListBG() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollItemGridContainer.rerollGridBg") as Coreponent;
      }
      
      public function get moduleListScrollBar() : Scrollbar
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollItemGridContainer.item_grid") as Scrollbar;
      }
      
      public function get moduleListScrollRowNumber() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollItemGridContainer.rowNumber") as Label;
      }
      
      public function get statsList() : Grid
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollStatsGridContainer.statsGrid") as Grid;
      }
      
      public function get shipsList() : ItemList
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollShips.shipList") as ItemList;
      }
      
      public function get rerollInfoTTip() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollInfo.help") as Button;
      }
      
      public function get rerollCostIcon() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollInfo.img") as Coreponent;
      }
      
      public function get rerollCostItemName() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollInfo.item_name") as Label;
      }
      
      public function get rerollCostItemAmount() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollInfo.item_amt") as Label;
      }
      
      public function get recycleCostIcon() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.recycleInfo.img") as Coreponent;
      }
      
      public function get recycleCostItemName() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.recycleInfo.item_name") as Label;
      }
      
      public function get recycleCostItemAmount() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.recycleInfo.item_amt") as Label;
      }
      
      public function get recycleCostHelpButton() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.recycleInfo.help") as Button;
      }
      
      public function get rollLeft() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollLeft.item_left") as Label;
      }
      
      public function get rerollLeftHelpButton() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollLeft.help") as Button;
      }
      
      public function get rollButton() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollBtn") as Button;
      }
      
      public function get recycleButton() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.recycleBtn") as Button;
      }
      
      public function get rerollCostBG() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollInfo.reollInfoBg") as Coreponent;
      }
      
      public function get rerollCostBGDiscount() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.rerollInfo.reollInfoBg_discount") as Coreponent;
      }
      
      public function get salvageInfoTTip() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.retainCost.help") as Button;
      }
      
      public function get retainCostContainer() : Container
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.retainCost") as Container;
      }
      
      public function get retainCostItemLeft() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.rerollCostsContainer.retainCost.item_left") as Label;
      }
   }
}

