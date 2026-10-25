package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipCommand;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.scroll.Scrollbar;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ExpeditionShipHangarView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function ExpeditionShipHangarView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.shipList.itemDataAssigner = ExpeditionShipAssigner;
      }
      
      public function get shipList() : ItemList
      {
         return this._fuiCache.selectComponent("root.body.itemListContainer.ships") as ItemList;
      }
      
      public function set shipListData(param1:Vector.<ExpeditionShipCommand>) : void
      {
         this.shipList.list = new VectorCollection(param1);
      }
      
      public function get selectedLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.selectedLabel") as Label;
      }
      
      public function get confirmButton() : Button
      {
         return this._fuiCache.selectComponent("root.body.confirmBtn") as Button;
      }
      
      public function get leftButton() : Button
      {
         return this._fuiCache.selectComponent("root.body.arrowLeftBtn") as Button;
      }
      
      public function get rightButton() : Button
      {
         return this._fuiCache.selectComponent("root.body.arrowRightBtn") as Button;
      }
      
      public function get scrollbar() : Scrollbar
      {
         return this._fuiCache.selectComponent("root.body.itemListContainer.item_bar") as Scrollbar;
      }
   }
}

