package net.bigpoint.darkorbit.equipment.view.mediators
{
   import com.greensock.TweenMax;
   import flash.events.Event;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.ItemEvent;
   import net.bigpoint.darkorbit.equipment.events.MoveItemEvent;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.MenuProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.AccordionViewEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Inventory;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ConfigManager;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.view.components.InventoryView;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.GridComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.InventoryItemComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.ItemFilter;
   import net.bigpoint.darkorbit.equipment.view.components.items.MultiSelectionComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.PopUp;
   import net.bigpoint.darkorbit.equipment.view.components.items.PopUpGridSellComponent;
   import net.bigpoint.utils.PredefinedFilters;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class InventoryViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "InventoryViewMediator";
      
      public var inventoryOnStage:Boolean = true;
      
      private var hangarManagerProxy:HangarManagerProxy;
      
      private var connectionProxy:ConnectionProxy;
      
      private var menuProxy:MenuProxy;
      
      public function InventoryViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW,ApplicationNotificationNames.MENU_LAYOUT_DEFINED,ApplicationNotificationNames.INIT_INVENTORY,ApplicationNotificationNames.MOVE_TO_INVENTORY,ApplicationNotificationNames.KEEP_IN_INVENTORY,ApplicationNotificationNames.INVENTORY_REARRANGE,ApplicationNotificationNames.MAKE_EMPTY_IN_INVENTORY,ApplicationNotificationNames.UPDATE_UNIQUE_ITEM,ApplicationNotificationNames.ADD_NEW_ITEM,ApplicationNotificationNames.DELETE_ITEM,ApplicationNotificationNames.DELETE_MULTIPLE_INVENTORY_ITEMS,ApplicationNotificationNames.DELETE_MULTIPLE_EQUIPPED_ITEMS,ApplicationNotificationNames.CHANGE_CONFIG,ApplicationNotificationNames.DELIVER_SELECTED_ITEM_INFO,ApplicationNotificationNames.CLEAR_ITEM_INFO,ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT,ApplicationNotificationNames.RETURN_ITEM_SALE_VALUE,ApplicationNotificationNames.RETURN_ITEM_BUY_COST,ApplicationNotificationNames.RETURN_CPU_TYPE,ApplicationNotificationNames
         .CHANGE_CONTEXT_BUTTON,ApplicationNotificationNames.CLOSE_SHIP_DESIGN_MENU,ApplicationNotificationNames.TAB_BUTTON_CLICKED,ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED,ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_SELECTION_CHANGED,ApplicationNotificationNames.UPDATE_UI_AFTER_CONFIGURATION_CLEARED,ApplicationNotificationNames.UPDATE_UI_AFTER_SHIP_DESIGN_CHANGED,ApplicationNotificationNames.KILL_DRONE,ApplicationNotificationNames.INVENTORY_UPDATE_ACTIONBUTTONS,ApplicationNotificationNames.INVENTORY_UPDATE_REPAIRED_MODULE];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:ItemInstanceVO = null;
         var _loc12_:ItemInstanceVO = null;
         var _loc13_:ItemInstanceVO = null;
         var _loc14_:String = null;
         var _loc15_:Array = null;
         var _loc16_:Dictionary = null;
         var _loc17_:Boolean = false;
         var _loc18_:ItemInstanceVO = null;
         var _loc19_:String = null;
         var _loc20_:Object = null;
         var _loc21_:Object = null;
         var _loc22_:Object = null;
         var _loc23_:String = null;
         var _loc24_:AccordionViewEntity = null;
         var _loc25_:ItemInfoVO = null;
         var _loc2_:FilterManager = FilterManager.getInstance();
         this.menuProxy = facade.retrieveProxy(MenuProxy.PROXY_NAME) as MenuProxy;
         this.connectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         this.hangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW:
               _loc3_ = param1.getBody();
               if(_loc3_)
               {
                  this.inventoryView.visible = _loc3_.showManagement;
               }
               break;
            case ApplicationNotificationNames.MENU_LAYOUT_DEFINED:
               this.inventoryView.sectionList = this.menuProxy.invSection;
               break;
            case ApplicationNotificationNames.INIT_INVENTORY:
               this.inventoryView.injectHangarManager(this.hangarManagerProxy);
               this.rebuildUIElements();
               this.initializeDragComponent();
               this.addAllEventListenersToInventoryView();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED:
               this.rebuildUIElements();
               break;
            case ApplicationNotificationNames.CHANGE_CONFIG:
               this.inventoryView.refreshView();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_CONFIGURATION_CLEARED:
            case ApplicationNotificationNames.MOVE_TO_INVENTORY:
               _loc4_ = param1.getBody() as Array;
               this.inventoryView.addAllMovedItems(_loc4_);
               this.deselectItemsAfterInventoryChanged();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_SHIP_DESIGN_CHANGED:
               break;
            case ApplicationNotificationNames.FILTER_INVENTORY_BY_CONTEXT:
               _loc5_ = param1.getBody() as Array;
               _loc6_ = _loc5_[0];
               _loc7_ = _loc5_[1] as String;
               if(_loc7_)
               {
                  _loc7_ = _loc7_.toUpperCase();
               }
               if(_loc6_)
               {
                  this.inventoryView.filterByContext(_loc6_,_loc7_);
               }
               break;
            case ApplicationNotificationNames.KEEP_IN_INVENTORY:
               _loc8_ = param1.getBody() as Array;
               this.inventoryView.replaceItemsThatAlreadyExist();
               break;
            case ApplicationNotificationNames.MAKE_EMPTY_IN_INVENTORY:
               _loc9_ = param1.getBody() as Array;
               this.inventoryView.setItemsEquippedToConfig(_loc9_);
               this.deselectItemsAfterInventoryChanged();
               break;
            case ApplicationNotificationNames.INVENTORY_REARRANGE:
               _loc10_ = param1.getBody() as Object;
               if(_loc10_ != null)
               {
                  this.inventoryView.swapInventoryItems(new Array(_loc10_.from.items[0],_loc10_.to.index));
               }
               break;
            case ApplicationNotificationNames.UPDATE_UNIQUE_ITEM:
               _loc11_ = param1.getBody() as ItemInstanceVO;
               this.inventoryView.updateUniqueItem(_loc11_);
               break;
            case ApplicationNotificationNames.ADD_NEW_ITEM:
               _loc12_ = param1.getBody() as ItemInstanceVO;
               this.inventoryView.addNewItem(new Array(_loc12_));
               break;
            case ApplicationNotificationNames.DELETE_ITEM:
               _loc13_ = ItemInstanceVO(param1.getBody());
               this.inventoryView.deleteItem(_loc13_.ID);
               this.inventoryView.disableAllInventoryButtons();
               break;
            case ApplicationNotificationNames.DELETE_MULTIPLE_EQUIPPED_ITEMS:
               this.deleteEquippedItems(param1.getBody() as Array);
               break;
            case ApplicationNotificationNames.DELETE_MULTIPLE_INVENTORY_ITEMS:
               this.deletedInventoryItems(Vector.<ItemInstanceVO>(param1.getBody()));
               break;
            case ApplicationNotificationNames.KILL_DRONE:
               this.inventoryView.disableAllInventoryButtons();
               break;
            case ApplicationNotificationNames.DELIVER_SELECTED_ITEM_INFO:
               _loc14_ = "";
               _loc15_ = param1.getBody() as Array;
               _loc16_ = _loc15_[0];
               _loc17_ = Boolean(_loc15_[1]);
               _loc18_ = _loc15_[2];
               if(_loc18_)
               {
                  _loc25_ = _loc18_.itemInfo;
                  if(_loc25_.factionDepended)
                  {
                     _loc14_ = this.hangarManagerProxy.getUserFaction();
                  }
               }
               this.inventoryView.updateSelectedItemTextFields(_loc16_,_loc17_,_loc14_);
               break;
            case ApplicationNotificationNames.CLEAR_ITEM_INFO:
               this.inventoryView.clearItemTextFields();
               break;
            case ApplicationNotificationNames.INVENTORY_UPDATE_ACTIONBUTTONS:
               this.inventoryView.updateActionButtonStatus();
               break;
            case ApplicationNotificationNames.INVENTORY_UPDATE_REPAIRED_MODULE:
               _loc19_ = param1.getBody() as String;
               this.inventoryView.updateRepairedBattlestationModule(_loc19_);
               break;
            case ApplicationNotificationNames.RETURN_ITEM_SALE_VALUE:
               _loc20_ = param1.getBody() as Object;
               if(Settings.inventoryOpen || _loc20_.action == ActionIdentifiers.SELL_DRONE)
               {
                  this.displaySellingWindow(_loc20_);
               }
               else
               {
                  this.displayMultiSellingWindow(_loc20_);
               }
               break;
            case ApplicationNotificationNames.RETURN_ITEM_BUY_COST:
               _loc21_ = param1.getBody() as Object;
               this.displayQuickBuyPopUp(_loc21_);
               break;
            case ApplicationNotificationNames.RETURN_CPU_TYPE:
               _loc22_ = param1.getBody() as Object;
               this.displayCPUChoicePopUp(_loc22_);
               break;
            case ApplicationNotificationNames.CHANGE_CONTEXT_BUTTON:
               _loc23_ = param1.getBody() as String;
               this.inventoryView.updateContextUseBtn(_loc23_);
               break;
            case ApplicationNotificationNames.CLOSE_SHIP_DESIGN_MENU:
               this.inventoryView.disableAllInventoryButtons();
               this.deselectItemsAfterInventoryChanged();
               break;
            case ApplicationNotificationNames.TAB_BUTTON_CLICKED:
               this.inventoryView.disableAllInventoryButtons();
               break;
            case ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_SELECTION_CHANGED:
               _loc24_ = param1.getBody() as AccordionViewEntity;
               this.inventoryView.updateFromAccordionViewEntitySelectionChanged(_loc24_);
         }
      }
      
      private function rebuildUIElements() : void
      {
         var _loc1_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         var _loc2_:FilterManager = FilterManager.getInstance();
         var _loc3_:Inventory = _loc1_.inventory;
         this.inventoryView.removeInventoryVisibleComponents();
         this.inventoryView.populateWithIcons(_loc3_);
         this.inventoryView.createGridFilteringMenus(_loc2_.filters);
         this.inventoryView.createButtons();
         _loc1_.updateCurrentEquipmentTab(ActionIdentifiers.SHIP);
         var _loc4_:Boolean = this.hangarManagerProxy.isHangarFilled();
         if(_loc4_)
         {
            this.inventoryView.filters = [];
            this.inventoryView.mouseEnabled = true;
            this.inventoryView.mouseChildren = true;
            TweenMax.to(this.inventoryView,0.5,PredefinedFilters.TWEENMAX_COLORMATRIX_COLORED);
         }
         else
         {
            this.inventoryView.deactivateSellShipOrPetButton();
         }
      }
      
      private function initializeDragComponent() : void
      {
         var _loc1_:DragComponent = DragComponent.getInstance();
         _loc1_.addEventListener(MoveItemEvent.ITEMS_MOVED_TO_INVENTORY,this.attemptedItemMoveToInventory);
         _loc1_.addEventListener(MoveItemEvent.ITEM_REARRANGED_WITHIN_INVENTORY,this.attemptedInventoryRearrange);
         _loc1_.addEventListener(MoveItemEvent.STACK_MOVED_TO_EMPTY_SLOT,this.attemptedToMoveStackToEmptySlot);
         _loc1_.addEventListener(ItemEvent.ITEM_SELECTED,this.handleInventoryItemSelected);
         _loc1_.addEventListener(InventoryEvent.BUYABLE_SLOT_CLICKED,this.handleBuyableSlotClicked);
         _loc1_.addEventListener(InventoryEvent.CHECK_INVENTORY_CONTEXT_BUTTON,this.handleCheckInventoryContextButton);
         _loc1_.addEventListener(InventoryEvent.UPDATE_SELL_BUTTON,this.updateSellButton);
         _loc1_.addEventListener(ItemEvent.ITEM_MULTISELECTED,this.handleInventoryItemMultiSelected);
         _loc1_.addEventListener(ItemEvent.ITEM_MULTISELECT_UPDATED,this.handleInventoryItemMultiSelectUpdated);
         _loc1_.addEventListener(ItemEvent.ALL_ITEMS_DESELECTED,this.handleInventoryItemsDeselected);
      }
      
      private function addAllEventListenersToInventoryView() : void
      {
         this.inventoryView.addEventListener(MoveItemEvent.SELL_ITEM,this.attemptedToSellItem);
         this.inventoryView.addEventListener(MoveItemEvent.SELL_SHIP_OR_PET,this.attemptedToSellShipOrPet);
         this.inventoryView.addEventListener(MoveItemEvent.QUICK_BUY_ITEM,this.attemptedToQuickBuyItem);
         this.inventoryView.addEventListener(InventoryEvent.INVENTORY_SWITCHED,this.handleInventoryModeSwitched);
         this.inventoryView.addEventListener(InventoryEvent.DESIGN_MENU_CLICK,this.handleDesignButtonClicked);
         this.inventoryView.addEventListener(InventoryEvent.REPAIR_BUTTON_CLICKED,this.handleRepairButtonClicked);
         this.inventoryView.addEventListener(InventoryEvent.CHANGE_CPU_MODE_BUTTON_CLICKED,this.handleChangeCPUModeButtonClicked);
         this.inventoryView.addEventListener(InventoryEvent.CLOSE_DESIGN_MENU,this.handleCloseDesignNotification);
         this.inventoryView.addEventListener(InventoryView.EVENT_IMPORT_BUTTON_CLICKED,this.handleImportButtonClickedEvent);
      }
      
      private function handleImportButtonClickedEvent(param1:Event) : void
      {
         var _loc7_:ConnectionProxy = null;
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.IMPORT_CONFIG_POPUP;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         _loc2_.itemListClickCallback = this.handleImportConfigItemListClicked;
         _loc2_.callback = this.handleImportConfigItemListPopUpClose;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         var _loc3_:PopUpViewMediator = facade.retrieveMediator(PopUpViewMediator.NAME) as PopUpViewMediator;
         var _loc4_:PopUp = _loc3_.popUpView.activePopUp;
         if(_loc4_)
         {
            _loc4_.activateConfirmationButtons = false;
            var _loc5_:ShipSelectorMediator = facade.retrieveMediator(ShipSelectorMediator.NAME) as ShipSelectorMediator;
            var _loc6_:HangarSlotEntity = _loc5_.shipSelectorView.getSelectedItemRenderer().data;
            if(_loc6_.hangarID > 0)
            {
               _loc7_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
               _loc7_.getCompatibleShips(_loc6_.hangarID,this.handleShipImportListConfigurationListResponse);
            }
            return;
         }
         throw new Error("This should never happen. There is no reference to the ship import config window available.");
      }
      
      private function handleShipImportListConfigurationListResponse(param1:Array) : void
      {
         var _loc2_:PopUpViewMediator = facade.retrieveMediator(PopUpViewMediator.NAME) as PopUpViewMediator;
         var _loc3_:PopUp = _loc2_.popUpView.activePopUp;
         if(Boolean(_loc3_) && Boolean(param1))
         {
            _loc3_.fillListbox(param1);
         }
      }
      
      private function handleImportConfigItemListClicked(param1:Object) : void
      {
         var _loc2_:PopUpViewMediator = facade.retrieveMediator(PopUpViewMediator.NAME) as PopUpViewMediator;
         var _loc3_:PopUp = _loc2_.popUpView.activePopUp;
         _loc3_.activateConfirmationButtons = true;
         var _loc4_:Object = param1.data;
      }
      
      private function handleImportConfigItemListPopUpClose(... rest) : void
      {
         var _loc4_:Object = null;
         var _loc5_:ShipSelectorMediator = null;
         var _loc6_:HangarSlotEntity = null;
         var _loc7_:ConnectionProxy = null;
         var _loc2_:PopUpViewMediator = facade.retrieveMediator(PopUpViewMediator.NAME) as PopUpViewMediator;
         var _loc3_:PopUp = _loc2_.popUpView.activePopUp;
         if(_loc3_)
         {
            _loc4_ = _loc3_.itemSelectionData;
            if(_loc4_)
            {
               _loc5_ = facade.retrieveMediator(ShipSelectorMediator.NAME) as ShipSelectorMediator;
               _loc6_ = _loc5_.shipSelectorView.getSelectedItemRenderer().data;
               if(_loc6_.hangarID > 0 && _loc4_.data.hangarId > 0)
               {
                  _loc7_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
                  _loc7_.importShipConfiguration(_loc6_.hangarID,_loc4_.data.hangarId);
               }
            }
         }
      }
      
      private function handleCloseDesignNotification(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.CLOSE_SHIP_DESIGN_MENU);
      }
      
      private function updateSellButton(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_CLEAR_SELECTION);
         this.inventoryView.updateActionButtonStatus();
      }
      
      private function handleCheckInventoryContextButton(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.CHECK_CONTEXT_BUTTON);
      }
      
      private function handleChangeCPUModeButtonClicked(param1:InventoryEvent) : void
      {
         var _loc2_:DragComponent = DragComponent.getInstance();
         sendNotification(ApplicationNotificationNames.GET_CPU_TYPE,_loc2_.selectedItem.itemID);
      }
      
      private function displayCPUChoicePopUp(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.AMMO_CPU_CHOICE;
         _loc2_.transporter = param1;
         _loc2_.callback = this.askServerForChangeCPUMode;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      public function askServerForChangeCPUMode(param1:MoveItemEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.itemId = param1.transporter.itemId;
         _loc2_.action = param1.transporter.action;
         _loc2_.ammo = param1.transporter.ammo;
         sendNotification(ApplicationNotificationNames.QUERY_SERVER_FOR_CPU_MODE_CHANGE,_loc2_);
      }
      
      private function handleDesignButtonClicked(param1:InventoryEvent) : void
      {
         sendNotification(ApplicationNotificationNames.CHANGE_SELECTED_DESIGN,param1.info);
      }
      
      private function handleBuyableSlotClicked(param1:InventoryEvent) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.BUYABLE_SLOT_POPUP;
         _loc2_.transporter = param1.info;
         _loc2_.callback = this.attemptedToBuyExtraPetSlot;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function handleRepairButtonClicked(param1:InventoryEvent) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         var _loc3_:Object = param1.info;
         var _loc4_:String = _loc3_.action;
         switch(_loc4_)
         {
            case ActionIdentifiers.REPAIR_DRONE:
               _loc2_.popUpType = PopUpDefiner.REPAIR_ITEM_POPUP;
               _loc2_.transporter = _loc3_;
               _loc2_.callback = this.attemptedToRepairItem;
               _loc2_.cleanUpCallback = this.removeSuspendView;
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
               sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
               break;
            case ActionIdentifiers.REPAIR_MODULE:
               _loc2_.popUpType = PopUpDefiner.REPAIR_MODULE_POPUP;
               _loc2_.transporter = _loc3_;
               _loc2_.callback = this.attemptedToRepairModule;
               _loc2_.cleanUpCallback = this.removeSuspendView;
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
               sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         }
      }
      
      private function attemptedToRepairItem(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_REPAIR_ITEM,param1.transporter);
      }
      
      private function attemptedToRepairModule(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_REPAIR_MODULE,param1.transporter);
      }
      
      private function attemptedToBuyExtraPetSlot(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_BUY_EXTRA_PET_SLOT,param1.transporter);
      }
      
      private function handleInventoryModeSwitched(param1:InventoryEvent) : void
      {
         if(this.inventoryOnStage)
         {
            sendNotification(ApplicationNotificationNames.REMOVE_ACCORDION_VIEW);
            this.inventoryOnStage = false;
         }
         else
         {
            sendNotification(ApplicationNotificationNames.ADD_ACCORDION_VIEW);
            this.inventoryOnStage = true;
         }
      }
      
      private function handleInventoryItemSelected(param1:ItemEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         sendNotification(ApplicationNotificationNames.FIND_SELECTED_ITEM_INFO,param1.ID);
         var _loc2_:ItemInstanceVO = this.connectionProxy.inventory.items[param1.ID];
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.itemInfo.sellable)
         {
            _loc3_ = _loc2_.level;
            _loc4_ = 0;
            if(_loc2_.hasPetGearModifier())
            {
               _loc4_ = int(_loc2_.itemInfo.saleValuesByLevel[_loc3_ + "X"]);
            }
            else
            {
               _loc4_ = int(_loc2_.itemInfo.saleValuesByLevel[_loc3_]);
            }
            this.inventoryView.updateSaleTextValue(_loc4_);
            this.inventoryView.updateActionButtonStatus();
         }
         else
         {
            this.inventoryView.updateSaleTextValue(0);
            this.deselectAllInventoryItems();
         }
      }
      
      protected function handleInventoryItemsDeselected(param1:ItemEvent) : void
      {
         this.deselectItemsAfterInventoryChanged();
      }
      
      protected function handleInventoryItemMultiSelectUpdated(param1:ItemEvent) : void
      {
         var _loc2_:DragComponent = DragComponent.getInstance();
         this.updateMultipleSaleValue(_loc2_.multiSelection);
      }
      
      private function handleInventoryItemMultiSelected(param1:ItemEvent) : void
      {
         var _loc8_:Boolean = false;
         var _loc9_:GridComponent = null;
         var _loc10_:Array = null;
         var _loc11_:uint = 0;
         var _loc12_:InventoryItemComponent = null;
         var _loc13_:String = null;
         var _loc14_:Array = null;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc2_:DragComponent = DragComponent.getInstance();
         var _loc3_:GridComponent = _loc2_.currentSelectedItem.parent as GridComponent;
         var _loc4_:Array = ConfigManager.getInstance().getEquippedItemsConfigs();
         var _loc5_:Array = _loc4_[0];
         var _loc6_:Array = _loc4_[1];
         var _loc7_:Array = [];
         _loc14_ = MultiSelectionComponent.getInstance().allGrids;
         var _loc15_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         var _loc18_:uint = _loc14_.length;
         _loc16_ = 0;
         while(_loc16_ < _loc18_)
         {
            _loc9_ = _loc14_[_loc16_];
            _loc10_ = _loc9_.iconsInThisMenu;
            _loc11_ = _loc10_.length;
            _loc17_ = 0;
            while(_loc17_ < _loc11_)
            {
               _loc12_ = _loc10_[_loc17_];
               _loc13_ = _loc12_.itemID;
               _loc8_ = param1.itemName == _loc12_.itemName && _loc12_.canBeSelected && _loc12_.group != ItemFilter.EMPTY_SPACE_FILTER && !_loc12_.buyableExtraSlot && _loc15_.stage.contains(_loc12_) && _loc7_.indexOf(_loc13_) == -1;
               if(_loc8_)
               {
                  if(_loc3_.parent is InventoryView && (Settings.activeConfig == 1 && _loc5_.indexOf(_loc13_) == -1 || Settings.activeConfig == 2 && _loc6_.indexOf(_loc13_) == -1))
                  {
                     _loc7_.push(_loc12_);
                     _loc12_.setSelected();
                  }
                  else if(_loc9_.containsIconInThisMenu(param1.ID) && (Settings.activeConfig == 1 && _loc5_.indexOf(_loc13_) > -1 || Settings.activeConfig == 2 && _loc6_.indexOf(_loc13_) > -1))
                  {
                     _loc7_.push(_loc12_);
                     _loc12_.setSelected();
                  }
               }
               _loc17_++;
            }
            _loc16_++;
         }
         _loc2_.multiSelection = _loc7_;
         this.updateMultipleSaleValue(_loc7_);
      }
      
      protected function updateMultipleSaleValue(param1:Array) : void
      {
         var _loc8_:InventoryItemComponent = null;
         var _loc9_:ItemInstanceVO = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:String = null;
         this.inventoryView.updateActionButtonStatus();
         if(param1.length != 1)
         {
            this.inventoryView.disableQuickBuyBtn();
         }
         var _loc2_:int = 0;
         var _loc3_:Dictionary = this.connectionProxy.inventory.items;
         var _loc4_:int = 0;
         var _loc5_:int = 1;
         var _loc6_:int = int(param1.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc8_ = param1[_loc7_];
            if(!_loc8_.isSellable())
            {
               this.inventoryView.disableAllInventoryButtons();
            }
            _loc9_ = _loc3_[_loc8_.itemID];
            _loc10_ = _loc9_.level;
            _loc11_ = 0;
            if(_loc9_.hasPetGearModifier())
            {
               _loc11_ = int(_loc9_.itemInfo.saleValuesByLevel[_loc10_ + "X"]);
            }
            else
            {
               _loc11_ = int(_loc9_.itemInfo.saleValuesByLevel[_loc10_]);
            }
            _loc11_ = Math.floor(_loc11_ / _loc5_);
            _loc12_ = _loc2_ + _loc11_;
            if(_loc12_ <= 0)
            {
               _loc2_ = Math.floor(_loc2_ / 1000);
               _loc5_ = Math.pow(1000,++_loc4_);
               _loc11_ = Math.floor(_loc11_ / _loc5_);
            }
            _loc2_ += _loc11_;
            _loc7_++;
         }
         if(_loc2_ > 0)
         {
            if(_loc4_ >= PopUpGridSellComponent.DIVISION_SUFFIXES.length)
            {
               _loc4_ = PopUpGridSellComponent.DIVISION_SUFFIXES.length - 1;
            }
            _loc13_ = PopUpGridSellComponent.DIVISION_SUFFIXES[_loc4_];
            this.inventoryView.updateSaleTextValue(_loc2_,_loc13_);
         }
         else
         {
            this.inventoryView.resetSaleTextValue();
         }
      }
      
      private function containsNotItem(param1:int, param2:Array) : Boolean
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            if(param2[_loc3_] == param1)
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private function attemptedToMoveStackToEmptySlot(param1:MoveItemEvent) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.SPLIT_STACK_POPUP;
         _loc2_.transporter = param1.transporter;
         _loc2_.callback = this.attemptedInventoryItemSplit;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      private function attemptedToQuickBuyItem(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.GET_ITEM_COST,param1.transporter);
      }
      
      private function displayQuickBuyPopUp(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.QUICK_BUY_ITEM;
         _loc2_.transporter = param1;
         _loc2_.callback = this.sendQuickBuyToServer;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      private function sendQuickBuyToServer(param1:MoveItemEvent) : void
      {
         var _loc2_:Object = new Object();
         _loc2_.quantity = param1.transporter.chosenQuantity;
         _loc2_.itemId = param1.transporter.itemId;
         _loc2_.action = param1.transporter.action;
         sendNotification(ApplicationNotificationNames.QUERY_FOR_QUICK_BUY_ITEM,_loc2_);
      }
      
      private function attemptedToSellItem(param1:MoveItemEvent) : void
      {
         if(param1.transporter.quantity > 1 || param1.transporter.quantity == 1)
         {
            sendNotification(ApplicationNotificationNames.GET_ITEM_SALE_VALUE,param1.transporter);
            return;
         }
         this.sellAmountCallback(param1,false);
      }
      
      private function attemptedToSellShipOrPet(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_CLEAR_SELECTION);
         this.displaySellShipWindow(param1.transporter);
      }
      
      private function displaySellShipWindow(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.SELL_SHIP_POPUP;
         _loc2_.transporter = param1;
         _loc2_.callback = this.sellShipConfirmationCallback;
         _loc2_.callbackParams = param1;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      private function sellShipConfirmationCallback(param1:Object) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_FOR_SELLING_SHIP,param1);
      }
      
      private function displaySellingWindow(param1:Object) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.SELL_POPUP;
         _loc2_.transporter = param1;
         _loc2_.callback = this.sellAmountCallback;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      private function displayMultiSellingWindow(param1:Object) : void
      {
         var _loc8_:String = null;
         var _loc9_:ItemInstanceVO = null;
         var _loc10_:InventoryItemComponent = null;
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.MULTI_SELL_POPUP;
         _loc2_.transporter = param1;
         _loc2_.callback = this.sellMultipleItemsCallback;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         var _loc3_:Dictionary = this.connectionProxy.inventory.items;
         var _loc4_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         var _loc5_:Array = _loc4_.dragComp.multiSelection;
         if(_loc5_ == null)
         {
            _loc5_ = [];
         }
         var _loc6_:InventoryItemComponent = _loc4_.dragComp.currentSelectedItem;
         if(_loc6_ != null && _loc6_.isSelected() && _loc5_.indexOf(_loc6_) < 0)
         {
            _loc5_.push(_loc6_);
         }
         var _loc7_:Array = [];
         for(_loc8_ in _loc3_)
         {
            _loc9_ = _loc3_[_loc8_];
            for each(_loc10_ in _loc5_)
            {
               if(_loc9_.itemInfo.sellable && _loc8_ == _loc10_.itemID)
               {
                  _loc7_.push(_loc9_);
               }
            }
         }
         this.deselectItemsAfterInventoryChanged();
         _loc2_.itemList = _loc7_;
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
      }
      
      public function removeSuspendView() : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function sellMultipleItemsCallback(param1:Array) : void
      {
         var _loc5_:ItemInstanceVO = null;
         var _loc2_:Object = new Object();
         _loc2_.action = ActionIdentifiers.MULTI_ITEMS_SELL;
         _loc2_.items = [];
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc2_.items.push(_loc5_.ID);
            _loc4_++;
         }
         sendNotification(ApplicationNotificationNames.QUERY_FOR_SELLING_MULTIPLE_ITEMS,_loc2_);
      }
      
      private function sellAmountCallback(param1:MoveItemEvent, param2:Boolean = true) : void
      {
         var _loc3_:Object = null;
         if(param2)
         {
            _loc3_ = new Object();
            _loc3_.quantity = param1.transporter.chosenQuantity;
            _loc3_.itemId = param1.transporter.itemId;
            _loc3_.action = param1.transporter.action;
            sendNotification(ApplicationNotificationNames.QUERY_FOR_SELLING_ITEM,_loc3_);
         }
         else
         {
            sendNotification(ApplicationNotificationNames.QUERY_FOR_SELLING_ITEM,param1.transporter);
         }
      }
      
      private function attemptedInventoryItemSplit(param1:MoveItemEvent) : void
      {
         var _loc2_:Object = new Object();
         if(param1.transporter.chosenQuantity == param1.transporter.quantity)
         {
            _loc2_.action = ActionIdentifiers.MOVE;
            _loc2_.to = param1.transporter.to;
            _loc2_.from = param1.transporter.from;
            sendNotification(ApplicationNotificationNames.QUERY_INVENTORY_ITEMS_REARRANGED,_loc2_);
         }
         else
         {
            _loc2_.action = ActionIdentifiers.SPLIT;
            _loc2_.itemId = param1.transporter.from.items[0];
            _loc2_.quantity = param1.transporter.chosenQuantity;
            _loc2_.index = param1.transporter.to.index;
            sendNotification(ApplicationNotificationNames.QUERY_INVENTORY_ITEM_SPLIT,_loc2_);
         }
      }
      
      private function attemptedInventoryRearrange(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_INVENTORY_ITEMS_REARRANGED,param1.transporter);
      }
      
      private function attemptedItemMoveToInventory(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_INVENTORY,param1.transporter);
      }
      
      private function deselectItemsAfterInventoryChanged() : void
      {
         this.inventoryView.deactivateSellShipOrPetButton();
         this.inventoryView.resetSaleTextValue();
         this.deselectAllInventoryItems();
      }
      
      private function deselectAllInventoryItems() : void
      {
         this.inventoryView.disableAllInventoryButtons();
         MultiSelectionComponent.getInstance().deselectMultiSelection();
      }
      
      private function handleInventoryReady(param1:Event) : void
      {
         sendNotification(ApplicationNotificationNames.INVENTORY_READY);
      }
      
      private function get inventoryView() : InventoryView
      {
         return viewComponent as InventoryView;
      }
      
      private function deleteEquippedItems(param1:Array) : void
      {
         var _loc2_:ItemInstanceVO = null;
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1[_loc4_];
            this.inventoryView.deleteItem(_loc2_.ID,false);
            _loc4_++;
         }
      }
      
      private function deletedInventoryItems(param1:Vector.<ItemInstanceVO>) : void
      {
         var _loc2_:ItemInstanceVO = null;
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_ = param1[_loc4_];
            this.inventoryView.deleteItem(_loc2_.ID,false);
            _loc4_++;
         }
         this.inventoryView.removeNumberOfGridSlots(_loc3_);
         this.inventoryView.refreshView();
         this.inventoryView.disableAllInventoryButtons();
      }
   }
}

