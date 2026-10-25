package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.tab
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveCostAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveStatsLockAssigner;
   
   public class SingularityDriveTab2 implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public function SingularityDriveTab2(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab2_container") as Coreponent;
         this.statsList.itemDataAssigner = SingularityDriveStatsLockAssigner;
         this.costsList.itemDataAssigner = SingularityDriveCostAssigner;
      }
      
      public function get title() : String
      {
         return "title_reroll";
      }
      
      public function get view() : Coreponent
      {
         return this._view;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this.view.visible = param1;
      }
      
      public function get visible() : Boolean
      {
         return this.view.visible;
      }
      
      public function set active(param1:Boolean) : void
      {
      }
      
      public function get active() : Boolean
      {
         return true;
      }
      
      public function get statsList() : Grid
      {
         return this._cache.selectComponent("tab2_container.stats_container.stats_grid") as Grid;
      }
      
      public function get statsContainer() : Container
      {
         return this._cache.selectComponent("tab2_container.stats_container") as Container;
      }
      
      public function get button() : Button
      {
         return this._cache.selectComponent("tab2_container.btn") as Button;
      }
      
      public function get costsList() : Grid
      {
         return this._cache.selectComponent("tab2_container.cost_container.selectedItemRecipes") as Grid;
      }
   }
}

