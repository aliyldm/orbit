package net.bigpoint.darkorbit.mvc.gui.windows.eventProgress.model.vo
{
   public class EventRewardVO
   {
      
      private static const DEFAULT_ITEMS_SHOWTIME:Number = 3;
      
      private var _lootID:String;
      
      private var _packageID:String;
      
      private var _packageItemIDs:Array;
      
      private var _itemShowTimeInMS:Number = 3;
      
      private var _amount:int;
      
      private var _unlockRequirement:int;
      
      private var _tooltip:String;
      
      public function EventRewardVO()
      {
         super();
      }
      
      public function get lootID() : String
      {
         return this._lootID;
      }
      
      public function set lootID(param1:String) : void
      {
         this._lootID = param1;
      }
      
      public function get packageID() : String
      {
         return this._packageID;
      }
      
      public function set packageID(param1:String) : void
      {
         this._packageID = param1;
      }
      
      public function setPackageItemIDs(param1:String) : void
      {
         if(param1)
         {
            this._packageItemIDs = param1.split(",");
         }
         else
         {
            this._packageItemIDs = [];
         }
      }
      
      public function getPackageItemIDs() : Array
      {
         return this._packageItemIDs;
      }
      
      public function get amount() : int
      {
         return this._amount;
      }
      
      public function set amount(param1:int) : void
      {
         this._amount = param1;
      }
      
      public function get unlockRequirement() : int
      {
         return this._unlockRequirement;
      }
      
      public function set unlockRequirement(param1:int) : void
      {
         this._unlockRequirement = param1;
      }
      
      public function set tooltipkey(param1:String) : void
      {
         this._tooltip = param1;
      }
      
      public function get tooltipkey() : String
      {
         return this._tooltip;
      }
      
      public function get itemShowTimeInMS() : Number
      {
         return this._itemShowTimeInMS;
      }
      
      public function set itemShowTimeInMS(param1:Number) : void
      {
         if(param1 > 0)
         {
            this._itemShowTimeInMS = param1;
         }
      }
      
      public function set itemShowTimeinSec(param1:Number) : void
      {
         this.itemShowTimeInMS = param1 * 1000;
      }
   }
}

