package net.bigpoint.darkorbit.equipment.view.mediators
{
   import flash.external.ExternalInterface;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.ShipDetailsViewDataProxy;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.ShipDetailsViewData;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.ItemInfoManager;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.ShipInfoControlPanel;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.ShipInfoPanelHeaderUIControls;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.ShipSelectorView;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.ShipSelectorGrid;
   import net.bigpoint.darkorbit.equipment.view.components.shipSelector.components.ShipSelectorItemRenderer;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class ShipSelectorMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "ShipSelectorMediator";
      
      private var _selectedHangarSlotData:HangarSlotEntity;
      
      public function ShipSelectorMediator(param1:ShipSelectorView)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         this.addEventListeners();
      }
      
      override public function onRemove() : void
      {
         this.removeEventListeners();
      }
      
      protected function addEventListeners() : void
      {
         this.shipSelectorView.setCallback(ShipInfoControlPanel.EVENT_ACTIVATE_BUTTON_CLICKED,this.handleActivateButtonClicked);
         this.shipSelectorView.setCallback(ShipInfoControlPanel.EVENT_BUY_BUTTON_CLICKED,this.handleBuyButtonClicked);
         this.shipSelectorView.setCallback(ShipInfoControlPanel.EVENT_MANAGE_BUTTON_CLICKED,this.handleManageButtonClicked);
         this.shipSelectorView.setCallback(ShipSelectorGrid.EVENT_ITEM_CLICKED,this.handleShipItemClickedEvent);
         this.shipSelectorView.setCallback(ShipSelectorView.EVENT_UPDATE_SHIP_DESIGNLIST,this.handleShipDesignUpdateEvent);
         this.shipSelectorView.setCallback(ShipInfoPanelHeaderUIControls.EVENT_FAVOURITE_BUTTON_CLICKED,this.handleFavouriteClickedEvent);
         this.shipSelectorView.setCallback(ShipInfoPanelHeaderUIControls.EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED,this.getShipDetails);
         this.shipSelectorView.setCallback(ShipInfoPanelHeaderUIControls.EVENT_SHIPDESIGN_SELECTION_CHANGED,this.handleOwnedShipDesignSelectionChangeEvent);
      }
      
      protected function removeEventListeners() : void
      {
         this.shipSelectorView.removeCallback(ShipInfoControlPanel.EVENT_ACTIVATE_BUTTON_CLICKED);
         this.shipSelectorView.removeCallback(ShipInfoControlPanel.EVENT_BUY_BUTTON_CLICKED);
         this.shipSelectorView.removeCallback(ShipInfoControlPanel.EVENT_MANAGE_BUTTON_CLICKED);
         this.shipSelectorView.removeCallback(ShipSelectorGrid.EVENT_ITEM_CLICKED);
         this.shipSelectorView.removeCallback(ShipSelectorView.EVENT_UPDATE_SHIP_DESIGNLIST);
         this.shipSelectorView.removeCallback(ShipInfoPanelHeaderUIControls.EVENT_FAVOURITE_BUTTON_CLICKED);
         this.shipSelectorView.removeCallback(ShipInfoPanelHeaderUIControls.EVENT_SHOW_SHIP_DETAILS_BUTTON_CLICKED);
         this.shipSelectorView.removeCallback(ShipInfoPanelHeaderUIControls.EVENT_SHIPDESIGN_SELECTION_CHANGED);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW,ApplicationNotificationNames.SHIP_ACTIVATION_RESPONSE,ShipDetailsViewDataProxy.MODEL_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = null;
         var _loc3_:ShipDetailsViewDataProxy = null;
         var _loc4_:ShipDetailsViewData = null;
         var _loc5_:Boolean = false;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW:
               this.handleSwitchBetweenEquipmentAndShipSelectorView(param1);
               break;
            case ShipDetailsViewDataProxy.MODEL_CHANGED:
               _loc2_ = param1.getBody() as String;
               _loc3_ = facade.retrieveProxy(ShipDetailsViewDataProxy.NAME) as ShipDetailsViewDataProxy;
               _loc4_ = _loc3_.getInfo(_loc2_);
               _loc5_ = _loc2_ == "0";
               this.shipSelectorView.updateShipInfoPanel(_loc4_,_loc5_);
               if(_loc5_)
               {
                  this.updateShipDesignListForNotOwnedShips(_loc4_);
               }
               break;
            case ApplicationNotificationNames.SHIP_ACTIVATION_RESPONSE:
               this.handleSetShipActivationResponse(param1.getBody());
         }
      }
      
      protected function handleSwitchBetweenEquipmentAndShipSelectorView(param1:INotification) : void
      {
         var _loc2_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         var _loc3_:Object = param1.getBody();
         if(_loc3_.showManagement)
         {
            this.shipSelectorView.hide();
            _loc2_.enable();
         }
         else
         {
            this.shipSelectorView.show();
            _loc2_.disable();
         }
      }
      
      protected function handleShipItemClickedEvent(param1:HangarSlotEntity) : void
      {
         this.updateShipDetailsViewWithServerData(param1);
      }
      
      private function updateShipDetailsViewWithServerData(param1:HangarSlotEntity) : void
      {
         if(this._selectedHangarSlotData != param1)
         {
            if(this._selectedHangarSlotData)
            {
               this._selectedHangarSlotData.isSelected = false;
            }
            this.setHangarSlotSelection(param1);
            this.getShipDetails(String(param1.hangarID),String(param1.getShip().lootID));
         }
         else
         {
            this.setHangarSlotSelection(param1);
         }
      }
      
      private function setHangarSlotSelection(param1:HangarSlotEntity) : void
      {
         this._selectedHangarSlotData = param1;
         this._selectedHangarSlotData.isSelected = true;
         var _loc2_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         _loc2_.setHangarSlot(this._selectedHangarSlotData);
      }
      
      protected function getShipDetails(param1:String, param2:String) : void
      {
         var _loc3_:ShipDetailsViewDataProxy = facade.retrieveProxy(ShipDetailsViewDataProxy.NAME) as ShipDetailsViewDataProxy;
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         if(param1 == "0")
         {
            _loc4_.getShipDetails(param1,param2);
         }
         else if(!_loc3_.existInfo(param1))
         {
            _loc4_.getShipDetails(param1,param2);
         }
         else
         {
            sendNotification(ShipDetailsViewDataProxy.MODEL_CHANGED,param1);
         }
      }
      
      protected function handleActivateButtonClicked(param1:Object = null) : void
      {
         var _loc2_:HangarSlotEntity = param1 as HangarSlotEntity;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Ship = _loc2_.getShip();
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         _loc4_.activateShip(_loc2_.hangarID,true);
      }
      
      protected function handleSetShipActivationResponse(param1:Object) : void
      {
         var _loc2_:Boolean = param1 as Boolean;
         if(!_loc2_)
         {
            this.shipSelectorView.activateCurrentSelectedItem();
         }
      }
      
      protected function handleBuyButtonClicked(param1:Object = null) : void
      {
         var ship:Ship;
         var lootID:String = null;
         var params:Object = param1;
         var data:HangarSlotEntity = params as HangarSlotEntity;
         if(data == null)
         {
            return;
         }
         ship = data.getShip();
         if(ship == null)
         {
            return;
         }
         if(ExternalInterface.available)
         {
            try
            {
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false,SuspendView.COMMUNICATING_WITH_SERVER]);
               ExternalInterface.call("referToShopItem",ship.lootID,null,"_self");
            }
            catch(e:Error)
            {
            }
         }
      }
      
      protected function handleManageButtonClicked(param1:Object = null) : void
      {
         var _loc2_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         _loc2_.changeHangar(this._selectedHangarSlotData.slotID,true,this.handleChangeHangarResponseCallback);
      }
      
      protected function handleChangeHangarResponseCallback() : void
      {
         var _loc1_:Object = {"showManagement":true};
         facade.sendNotification(ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW,_loc1_);
      }
      
      protected function handleFavouriteClickedEvent(param1:Object) : void
      {
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         _loc2_.setFavourite(param1.hangarId,param1.isFavourite);
      }
      
      private function handleShipDesignUpdateEvent(param1:HangarSlotEntity) : void
      {
         this.updateShipDesignListForOwnedShips(param1);
      }
      
      private function updateShipDesignListForOwnedShips(param1:HangarSlotEntity) : void
      {
         var _loc11_:String = null;
         var _loc13_:String = null;
         var _loc14_:String = null;
         var _loc15_:ItemInfoVO = null;
         var _loc16_:String = null;
         this.shipSelectorView.setCallback(ShipInfoPanelHeaderUIControls.EVENT_SHIPDESIGN_SELECTION_CHANGED,this.handleOwnedShipDesignSelectionChangeEvent);
         var _loc2_:Ship = param1.getShip();
         var _loc3_:String = _loc2_.getShipType();
         var _loc4_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         var _loc5_:Object = _loc4_.getAllFreeAndAssignedDesignsForType(_loc3_,_loc2_.selectedDesign);
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:Array = (_loc5_.freeDesigns as Array).concat(_loc5_.assignedDesigns);
         var _loc8_:int = int(_loc7_.length);
         if(_loc8_ == 0)
         {
            _loc13_ = _loc2_.selectedDesign;
            if(_loc13_ != _loc3_ && _loc3_ != null)
            {
               _loc7_.push(_loc3_);
               _loc8_ = int(_loc7_.length);
            }
         }
         var _loc9_:ItemInfoManager = ItemInfoManager.getInstance();
         var _loc10_:int = 0;
         while(_loc10_ < _loc8_)
         {
            _loc14_ = _loc7_[_loc10_];
            _loc15_ = _loc9_.getItemInfo(_loc14_);
            if(_loc15_)
            {
               _loc6_[_loc15_.name] = _loc14_;
            }
            _loc10_++;
         }
         var _loc12_:ItemInfoVO = ItemInfoManager.getInstance().getItemInfo(_loc2_.selectedDesign);
         if(_loc12_)
         {
            _loc16_ = "items_" + _loc12_.lootID + "_code";
            _loc11_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc16_).toUpperCase();
         }
         else
         {
            _loc11_ = "";
         }
         this.shipSelectorView.updateShipDesignList(_loc11_,_loc6_);
      }
      
      private function updateShipDesignListForNotOwnedShips(param1:ShipDetailsViewData, param2:String = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         this.shipSelectorView.setCallback(ShipInfoPanelHeaderUIControls.EVENT_SHIPDESIGN_SELECTION_CHANGED,this.handleNotOwnedShipDesignSelectionChangeEvent);
         var _loc6_:Dictionary = new Dictionary();
         for(_loc7_ in param1.ownedShipDesignMap)
         {
            _loc4_ = "items_" + _loc7_ + "_fullname";
            _loc5_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_);
            _loc6_[_loc5_] = _loc7_;
         }
         param2 = this._selectedHangarSlotData.getShip().lootID;
         _loc4_ = "items_" + param2 + "_fullname";
         _loc5_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_);
         _loc6_[_loc5_] = param2;
         _loc8_ = this._selectedHangarSlotData.getShip().selectedDesign;
         if(_loc8_)
         {
            param2 = _loc8_;
            _loc4_ = "items_" + param2 + "_fullname";
            _loc5_ = BPLocale.getItemInCategory(ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS,_loc4_);
         }
         this.shipSelectorView.updateShipDesignList(_loc5_.toUpperCase(),_loc6_);
      }
      
      protected function handleNotOwnedShipDesignSelectionChangeEvent(param1:String) : void
      {
         var _loc2_:HangarSlotEntity = this._selectedHangarSlotData;
         _loc2_.getShip().selectedDesign = param1;
         this.updateShipDetailsViewWithServerData(_loc2_);
         this.shipSelectorView.selectHangar(_loc2_);
         var _loc3_:ShipDetailsViewDataProxy = facade.retrieveProxy(ShipDetailsViewDataProxy.NAME) as ShipDetailsViewDataProxy;
         var _loc4_:ShipDetailsViewData = _loc3_.getLatestInfo();
         this.updateShipDesignListForNotOwnedShips(_loc4_);
      }
      
      protected function handleOwnedShipDesignSelectionChangeEvent(param1:String) : void
      {
         var _loc9_:String = null;
         var _loc2_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         var _loc3_:Vector.<HangarSlotEntity> = _loc2_.getAllHangarSlotEntities();
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:HangarSlotEntity = this._selectedHangarSlotData;
         var _loc7_:uint = _loc6_.getShip().availableDesignsList.length;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc7_)
         {
            _loc9_ = _loc6_.getShip().availableDesignsList[_loc8_] as String;
            if(_loc9_ == param1)
            {
               _loc4_ = _loc6_.isOwned();
               _loc5_ = true;
               _loc6_.getShip().selectedDesign = _loc9_;
               break;
            }
            _loc8_++;
         }
         if(_loc5_)
         {
            if(_loc4_)
            {
               this.updateShipDetailsViewWithServerData(_loc6_);
               this.shipSelectorView.selectHangar(_loc6_);
               sendNotification(ApplicationNotificationNames.CHANGE_SELECTED_DESIGN,param1);
            }
         }
      }
      
      public function set list(param1:Vector.<HangarSlotEntity>) : void
      {
         var _loc2_:ShipSelectorItemRenderer = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:HangarSlotEntity = null;
         if(Boolean(param1) && param1.length > 0)
         {
            _loc2_ = this.shipSelectorView.getSelectedItemRenderer();
            this.shipSelectorView.list = param1;
            if(_loc2_ == null)
            {
               _loc3_ = this.shipSelectorView.list.length;
               _loc4_ = 0;
               while(_loc4_ < _loc3_)
               {
                  _loc5_ = this.shipSelectorView.list[_loc4_];
                  if(_loc5_.isActive())
                  {
                     this.shipSelectorView.selectHangar(_loc5_);
                  }
                  _loc4_++;
               }
            }
         }
      }
      
      public function get shipSelectorView() : ShipSelectorView
      {
         return this.viewComponent as ShipSelectorView;
      }
   }
}

