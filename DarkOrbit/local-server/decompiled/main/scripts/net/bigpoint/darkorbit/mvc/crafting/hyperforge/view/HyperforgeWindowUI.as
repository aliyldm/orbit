package net.bigpoint.darkorbit.mvc.crafting.hyperforge.view
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
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.view.assigners.HyperforgeAttributeAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.view.assigners.HyperforgeModuleAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.hyperforge.view.assigners.HyperforgeTypeAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollShipListAssigner;
   
   public class HyperforgeWindowUI
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public function HyperforgeWindowUI(param1:DisplayObjectContainer)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this.filterList.itemDataAssigner = HyperforgeTypeAssigner;
         this.moduleList.itemDataAssigner = HyperforgeModuleAssigner;
         this.statsList.itemDataAssigner = HyperforgeAttributeAssigner;
         this.shipsList.itemDataAssigner = RerollShipListAssigner;
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
         return this._cache.selectComponent("contentContainer.standardViewContainer.itemGridContainer.itemListContainer.hyperforgeTargetTypeList") as ItemList;
      }
      
      public function get moduleList() : Grid
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeItemGridContainer.hyperforgeItemsGrid") as Grid;
      }
      
      public function get moduleListBG() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeItemGridContainer.hyperforgeGridBg") as Coreponent;
      }
      
      public function get moduleListScrollBar() : Scrollbar
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeItemGridContainer.item_grid") as Scrollbar;
      }
      
      public function get moduleListScrollRowNumber() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeItemGridContainer.rowNumber") as Label;
      }
      
      public function get statsList() : Grid
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeStatsGridContainer.statsGrid") as Grid;
      }
      
      public function get shipsList() : ItemList
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeShips.shipList") as ItemList;
      }
      
      public function get forgeInfoTTip() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.hyperforgeInfo.help") as Button;
      }
      
      public function get forgeCostIcon() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.hyperforgeInfo.img") as Coreponent;
      }
      
      public function get forgeCostItemName() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.hyperforgeInfo.item_name") as Label;
      }
      
      public function get forgeCostItemAmount() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.hyperforgeInfo.item_amt") as Label;
      }
      
      public function get recycleCostIcon() : Coreponent
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.recycleInfo.img") as Coreponent;
      }
      
      public function get recycleCostItemName() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.recycleInfo.item_name") as Label;
      }
      
      public function get recycleCostItemAmount() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.recycleInfo.item_amt") as Label;
      }
      
      public function get recycleCostHelpButton() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.recycleInfo.help") as Button;
      }
      
      public function get forgeButton() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.forgeBtn") as Button;
      }
      
      public function get nextLevelLabel() : Label
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.next_level_label") as Label;
      }
      
      public function get recycleButton() : Button
      {
         return this._cache.selectComponent("contentContainer.standardViewContainer.hyperforgeCostsContainer.recycleBtn") as Button;
      }
   }
}

