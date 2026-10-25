package net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.model
{
   import com.bigpoint.utils.bindables.BindableBoolean;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.darkorbit.com.module.ShipBoostEventBoostInfoCommand;
   import net.bigpoint.darkorbit.com.module.ShipBoostEventInfoCommand;
   import net.bigpoint.darkorbit.com.module.ShipBoostEventModule;
   import net.bigpoint.darkorbit.com.module.ShipBoostEventUpdateInfoCommand;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ShipBoostEventUIData
   {
      
      public const changed:ISignal = new Signal();
      
      public const timer:BindableCountDown = new BindableCountDown();
      
      public const isShipBoosted:BindableBoolean = new BindableBoolean();
      
      private var _slots:Vector.<ShipBoostEventVO> = new Vector.<ShipBoostEventVO>(0);
      
      private var _isBoostActive:Boolean;
      
      private var _currentSlot:ShipBoostEventModule;
      
      public function ShipBoostEventUIData()
      {
         super();
      }
      
      public function updateInfo(param1:ShipBoostEventInfoCommand) : void
      {
         this.updateShipBoostSlots(param1.shipBoostSlots);
         this.updateChange(param1.boostUpdateInfo);
      }
      
      public function updateChange(param1:ShipBoostEventUpdateInfoCommand) : void
      {
         this.updateTimer(param1.timeToWindowChange);
         this._isBoostActive = param1.isBoostActive;
         var _loc2_:int = 0;
         while(_loc2_ < this._slots.length)
         {
            this._slots[_loc2_].isUpcoming = false;
            this._slots[_loc2_].isActive = false;
            if(this.areSlotsEqualOrEndsEarlier(this._slots[_loc2_].data,param1.currentSlot))
            {
               if(this._isBoostActive)
               {
                  this._slots[_loc2_].isActive = true;
               }
               else
               {
                  this._slots[_loc2_].isUpcoming = true;
               }
            }
            _loc2_++;
         }
         this.updateBoost(param1.boostInfo);
         this._currentSlot = param1.currentSlot;
         this.changed.dispatch();
      }
      
      public function updateBoost(param1:ShipBoostEventBoostInfoCommand) : void
      {
         this.isShipBoosted.value = param1.isShipBoosted;
      }
      
      private function updateTimer(param1:Number) : void
      {
         this.timer.value = param1;
      }
      
      private function updateShipBoostSlots(param1:Vector.<ShipBoostEventModule>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._slots[_loc2_] = new ShipBoostEventVO(param1[_loc2_],_loc2_ + 1);
            _loc2_++;
         }
      }
      
      public function get slots() : Vector.<ShipBoostEventVO>
      {
         return this._slots;
      }
      
      public function get isBoostActive() : Boolean
      {
         return this._isBoostActive;
      }
      
      public function get currentSlot() : ShipBoostEventModule
      {
         return this._currentSlot;
      }
      
      private function areSlotsEqualOrEndsEarlier(param1:ShipBoostEventModule, param2:ShipBoostEventModule) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            return false;
         }
         return !(param1.day != param2.day || param1.startTime != param2.startTime || param1.endTime < param2.endTime);
      }
      
      private function areSlotsEqual(param1:ShipBoostEventModule, param2:ShipBoostEventModule) : Boolean
      {
         if(param1 == null || param2 == null)
         {
            return false;
         }
         return !(param1.day != param2.day || param1.startTime != param2.startTime || param1.endTime != param2.endTime);
      }
   }
}

