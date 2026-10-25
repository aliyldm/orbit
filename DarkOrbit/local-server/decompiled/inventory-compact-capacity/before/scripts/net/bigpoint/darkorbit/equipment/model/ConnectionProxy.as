package net.bigpoint.darkorbit.equipment.model
{
   import flash.events.Event;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetInfoVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ConfigManager;
   import net.bigpoint.darkorbit.equipment.model.managers.EquipmentManager;
   import net.bigpoint.darkorbit.equipment.model.managers.ExternalInterfaceManager;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.model.transporter.Transporter;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.ItemFilter;
   import net.bigpoint.dataInterchange.DataInterchange;
   import net.bigpoint.dataInterchange.DataInterchangeEvent;
   import net.bigpoint.dataInterchange.Transaction;
   import org.puremvc.as3.interfaces.IProxy;
   import org.puremvc.as3.patterns.proxy.Proxy;
   
   public class ConnectionProxy extends Proxy implements IProxy
   {
      
      public static const PROXY_NAME:String = "ConnectionProxy";
      
      public static const INVENTORY_EQUIPPED:int = 0;
      
      public static const MAX_CONFIGS:int = 2;
      
      public static const EXTENDER_CPUS:Dictionary = new Dictionary();
      
      public static const autoBuyAmmo:String = "equipment_extra_cpu_alb-x";
      
      public static const autoBuyRocket:String = "equipment_extra_cpu_rb-x";
      
      public var inventory:Inventory;
      
      public var configManager:ConfigManager;
      
      public var equipmentManager:EquipmentManager;
      
      protected var hangarManager:HangarManagerProxy;
      
      private var _initialized:Boolean = false;
      
      private var initTransaction:Transaction;
      
      private var dataInterchange:DataInterchange;
      
      public var activeConfig:int = 1;
      
      public var currentActionInProgress:String;
      
      private var itemsToMove:Array;
      
      private var currentActiveTransporter:Object = new Object();
      
      private var currentOpenEquipmentTab:String = "ship";
      
      private var shipDesignToEquip:String;
      
      private var possibleNewPetName:String;
      
      private var _activateShipCallback:Function;
      
      private var _callback_getCompatibleShips:Function;
      
      private var _importHangarId:uint;
      
      protected var getHangarSlotDataCallback:Function;
      
      public function ConnectionProxy(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function fillCPUExtenders() : void
      {
         var _loc1_:int = Settings.defaultNumberOfExtrasSlots;
         ConnectionProxy.EXTENDER_CPUS["equipment_extra_cpu_sle-01"] = _loc1_ + 2;
         ConnectionProxy.EXTENDER_CPUS["equipment_extra_cpu_sle-02"] = _loc1_ + 4;
         ConnectionProxy.EXTENDER_CPUS["equipment_extra_cpu_sle-03"] = _loc1_ + 6;
         ConnectionProxy.EXTENDER_CPUS["equipment_extra_cpu_sle-04"] = _loc1_ + 10;
      }
      
      public function beginConnection() : void
      {
         this.dataInterchange = new DataInterchange();
         this.dataInterchange.addEventListener(DataInterchangeEvent.SERVER_RESPONSE_ERROR,this.handleServerResponseError);
         this.dataInterchange.addEventListener(DataInterchangeEvent.GET_HANGAR_LIST,this.handleGetHangarListDataResponse);
         this.dataInterchange.getHangarList();
      }
      
      protected function handleGetHangarListDataResponse(param1:DataInterchangeEvent) : void
      {
         this.initTransaction = param1.transaction;
         this.buildStructure(this.initTransaction.response.data);
         sendNotification(ApplicationNotificationNames.BOOTSTRAP_FINISHED);
      }
      
      private function buildStructure(param1:Object) : void
      {
         if(this._initialized)
         {
            return;
         }
         this.createManagersAndInventory();
         this.initManagers(param1);
         this._initialized = true;
      }
      
      protected function createManagersAndInventory() : void
      {
         this.configManager = ConfigManager.getInstance();
         this.equipmentManager = EquipmentManager.getInstance();
         this.inventory = Inventory.getInstance();
         this.hangarManager = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
      }
      
      private function initManagers(param1:Object) : void
      {
         var _loc2_:FilterManager = FilterManager.getInstance();
         _loc2_.initNameMaps(param1.map);
         var _loc3_:Object = param1.ret;
         _loc2_.init(_loc3_.filters);
         this.hangarManager.initializeWithData(_loc3_);
      }
      
      private function handleServerResponseError(param1:DataInterchangeEvent = null) : void
      {
         this.showErrorMessageDialog(param1.transaction.getErrorMessage());
      }
      
      public function showErrorMessageDialog(param1:String = "") : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.ERROR_POPUP;
         if(param1.length > 0)
         {
            _loc2_.callback = this.handleShowErrorMessageDialogConfirmation;
         }
         else
         {
            param1 = BPLocale.getItem("popup_unspecific_error_description");
            _loc2_.buttonText = BPLocale.getItem("label_button_restart");
            _loc2_.callback = this.handleShowErrorMessageDialogConfirmationOnRedirect;
         }
         _loc2_.errorMessage = param1;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function handleShowErrorMessageDialogConfirmationOnRedirect(param1:Event = null) : void
      {
         ExternalInterfaceManager.redirectToEquipmentClient();
      }
      
      private function handleShowErrorMessageDialogConfirmation(param1:Event = null) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      protected function handleResponse(param1:Transaction, param2:Boolean = true) : Boolean
      {
         if(param2)
         {
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false,SuspendView.COMMUNICATING_WITH_SERVER]);
         }
         if(param1.hasErrors())
         {
            this.dataInterchange.dispatchServerResponseError(param1);
            return false;
         }
         return true;
      }
      
      public function getShipDetails(param1:String, param2:String = null) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         var _loc3_:Object = {};
         _loc3_.params = {};
         _loc3_.params.hangarId = param1;
         if(param2)
         {
            _loc3_.params.lootId = param2;
         }
         this.dataInterchange.executeAction("getShipDetails",_loc3_,this.handleGetShipDetailsResponse,param1 == "0" ? 0 : int(param1));
      }
      
      protected function handleGetShipDetailsResponse(param1:Transaction) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:ShipDetailsViewDataProxy = null;
         var _loc5_:ShipDetailsViewData = null;
         if(this.handleResponse(param1))
         {
            _loc2_ = param1.request.parameters.params;
            _loc3_ = _loc2_.hangarId;
            _loc4_ = facade.retrieveProxy(ShipDetailsViewDataProxy.NAME) as ShipDetailsViewDataProxy;
            _loc5_ = new ShipDetailsViewData(param1.response.data.ret);
            _loc4_.setInfo(_loc3_,_loc5_);
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false,SuspendView.COMMUNICATING_WITH_SERVER]);
         }
      }
      
      public function setFavourite(param1:uint, param2:Boolean) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         var _loc3_:Object = new Object();
         var _loc4_:Object = _loc3_.params = new Object();
         _loc4_.hangarId = param1;
         _loc4_.activate = param2;
         this.dataInterchange.executeAction("setFavourite",_loc3_,this.handleSetFavouriteResponse);
      }
      
      protected function handleSetFavouriteResponse(param1:Transaction) : void
      {
         if(this.handleResponse(param1))
         {
         }
      }
      
      public function activateShip(param1:uint, param2:Boolean, param3:Function = null) : void
      {
         this._activateShipCallback = param3;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         var _loc4_:Object = new Object();
         var _loc5_:Object = _loc4_.params = new Object();
         _loc5_.hangarId = param1;
         this.dataInterchange.executeAction("activateShip",_loc4_,this.handleActivateShipResponse);
      }
      
      protected function handleActivateShipResponse(param1:Transaction) : void
      {
         if(this.handleResponse(param1))
         {
            sendNotification(ApplicationNotificationNames.SHIP_ACTIVATION_RESPONSE,param1.hasErrors());
         }
         if(this._activateShipCallback != null)
         {
            this._activateShipCallback();
         }
      }
      
      public function getCompatibleShips(param1:uint, param2:Function) : void
      {
         this._callback_getCompatibleShips = param2;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         var _loc3_:Object = {};
         _loc3_.params = {};
         _loc3_.params.hangarId = param1;
         this.dataInterchange.executeAction("getCompatibleShips",_loc3_,this.handleGetShipImportConfigurationList);
      }
      
      protected function handleGetShipImportConfigurationList(param1:Transaction) : void
      {
         if(this.handleResponse(param1,false))
         {
            if(this._callback_getCompatibleShips != null)
            {
               this._callback_getCompatibleShips(param1.response.data.ret as Array);
               this._callback_getCompatibleShips = null;
            }
         }
      }
      
      public function importShipConfiguration(param1:uint, param2:uint) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         var _loc3_:Object = new Object();
         var _loc4_:Object = _loc3_.params = new Object();
         _loc4_.hangarId = param1;
         _loc4_.importId = this._importHangarId = param2;
         this.dataInterchange.executeAction("importConfig",_loc3_,this.handleImportConfigResponse);
      }
      
      protected function handleImportConfigResponse(param1:Transaction) : void
      {
         var transaction:Transaction = param1;
         setTimeout(function():void
         {
            if(handleResponse(transaction))
            {
               activateShip(_importHangarId,true,foobar);
            }
         },1000);
      }
      
      private function foobar() : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         ExternalInterfaceManager.redirectToEquipmentClient(Settings.SHOW_VIEW_ON_INIT__EQUIPMENT);
      }
      
      public function setHangarID(param1:uint) : void
      {
         this.dataInterchange.setHangarID(param1);
      }
      
      public function updateCurrentEquipmentTab(param1:String = null) : void
      {
         if(param1 != null)
         {
            this.currentOpenEquipmentTab = param1;
         }
         this.getFiltersForSelectedTab(this.currentOpenEquipmentTab);
      }
      
      public function getHangarData(param1:Function) : void
      {
         this.getHangarSlotDataCallback = param1;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         this.dataInterchange.addEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleGetHangarSlotDataResponse);
         this.dataInterchange.serverRequest(ActionIdentifiers.GET_HANGARSLOT_DATA,null);
      }
      
      private function handleGetHangarSlotDataResponse(param1:DataInterchangeEvent) : void
      {
         var _loc3_:Object = null;
         this.dataInterchange.removeEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleGetHangarSlotDataResponse);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false,SuspendView.COMMUNICATING_WITH_SERVER]);
         var _loc2_:Transaction = param1.transaction;
         if(this.getHangarSlotDataCallback != null)
         {
            _loc3_ = _loc2_.response.data;
            this.getHangarSlotDataCallback(_loc3_);
         }
      }
      
      public function shipSellRequest(param1:Object) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         this.currentActionInProgress = param1.action;
         this.currentActiveTransporter = param1;
         this.dataInterchange.serverRequest(param1.action,param1,this.handleSellShipResponse);
      }
      
      private function handleSellShipResponse(param1:Transaction) : void
      {
         var _loc2_:Object = null;
         var _loc3_:HangarManagerProxy = null;
         if(!param1.hasErrors())
         {
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false,SuspendView.COMMUNICATING_WITH_SERVER]);
            _loc2_ = param1.response.data;
            if(_loc2_.ret == 1)
            {
               _loc3_ = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
               _loc3_.redirectToEquipmentClient();
               _loc3_.reloadCurrentHangar();
            }
         }
         else
         {
            this.showErrorMessageDialog(param1.getErrorMessage());
         }
      }
      
      public function itemMoveRequest(param1:Object, param2:String) : void
      {
         this.currentActionInProgress = param2;
         this.currentActiveTransporter = param1;
         this.itemsToMove = param1.from.items;
         this.dataInterchange.serverRequest(param1.action,param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      public function itemRepairRequest(param1:Object, param2:String) : void
      {
         this.currentActionInProgress = param2;
         this.currentActiveTransporter = param1;
         this.dataInterchange.serverRequest(param1.action,param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      public function itemSellRequest(param1:Object, param2:String) : void
      {
         this.currentActionInProgress = param2;
         this.currentActiveTransporter = param1;
         this.dataInterchange.serverRequest(param1.action,param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      public function itemQuickBuyRequest(param1:Object, param2:String) : void
      {
         this.currentActionInProgress = param2;
         this.currentActiveTransporter = param1;
      }
      
      public function buyExtraPetSlotRequest(param1:Object) : void
      {
         this.currentActionInProgress = param1.action;
         this.currentActiveTransporter = param1;
         this.dataInterchange.serverRequest(param1.action,param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      public function rearrangeInventoryRequest(param1:Object, param2:String) : void
      {
         this.currentActionInProgress = param2;
         this.currentActiveTransporter = param1;
         this.dataInterchange.serverRequest(param1.action,param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      public function splitInventoryItemRequest(param1:Object, param2:String) : void
      {
         this.currentActionInProgress = param2;
         this.currentActiveTransporter = param1;
         this.dataInterchange.serverRequest(param1.action,param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      public function handleHomePageRedirect() : void
      {
         ExternalInterfaceManager.redirectToExternalHome();
      }
      
      private function handleServerActionReply(param1:DataInterchangeEvent) : void
      {
         var _loc3_:Object = null;
         var _loc2_:Transaction = param1.transaction;
         this.updatePaymentValuesViaJavascriptBridge(_loc2_);
         if(_loc2_.response.data.sessionInvalid != null)
         {
            if(_loc2_.response.data.sessionInvalid == 1)
            {
               this.handleHomePageRedirect();
               return;
            }
         }
         if(_loc2_.response.data.update != null)
         {
            this.handleOptionalUpdates(_loc2_);
            this.dataInterchange.removeEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
            return;
         }
         if(this.currentActiveTransporter.action == ActionIdentifiers.SELL_DRONE)
         {
            if(_loc2_.response.data.ret == 1)
            {
               this.handleSlotCpuUnequip(_loc2_.response.data.slotCpuMove);
               this.handleDroneRemoval();
            }
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
            return;
         }
         if(this.currentActiveTransporter.action == ActionIdentifiers.REPAIR_DRONE)
         {
            if(_loc2_.response.data.ret == 1)
            {
               this.handleDroneRepair();
            }
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
            return;
         }
         if(this.currentActiveTransporter.action == ActionIdentifiers.REPAIR_MODULE)
         {
            if(_loc2_.response.data.ret == 1)
            {
               this.handleModuleRepair();
            }
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
            return;
         }
         if(this.currentActiveTransporter.action == ActionIdentifiers.BUY_SLOT)
         {
            if(_loc2_.response.data.ret == 1)
            {
               this.handleUnlockSlot();
            }
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
            return;
         }
         if(this.currentActiveTransporter.action == ActionIdentifiers.MOVE_DRONE_DESIGN)
         {
            _loc3_ = _loc2_.response.data.ret;
            this.moveDroneDesign(_loc3_);
            return;
         }
         if(this.currentActionInProgress == ActionIdentifiers.SELL)
         {
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         }
         else if(this.currentActionInProgress == ActionIdentifiers.REMOVE)
         {
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         }
         else if(this.currentActionInProgress == ActionIdentifiers.INVENTORY_ITEM_SPLIT)
         {
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         }
         else if(this.currentActiveTransporter.to.target == "inventory" && this.currentActiveTransporter.from.target == "inventory")
         {
            this.reOrganiseModelForInventoryRearrange(_loc2_.response.data.ret);
         }
         else
         {
            this.reOrganiseModelForMove(_loc2_.response.data.ret,this.itemsToMove);
         }
         this.dataInterchange.removeEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      private function moveDroneDesign(param1:Object) : void
      {
         var _loc2_:Boolean = Boolean(param1.success);
         var _loc3_:Object = param1.newEffects;
         this.updateDroneEffects(_loc3_);
         this.reOrganiseModelForMove(_loc2_,this.itemsToMove);
         this.dataInterchange.removeEventListener(DataInterchangeEvent.ACTION_REPLY_RECEIVED,this.handleServerActionReply);
      }
      
      private function handleUnlockSlot() : void
      {
         sendNotification(ApplicationNotificationNames.UNLOCK_SLOT,[this.currentActiveTransporter.target,this.currentActiveTransporter.slotset]);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function handleDroneRepair() : void
      {
      }
      
      private function handleModuleRepair() : void
      {
         var _loc1_:String = this.currentActiveTransporter.itemId;
         if(_loc1_)
         {
            sendNotification(ApplicationNotificationNames.INVENTORY_UPDATE_ACTIONBUTTONS);
            sendNotification(ApplicationNotificationNames.INVENTORY_UPDATE_REPAIRED_MODULE,_loc1_);
         }
      }
      
      private function handleDroneRemoval() : void
      {
         var _loc1_:Array = this.configManager.getAllItemsEquippedToThisDrone(this.currentActiveTransporter.itemId);
         this.reappropriateDroneItems(_loc1_);
         this.killDrone(this.currentActiveTransporter.itemId);
         sendNotification(ApplicationNotificationNames.KILL_DRONE,this.currentActiveTransporter.itemId);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function reappropriateDroneItems(param1:Array) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = this.configManager.updateDroneEquipment(_loc3_,ConfigManager.REMOVE,this.currentActiveTransporter.itemId);
            sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc4_);
            _loc2_++;
         }
      }
      
      private function killDrone(param1:String) : void
      {
         this.equipmentManager.deleteDrone(param1);
         this.configManager.deleteDrone(param1);
         Settings.USER_HAS_DRONES = this.equipmentManager.checkIfDronesRemain();
      }
      
      private function handleSlotCpuUnequip(param1:*) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:ItemInstanceVO = null;
         var _loc7_:Array = null;
         if(this.currentActiveTransporter.action == ActionIdentifiers.SELL || this.currentActiveTransporter.action == ActionIdentifiers.MULTI_ITEMS_SELL || this.currentActiveTransporter.action == ActionIdentifiers.SELL_DRONE)
         {
            if(param1["1"].length > 0)
            {
               _loc3_ = this.findSlotCPUIndexInArray(param1["1"]);
               _loc4_ = param1["1"][_loc3_];
               _loc5_ = param1["1"].splice(_loc3_,1);
               _loc6_ = this.inventory.getItem(_loc4_);
               _loc2_ = this.configManager.updateEquipment(param1["1"],ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.EXTRAS,1);
               sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CONFIG,[_loc2_,1]);
               if(Settings.activeConfig == 1)
               {
                  sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc2_);
               }
               this.checkForSlotExtenderCPU([_loc6_],true,1);
            }
            if(param1["2"].length > 0)
            {
               _loc3_ = this.findSlotCPUIndexInArray(param1["2"]);
               _loc4_ = param1["2"][_loc3_];
               _loc5_ = param1["2"].splice(_loc3_,1);
               _loc6_ = this.inventory.getItem(_loc4_);
               _loc2_ = this.configManager.updateEquipment(param1["2"],ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.EXTRAS,2);
               sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CONFIG,[_loc2_,2]);
               if(Settings.activeConfig == 2)
               {
                  sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc2_);
               }
               this.checkForSlotExtenderCPU([_loc6_],true,2);
            }
         }
         else if(this.currentActiveTransporter.from.droneId != null)
         {
            _loc3_ = this.findSlotCPUIndexInArray(param1);
            _loc4_ = param1[_loc3_];
            _loc5_ = param1.splice(_loc3_,1);
            _loc7_ = this.configManager.updateDroneEquipment([_loc4_],ConfigManager.REMOVE,this.currentActiveTransporter.from.droneId);
            _loc2_ = this.configManager.updateEquipment(param1,ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.EXTRAS);
            sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CURRENT_MENU,_loc7_);
            sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc7_);
            sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CURRENT_MENU,_loc2_);
            sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc2_);
            this.checkForSlotExtenderCPU(_loc7_,true);
         }
         else
         {
            _loc2_ = this.configManager.updateEquipment(param1,ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.EXTRAS);
            sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CURRENT_MENU,_loc2_);
            sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc2_);
            this.removeAllMovedItemIDsFromHangarManager(_loc2_);
            this.checkForSlotExtenderCPU(_loc2_,true);
         }
      }
      
      private function handleOptionalUpdates(param1:Transaction) : void
      {
         var _loc3_:ItemInstanceVO = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc6_:Vector.<ItemInstanceVO> = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:uint = 0;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc12_:ItemInstanceVO = null;
         var _loc13_:Drone = null;
         var _loc2_:Object = param1.response.data.update;
         if(_loc2_.slotCpuMove)
         {
            _loc5_ = _loc2_.slotCpuMove;
            this.handleSlotCpuUnequip(_loc5_);
         }
         if(_loc2_.changed)
         {
            for(_loc4_ in _loc2_.changed)
            {
               _loc3_ = this.inventory.optionalItemUpdate(_loc4_,_loc2_.changed[_loc4_]);
               if(_loc3_.quantity > 0)
               {
                  sendNotification(ApplicationNotificationNames.UPDATE_UNIQUE_ITEM,_loc3_);
                  this.getSelectedItemInfo(_loc4_,ApplicationNotificationNames.FIND_SELECTED_ITEM_INFO);
               }
               else if(_loc3_.quantity == 0)
               {
                  _loc2_.deleted = [_loc4_];
               }
            }
         }
         if(_loc2_.deleted)
         {
            _loc6_ = new Vector.<ItemInstanceVO>();
            _loc7_ = [];
            _loc8_ = ConfigManager.getInstance().getEquippedItemsConfigs();
            _loc8_ = _loc8_[0].concat(_loc8_[1]);
            _loc9_ = uint(_loc2_.deleted.length);
            _loc10_ = 0;
            while(_loc10_ < _loc9_)
            {
               _loc11_ = _loc2_.deleted[_loc10_];
               _loc12_ = this.inventory.getItem(_loc11_);
               if(_loc8_.indexOf(_loc11_) < 0)
               {
                  _loc6_.push(_loc12_);
               }
               else
               {
                  _loc7_.push(_loc12_);
               }
               this.configManager.deleteItem(_loc11_);
               this.inventory.deleteItem(_loc11_);
               _loc10_++;
            }
            if(_loc9_ == 1)
            {
               sendNotification(ApplicationNotificationNames.DELETE_ITEM,_loc12_);
            }
            else
            {
               if(_loc7_.length > 0)
               {
                  sendNotification(ApplicationNotificationNames.DELETE_MULTIPLE_EQUIPPED_ITEMS,_loc7_);
               }
               if(_loc6_.length > 0)
               {
                  sendNotification(ApplicationNotificationNames.DELETE_MULTIPLE_INVENTORY_ITEMS,_loc6_);
               }
            }
            sendNotification(ApplicationNotificationNames.CLEAR_ITEM_INFO);
         }
         if(_loc2_.added)
         {
            for(_loc4_ in _loc2_.added)
            {
               _loc3_ = this.inventory.addItem(_loc4_,_loc2_.added[_loc4_]);
               sendNotification(ApplicationNotificationNames.ADD_NEW_ITEM,_loc3_);
            }
         }
         if(_loc2_.droneRepair)
         {
            Settings.DRONE_REPAIR_COST = _loc2_.droneRepair.repair;
            _loc13_ = this.equipmentManager.drones[this.currentActiveTransporter.itemId];
            _loc13_.level = _loc2_.droneRepair.level;
            _loc13_.hitPoints = "0%";
            _loc13_.damage = int(_loc13_.hitPoints.substring(0,_loc13_.hitPoints.length - 1));
            sendNotification(ApplicationNotificationNames.UPDATE_DRONE_INFO,_loc13_);
            sendNotification(ApplicationNotificationNames.INVENTORY_UPDATE_ACTIONBUTTONS);
         }
         if(_loc2_.petSlots)
         {
            this.handleUnlockSlot();
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function updatePaymentValuesViaJavascriptBridge(param1:Transaction) : void
      {
         var _loc2_:Object = null;
         if(param1)
         {
            _loc2_ = param1.response.data.money;
            if(_loc2_.uridium)
            {
               ExternalInterfaceManager.updateMoneyValue("uridium",_loc2_.uridium);
            }
            if(_loc2_.credits)
            {
               ExternalInterfaceManager.updateMoneyValue("credits",_loc2_.credits);
            }
         }
      }
      
      private function findSlotCPUIndexInArray(param1:Array) : int
      {
         var _loc3_:ItemInstanceVO = null;
         var _loc4_:String = null;
         var _loc2_:int = 0;
         loop0:
         while(_loc2_ < param1.length)
         {
            _loc3_ = this.inventory.getItem(param1[_loc2_]);
            var _loc5_:int = 0;
            var _loc6_:* = EXTENDER_CPUS;
            do
            {
               for(_loc4_ in _loc6_)
               {
               }
               _loc2_++;
               continue loop0;
            }
            while(_loc3_.itemInfo.lootID != _loc4_);
            return _loc2_;
         }
         return -1;
      }
      
      private function reOrganiseModelForInventoryRearrange(param1:int) : void
      {
         switch(param1)
         {
            case 0:
               sendNotification(ApplicationNotificationNames.INVENTORY_REARRANGE,null);
               break;
            case 1:
               this.currentActiveTransporter.from.items[0] = this.inventory.swapItems(this.currentActiveTransporter.from.items[0],this.currentActiveTransporter.to.index);
               sendNotification(ApplicationNotificationNames.INVENTORY_REARRANGE,this.currentActiveTransporter);
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function reOrganiseModelForMove(param1:Object, param2:Array) : void
      {
         var _loc4_:ItemFilter = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         if(param1 is Array)
         {
            _loc4_ = new ItemFilter();
            _loc5_ = _loc4_.getItemsNotInOtherArray(this.itemsToMove,param1 as Array);
            _loc6_ = this.getItemInstances(param2);
            this.updateConfigInformation(_loc5_,_loc6_);
            return;
         }
         var _loc3_:int = int(param1);
         this.reOrganiseModelResponse(_loc3_,param2);
      }
      
      private function reOrganiseModelForDroneMove(param1:Object, param2:Array) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(param1 is Array)
         {
            _loc4_ = param1 as Array;
            _loc5_ = this.getItemInstances(param2);
            this.updateConfigInformation(_loc4_,_loc5_);
            return;
         }
         var _loc3_:int = int(param1);
         this.reOrganiseModelResponse(_loc3_,param2);
      }
      
      private function reOrganiseModelResponse(param1:int, param2:Array) : void
      {
         if(param1 == 0)
         {
            this.moveNotAllowed(param2);
         }
         else if(param1 == 1)
         {
            this.updateConfigInformation(param2,null);
         }
      }
      
      private function moveNotAllowed(param1:Array) : void
      {
         switch(this.currentActionInProgress)
         {
            case ActionIdentifiers.EQUIPMENT_SHIP_MOVE:
            case ActionIdentifiers.EQUIPMENT_DRONE_MOVE:
               sendNotification(ApplicationNotificationNames.KEEP_IN_INVENTORY,param1);
               break;
            case ActionIdentifiers.MOVE_TO_INVENTORY:
               sendNotification(ApplicationNotificationNames.KEEP_IN_EQUIPMENT,param1);
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function updateConfigInformation(param1:Array, param2:Array = null) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Transporter = null;
         var _loc5_:uint = 0;
         var _loc6_:InventoryItemComponent = null;
         var _loc7_:Object = null;
         var _loc8_:Array = null;
         var _loc9_:ItemInstanceVO = null;
         var _loc10_:ItemFilter = null;
         var _loc11_:String = null;
         var _loc12_:Array = null;
         switch(this.currentActionInProgress)
         {
            case ActionIdentifiers.EQUIPMENT_SHIP_MOVE:
               if(this.currentActiveTransporter.to.target == ActionIdentifiers.SHIP)
               {
                  _loc8_ = new Array();
                  for each(_loc9_ in param2)
                  {
                     _loc8_.push(_loc9_.ID);
                  }
                  _loc10_ = new ItemFilter();
                  _loc3_ = this.configManager.updateEquipment(param1,ConfigManager.ADD,ActionIdentifiers.SHIP,this.currentActiveTransporter.to.slotset);
                  if(this.currentActiveTransporter.to.slotset == ActionIdentifiers.EXTRAS)
                  {
                     this.checkForSlotExtenderCPU(_loc3_);
                  }
               }
               else if(this.currentActiveTransporter.to.target == ActionIdentifiers.PET)
               {
                  _loc3_ = this.configManager.updateEquipment(param1,ConfigManager.ADD,ActionIdentifiers.PET,this.currentActiveTransporter.to.slotset);
               }
               if(param2 != null)
               {
                  sendNotification(ApplicationNotificationNames.KEEP_IN_INVENTORY,_loc3_);
               }
               _loc4_ = new Transporter();
               _loc4_.from.items = _loc3_;
               _loc4_.to.slotset = this.currentActiveTransporter.to.slotset;
               sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_INVENTORY,_loc3_);
               sendNotification(ApplicationNotificationNames.MOVE_TO_SHIP_EQUIPMENT,_loc4_);
               this.addAllMovedItemIDsToHangarManager(_loc3_);
               break;
            case ActionIdentifiers.MOVE_TO_INVENTORY:
               _loc5_ = 0;
               _loc6_ = DragComponent.getInstance().selectedItem;
               if(this.currentActiveTransporter.from.target == ActionIdentifiers.SHIP)
               {
                  _loc3_ = this.configManager.updateEquipment(param1,ConfigManager.REMOVE,ActionIdentifiers.SHIP,this.currentActiveTransporter.from.slotset);
               }
               else if(this.currentActiveTransporter.from.target == ActionIdentifiers.DRONES)
               {
                  _loc3_ = this.configManager.updateDroneEquipment(param1,ConfigManager.REMOVE,this.currentActiveTransporter.from.droneId);
               }
               else if(this.currentActiveTransporter.from.target == ActionIdentifiers.PET)
               {
                  _loc3_ = this.configManager.updateEquipment(param1,ConfigManager.REMOVE,ActionIdentifiers.PET,this.currentActiveTransporter.from.slotset);
               }
               if(param2 != null)
               {
                  sendNotification(ApplicationNotificationNames.KEEP_IN_EQUIPMENT,param2);
               }
               sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CURRENT_MENU,_loc3_);
               sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc3_);
               this.removeAllMovedItemIDsFromHangarManager(_loc3_);
               break;
            case ActionIdentifiers.EQUIPMENT_DRONE_MOVE:
               this.updateDroneConfiguration(param1,param2,this.currentActiveTransporter.to.droneId);
               break;
            case ActionIdentifiers.EQUIPMENT_NDRONE_MOVE:
               _loc7_ = this.currentActiveTransporter.from.droneItems;
               for(_loc11_ in _loc7_)
               {
                  _loc12_ = _loc7_[_loc11_];
                  if(param2 != null)
                  {
                     _loc12_ = this.returnFilteredOutNotAcceptedItems(_loc12_,param1);
                  }
                  this.updateDroneConfiguration(_loc12_,param2,_loc11_);
               }
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         facade.sendNotification(ApplicationNotificationNames.UPDATE_TOP_VIEW);
      }
      
      private function updateDroneConfiguration(param1:Array, param2:Array, param3:String) : void
      {
         var _loc4_:Array = null;
         _loc4_ = this.configManager.updateDroneEquipment(param1,ConfigManager.ADD,param3);
         this.checkForSlotExtenderCPU(_loc4_);
         if(param2 != null)
         {
            sendNotification(ApplicationNotificationNames.KEEP_IN_INVENTORY,param2);
         }
         sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_INVENTORY,_loc4_);
         var _loc5_:Transporter = new Transporter();
         _loc5_.from.items = _loc4_;
         _loc5_.to.droneId = param3;
         sendNotification(ApplicationNotificationNames.MOVE_TO_DRONE_EQUIPMENT,_loc5_);
         this.addAllMovedItemIDsToHangarManager(_loc4_);
      }
      
      private function addAllMovedItemIDsToHangarManager(param1:Array) : void
      {
         var _loc3_:ItemInstanceVO = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc2_.push(_loc3_.ID);
         }
         this.hangarManager.addEquippedItemIDsTo(this.currentActiveTransporter.to.target,_loc2_,this.currentActiveTransporter.to.configId);
      }
      
      private function removeAllMovedItemIDsFromHangarManager(param1:Array, param2:uint = 1) : void
      {
         var _loc4_:ItemInstanceVO = null;
         var _loc3_:Array = [];
         for each(_loc4_ in param1)
         {
            _loc3_.push(_loc4_.ID);
         }
         if(param2 == -1)
         {
            this.hangarManager.removeEquippedItemIDsFromCurrentHangar(this.currentActiveTransporter.from.target,_loc3_,this.currentActiveTransporter.from.configId);
         }
         else
         {
            this.hangarManager.removeEquippedItemIDsFromCurrentHangar(ActionIdentifiers.SHIP,_loc3_,param2);
         }
      }
      
      private function checkForSlotExtenderCPU(param1:Array, param2:Boolean = false, param3:int = -1) : void
      {
         var _loc5_:ItemInstanceVO = null;
         var _loc6_:String = null;
         var _loc7_:SlotSetInfoVO = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            for(_loc6_ in EXTENDER_CPUS)
            {
               if(_loc5_.itemInfo.lootID == _loc6_)
               {
                  if(param2 == false)
                  {
                     _loc7_ = this.equipmentManager.ship.slotSetInfos[ActionIdentifiers.EXTRAS];
                     sendNotification(ApplicationNotificationNames.EXTEND_EXTRA_SLOTS,[EXTENDER_CPUS[_loc6_],-1]);
                  }
                  else
                  {
                     sendNotification(ApplicationNotificationNames.EXTEND_EXTRA_SLOTS,[this.equipmentManager.ship.slotSetInfos[ActionIdentifiers.EXTRAS].quantity,param3]);
                  }
               }
            }
            _loc4_++;
         }
      }
      
      private function returnFilteredOutNotAcceptedItems(param1:Array, param2:Array) : Array
      {
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:Array = new Array();
         for each(_loc5_ in param1)
         {
            _loc4_ = true;
            for each(_loc6_ in param2)
            {
               if(_loc6_ == _loc5_)
               {
                  _loc4_ = false;
                  break;
               }
            }
            if(_loc4_)
            {
               _loc3_.push(_loc5_);
            }
         }
         _loc3_.reverse();
         return _loc3_;
      }
      
      public function changeSelectedDesignRequest(param1:String, param2:int) : void
      {
         this.shipDesignToEquip = param1;
         var _loc3_:Object = new Object();
         _loc3_.lootId = param1;
         _loc3_.action = ActionIdentifiers.DESIGN_CHANGE;
         this.dataInterchange.designChangeRequest(ActionIdentifiers.DESIGN_CHANGE,_loc3_,param2);
         this.dataInterchange.addEventListener(DataInterchangeEvent.DESIGN_CHANGE_REPLY_RECEIVED,this.handleDesignChangeReaction);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
      }
      
      private function handleDesignChangeReaction(param1:DataInterchangeEvent) : void
      {
         var _loc3_:Ship = null;
         var _loc4_:Ship = null;
         var _loc5_:ItemInfoVO = null;
         var _loc6_:ItemInfoVO = null;
         var _loc7_:Object = null;
         var _loc8_:String = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc2_:Object = param1.transaction.response.data;
         if(_loc2_.ret == 1)
         {
            if(_loc2_.deletedItems)
            {
               _loc10_ = [];
               _loc9_ = _loc2_.deletedItems[ActionIdentifiers.LASERS];
               if(_loc9_)
               {
                  _loc10_ = _loc10_.concat(this.configManager.updateEquipment(_loc9_,ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.LASERS,1));
                  _loc10_ = _loc10_.concat(this.configManager.updateEquipment(_loc9_,ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.LASERS,2));
               }
               _loc9_ = null;
               _loc9_ = _loc2_.deletedItems[ActionIdentifiers.GENERATORS];
               if(_loc9_)
               {
                  _loc10_ = _loc10_.concat(this.configManager.updateEquipment(_loc9_,ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.GENERATORS,1));
                  _loc10_ = _loc10_.concat(this.configManager.updateEquipment(_loc9_,ConfigManager.REMOVE,ActionIdentifiers.SHIP,ActionIdentifiers.GENERATORS,2));
               }
               if(_loc10_.length > 0)
               {
                  sendNotification(ApplicationNotificationNames.MOVE_TO_INVENTORY,_loc10_);
                  sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CONFIG,[_loc10_,1]);
                  sendNotification(ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CONFIG,[_loc10_,2]);
                  this.removeAllMovedItemIDsFromHangarManager(_loc10_,1);
                  this.removeAllMovedItemIDsFromHangarManager(_loc10_,2);
               }
            }
            this.equipmentManager.ship.selectedDesign = this.shipDesignToEquip;
            this.hangarManager.changeHangarShipDesign(this.shipDesignToEquip);
            _loc3_ = this.hangarManager.getCurrentHangarSlotVO().getShip();
            _loc4_ = this.equipmentManager.ship;
            _loc5_ = ItemInfoManager.getInstance().getItemInfo(_loc3_.lootID);
            _loc6_ = ItemInfoManager.getInstance().getItemInfo(this.shipDesignToEquip);
            _loc4_.saleValue = _loc5_.saleValuesByLevel[0];
            _loc4_.sellable = _loc5_.sellable;
            _loc3_.saleValue = _loc5_.saleValuesByLevel[0];
            _loc3_.sellable = _loc5_.sellable;
            _loc4_.allGroupsAcceptedByThisObject = [];
            _loc4_.slotSetInfos = new Dictionary();
            _loc3_.allGroupsAcceptedByThisObject = [];
            _loc3_.slotSetInfos = new Dictionary();
            _loc7_ = _loc6_.rawSlotSetInfoByLevel[_loc3_.level];
            for(_loc8_ in _loc7_)
            {
               _loc4_.addSlotSetInfo(_loc8_,_loc7_[_loc8_]);
               _loc4_.addAcceptedGroupsToTotal(_loc7_[_loc8_][DataInterchange.ITEM_GROUP]);
               _loc3_.addSlotSetInfo(_loc8_,_loc7_[_loc8_]);
               _loc3_.addAcceptedGroupsToTotal(_loc7_[_loc8_][DataInterchange.ITEM_GROUP]);
            }
            sendNotification(ApplicationNotificationNames.UPDATE_UI_AFTER_SHIP_DESIGN_CHANGED);
            facade.sendNotification(ApplicationNotificationNames.UPDATE_TOP_VIEW);
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      public function changePetNameRequest(param1:String) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         this.possibleNewPetName = param1;
         var _loc2_:Object = new Object();
         _loc2_.name = param1;
         this.dataInterchange.petNameChangeRequest(ActionIdentifiers.CHANGE_PET_NAME,_loc2_);
         this.dataInterchange.addEventListener(DataInterchangeEvent.PET_NAME_CHANGE_REPLY_RECEIVED,this.handlePetNameChangeResponse);
      }
      
      private function handlePetNameChangeResponse(param1:DataInterchangeEvent) : void
      {
         this.updatePaymentValuesViaJavascriptBridge(param1.transaction);
         if(param1.transaction.response.data.ret == 1)
         {
            sendNotification(ApplicationNotificationNames.CHANGE_PET_NAME,this.possibleNewPetName);
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         }
         else
         {
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
            sendNotification(ApplicationNotificationNames.PET_NAME_REJECTED,param1.transaction.getErrorMessage());
         }
      }
      
      public function changeCPUModeRequest(param1:Object, param2:String) : void
      {
         this.currentActiveTransporter = param1;
         this.dataInterchange.cpuModeChange(this.currentActiveTransporter.action,this.currentActiveTransporter);
         this.dataInterchange.addEventListener(DataInterchangeEvent.CPU_MODE_CHANGE_REPLY,this.handleCpuModeChangeResponse);
      }
      
      private function handleCpuModeChangeResponse(param1:DataInterchangeEvent) : void
      {
         var _loc2_:ItemInstanceVO = this.inventory.getItem(this.currentActiveTransporter.itemId);
         _loc2_.attachedAmmo = this.currentActiveTransporter.ammo;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      public function clearShipEquipmentConfigurationRequest(param1:int = 0) : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         this.dataInterchange.clearShipEquipmentConfiguration(param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.SHIP_CONFIG_CLEARED_REPLY_RECEIVED,this.handleClearShipEquipmentConfigurationResponse);
      }
      
      private function handleClearShipEquipmentConfigurationResponse(param1:DataInterchangeEvent) : void
      {
         var _loc2_:Object = param1.transaction.response.data.ret;
         if(_loc2_ == true)
         {
            this.clearActivateConfiguration();
         }
      }
      
      private function clearActivateConfiguration() : void
      {
         var _loc5_:int = 0;
         var _loc6_:ItemInstanceVO = null;
         var _loc1_:int = Settings.activeConfig;
         var _loc2_:Object = this.configManager.clearConfig(_loc1_);
         var _loc3_:Array = _loc2_.IDs;
         var _loc4_:Array = _loc2_.instances;
         this.hangarManager.removeEquippedItemIDsFromCurrentHangar(ActionIdentifiers.SHIP,_loc3_,_loc1_);
         this.hangarManager.removeEquippedItemIDsFromCurrentHangar(ActionIdentifiers.PET,_loc3_,_loc1_);
         this.hangarManager.removeEquippedItemIDsFromCurrentHangar(ActionIdentifiers.DRONES,_loc3_,_loc1_);
         sendNotification(ApplicationNotificationNames.UPDATE_UI_AFTER_CONFIGURATION_CLEARED,_loc4_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false,SuspendView.COMMUNICATING_WITH_SERVER]);
         if(_loc3_.length > 0)
         {
            _loc5_ = this.findSlotCPUIndexInArray(_loc3_);
            if(_loc5_ != -1)
            {
               _loc6_ = _loc4_[_loc5_];
               this.checkForSlotExtenderCPU([_loc6_],true);
            }
         }
      }
      
      public function saveShipEquipmentConfigurationRequest() : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         this.dataInterchange.saveShipEquipmentConfiguration();
         this.dataInterchange.addEventListener(DataInterchangeEvent.SHIP_CONFIG_SAVED_REPLY_RECEIVED,this.handleSaveShipEquipmentConfigurationResponse);
      }
      
      private function handleSaveShipEquipmentConfigurationResponse(param1:DataInterchangeEvent) : void
      {
         var _loc2_:Object = param1.transaction.response.data.ret;
         if(_loc2_ == true)
         {
            sendNotification(ApplicationNotificationNames.SAVE_CONFIGS_SUCCESSFUL);
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
         }
         else
         {
            this.showErrorMessageDialog();
         }
      }
      
      public function loadShipEquipmentConfigurationRequest() : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         this.dataInterchange.loadShipEquipmentConfiguration();
         this.dataInterchange.addEventListener(DataInterchangeEvent.SHIP_CONFIG_LOAD_REPLY_RECEIVED,this.handleLoadShipEquipmentConfigurationResponse);
      }
      
      private function handleLoadShipEquipmentConfigurationResponse(param1:DataInterchangeEvent) : void
      {
         var _loc2_:Object = param1.transaction.response.data.ret;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         if(_loc2_ == true)
         {
            this.hangarManager.reloadCurrentHangarWithCallback(this.completeLoadShipEquipmentConfiguration);
         }
         else if(_loc2_ == false)
         {
            this.hangarManager.reloadCurrentHangarWithCallback(this.completeLoadShipEquipmentConfigurationWithMissingItems);
         }
         else
         {
            this.hangarManager.reloadCurrentHangarWithCallback(this.completeLoadShipEquipmentConfigurationWithFailure);
         }
      }
      
      private function completeLoadShipEquipmentConfiguration() : void
      {
         sendNotification(ApplicationNotificationNames.LOAD_CONFIGS_SUCCESSFUL);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function completeLoadShipEquipmentConfigurationWithMissingItems() : void
      {
         sendNotification(ApplicationNotificationNames.LOAD_CONFIGS_WITH_MISSING_ITEMS);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function completeLoadShipEquipmentConfigurationWithFailure() : void
      {
         sendNotification(ApplicationNotificationNames.LOAD_CONFIGS_FAIL);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      public function equipItemsToNDronesRequest(param1:Transporter, param2:String) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         this.currentActionInProgress = param2;
         this.currentActiveTransporter = param1;
         this.itemsToMove = [];
         for each(_loc3_ in param1.from.droneItems)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length)
            {
               _loc5_ = _loc3_[_loc4_];
               this.itemsToMove.push(_loc5_);
               _loc4_++;
            }
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.COMMUNICATING_WITH_SERVER]);
         this.dataInterchange.equipItemsToNDrones(param1);
         this.dataInterchange.addEventListener(DataInterchangeEvent.DRONE_ITEMS_EQUIPPED_REPLY_RECEIVED,this.handleDroneItemsEquipmentResponse);
      }
      
      private function handleDroneItemsEquipmentResponse(param1:DataInterchangeEvent) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Object = null;
         var _loc2_:Object = param1.transaction.response.data.ret;
         if(_loc2_ is Object && !(_loc2_ is Number) && _loc2_.hasOwnProperty("newEffects"))
         {
            _loc3_ = Boolean(_loc2_.success);
            _loc4_ = _loc2_.newEffects;
            this.updateDroneEffects(_loc4_);
            this.reOrganiseModelForDroneMove(_loc3_,this.itemsToMove);
         }
         else
         {
            this.reOrganiseModelForDroneMove(_loc2_,this.itemsToMove);
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false,SuspendView.COMMUNICATING_WITH_SERVER]);
      }
      
      private function updateDroneEffects(param1:Object) : void
      {
         var _loc2_:int = 1;
         this.updatedDroneEffectForConfigId(param1,_loc2_);
         this.updatedDroneEffectForConfigId(param1,_loc2_ + 1);
      }
      
      private function updatedDroneEffectForConfigId(param1:Object, param2:int) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Drone = null;
         var _loc3_:EquipmentManager = EquipmentManager.getInstance();
         for(_loc4_ in param1[param2])
         {
            _loc5_ = String(param1[param2][_loc4_]);
            _loc6_ = _loc3_.getDroneAtIndex(parseInt(_loc4_));
            _loc6_.bonusEffects[param2] = _loc5_;
         }
      }
      
      public function switchConfig(param1:int) : void
      {
         this.activeConfig = param1;
         sendNotification(ApplicationNotificationNames.CHANGE_CONFIG);
         sendNotification(ApplicationNotificationNames.UPDATE_TOP_VIEW);
      }
      
      public function checkContextButton() : void
      {
         var _loc1_:DragComponent = DragComponent.getInstance();
         if(_loc1_.selectedItem.group == ItemFilter.UNLOCKABLE_ITEM)
         {
            return;
         }
         if(_loc1_.selectedItem.isDrone)
         {
            sendNotification(ApplicationNotificationNames.CHANGE_CONTEXT_BUTTON,ActionIdentifiers.CONTEXT_BTN_REPAIR_MODE);
            return;
         }
         var _loc2_:ItemInstanceVO = this.inventory.getItem(_loc1_.selectedItem.itemID);
         if(_loc2_)
         {
            if(_loc2_.itemInfo.lootID == autoBuyAmmo || _loc2_.itemInfo.lootID == autoBuyRocket)
            {
               sendNotification(ApplicationNotificationNames.CHANGE_CONTEXT_BUTTON,ActionIdentifiers.CONTEXT_BTN_CPU_MODE);
            }
            else
            {
               sendNotification(ApplicationNotificationNames.CHANGE_CONTEXT_BUTTON,ActionIdentifiers.CONTEXT_BTN_REPAIR_MODE);
            }
         }
      }
      
      public function getItemSaleValue(param1:Object) : void
      {
         var _loc2_:ItemInstanceVO = null;
         if(param1.action == ActionIdentifiers.SELL_DRONE)
         {
            param1.saleValue = this.equipmentManager.getItemValueForDroneID(param1.itemId);
         }
         else
         {
            _loc2_ = this.inventory.getItem(param1.itemId);
            if(_loc2_.hasPetGearModifier())
            {
               param1.saleValue = _loc2_.itemInfo.saleValuesByLevel[_loc2_.level + "X"];
            }
            else
            {
               param1.saleValue = _loc2_.itemInfo.saleValuesByLevel[_loc2_.level];
            }
         }
         if(param1.saleValue > 0)
         {
            sendNotification(ApplicationNotificationNames.RETURN_ITEM_SALE_VALUE,param1);
            return;
         }
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      public function getItemBuyingCost(param1:Object) : void
      {
         var _loc2_:ItemInstanceVO = this.inventory.getItem(param1.itemId);
         param1.saleValue = _loc2_.itemInfo.saleValuesByLevel[_loc2_.level];
         param1.quantity = 1000;
         var _loc3_:Object = new Object();
         _loc3_.destination = _loc2_.itemInfo.shopDeepLink;
         _loc3_.newWindow = 0;
         var _loc4_:String = _loc2_.itemInfo.shopDeepLink;
         ExternalInterfaceManager.openShopCategory(_loc4_);
      }
      
      public function getCPUType(param1:String) : void
      {
         var _loc2_:ItemInstanceVO = this.inventory.getItem(param1);
         var _loc3_:Object = new Object();
         _loc3_.action = ActionIdentifiers.CPU_MODE;
         if(_loc2_.itemInfo.lootID == autoBuyAmmo)
         {
            _loc3_.cpuType = autoBuyAmmo;
            _loc3_.selectedAmmo = _loc2_.attachedAmmo;
            _loc3_.itemId = param1;
            sendNotification(ApplicationNotificationNames.RETURN_CPU_TYPE,_loc3_);
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
            return;
         }
         if(_loc2_.itemInfo.lootID == autoBuyRocket)
         {
            _loc3_.cpuType = autoBuyRocket;
            _loc3_.selectedAmmo = _loc2_.attachedAmmo;
            _loc3_.itemId = param1;
            sendNotification(ApplicationNotificationNames.RETURN_CPU_TYPE,_loc3_);
            sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
            return;
         }
      }
      
      public function getFiltersForSelectedTab(param1:String) : void
      {
         var _loc2_:Array = null;
         this.currentOpenEquipmentTab = param1;
         switch(param1)
         {
            case ActionIdentifiers.SHIP:
               _loc2_ = this.equipmentManager.ship.allGroupsAcceptedByThisObject;
               sendNotification(ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT,[_loc2_,ActionIdentifiers.SHIP]);
               break;
            case ActionIdentifiers.DRONES:
               _loc2_ = this.equipmentManager.generalDrone.allGroupsAcceptedByThisObject;
               sendNotification(ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT,[_loc2_,ActionIdentifiers.DRONES]);
               break;
            case ActionIdentifiers.PET:
               if(this.equipmentManager.pet != null)
               {
                  _loc2_ = this.equipmentManager.pet.allGroupsAcceptedByThisObject;
                  sendNotification(ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT,[_loc2_,ActionIdentifiers.PET]);
               }
               else
               {
                  sendNotification(ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT,[]);
               }
         }
      }
      
      private function getItemsNotInOtherArray(param1:Array, param2:Array) : Array
      {
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            if(param2.indexOf(param1[_loc4_]) == -1)
            {
               _loc3_.push(param1[_loc4_]);
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function getItemInstances(param1:Array) : Array
      {
         var _loc4_:ItemInstanceVO = null;
         var _loc2_:Array = [];
         if(param1 == null)
         {
            return [];
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = this.inventory.getItem(param1[_loc3_]);
            _loc2_.push(_loc4_);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function getSelectedItemInfo(param1:String, param2:String) : void
      {
         var _loc3_:Dictionary = null;
         var _loc4_:Drone = null;
         var _loc5_:ItemInstanceVO = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:ItemInfoVO = null;
         var _loc10_:String = null;
         var _loc11_:RegExp = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:RegExp = null;
         switch(param2)
         {
            case ApplicationNotificationNames.FIND_SELECTED_ITEM_INFO:
               _loc4_ = this.equipmentManager.drones[param1];
               _loc5_ = this.inventory.getItem(param1);
               if(_loc4_ != null)
               {
                  _loc3_ = new Dictionary();
                  _loc3_[ActionIdentifiers.SALE_VALUE] = _loc4_.itemInfo.saleValuesByLevel[_loc4_.level];
                  sendNotification(ApplicationNotificationNames.DELIVER_SELECTED_ITEM_INFO,[_loc3_,true,_loc5_]);
                  return;
               }
               _loc3_ = this.inventory.getItemTextInfo(param1);
               _loc6_ = _loc5_.itemInfo.lootID.split("_");
               _loc7_ = _loc6_.pop();
               _loc7_ = InventoryItemComponent.changeFilename(_loc7_,_loc5_);
               _loc3_[ActionIdentifiers.ICON_PATH] = _loc7_;
               if(_loc5_.hasPetGearModifier())
               {
                  _loc3_[ActionIdentifiers.SALE_VALUE] = _loc5_.itemInfo.saleValuesByLevel[_loc5_.level + "X"];
               }
               else
               {
                  _loc3_[ActionIdentifiers.SALE_VALUE] = _loc5_.itemInfo.saleValuesByLevel[_loc5_.level];
               }
               _loc3_[ItemLocalisationKeys.LOCA_DURABILITY] = _loc5_.durability;
               _loc3_[ItemLocalisationKeys.LOCA_CHARGES] = _loc5_.charges;
               _loc3_[ItemLocalisationKeys.LOCA_LEVEL] = _loc5_.levelText;
               _loc3_[ItemLocalisationKeys.LOCA_DAMAGE_LEVEL] = _loc5_.damageLevel;
               _loc3_[ItemLocalisationKeys.LOCA_SHIELD_LEVEL] = _loc5_.shieldLevel;
               _loc8_ = "";
               if(_loc5_.isShipUpgrade())
               {
                  _loc8_ = _loc5_.constructShipUpdateDesc(BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,"items_equipment_shipupgrade_description"));
               }
               else
               {
                  _loc8_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc3_[ItemLocalisationKeys.LOCA_DESCRIPTION]);
                  _loc9_ = _loc5_.itemInfo;
                  _loc10_ = _loc9_.replacementText[_loc5_.level];
                  _loc11_ = new RegExp("%" + _loc5_.itemInfo.replacePattern[_loc5_.level] + "%");
                  _loc8_ = _loc8_.replace(_loc11_,_loc10_);
                  if(_loc9_.textReplacements)
                  {
                     for(_loc12_ in _loc9_.textReplacements)
                     {
                        _loc13_ = String(_loc9_.textReplacements[_loc12_]);
                        _loc14_ = new RegExp(_loc12_);
                        _loc8_ = _loc8_.replace(_loc14_,_loc13_);
                     }
                  }
               }
               _loc3_[ItemLocalisationKeys.LOCA_DESC_REPLACE] = _loc8_;
               sendNotification(ApplicationNotificationNames.DELIVER_SELECTED_ITEM_INFO,[_loc3_,false,_loc5_]);
         }
      }
   }
}

