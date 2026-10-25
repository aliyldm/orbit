package net.bigpoint.darkorbit.equipment.model.VO
{
   public class ShipInfoVO
   {
      
      public static var HANGAR_ID:uint = 1;
      
      private var _factionBased:Boolean;
      
      private var _favourite:Boolean;
      
      private var _hangarID:String;
      
      private var _lootID:String;
      
      private var _owned:Boolean;
      
      private var _credits:Number;
      
      private var _uridium:Number;
      
      private var _isPayment:Boolean;
      
      private var _eventItem:Boolean;
      
      private var _eventActive:Boolean;
      
      private var _isUpgradedShip:Boolean;
      
      private var _upgradeLevel:Number;
      
      public function ShipInfoVO(param1:Object)
      {
         super();
         this._factionBased = param1["factionBased"] == 1 ? true : false;
         this._favourite = param1["fav"] == 1 ? true : false;
         this._hangarID = param1["hangarId"];
         this._lootID = param1["lootId"];
         this._owned = param1["owned"] == 1 ? true : false;
         if(param1.price)
         {
            this._credits = param1.price["credits"];
            this._uridium = param1.price["uridium"];
            this._isPayment = param1.price["isPayment"] == 1 ? true : false;
         }
         this._eventItem = param1["eventItem"] == 1 ? true : false;
         this._eventActive = param1["eventActive"] == 1 ? true : false;
         this._isUpgradedShip = param1["remodel"] > 0 ? true : false;
         this._upgradeLevel = param1["remodel"];
         if(!this._owned)
         {
            ++HANGAR_ID;
            this._hangarID = "NOT_OWNED_" + HANGAR_ID;
         }
      }
      
      public function isFactionBased() : Boolean
      {
         return this._factionBased;
      }
      
      public function set favourite(param1:Boolean) : void
      {
         this._favourite = param1;
      }
      
      public function isFavourite() : Boolean
      {
         return this._favourite;
      }
      
      public function isOwned() : Boolean
      {
         return this._owned;
      }
      
      public function get hangarID() : String
      {
         return this._hangarID;
      }
      
      public function get lootID() : String
      {
         return this._lootID;
      }
      
      public function get credits() : Number
      {
         return this._credits;
      }
      
      public function get uridium() : Number
      {
         return this._uridium;
      }
      
      public function isPayment() : Boolean
      {
         return this._isPayment;
      }
      
      public function isUpgradedShip() : Boolean
      {
         return this._isUpgradedShip;
      }
      
      public function shipUpgradeLevel() : Number
      {
         return this._upgradeLevel;
      }
      
      public function get eventItem() : Boolean
      {
         return this._eventItem;
      }
      
      public function get eventActive() : Boolean
      {
         return this._eventActive;
      }
   }
}

