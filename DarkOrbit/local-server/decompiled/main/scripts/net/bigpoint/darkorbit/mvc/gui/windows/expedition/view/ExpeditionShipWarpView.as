package net.bigpoint.darkorbit.mvc.gui.windows.expedition.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionShipCommand;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   
   public class ExpeditionShipWarpView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _uiContainer:Sprite;
      
      public function ExpeditionShipWarpView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.shipList.itemDataAssigner = ExpeditionShipWarpAssigner;
      }
      
      public function get confirmButton() : Button
      {
         return this._fuiCache.selectComponent("root.body.confirmBtn") as Button;
      }
      
      public function get infoLabel() : Label
      {
         return this._fuiCache.selectComponent("root.body.info_label1") as Label;
      }
      
      public function get shipList() : ItemList
      {
         return this._fuiCache.selectComponent("root.body.ship_container.ships") as ItemList;
      }
      
      public function setShipListData(param1:Vector.<ExpeditionShipCommand>) : void
      {
         this.shipList.list = new VectorCollection(param1);
      }
   }
}

