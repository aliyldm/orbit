package net.bigpoint.darkorbit.mvc.crafting.disassembly.view.comps
{
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners.UpgradeTargetGridAssigner;
   
   public class DisassemblyTargetGridView
   {
      
      private var _view:FuiComponentSelectorCache;
      
      public function DisassemblyTargetGridView(param1:Container)
      {
         super();
         this._view = new FuiComponentSelectorCache(param1);
         this.upgradeTargetsGrid.itemDataAssigner = UpgradeTargetGridAssigner;
      }
      
      public function get upgradeTargetsGrid() : Grid
      {
         return this._view.selectComponent("contentContainer.standardViewContainer.itemGridContainer.disassemblyItemsGrid") as Grid;
      }
   }
}

