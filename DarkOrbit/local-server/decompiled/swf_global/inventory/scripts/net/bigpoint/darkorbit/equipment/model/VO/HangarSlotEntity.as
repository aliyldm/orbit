package net.bigpoint.darkorbit.equipment.model.VO
{
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.dataInterchange.DataInterchange;
   
   public class HangarSlotEntity
   {
      
      public var slotID:int = 0;
      
      public var hangarID:int;
      
      public var name:String;
      
      public var configs:Object;
      
      public var general:Object;
      
      private var ship:Ship;
      
      public var isSelected:Boolean = false;
      
      private var _isActive:Boolean = false;
      
      private var _shipInfoVO:ShipInfoVO;
      
      private var filterManager:FilterManager;
      
      private var itemInfoManager:ItemInfoManager;
      
      public function HangarSlotEntity(param1:Object = null, param2:ShipInfoVO = null)
      {
         super();
         this._shipInfoVO = param2;
         if(param1)
         {
            this.hangarID = param1.hangarID;
            this.name = param1.name;
            this.configs = param1.config;
            this.general = param1.general;
            this._isActive = param1.hangar_is_active;
            this.filterManager = FilterManager.getInstance();
            this.itemInfoManager = ItemInfoManager.getInstance();
            this.createShipEntity();
            this.createPetEntity();
            this.createDroneEntities();
         }
      }
      
      private function createShipEntity() : void
      {
         var _loc1_:Object = null;
         var _loc2_:ItemInfoVO = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         if(!this.isHangarEmpty())
         {
            this.ship = new Ship();
            this.ship.level = 0;
            _loc1_ = this.general.ship;
            if(_loc1_ != null)
            {
               this.ship.lootID = this._shipInfoVO.lootID;
               this.ship.ID = _loc1_[DataInterchange.ITEM_ID];
               this.ship.hitPoints = _loc1_[DataInterchange.ITEM_HITPOINTS];
               this.ship.selectedDesign = _loc1_[DataInterchange.SELECTED_DESIGN];
               this.ship.setAvailableDesignsList(_loc1_[DataInterchange.AVAILABLE_DESIGNS]);
               this.ship.setAllAvailableDesignLokaInfo(this.itemInfoManager);
               _loc2_ = this.itemInfoManager.getItemInfo(this.ship.lootID);
               if(_loc2_)
               {
                  this.ship.saleValue = _loc2_.saleValuesByLevel[0];
                  _loc3_ = _loc2_.rawSlotSetInfoByLevel[this.ship.level];
                  for(_loc4_ in _loc3_)
                  {
                     this.ship.addSlotSetInfo(_loc4_,_loc3_[_loc4_]);
                     this.ship.addAcceptedGroupsToTotal(_loc3_[_loc4_][DataInterchange.ITEM_GROUP]);
                  }
               }
            }
         }
      }
      
      private function createPetEntity() : void
      {
      }
      
      private function createDroneEntities() : void
      {
      }
      
      public function isHangarEmpty() : Boolean
      {
         if(this.general == null)
         {
            return true;
         }
         if(this.general.ship == null)
         {
            return true;
         }
         var _loc1_:Array = this.general.ship as Array;
         if(_loc1_ != null)
         {
            return true;
         }
         return false;
      }
      
      public function getShip() : Ship
      {
         return this.ship;
      }
      
      public function getItemInfoManager() : ItemInfoManager
      {
         return this.itemInfoManager;
      }
      
      public function set activate(param1:Boolean) : void
      {
         this._isActive = param1;
      }
      
      public function isActive() : Boolean
      {
         return this._isActive;
      }
      
      public function set favourite(param1:Boolean) : void
      {
         if(this._shipInfoVO != null)
         {
            this._shipInfoVO.favourite = param1;
         }
      }
      
      public function isFavourite() : Boolean
      {
         if(this._shipInfoVO != null)
         {
            return this._shipInfoVO.isFavourite();
         }
         return false;
      }
      
      public function isFactionBased() : Boolean
      {
         if(this._shipInfoVO != null)
         {
            return this._shipInfoVO.isFactionBased();
         }
         return false;
      }
      
      public function isOwned() : Boolean
      {
         if(this._shipInfoVO != null)
         {
            return this._shipInfoVO.isOwned();
         }
         return false;
      }
      
      public function isPayment() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._shipInfoVO != null)
         {
            _loc1_ = this._shipInfoVO.isPayment();
         }
         return _loc1_;
      }
      
      public function isEventItem() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._shipInfoVO != null)
         {
            _loc1_ = this._shipInfoVO.eventItem;
         }
         return _loc1_;
      }
      
      public function isEventActive() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._shipInfoVO != null)
         {
            _loc1_ = this._shipInfoVO.eventActive;
         }
         return _loc1_;
      }
      
      public function get priceCredits() : Number
      {
         var _loc1_:Number = -1;
         if(this._shipInfoVO != null)
         {
            _loc1_ = this._shipInfoVO.credits;
         }
         return _loc1_;
      }
      
      public function get priceUridium() : Number
      {
         var _loc1_:Number = -1;
         if(this._shipInfoVO != null)
         {
            _loc1_ = this._shipInfoVO.uridium;
         }
         return _loc1_;
      }
      
      public function get isUpgradedShip() : Boolean
      {
         var _loc1_:Boolean = false;
         if(this._shipInfoVO != null)
         {
            _loc1_ = this._shipInfoVO.isUpgradedShip();
         }
         return _loc1_;
      }
      
      public function get shipUpgradeLevel() : Number
      {
         var _loc1_:Number = 0;
         if(this._shipInfoVO != null)
         {
            _loc1_ = this._shipInfoVO.shipUpgradeLevel();
         }
         return _loc1_;
      }
   }
}

