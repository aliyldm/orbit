package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components
{
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeTargetGridAssigner;
   
   public class UpgradeTargetGridView
   {
      
      private var _view:FuiComponentSelectorCache;
      
      public function UpgradeTargetGridView(param1:Container)
      {
         super();
         this._view = new FuiComponentSelectorCache(param1);
         this.upgradeTargetsGrid.itemDataAssigner = UpgradeTargetGridAssigner;
      }
      
      public function get upgradeTargetsGrid() : Grid
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.itemGridContainer.upgradeItemsGrid") as Grid;
      }
      
      public function get collectAllBtn() : Button
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.itemGridContainer.collect_all_btn") as Button;
      }
   }
}

