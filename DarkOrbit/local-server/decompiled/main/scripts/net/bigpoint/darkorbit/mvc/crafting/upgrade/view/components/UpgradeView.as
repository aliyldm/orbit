package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components
{
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class UpgradeView
   {
      
      private var _upgradeTargetTypeComponents:UpgradeTargetTypeView;
      
      private var _upgradeTargetGridComponents:UpgradeTargetGridView;
      
      private var _upgradeTargetBuildComponents:UpgradeTargetInteractionView;
      
      private var _view:FuiComponentSelectorCache;
      
      public function UpgradeView(param1:Container)
      {
         super();
         this._view = new FuiComponentSelectorCache(param1);
         this._upgradeTargetTypeComponents = new UpgradeTargetTypeView(param1);
         this._upgradeTargetGridComponents = new UpgradeTargetGridView(param1);
         this._upgradeTargetBuildComponents = new UpgradeTargetInteractionView(param1);
      }
      
      public function get standardViewContainer() : Container
      {
         return this._view.selectComponent("contentContainer.standardViewContainer") as Container;
      }
      
      public function get filterEmptyItemsContainer() : Container
      {
         return this._view.selectComponent("contentContainer.filterEmptyItemsContainer") as Container;
      }
      
      public function get upgradeTargetTypeComponents() : UpgradeTargetTypeView
      {
         return this._upgradeTargetTypeComponents;
      }
      
      public function get upgradeTargetGridComponents() : UpgradeTargetGridView
      {
         return this._upgradeTargetGridComponents;
      }
      
      public function get upgradeTargetBuildComponents() : UpgradeTargetInteractionView
      {
         return this._upgradeTargetBuildComponents;
      }
   }
}

