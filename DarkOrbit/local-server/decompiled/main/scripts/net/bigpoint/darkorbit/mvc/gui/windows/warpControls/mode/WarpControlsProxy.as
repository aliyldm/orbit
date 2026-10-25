package net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode
{
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarListRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipBriefCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipMoveItemsCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipMoveItemsRequest;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipsCommand;
   import net.bigpoint.darkorbit.com.module.porting.hangar.InventoryItemPack;
   import net.bigpoint.darkorbit.com.module.porting.hangar.ShipDesignPack;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.model.SimpleWindowProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpChangeData;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpControlsItemData;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.vo.WarpShipData;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   
   public class WarpControlsProxy extends SimpleWindowProxy
   {
      
      public static var NAME:String = "WarpControlsProxy";
      
      private var _allItems:Vector.<HangarShipEquipmentInventoryItem>;
      
      private var _allDesign:Vector.<String>;
      
      private var _isDataComplete:Boolean = false;
      
      private var _currentShip:WarpShipData;
      
      public function WarpControlsProxy()
      {
         super(NAME,null);
         this._currentShip = new WarpShipData();
      }
      
      public static function getProxy(param1:IFacade) : WarpControlsProxy
      {
         var _loc2_:WarpControlsProxy = param1.retrieveProxy(WarpControlsProxy.NAME) as WarpControlsProxy;
         if(!_loc2_)
         {
            _loc2_ = new WarpControlsProxy();
            param1.registerProxy(_loc2_);
         }
         return _loc2_;
      }
      
      public function get shipData() : WarpShipData
      {
         return this._currentShip;
      }
      
      public function sendListRequest() : void
      {
         var _loc1_:HangarListRequest = new HangarListRequest();
         connectionProxy.connectionManager.sendRequest(_loc1_);
         this._isDataComplete = false;
      }
      
      public function sendHangarShipEquipmentRequest() : void
      {
         var _loc1_:HangarShipEquipmentRequest = new HangarShipEquipmentRequest();
         _loc1_.shipId = this._currentShip.shipId;
         connectionProxy.connectionManager.sendRequest(_loc1_);
      }
      
      public function rcvHangarShipEquipmentCommand(param1:HangarShipEquipmentCommand) : void
      {
         this._currentShip.hangarId = param1.hangarId;
         this._currentShip.updateShipWeapons(param1);
         this._isDataComplete = true;
         sendNotification(GuiNotifications.WARP_CONTROLS_INIT);
      }
      
      public function rcvAllData(param1:HangarShipsCommand) : void
      {
         var _loc2_:int = 0;
         var _loc3_:HangarShipBriefCommand = null;
         var _loc4_:ShipDesignPack = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:InventoryItemPack = null;
         var _loc8_:HangarShipEquipmentInventoryItem = null;
         this._allItems = new Vector.<HangarShipEquipmentInventoryItem>();
         _loc2_ = 0;
         while(_loc2_ < param1.ships.length)
         {
            _loc3_ = param1.ships[_loc2_] as HangarShipBriefCommand;
            if(_loc3_.isActive)
            {
               this._currentShip.update(_loc3_);
            }
            _loc2_++;
         }
         this._allDesign = new Vector.<String>();
         _loc2_ = 0;
         while(_loc2_ < param1.allDesignPack.length)
         {
            _loc4_ = param1.allDesignPack[_loc2_] as ShipDesignPack;
            _loc5_ = 0;
            while(_loc5_ < _loc4_.designList.length)
            {
               _loc6_ = _loc4_.designList[_loc5_];
               this._allDesign.push(_loc6_);
               _loc5_++;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < param1.items.length)
         {
            _loc7_ = param1.items[_loc2_];
            _loc5_ = 0;
            while(_loc5_ < _loc7_.items.length)
            {
               _loc8_ = _loc7_.items[_loc5_];
               if(this.isShowByLootType(_loc8_.lootType))
               {
                  this._allItems.push(_loc8_);
               }
               _loc5_++;
            }
            _loc2_++;
         }
         this.sendHangarShipEquipmentRequest();
      }
      
      private function isShowByLootType(param1:String) : Boolean
      {
         if(param1 == ItemFilterTypes.Weapon__CannonType || param1 == ItemFilterTypes.Weapon__CannonShieldType || param1 == ItemFilterTypes.Weapon__QuantumFluidCoreType || param1 == ItemFilterTypes.Equipment__LensType || param1 == ItemFilterTypes.Equipment__DriveType)
         {
            return true;
         }
         return false;
      }
      
      public function get allItems() : Vector.<HangarShipEquipmentInventoryItem>
      {
         return this._allItems;
      }
      
      public function updateInventoryItems(param1:Vector.<HangarShipEquipmentInventoryItem>, param2:Boolean) : void
      {
         var _loc4_:HangarShipEquipmentInventoryItem = null;
         var _loc5_:int = 0;
         if(!this._allItems)
         {
            this._allItems = new Vector.<HangarShipEquipmentInventoryItem>();
         }
         if(!param1)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_)
            {
               _loc5_ = this.getInventoryItemIndexByItemId(_loc4_.itemid);
               if(param2)
               {
                  if(_loc5_ >= 0)
                  {
                     this._allItems.splice(_loc5_,1);
                  }
               }
               else if(!this.isShowByLootType(_loc4_.lootType))
               {
                  if(_loc5_ >= 0)
                  {
                     this._allItems.splice(_loc5_,1);
                  }
               }
               else if(_loc5_ >= 0)
               {
                  this._allItems[_loc5_] = _loc4_;
               }
               else
               {
                  this._allItems.push(_loc4_);
               }
            }
            _loc3_++;
         }
      }
      
      private function getInventoryItemIndexByItemId(param1:Number) : int
      {
         var _loc3_:HangarShipEquipmentInventoryItem = null;
         if(!this._allItems)
         {
            return -1;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._allItems.length)
         {
            _loc3_ = this._allItems[_loc2_];
            if(Boolean(_loc3_) && _loc3_.itemid == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      private function itemEquipHangarId(param1:*, param2:Number) : Boolean
      {
         var _loc3_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.CANNONS][param1 - 1];
         var _loc4_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.CANNON_SHIELDS][param1 - 1];
         var _loc5_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.QUANTUMFLUIDCORE][param1 - 1];
         var _loc6_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.ENGINE_WEAPON][param1 - 1];
         var _loc7_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.ENGINE_ARMOR][param1 - 1];
         if(_loc3_.indexOf(param2) != -1 || _loc4_.indexOf(param2) != -1 || _loc5_.indexOf(param2) != -1 || _loc6_.indexOf(param2) != -1 || _loc7_.indexOf(param2) != -1)
         {
            return true;
         }
         return false;
      }
      
      public function getAllNotHangarItems(param1:int) : Vector.<WarpControlsItemData>
      {
         var _loc4_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:Vector.<WarpControlsItemData> = new Vector.<WarpControlsItemData>();
         var _loc3_:int = 0;
         while(_loc3_ < this._allItems.length)
         {
            _loc4_ = this._allItems[_loc3_];
            if((_loc4_.hangarId == 0 || _loc4_.hangarId == this._currentShip.hangarId) && !this.itemEquipHangarId(param1,_loc4_.itemid))
            {
               _loc2_.push(new WarpControlsItemData(WarpControlsConst.INVENTORY,_loc4_));
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getItemByHangarIdAndItemType(param1:Number, param2:String) : Vector.<WarpControlsItemData>
      {
         var _loc4_:String = null;
         var _loc6_:HangarShipEquipmentInventoryItem = null;
         var _loc3_:Vector.<WarpControlsItemData> = new Vector.<WarpControlsItemData>();
         if(param2 == ItemFilterTypes.Weapon__CannonType)
         {
            _loc4_ = WarpControlsConst.CANNONS;
         }
         if(param2 == ItemFilterTypes.Weapon__CannonShieldType)
         {
            _loc4_ = WarpControlsConst.CANNON_SHIELDS;
         }
         var _loc5_:int = 0;
         while(_loc5_ < this._allItems.length)
         {
            _loc6_ = this._allItems[_loc5_];
            if(_loc6_.hangarId == param1 && _loc6_.lootType == param2)
            {
               _loc3_.push(new WarpControlsItemData(_loc4_,_loc6_));
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function shipsItemMove(param1:HangarShipMoveItemsCommand) : void
      {
         if(param1.result == 1)
         {
            this.sendListRequest();
         }
      }
      
      public function shipsItemMoveRequest(param1:WarpChangeData) : void
      {
         var _loc2_:HangarShipMoveItemsRequest = new HangarShipMoveItemsRequest(param1.hangarId,param1.items,param1.source,param1.destination,param1.index,param1.configId,param1.slotSet,param1.droneId);
         connectionProxy.connectionManager.sendRequest(_loc2_);
      }
      
      public function get isDataComplete() : Boolean
      {
         return this._isDataComplete;
      }
      
      public function getShipCannonDatas(param1:int) : Vector.<WarpControlsItemData>
      {
         var _loc7_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.CANNONS][param1 - 1];
         var _loc3_:int = int(this._currentShip.getSoltable(WarpControlsConst.CANNONS).size);
         var _loc4_:Vector.<WarpControlsItemData> = new Vector.<WarpControlsItemData>();
         var _loc5_:Vector.<HangarShipEquipmentInventoryItem> = this.allItems;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            if(_loc7_.hangarId == this._currentShip.hangarId && _loc7_.lootType == ItemFilterTypes.Weapon__CannonType && _loc2_.indexOf(_loc7_.itemid) != -1)
            {
               _loc4_.push(new WarpControlsItemData(WarpControlsConst.CANNONS,_loc7_));
            }
            _loc6_++;
         }
         if(_loc4_.length < _loc3_)
         {
            this.addNullItemToDatas(_loc4_,_loc3_ - _loc4_.length,WarpControlsConst.CANNONS);
         }
         return _loc4_;
      }
      
      public function getShipQuantumFluidCoreDatas(param1:int) : Vector.<WarpControlsItemData>
      {
         var _loc7_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.QUANTUMFLUIDCORE][param1 - 1];
         var _loc3_:int = int(this._currentShip.getSoltable(WarpControlsConst.QUANTUMFLUIDCORE).size);
         var _loc4_:Vector.<WarpControlsItemData> = new Vector.<WarpControlsItemData>();
         var _loc5_:Vector.<HangarShipEquipmentInventoryItem> = this.allItems;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            if(_loc7_.hangarId == this._currentShip.hangarId && _loc7_.lootType == ItemFilterTypes.Weapon__QuantumFluidCoreType && _loc2_.indexOf(_loc7_.itemid) != -1)
            {
               _loc4_.push(new WarpControlsItemData(WarpControlsConst.QUANTUMFLUIDCORE,_loc7_));
            }
            _loc6_++;
         }
         if(_loc4_.length < _loc3_)
         {
            this.addNullItemToDatas(_loc4_,_loc3_ - _loc4_.length,WarpControlsConst.QUANTUMFLUIDCORE);
         }
         return _loc4_;
      }
      
      public function getShipCannonShieldsDatas(param1:int) : Vector.<WarpControlsItemData>
      {
         var _loc7_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.CANNON_SHIELDS][param1 - 1];
         var _loc3_:int = int(this._currentShip.getSoltable(WarpControlsConst.CANNON_SHIELDS).size);
         var _loc4_:Vector.<WarpControlsItemData> = new Vector.<WarpControlsItemData>();
         var _loc5_:Vector.<HangarShipEquipmentInventoryItem> = this.allItems;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            if(_loc7_.hangarId == this._currentShip.hangarId && _loc7_.lootType == ItemFilterTypes.Weapon__CannonShieldType && _loc2_.indexOf(_loc7_.itemid) != -1)
            {
               _loc4_.push(new WarpControlsItemData(WarpControlsConst.CANNON_SHIELDS,_loc7_));
            }
            _loc6_++;
         }
         if(_loc4_.length < _loc3_)
         {
            this.addNullItemToDatas(_loc4_,_loc3_ - _loc4_.length,WarpControlsConst.CANNON_SHIELDS);
         }
         return _loc4_;
      }
      
      public function getShipDrivesDatas(param1:int) : Vector.<WarpControlsItemData>
      {
         var _loc7_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.ENGINE_WEAPON][param1 - 1];
         var _loc3_:int = int(this._currentShip.getSoltable(WarpControlsConst.ENGINE_WEAPON).size);
         var _loc4_:Vector.<WarpControlsItemData> = new Vector.<WarpControlsItemData>();
         var _loc5_:Vector.<HangarShipEquipmentInventoryItem> = this.allItems;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            if(_loc7_.hangarId == this._currentShip.hangarId && _loc7_.lootType == ItemFilterTypes.Equipment__DriveType && _loc2_.indexOf(_loc7_.itemid) != -1)
            {
               _loc4_.push(new WarpControlsItemData(WarpControlsConst.ENGINE_WEAPON,_loc7_));
            }
            _loc6_++;
         }
         if(_loc4_.length < _loc3_)
         {
            this.addNullItemToDatas(_loc4_,_loc3_ - _loc4_.length,WarpControlsConst.ENGINE_WEAPON);
         }
         return _loc4_;
      }
      
      public function getShipLensDatas(param1:int) : Vector.<WarpControlsItemData>
      {
         var _loc7_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:Vector.<int> = this._currentShip.equipmentWeapons[WarpControlsConst.ENGINE_ARMOR][param1 - 1];
         var _loc3_:int = int(this._currentShip.getSoltable(WarpControlsConst.ENGINE_ARMOR).size);
         var _loc4_:Vector.<WarpControlsItemData> = new Vector.<WarpControlsItemData>();
         var _loc5_:Vector.<HangarShipEquipmentInventoryItem> = this.allItems;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_.length)
         {
            _loc7_ = _loc5_[_loc6_];
            if(_loc7_.hangarId == this._currentShip.hangarId && _loc7_.lootType == ItemFilterTypes.Equipment__LensType && _loc2_.indexOf(_loc7_.itemid) != -1)
            {
               _loc4_.push(new WarpControlsItemData(WarpControlsConst.ENGINE_ARMOR,_loc7_));
            }
            _loc6_++;
         }
         if(_loc4_.length < _loc3_)
         {
            this.addNullItemToDatas(_loc4_,_loc3_ - _loc4_.length,WarpControlsConst.ENGINE_ARMOR);
         }
         return _loc4_;
      }
      
      private function addNullItemToDatas(param1:*, param2:int, param3:String = "") : void
      {
         var _loc4_:int = 0;
         while(_loc4_ < param2)
         {
            param1.push(new WarpControlsItemData(param3));
            _loc4_++;
         }
      }
      
      public function setItemHangarID(param1:Number, param2:Number = 0) : void
      {
         var _loc5_:HangarShipEquipmentInventoryItem = null;
         var _loc3_:Vector.<HangarShipEquipmentInventoryItem> = this.allItems;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            if(_loc5_.itemid == param1 && (_loc5_.lootType == ItemFilterTypes.Weapon__CannonShieldType || _loc5_.lootType == ItemFilterTypes.Weapon__CannonType))
            {
               _loc5_.hangarId = param2;
            }
            _loc4_++;
         }
      }
      
      public function getInventoryItemByItemId(param1:Number) : HangarShipEquipmentInventoryItem
      {
         var _loc3_:HangarShipEquipmentInventoryItem = null;
         if(!this._allItems)
         {
            return null;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._allItems.length)
         {
            _loc3_ = this._allItems[_loc2_];
            if(_loc3_.itemid == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

