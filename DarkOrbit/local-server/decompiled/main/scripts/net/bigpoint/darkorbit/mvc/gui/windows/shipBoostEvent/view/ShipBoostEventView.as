package net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   
   public class ShipBoostEventView
   {
      
      private var _uiContainer:Sprite;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      public function ShipBoostEventView(param1:Sprite)
      {
         super();
         this._uiContainer = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this.slotList.itemDataAssigner = ShipBoostEventSlotAssigner;
      }
      
      public function get slotList() : ItemList
      {
         return this._fuiCache.selectComponent("root.parent.body.ship_boost_event_slotslist") as ItemList;
      }
      
      public function get shipBoostStatus() : Label
      {
         return this._fuiCache.selectComponent("root.parent.topmost.ship_boost_status_message") as Label;
      }
      
      public function get shipBoostTimerMessage() : Label
      {
         return this._fuiCache.selectComponent("root.parent.bottom.ship_boost_status") as Label;
      }
      
      public function get shipBoostTimer() : Label
      {
         return this._fuiCache.selectComponent("root.parent.bottom.ship_boost_timer") as Label;
      }
      
      public function get feverButton() : Button
      {
         return this._fuiCache.selectComponent("root.parent.bottom.fever_btn") as Button;
      }
   }
}

