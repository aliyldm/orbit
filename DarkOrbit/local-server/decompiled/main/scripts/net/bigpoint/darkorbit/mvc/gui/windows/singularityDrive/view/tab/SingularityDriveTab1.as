package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.tab
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.bars.ProgressBar;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.spinbar.HorizontalSpinBox;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveSkipCostAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveStatsGridAssigner;
   
   public class SingularityDriveTab1 implements ITabItem
   {
      
      private var _cache:FuiComponentSelectorCache;
      
      public var _view:Coreponent;
      
      public function SingularityDriveTab1(param1:Sprite)
      {
         super();
         this._cache = new FuiComponentSelectorCache(param1);
         this._view = this._cache.selectComponent("tab1_container") as Coreponent;
         this.statsList.itemDataAssigner = SingularityDriveStatsGridAssigner;
         this.costsList.itemDataAssigner = SingularityDriveSkipCostAssigner;
      }
      
      public function get title() : String
      {
         return "title_upgrade";
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
         return this._cache.selectComponent("tab1_container.stats_container.stats_grid") as Grid;
      }
      
      public function get buffImg() : Coreponent
      {
         return this._cache.selectComponent("tab1_container.upgrade_container.buff_container.img") as Coreponent;
      }
      
      public function get levelLabel() : Label
      {
         return this._cache.selectComponent("tab1_container.upgrade_container.selectedItemLevel") as Label;
      }
      
      public function get currentLabel() : Label
      {
         return this._cache.selectComponent("tab1_container.upgrade_container.buff_container.current_label") as Label;
      }
      
      public function get nextLabel() : Label
      {
         return this._cache.selectComponent("tab1_container.upgrade_container.buff_container.next_label") as Label;
      }
      
      public function get buffContainer() : Container
      {
         return this._cache.selectComponent("tab1_container.upgrade_container.buff_container") as Container;
      }
      
      public function get levelSpinBox() : HorizontalSpinBox
      {
         return this._cache.selectComponent("tab1_container.build_container.spinBox") as HorizontalSpinBox;
      }
      
      public function get timeLabel() : Label
      {
         return this._cache.selectComponent("tab1_container.build_container.time_label") as Label;
      }
      
      public function get buildButton() : Button
      {
         return this._cache.selectComponent("tab1_container.build_container.build_button") as Button;
      }
      
      public function get costsContainer() : Container
      {
         return this._cache.selectComponent("tab1_container.cost_container") as Container;
      }
      
      public function get costsList() : Grid
      {
         return this._cache.selectComponent("tab1_container.cost_container.selectedItemRecipes") as Grid;
      }
      
      public function get buildContainer() : Container
      {
         return this._cache.selectComponent("tab1_container.build_container") as Container;
      }
      
      public function get buildingContainer() : Container
      {
         return this._cache.selectComponent("tab1_container.building") as Container;
      }
      
      public function get buildingProgressbar() : ProgressBar
      {
         return this._cache.selectComponent("tab1_container.building.progressbar") as ProgressBar;
      }
      
      public function get buildingTimeLabel() : Label
      {
         return this._cache.selectComponent("tab1_container.building.time") as Label;
      }
      
      public function get buildingSkipButton() : Button
      {
         return this._cache.selectComponent("tab1_container.building.btn") as Button;
      }
      
      public function get skipButton() : Button
      {
         return this._cache.selectComponent("tab1_container.building.btn") as Button;
      }
      
      public function get notPossibleContainer() : Container
      {
         return this._cache.selectComponent("tab1_container.not_possible") as Container;
      }
      
      public function get notPossibleLabel() : Label
      {
         return this._cache.selectComponent("tab1_container.not_possible.label") as Label;
      }
      
      public function get collectContainer() : Container
      {
         return this._cache.selectComponent("tab1_container.collect") as Container;
      }
      
      public function get collectButton() : Button
      {
         return this._cache.selectComponent("tab1_container.collect.btn") as Button;
      }
      
      public function get collectProgressbar() : ProgressBar
      {
         return this._cache.selectComponent("tab1_container.collect.progressbar") as ProgressBar;
      }
      
      public function get collectTimeLabel() : Label
      {
         return this._cache.selectComponent("tab1_container.collect.time") as Label;
      }
   }
}

