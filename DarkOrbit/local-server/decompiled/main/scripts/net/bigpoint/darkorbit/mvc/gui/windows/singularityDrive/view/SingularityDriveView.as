package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveModuleAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners.SingularityDriveTypeAssigner;
   
   public class SingularityDriveView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function SingularityDriveView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.filterList.itemDataAssigner = SingularityDriveTypeAssigner;
         this.moduleList.itemDataAssigner = SingularityDriveModuleAssigner;
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get emptyItemsContainer() : Coreponent
      {
         return this._fuiCache.selectComponent("emptyItemsContainer") as Coreponent;
      }
      
      public function get filterList() : ItemList
      {
         return this._fuiCache.selectComponent("root.type_container.upgrade_type_list") as ItemList;
      }
      
      public function get moduleList() : Grid
      {
         return this._fuiCache.selectComponent("root.item_grid_container.upgrade_items_grid") as Grid;
      }
      
      public function get collectAllBbtn() : Button
      {
         return this._fuiCache.selectComponent("root.item_grid_container.collect_all_btn") as Button;
      }
   }
}

