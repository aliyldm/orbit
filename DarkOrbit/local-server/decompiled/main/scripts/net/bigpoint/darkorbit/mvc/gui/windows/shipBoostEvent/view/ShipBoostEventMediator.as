package net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.view
{
   import com.bigpoint.utils.TimeFormatter;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.model.ShipBoostEventUIData;
   
   public class ShipBoostEventMediator extends SimpleWindowMediator
   {
      
      private var _data:ShipBoostEventUIData;
      
      private var _view:ShipBoostEventView;
      
      public function ShipBoostEventMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
         param2.setSize(550,600);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.data = null;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new ShipBoostEventView(simpleWindow.getUIContainer());
         this.data = retrieveWindowProxy().getData() as ShipBoostEventUIData;
      }
      
      public function set data(param1:ShipBoostEventUIData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.update);
            this._data.timer.changed.remove(this.updateTimer);
            this._data.isShipBoosted.changed.remove(this.updateShipBoostStatus);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.update);
            this._data.timer.changed.add(this.updateTimer);
            this._data.isShipBoosted.changed.add(this.updateShipBoostStatus);
            this.update();
         }
      }
      
      public function update() : void
      {
         if(Boolean(this._data) && isUIReady())
         {
            this.updateSlotList();
            this.updateShipBoostTimerStatus();
            this.updateTimer();
            this.updateShipBoostStatus();
         }
      }
      
      private function updateTimer() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.timer.value > 0)
            {
               this._view.shipBoostTimer.text = TimeFormatter.getSmartFormatedTime(this._data.timer.value);
            }
            else
            {
               this._view.shipBoostTimer.text = "-";
            }
         }
      }
      
      private function updateSlotList() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            if(this._data.slots.length <= 0)
            {
               this._view.slotList.visible = false;
            }
            else
            {
               this._view.slotList.visible = true;
               this._view.slotList.clearList();
               this._view.slotList.list = new VectorCollection(this._data.slots);
            }
         }
      }
      
      private function updateShipBoostStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.shipBoostStatus.localizedText = !this._data.isBoostActive ? "ship_boost_player_status_no_fever" : (this._data.isShipBoosted.value ? "ship_boost_player_status_fever_affected" : "ship_boost_player_status_fever_unaffected");
            if(this._data.currentSlot != null)
            {
               _loc1_ = int(this._data.currentSlot.eventNameTextKeys.length);
               _loc2_ = "";
               _loc3_ = 0;
               while(_loc3_ < _loc1_)
               {
                  _loc2_ += UISystem.localize(this._data.currentSlot.eventNameTextKeys[_loc3_]);
                  if(_loc3_ < _loc1_ - 1)
                  {
                     _loc2_ += ", ";
                  }
                  _loc3_++;
               }
               this._view.feverButton.tooltipData = this._view.feverButton.tooltipData.replace("%EVENTS%",_loc2_);
               if(!this._data.isShipBoosted.value)
               {
                  this._view.shipBoostStatus.text = this._view.shipBoostStatus.text.replace("%EVENTS%",_loc2_);
               }
            }
         }
      }
      
      private function updateShipBoostTimerStatus() : void
      {
         if(Boolean(this._data) && Boolean(this._view))
         {
            this._view.shipBoostTimerMessage.localizedText = this._data.isBoostActive ? "ship_boost_ongoing" : "ship_boost_countdown";
         }
      }
   }
}

