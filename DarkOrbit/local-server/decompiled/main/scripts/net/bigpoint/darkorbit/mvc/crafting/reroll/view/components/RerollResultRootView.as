package net.bigpoint.darkorbit.mvc.crafting.reroll.view.components
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollResultRetainCostGridAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollStatsGridAssigner;
   import net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners.RerollTargetGridAssigner;
   
   public class RerollResultRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      private var _window:SimpleWindow;
      
      private var _confirmButton:Button;
      
      public function RerollResultRootView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._window = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.oldStatsList.itemDataAssigner = RerollStatsGridAssigner;
         this.newStatsList.itemDataAssigner = RerollStatsGridAssigner;
         this.moduleList.itemDataAssigner = RerollTargetGridAssigner;
         this.retainCostList.itemDataAssigner = RerollResultRetainCostGridAssigner;
      }
      
      public function get oldStatsList() : Grid
      {
         return this._fuiCache.selectComponent("root.oldStatsContainer.statsGrid") as Grid;
      }
      
      public function get newStatsList() : Grid
      {
         return this._fuiCache.selectComponent("root.newStatsContainer.statsGrid") as Grid;
      }
      
      public function get moduleList() : Grid
      {
         return this._fuiCache.selectComponent("root.rerollItemGridContainer.rerollItemsGrid") as Grid;
      }
      
      public function get retainCostList() : Grid
      {
         return this._fuiCache.selectComponent("root.oldStatsContainer.retainCostGrid") as Grid;
      }
      
      public function get ingredients() : ItemList
      {
         return this._fuiCache.selectComponent("root.oldStatsContainer.ingredients_container") as ItemList;
      }
      
      public function get confirmButton() : Button
      {
         if(!this._confirmButton)
         {
            this._confirmButton = this._fuiCache.selectComponent("root.bottom.okButton") as Button;
         }
         return this._confirmButton;
      }
      
      public function get oldCheckBox() : CheckBox
      {
         return this._fuiCache.selectComponent("root.oldStatsContainer.checkBox") as CheckBox;
      }
      
      public function get newCheckBox() : CheckBox
      {
         return this._fuiCache.selectComponent("root.newStatsContainer.checkBox") as CheckBox;
      }
      
      public function get oldFrame() : CheckBox
      {
         return this._fuiCache.selectComponent("root.oldStatsContainer.background") as CheckBox;
      }
      
      public function get newFrame() : CheckBox
      {
         return this._fuiCache.selectComponent("root.newStatsContainer.background") as CheckBox;
      }
      
      public function get oldStatsRetainCostLabel() : Label
      {
         return this._fuiCache.selectComponent("root.oldStatsContainer.retainCost") as Label;
      }
   }
}

