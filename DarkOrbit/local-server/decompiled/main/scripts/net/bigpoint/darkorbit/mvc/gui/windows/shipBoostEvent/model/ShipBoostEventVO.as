package net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.model
{
   import net.bigpoint.darkorbit.com.module.ShipBoostEventModule;
   
   public class ShipBoostEventVO
   {
      
      private var _data:ShipBoostEventModule;
      
      private var _slotIndex:int;
      
      private var _isActive:Boolean;
      
      private var _isUpcoming:Boolean;
      
      public function ShipBoostEventVO(param1:ShipBoostEventModule, param2:int)
      {
         super();
         this._data = param1;
         this._slotIndex = param2;
      }
      
      public function get data() : ShipBoostEventModule
      {
         return this._data;
      }
      
      public function get slotIndex() : int
      {
         return this._slotIndex;
      }
      
      public function set isActive(param1:Boolean) : void
      {
         this._isActive = param1;
      }
      
      public function get isActive() : Boolean
      {
         return this._isActive;
      }
      
      public function set isUpcoming(param1:Boolean) : void
      {
         this._isUpcoming = param1;
      }
      
      public function get isUpcoming() : Boolean
      {
         return this._isUpcoming;
      }
   }
}

