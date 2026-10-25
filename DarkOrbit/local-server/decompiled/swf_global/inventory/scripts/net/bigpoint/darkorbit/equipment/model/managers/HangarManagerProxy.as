package net.bigpoint.darkorbit.equipment.model.managers
{
   import flash.events.TimerEvent;
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.ShipInfoProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.User;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.dataInterchange.DataInterchange;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class HangarManagerProxy extends Proxy
   {
      
      public static const PROXY_NAME:String = "HangarManagerProxy";
      
      public static const SEARCH_TARGET_PET:String = "pet";
      
      public static const SEARCH_TARGET_SHIP:String = "ship";
      
      public static const SEARCH_TARGET_DRONES:String = "drones";
      
      private static const DEFAULT_DRONE_NODE_NAME:String = "default";
      
      private static const DEFAULT_HANGAR_SLOT_ID:int = 0;
      
      public var currentHangarSlotID:int = -1;
      
      protected var hangarSlots:Dictionary = new Dictionary();
      
      protected var currentHangarIsEmpty:Boolean = false;
      
      protected var isJSreadyTimer:Timer;
      
      protected var isReadyForJSCalls:Boolean = false;
      
      private var inventoryItems:Array;
      
      private var inventoryItemInfos:Array;
      
      private var userInfoManager:UserInfoManager;
      
      private var _changeHangarCallerCallback:Function;
      
      public function HangarManagerProxy()
      {
         super(PROXY_NAME,null);
      }
      
      public static function setHangarBarActive(param1:Boolean) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("setHangarBarActive",param1);
         }
      }
      
      override public function onRegister() : void
      {
         this.initializeExternalInterfaceCallbacks();
      }
      
      public function preinitializeWithHangarSlotID(param1:int) : void
      {
         this.currentHangarSlotID = param1;
      }
      
      public function initializeWithData(param1:Object) : void
      {
         this.intitializeInventoryAndHangarSlots(param1);
         var _loc2_:int = this.getSelectedHangarSlotID();
         this.setHangar(_loc2_);
         this.currentHangarSlotID = _loc2_;
         this.isReadyForJSCalls = true;
      }
      
      public function intitializeInventoryAndHangarSlots(param1:Object) : void
      {
         this.initializeShipData(param1);
         this.initializeUserInfos(param1);
         this.initializeInventoryItems(param1);
         this.updateHangarSlots(param1);
      }
      
      private function initializeShipData(param1:Object) : void
      {
         var _loc6_:Object = null;
         var _loc2_:Array = param1.shipInfo;
         var _loc3_:uint = _loc2_.length;
         var _loc4_:ShipInfoProxy = facade.retrieveProxy(ShipInfoProxy.NAME) as ShipInfoProxy;
         _loc4_.init();
         var _loc5_:uint = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc4_.add(_loc6_);
            _loc5_++;
         }
      }
      
      private function initializeInventoryItems(param1:Object) : void
      {
         if(param1.itemInfo)
         {
            this.inventoryItemInfos = param1.itemInfo;
            ItemInfoManager.getInstance().init(this.inventoryItemInfos,this.getUserFaction());
         }
         if(param1.items)
         {
            this.inventoryItems = param1.items;
            Inventory.getInstance().init(this.inventoryItems);
         }
      }
      
      private function initializeUserInfos(param1:Object) : void
      {
         if(param1.userInfo)
         {
            this.userInfoManager = new UserInfoManager(param1.userInfo);
         }
      }
      
      public function reloadCurrentHangarWithCallback(param1:Function) : void
      {
         this.changeHangar(this.currentHangarSlotID,true,param1);
      }
      
      public function reloadCurrentHangar() : void
      {
         this.changeHangar(this.currentHangarSlotID,true);
      }
      
      public function changeHangar(param1:int, param2:Boolean = false, param3:Function = null) : void
      {
         var _loc4_:HangarSlotEntity = null;
         var _loc5_:int = 0;
         var _loc6_:ConnectionProxy = null;
         this._changeHangarCallerCallback = param3;
         if(param1 != this.currentHangarSlotID || param2)
         {
            this.currentHangarSlotID = param1;
            _loc4_ = this.getHangarSlot(param1);
            if(_loc4_)
            {
               _loc5_ = _loc4_.hangarID;
               _loc6_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
               if(_loc6_)
               {
                  _loc6_.setHangarID(_loc5_);
                  _loc6_.getHangarData(this.changeHangarCallback);
               }
            }
         }
      }
      
      protected function changeHangarCallback(param1:Object) : void
      {
         var _loc2_:Object = param1.map;
         FilterManager.getInstance().initNameMaps(_loc2_);
         var _loc3_:Object = param1.ret;
         this.intitializeInventoryAndHangarSlots(_loc3_);
         this.setHangar(this.currentHangarSlotID);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED);
         if(this._changeHangarCallerCallback != null)
         {
            this._changeHangarCallerCallback();
         }
      }
      
      private function updateHangarSlots(param1:Object) : void
      {
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:Object = null;
         var _loc12_:ShipInfoVO = null;
         var _loc13_:HangarSlotEntity = null;
         var _loc14_:ShipInfoVO = null;
         var _loc2_:HangarSlotEntity = this.getSelectedHangarSlotEntity();
         var _loc3_:uint = 0;
         if(_loc2_)
         {
            _loc3_ = uint(_loc2_.hangarID);
         }
         var _loc4_:ShipInfoProxy = facade.retrieveProxy(ShipInfoProxy.NAME) as ShipInfoProxy;
         var _loc5_:Object = param1.hangars;
         for(_loc6_ in _loc5_)
         {
            _loc11_ = _loc5_[_loc6_];
            _loc12_ = _loc4_.getOwnedByHangarID(_loc11_.hangarID);
            if(_loc12_)
            {
               _loc13_ = new HangarSlotEntity(_loc11_,_loc12_);
               _loc13_.slotID = int(_loc6_);
               if(_loc13_.hangarID == _loc3_)
               {
                  _loc13_.isSelected = true;
               }
               this.hangarSlots[int(_loc6_)] = _loc13_;
            }
         }
         _loc7_ = 0;
         for(_loc6_ in this.hangarSlots)
         {
            if(int(_loc6_) > _loc7_)
            {
               _loc7_ = uint(int(_loc6_));
            }
         }
         _loc8_ = _loc7_;
         _loc9_ = _loc4_.notOwned.length;
         _loc10_ = 0;
         while(_loc10_ < _loc9_)
         {
            _loc8_++;
            _loc14_ = _loc4_.notOwned[_loc10_];
            param1 = {
               "hangar_is_active":false,
               "hangarID":_loc14_.hangarID,
               "general":{"ship":{"L":_loc14_.lootID}}
            };
            _loc13_ = new HangarSlotEntity(param1,_loc14_);
            _loc13_.slotID = _loc8_;
            this.hangarSlots[_loc8_] = _loc13_;
            _loc10_++;
         }
      }
      
      public function setHangar(param1:int) : void
      {
         var _loc2_:HangarSlotEntity = this.getHangarSlot(param1);
         var _loc3_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         _loc3_.setHangarID(_loc2_.hangarID);
         ItemInfoManager.getInstance().init(this.inventoryItemInfos,this.getUserFaction());
         Inventory.getInstance().init(this.inventoryItems);
         this.currentHangarIsEmpty = _loc2_.isHangarEmpty();
         EquipmentManager.getInstance().init(_loc2_.general);
         _loc3_.fillCPUExtenders();
         ConfigManager.getInstance().init(_loc2_.configs);
      }
      
      public function getHangarSlot(param1:int) : HangarSlotEntity
      {
         var _loc2_:HangarSlotEntity = null;
         if(this.hangarSlots[param1] != null)
         {
            _loc2_ = this.hangarSlots[String(param1)];
         }
         else
         {
            _loc2_ = this.hangarSlots[DEFAULT_HANGAR_SLOT_ID];
         }
         return _loc2_;
      }
      
      public function setHangarSlot(param1:HangarSlotEntity) : void
      {
         var _loc2_:String = null;
         var _loc3_:HangarSlotEntity = null;
         for(_loc2_ in this.hangarSlots)
         {
            _loc3_ = this.hangarSlots[_loc2_];
            if(_loc3_.hangarID == param1.hangarID)
            {
               _loc3_.isSelected = true;
            }
            else
            {
               _loc3_.isSelected = false;
            }
         }
         this.hangarSlots[String(param1.slotID)] = param1;
      }
      
      protected function getAllHangarSlotIDs() : Vector.<int>
      {
         var _loc2_:String = null;
         var _loc1_:Vector.<int> = new Vector.<int>();
         for(_loc2_ in this.hangarSlots)
         {
            _loc1_.push(int(_loc2_));
         }
         return _loc1_;
      }
      
      public function getAllHangarSlotVOs() : Dictionary
      {
         return this.hangarSlots;
      }
      
      protected function getSelectedHangarSlotID() : int
      {
         var _loc2_:HangarSlotEntity = null;
         var _loc1_:uint = uint(int.MAX_VALUE);
         for each(_loc2_ in this.hangarSlots)
         {
            if(_loc2_.isSelected)
            {
               return _loc2_.slotID;
            }
            if(_loc2_.slotID < _loc1_)
            {
               _loc1_ = uint(_loc2_.slotID);
            }
         }
         return _loc1_;
      }
      
      protected function getSelectedHangarSlotEntity() : HangarSlotEntity
      {
         var _loc1_:HangarSlotEntity = null;
         var _loc2_:HangarSlotEntity = null;
         for each(_loc2_ in this.hangarSlots)
         {
            if(_loc2_.isSelected)
            {
               _loc1_ = _loc2_;
               break;
            }
         }
         return _loc1_;
      }
      
      public function getCurrentHangarSlotID() : int
      {
         return this.currentHangarSlotID;
      }
      
      public function getCurrentHangarSlotVO() : HangarSlotEntity
      {
         return this.getHangarSlot(this.currentHangarSlotID);
      }
      
      public function isHangarEmpty() : Boolean
      {
         return this.currentHangarIsEmpty;
      }
      
      public function isHangarFilled() : Boolean
      {
         return !this.currentHangarIsEmpty;
      }
      
      public function getUserFaction() : String
      {
         var _loc1_:User = this.userInfoManager.getUserData();
         return _loc1_.faction;
      }
      
      public function getAllHangarSlotEntities() : Vector.<HangarSlotEntity>
      {
         var _loc2_:HangarSlotEntity = null;
         var _loc1_:Vector.<HangarSlotEntity> = new Vector.<HangarSlotEntity>();
         for each(_loc2_ in this.hangarSlots)
         {
            _loc1_.push(_loc2_);
         }
         return _loc1_;
      }
      
      public function getAllEquippedItemIDsForHangar(param1:int) : Array
      {
         var _loc3_:HangarSlotEntity = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.hangarSlots)
         {
            if(_loc3_.hangarID == param1)
            {
               _loc4_ = _loc3_.configs;
               for(_loc5_ in _loc4_)
               {
                  _loc6_ = this.getAllEquippedItemIDsForHangarConfiguration(_loc4_,_loc5_);
                  _loc2_ = _loc2_.concat(_loc6_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getAllEquippedItemIDsForCurrentHangarConfiguration(param1:int) : Array
      {
         var _loc2_:HangarSlotEntity = this.getCurrentHangarSlotVO();
         var _loc3_:Object = _loc2_.configs;
         var _loc4_:String = param1.toString();
         return this.getAllEquippedItemIDsForHangarConfiguration(_loc3_,_loc4_);
      }
      
      private function getAllEquippedItemIDsForHangarConfiguration(param1:Object, param2:String) : Array
      {
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc3_:Array = [];
         if(!param1)
         {
            return _loc3_;
         }
         var _loc4_:Object = param1[param2];
         var _loc5_:Object = _loc4_[SEARCH_TARGET_SHIP];
         if(_loc5_)
         {
            _loc8_ = this.getAllItemsForShipOrPetNode(_loc5_);
            _loc3_ = _loc3_.concat(_loc8_);
         }
         var _loc6_:Object = _loc4_[SEARCH_TARGET_PET];
         if(_loc6_)
         {
            _loc9_ = this.getAllItemsForShipOrPetNode(_loc6_);
            _loc3_ = _loc3_.concat(_loc9_);
         }
         var _loc7_:Object = _loc4_[SEARCH_TARGET_DRONES];
         if(_loc7_)
         {
            _loc10_ = this.getAllItemsForDroneNode(_loc7_);
            _loc3_ = _loc3_.concat(_loc10_);
         }
         return _loc3_;
      }
      
      public function getAllEquippedItemIDsHangarWideExceptTheCurrentHangarFor(param1:String = "ALL") : Array
      {
         var _loc2_:Array = [];
         switch(param1)
         {
            case ActionIdentifiers.SHIP:
               _loc2_ = this.getAllEquippedItemIDsForPetOrShipExceptTheCurrentHangar(SEARCH_TARGET_SHIP);
               break;
            case ActionIdentifiers.PET:
               _loc2_ = this.getAllEquippedItemIDsForPetOrShipExceptTheCurrentHangar(SEARCH_TARGET_PET);
               break;
            case ActionIdentifiers.DRONES:
               _loc2_ = this.getAllEquippedItemIDsForDronesExceptTheCurrentHangar();
               break;
            case "ALL":
               _loc2_ = this.getAllEquippedItemIDsForPetOrShipExceptTheCurrentHangar(ActionIdentifiers.SHIP);
               _loc2_ = _loc2_.concat(this.getAllEquippedItemIDsForPetOrShipExceptTheCurrentHangar(ActionIdentifiers.PET));
               _loc2_ = _loc2_.concat(this.getAllEquippedItemIDsForDronesExceptTheCurrentHangar());
         }
         return _loc2_;
      }
      
      private function getAllEquippedItemIDsForPetOrShipExceptTheCurrentHangar(param1:String) : Array
      {
         var _loc3_:HangarSlotEntity = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.hangarSlots)
         {
            if(_loc3_.slotID != this.currentHangarSlotID)
            {
               _loc4_ = _loc3_.configs;
               for(_loc5_ in _loc4_)
               {
                  _loc6_ = _loc4_[_loc5_];
                  _loc7_ = _loc6_[param1];
                  _loc2_ = _loc2_.concat(this.getAllItemsForShipOrPetNode(_loc7_));
               }
            }
         }
         return _loc2_;
      }
      
      private function getAllEquippedItemIDsForDronesExceptTheCurrentHangar() : Array
      {
         var _loc3_:HangarSlotEntity = null;
         var _loc4_:Object = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc1_:String = SEARCH_TARGET_DRONES;
         var _loc2_:Array = [];
         for each(_loc3_ in this.hangarSlots)
         {
            if(_loc3_.slotID != this.currentHangarSlotID)
            {
               _loc4_ = _loc3_.configs;
               for(_loc5_ in _loc4_)
               {
                  _loc6_ = _loc4_[_loc5_];
                  _loc7_ = _loc6_[_loc1_];
                  _loc2_ = _loc2_.concat(this.getAllItemsForDroneNode(_loc7_));
               }
            }
         }
         return _loc2_;
      }
      
      private function getAllItemsForShipOrPetNode(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Array = [];
         if(param1)
         {
            _loc3_ = param1[DataInterchange.EQUIPPED_ITEMS];
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.length)
               {
                  _loc6_ = int(_loc4_[_loc5_]);
                  _loc2_.push(_loc6_);
                  _loc5_++;
               }
            }
         }
         return _loc2_;
      }
      
      private function getAllItemsForDroneNode(param1:Object) : Array
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc2_:Array = [];
         for(_loc3_ in param1)
         {
            _loc4_ = param1[_loc3_];
            if(_loc4_ != null)
            {
               _loc5_ = _loc4_[DataInterchange.EQUIPPED_ITEMS];
               for each(_loc6_ in _loc5_)
               {
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_.length)
                  {
                     _loc8_ = 0;
                     while(_loc8_ < _loc6_.length)
                     {
                        _loc9_ = int(_loc6_[_loc8_]);
                        _loc2_.push(_loc9_);
                        _loc8_++;
                     }
                     _loc7_++;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function addEquippedItemIDsTo(param1:String, param2:Array, param3:int) : void
      {
         switch(param1)
         {
            case ActionIdentifiers.SHIP:
               this.addEquippedItemIDsToShipOrPet(ActionIdentifiers.SHIP,param2,param3);
               break;
            case ActionIdentifiers.PET:
               this.addEquippedItemIDsToShipOrPet(ActionIdentifiers.PET,param2,param3);
               break;
            case ActionIdentifiers.DRONES:
               this.addEquippedItemIDsToDrone(param2,param3);
         }
      }
      
      protected function addEquippedItemIDsToShipOrPet(param1:String, param2:Array, param3:int) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc4_:HangarSlotEntity = this.getHangarSlot(this.currentHangarSlotID);
         var _loc5_:Object = _loc4_.configs[param3];
         if(_loc5_ != null)
         {
            _loc6_ = _loc5_[param1];
            if(_loc6_ != null)
            {
               _loc7_ = _loc6_[DataInterchange.EQUIPPED_ITEMS];
               if(_loc7_.tempSlot == null)
               {
                  _loc7_.tempSlot = [];
               }
               _loc8_ = 0;
               while(_loc8_ < param2.length)
               {
                  _loc7_.tempSlot.push(param2[_loc8_]);
                  _loc8_++;
               }
            }
         }
      }
      
      protected function addEquippedItemIDsToDrone(param1:Array, param2:int) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc3_:HangarSlotEntity = this.getHangarSlot(this.currentHangarSlotID);
         var _loc4_:Object = _loc3_.configs[param2];
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_[SEARCH_TARGET_DRONES];
            if(_loc5_ != null)
            {
               if(_loc5_.tempDrone == null)
               {
                  _loc5_.tempDrone = {};
                  _loc5_.tempDrone[DataInterchange.EQUIPPED_ITEMS] = {"default":[]};
               }
               _loc6_ = _loc5_.tempDrone;
               _loc7_ = _loc6_[DataInterchange.EQUIPPED_ITEMS][DEFAULT_DRONE_NODE_NAME];
               _loc8_ = 0;
               while(_loc8_ < param1.length)
               {
                  _loc7_.push(param1[_loc8_]);
                  _loc8_++;
               }
            }
         }
      }
      
      public function removeEquippedItemIDsFromCurrentHangar(param1:String, param2:Array, param3:int) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         switch(param1)
         {
            case ActionIdentifiers.SHIP:
               this.removeEquippedItemIDsFromCurrentHangarShipOrPet(ActionIdentifiers.SHIP,param2,param3);
               _loc4_ = [];
               _loc4_ = this.getAllEquippedItemIDsForPetOrShipExceptTheCurrentHangar(ActionIdentifiers.SHIP);
               this.removeEquippedItemIDsFromCurrentHangarShipOrPet(ActionIdentifiers.SHIP,_loc4_,param3);
               break;
            case ActionIdentifiers.PET:
               this.removeEquippedItemIDsFromCurrentHangarShipOrPet(ActionIdentifiers.PET,param2,param3);
               _loc5_ = [];
               _loc5_ = this.getAllEquippedItemIDsForPetOrShipExceptTheCurrentHangar(ActionIdentifiers.PET);
               this.removeEquippedItemIDsFromCurrentHangarShipOrPet(ActionIdentifiers.PET,_loc5_,param3);
               break;
            case ActionIdentifiers.DRONES:
               this.removeEquippedItemIDsFromCurrentHangarDrone(param2,param3);
               _loc6_ = [];
               _loc6_ = this.getAllEquippedItemIDsForDronesExceptTheCurrentHangar();
               this.removeEquippedItemIDsFromCurrentHangarDrone(_loc6_,param3);
         }
      }
      
      protected function removeEquippedItemIDsFromCurrentHangarShipOrPet(param1:String, param2:Array, param3:int) : void
      {
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc4_:HangarSlotEntity = this.getHangarSlot(this.currentHangarSlotID);
         var _loc5_:Object = _loc4_.configs[param3];
         if(_loc5_ != null)
         {
            _loc6_ = _loc5_[param1];
            if(_loc6_ != null)
            {
               _loc7_ = _loc6_[DataInterchange.EQUIPPED_ITEMS];
               for each(_loc8_ in _loc7_)
               {
                  _loc9_ = 0;
                  while(_loc9_ < param2.length)
                  {
                     _loc10_ = int(param2[_loc9_]);
                     _loc11_ = 0;
                     while(_loc11_ < _loc8_.length)
                     {
                        _loc12_ = int(_loc8_[_loc11_]);
                        if(_loc12_ == _loc10_)
                        {
                           _loc8_.splice(_loc11_,1);
                        }
                        _loc11_++;
                     }
                     _loc9_++;
                  }
               }
            }
         }
      }
      
      protected function removeEquippedItemIDsFromCurrentHangarDrone(param1:Array, param2:int) : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc3_:HangarSlotEntity = this.getHangarSlot(this.currentHangarSlotID);
         var _loc4_:Object = _loc3_.configs[param2];
         if(_loc4_ != null)
         {
            _loc5_ = _loc4_[SEARCH_TARGET_DRONES];
            if(_loc5_ != null)
            {
               if(_loc5_.tempDrone != null)
               {
                  _loc6_ = _loc5_.tempDrone;
                  _loc7_ = _loc6_[DataInterchange.EQUIPPED_ITEMS];
                  for each(_loc8_ in _loc7_)
                  {
                     _loc9_ = 0;
                     while(_loc9_ < param1.length)
                     {
                        _loc10_ = int(param1[_loc9_]);
                        _loc11_ = 0;
                        while(_loc11_ < _loc8_.length)
                        {
                           _loc12_ = int(_loc8_[_loc11_]);
                           if(_loc12_ == _loc10_)
                           {
                              _loc8_.splice(_loc11_,1);
                           }
                           _loc11_++;
                        }
                        _loc9_++;
                     }
                  }
               }
            }
         }
      }
      
      public function removeEquippedItemIDsHangarWide(param1:Array) : void
      {
      }
      
      private function getAllShipsHangarWideFor(param1:String) : Vector.<Ship>
      {
         var _loc3_:HangarSlotEntity = null;
         var _loc4_:Ship = null;
         var _loc2_:Vector.<Ship> = new Vector.<Ship>();
         for each(_loc3_ in this.hangarSlots)
         {
            if(!_loc3_.isHangarEmpty())
            {
               _loc4_ = _loc3_.getShip();
               if(_loc4_)
               {
                  if(param1 == _loc4_.getShipType())
                  {
                     _loc2_.push(_loc4_);
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function getAllFreeAndAssignedDesignsForType(param1:String, param2:String) : Object
      {
         var _loc7_:Ship = null;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Boolean = false;
         var _loc11_:int = 0;
         var _loc12_:Ship = null;
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         var _loc5_:Vector.<Ship> = this.getAllShipsHangarWideFor(param1);
         if(_loc5_.length > 0)
         {
            _loc7_ = _loc5_[0];
            _loc8_ = 0;
            while(_loc8_ < _loc7_.availableDesignsList.length)
            {
               _loc9_ = _loc7_.availableDesignsList[_loc8_];
               _loc10_ = false;
               _loc11_ = 0;
               while(_loc11_ < _loc5_.length)
               {
                  _loc12_ = _loc5_[_loc11_];
                  if(_loc12_.selectedDesign == _loc9_)
                  {
                     _loc10_ = true;
                     break;
                  }
                  _loc11_++;
               }
               if(_loc10_)
               {
                  _loc3_.push(_loc9_);
               }
               else
               {
                  _loc4_.push(_loc9_);
               }
               _loc8_++;
            }
         }
         if(param2 != param1)
         {
            _loc4_.push(param1);
         }
         return {
            "assignedDesigns":_loc3_,
            "freeDesigns":_loc4_
         };
      }
      
      public function changeHangarShipDesign(param1:String) : void
      {
         var _loc2_:HangarSlotEntity = this.getSelectedHangarSlot();
         var _loc3_:Ship = _loc2_.getShip();
         _loc3_.selectedDesign = param1;
      }
      
      private function initializeExternalInterfaceCallbacks() : void
      {
         if(ExternalInterface.available)
         {
            try
            {
               ExternalInterface.addCallback("changeHangarSlot",this.handleHangarSlotChangeCallFromJavascript);
               ExternalInterface.addCallback("isReady",this.handleIsFlashReadyRequestFromJavascript);
               if(!this.checkJavaScriptReady())
               {
                  this.isJSreadyTimer = new Timer(100,0);
                  this.isJSreadyTimer.addEventListener(TimerEvent.TIMER,this.handleCheckJSReadyTimerEvent);
                  this.isJSreadyTimer.start();
               }
            }
            catch(error:SecurityError)
            {
            }
            catch(error:Error)
            {
            }
         }
      }
      
      private function checkJavaScriptReady() : Boolean
      {
         return Boolean(ExternalInterface.call("isReady"));
      }
      
      private function handleHangarSlotChangeCallFromJavascript(param1:Object) : void
      {
         var _loc2_:int = 0;
         if(this.isReadyForJSCalls)
         {
            _loc2_ = int(param1);
            if(_loc2_ >= 0)
            {
               sendNotification(ApplicationNotificationNames.HANGAR_SLOT_CHANGED,_loc2_);
            }
         }
      }
      
      private function handleIsFlashReadyRequestFromJavascript() : void
      {
         if(this.isReadyForJSCalls)
         {
            if(ExternalInterface.available)
            {
               ExternalInterface.call("flashInitFinished");
            }
         }
      }
      
      private function handleCheckJSReadyTimerEvent(param1:TimerEvent) : void
      {
         var _loc2_:Boolean = this.checkJavaScriptReady();
         if(_loc2_)
         {
            this.isJSreadyTimer.stop();
            this.isJSreadyTimer.removeEventListener(TimerEvent.TIMER,this.handleCheckJSReadyTimerEvent);
         }
      }
      
      public function redirectToEquipmentClient() : void
      {
         ExternalInterfaceManager.redirectToEquipmentClient();
      }
      
      public function getSelectedHangarSlot() : HangarSlotEntity
      {
         return this.getHangarSlot(this.getSelectedHangarSlotID());
      }
   }
}

