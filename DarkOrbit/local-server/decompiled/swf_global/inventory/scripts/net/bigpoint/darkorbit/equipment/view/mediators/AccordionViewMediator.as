package net.bigpoint.darkorbit.equipment.view.mediators
{
   import flash.events.Event;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.MoveItemEvent;
   import net.bigpoint.darkorbit.equipment.events.PopUpEvent;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.LoadDataProxy;
   import net.bigpoint.darkorbit.equipment.model.MenuProxy;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.AccordionViewEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   import net.bigpoint.darkorbit.equipment.model.VO.Drone;
   import net.bigpoint.darkorbit.equipment.model.VO.HangarSlotEntity;
   import net.bigpoint.darkorbit.equipment.model.VO.Ship;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInfoVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemLocalisationKeys;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotItemVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.model.transporter.PopUpDefiner;
   import net.bigpoint.darkorbit.equipment.model.transporter.Transporter;
   import net.bigpoint.darkorbit.equipment.view.components.AccordionView;
   import net.bigpoint.darkorbit.equipment.view.components.SuspendView;
   import net.bigpoint.darkorbit.equipment.view.components.events.GenericDataEvent;
   import net.bigpoint.darkorbit.equipment.view.components.items.AccordionButtonComponent;
   import net.bigpoint.darkorbit.equipment.view.components.items.DragComponent;
   import net.bigpoint.darkorbit.equipment.view.components.menus.AccordionMenuComponent;
   import org.puremvc.as3.interfaces.IMediator;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.mediator.Mediator;
   
   public class AccordionViewMediator extends Mediator implements IMediator
   {
      
      public static const NAME:String = "AccordionViewMediator";
      
      public var selectedMenuButtonID:int = -1;
      
      public function AccordionViewMediator(param1:String = null, param2:Object = null)
      {
         super(param1,param2);
         this.initListener();
      }
      
      public function get accordionView() : AccordionView
      {
         return viewComponent as AccordionView;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW,ApplicationNotificationNames.BOOTSTRAP_FINISHED,ApplicationNotificationNames.MENU_BUTTON_CLICKED,ApplicationNotificationNames.MENU_LAYOUT_DEFINED,ApplicationNotificationNames.TAB_BUTTON_CLICKED,ApplicationNotificationNames.PLAYER_INFO_LOADED,ApplicationNotificationNames.INIT_INVENTORY,ApplicationNotificationNames.CHANGE_CONFIG,ApplicationNotificationNames.MOVE_TO_SHIP_EQUIPMENT,ApplicationNotificationNames.MOVE_TO_DRONE_EQUIPMENT,ApplicationNotificationNames.KEEP_IN_EQUIPMENT,ApplicationNotificationNames.UPDATE_UI_AFTER_CONFIGURATION_CLEARED,ApplicationNotificationNames.SAVE_CONFIGS_SUCCESSFUL,ApplicationNotificationNames.LOAD_CONFIGS_SUCCESSFUL,ApplicationNotificationNames.LOAD_CONFIGS_WITH_MISSING_ITEMS,ApplicationNotificationNames.LOAD_CONFIGS_FAIL,ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CURRENT_MENU,ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CONFIG,ApplicationNotificationNames
         .DELETE_ITEM,ApplicationNotificationNames.DELETE_MULTIPLE_EQUIPPED_ITEMS,ApplicationNotificationNames.CHANGE_ENTITY_GRAPHIC,ApplicationNotificationNames.KILL_DRONE,ApplicationNotificationNames.CHANGE_PET_NAME,ApplicationNotificationNames.PET_NAME_REJECTED,ApplicationNotificationNames.UNLOCK_SLOT,ApplicationNotificationNames.EXTEND_EXTRA_SLOTS,ApplicationNotificationNames.UPDATE_DRONE_INFO,ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED,ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_CLEAR_SELECTION,ApplicationNotificationNames.UPDATE_UI_AFTER_SHIP_DESIGN_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:LoadDataProxy = null;
         var _loc4_:HangarManagerProxy = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Boolean = false;
         var _loc8_:DragComponent = null;
         var _loc9_:Boolean = false;
         var _loc10_:MenuProxy = null;
         var _loc11_:TabViewMediator = null;
         var _loc12_:Transporter = null;
         var _loc13_:Array = null;
         var _loc14_:String = null;
         var _loc15_:Transporter = null;
         var _loc16_:Array = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc19_:Array = null;
         var _loc20_:Array = null;
         var _loc21_:Array = null;
         var _loc22_:Array = null;
         var _loc23_:int = 0;
         var _loc24_:Array = null;
         var _loc25_:ItemInstanceVO = null;
         var _loc26_:Array = null;
         var _loc27_:HangarSlotEntity = null;
         var _loc28_:Ship = null;
         var _loc29_:String = null;
         var _loc30_:String = null;
         var _loc31_:String = null;
         var _loc32_:Array = null;
         var _loc33_:Array = null;
         var _loc34_:int = 0;
         var _loc35_:int = 0;
         var _loc36_:Drone = null;
         var _loc37_:ItemInfoVO = null;
         var _loc38_:String = null;
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         _loc3_ = facade.retrieveProxy(LoadDataProxy.PROXY_NAME) as LoadDataProxy;
         _loc4_ = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         switch(param1.getName())
         {
            case ApplicationNotificationNames.SWITCH_BETWEEN_EQUIPMENT_AND_SHIP_SELECTOR_VIEW:
               _loc5_ = param1.getBody();
               if((Boolean(_loc5_)) && !_loc5_.showManagement)
               {
                  this.accordionView.dispose();
               }
               break;
            case ApplicationNotificationNames.BOOTSTRAP_FINISHED:
               _loc6_ = _loc3_.assetLib;
               this.accordionView.addEventListener(AccordionView.ACCORDION_MENUS_READY,this.handleAccordionMenuCreated);
               this.accordionView.addEventListener(AccordionView.PET_SELECTION_CHANGED,this.handlePetSelectionChanged);
               this.accordionView.addEventListener(AccordionView.MENU_BUTTON_CLICKED,this.handleMenuButtonClicked);
               this.accordionView.buildBasicUI();
               this.accordionView.buildMenu(_loc6_);
               this.accordionView.addEventListener(GenericDataEvent.FAVOURITE_HANGAR,this.handleFavouriteHanagarButtonClicked);
               break;
            case ApplicationNotificationNames.INIT_INVENTORY:
               _loc7_ = _loc4_.isHangarFilled();
               this.rebuildUIElements(_loc7_);
               this.accordionView.addEventListener(AccordionView.SHIP_SELECTION_CHANGED,this.handleShipSelectionChanged);
               _loc8_ = DragComponent.getInstance();
               _loc8_.addEventListener(MoveItemEvent.ITEMS_MOVED_TO_SHIP_EQUIPMENT,this.attemptedItemMoveToShipEquipment);
               _loc8_.addEventListener(MoveItemEvent.ITEMS_MOVED_TO_DRONE_EQUIPMENT,this.attemptedItemMoveToDroneEquipment);
               _loc8_.addEventListener(MoveItemEvent.ITEMS_MOVED_TO_N_DRONE_EQUIPMENT,this.attemptedItemMoveToNDroneEquipment);
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_HANGAR_SLOT_CHANGED:
               _loc9_ = _loc4_.isHangarFilled();
               this.rebuildUIElements(_loc9_);
               sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
               break;
            case ApplicationNotificationNames.CHANGE_CONFIG:
               _loc2_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
               this.accordionView.changeActiveConfig(_loc2_.activeConfig);
               break;
            case ApplicationNotificationNames.MENU_LAYOUT_DEFINED:
               _loc10_ = facade.retrieveProxy(MenuProxy.PROXY_NAME) as MenuProxy;
               this.accordionView.sectionList = _loc10_.tabMenuList;
               break;
            case ApplicationNotificationNames.PLAYER_INFO_LOADED:
               _loc2_ = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
               break;
            case ApplicationNotificationNames.MENU_BUTTON_CLICKED:
               this.accordionView.alterCurrentlySelectedWindow(this.selectedMenuButtonID);
               break;
            case ApplicationNotificationNames.TAB_BUTTON_CLICKED:
               _loc11_ = facade.retrieveMediator(TabViewMediator.NAME) as TabViewMediator;
               this.accordionView.switchAccordionMenu(_loc11_.selectedTabID);
               this.accordionView.switchTabSpecificUI(_loc11_.selectedTabID);
               break;
            case ApplicationNotificationNames.MOVE_TO_SHIP_EQUIPMENT:
               _loc12_ = param1.getBody() as Transporter;
               _loc13_ = _loc12_.from.items;
               _loc14_ = _loc12_.to.slotset;
               this.accordionView.placeItemsNewlyInEquipment(_loc13_,_loc14_);
               break;
            case ApplicationNotificationNames.MOVE_TO_DRONE_EQUIPMENT:
               _loc15_ = param1.getBody() as Transporter;
               _loc16_ = _loc15_.from.items;
               _loc17_ = _loc15_.to.droneId;
               this.accordionView.placeItemsNewlyInEquipment(_loc16_,_loc17_);
               break;
            case ApplicationNotificationNames.KEEP_IN_EQUIPMENT:
               _loc18_ = param1.getBody() as Array;
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_CONFIGURATION_CLEARED:
               _loc19_ = param1.getBody() as Array;
               this.accordionView.removeItemsFromEquipment(_loc19_,true,-1,ActionIdentifiers.SHIP);
               this.accordionView.removeItemsFromEquipment(_loc19_,true,-1,ActionIdentifiers.PET);
               this.clearActiveConfigDronesEffects();
               this.accordionView.removeItemsFromEquipment(_loc19_,true,-1,ActionIdentifiers.DRONES);
               break;
            case ApplicationNotificationNames.SAVE_CONFIGS_SUCCESSFUL:
               this.createSaveConfigSuccessPopUp();
               break;
            case ApplicationNotificationNames.LOAD_CONFIGS_SUCCESSFUL:
               this.createLoadConfigSuccessPopUp();
               break;
            case ApplicationNotificationNames.LOAD_CONFIGS_WITH_MISSING_ITEMS:
               this.createLoadConfigWithMissingItemsPopUp();
               break;
            case ApplicationNotificationNames.LOAD_CONFIGS_FAIL:
               this.createLoadConfigWithFailurePopUp();
               break;
            case ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CURRENT_MENU:
               _loc20_ = param1.getBody() as Array;
               this.accordionView.removeItemsFromEquipment(_loc20_,true);
               break;
            case ApplicationNotificationNames.MAKE_EMPTY_IN_EQUIPMENT_FOR_CONFIG:
               _loc21_ = param1.getBody() as Array;
               _loc22_ = _loc21_[0];
               _loc23_ = int(_loc21_[1]);
               this.accordionView.removeItemsFromEquipment(_loc22_,true,_loc23_);
               break;
            case ApplicationNotificationNames.DELETE_MULTIPLE_EQUIPPED_ITEMS:
               _loc24_ = param1.getBody() as Array;
               this.accordionView.removeItemsFromEquipment(_loc24_,true,1);
               this.accordionView.removeItemsFromEquipment(_loc24_,true,2);
               break;
            case ApplicationNotificationNames.DELETE_ITEM:
               _loc25_ = param1.getBody() as ItemInstanceVO;
               _loc24_ = [_loc25_];
               this.accordionView.removeItemsFromEquipment(_loc24_,true,1);
               this.accordionView.removeItemsFromEquipment(_loc24_,true,2);
               break;
            case ApplicationNotificationNames.CHANGE_ENTITY_GRAPHIC:
               _loc26_ = param1.getBody() as Array;
               _loc27_ = _loc4_.getCurrentHangarSlotVO();
               _loc28_ = _loc27_.getShip();
               if(_loc28_)
               {
                  _loc37_ = _loc27_.getItemInfoManager().items[_loc28_.selectedDesign] || _loc27_.getItemInfoManager().items[_loc28_.lootID] as ItemInfoVO;
                  if(_loc37_.factionDepended == "1")
                  {
                     _loc38_ = _loc4_.getUserFaction();
                     this.accordionView.changeDisplayedEntityGraphic(_loc26_[0],_loc26_[1],_loc38_);
                  }
                  else
                  {
                     this.accordionView.changeDisplayedEntityGraphic(_loc26_[0],_loc26_[1]);
                  }
               }
               else
               {
                  this.accordionView.changeDisplayedEntityGraphic(_loc26_[0],_loc26_[1]);
               }
               break;
            case ApplicationNotificationNames.KILL_DRONE:
               _loc29_ = param1.getBody() as String;
               this.accordionView.removeDroneSection(_loc29_);
               break;
            case ApplicationNotificationNames.CHANGE_PET_NAME:
               _loc30_ = param1.getBody() as String;
               this.accordionView.changePetDisplayName(_loc30_);
               break;
            case ApplicationNotificationNames.PET_NAME_REJECTED:
               _loc31_ = param1.getBody() as String;
               this.createRenamePetPopUpAfterError(_loc31_);
               break;
            case ApplicationNotificationNames.UNLOCK_SLOT:
               _loc32_ = param1.getBody() as Array;
               this.accordionView.unlockSlot(_loc32_[0],_loc32_[1]);
               break;
            case ApplicationNotificationNames.EXTEND_EXTRA_SLOTS:
               _loc33_ = param1.getBody() as Array;
               _loc34_ = int(_loc33_[0]);
               _loc35_ = int(_loc33_[1]);
               this.accordionView.changeExtrasSlots(_loc34_,_loc35_);
               break;
            case ApplicationNotificationNames.UPDATE_DRONE_INFO:
               _loc36_ = param1.getBody() as Drone;
               this.accordionView.updateDroneInfo(_loc36_);
               break;
            case ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_CLEAR_SELECTION:
               this.accordionView.deselectAllEntities();
               break;
            case ApplicationNotificationNames.UPDATE_UI_AFTER_SHIP_DESIGN_CHANGED:
               this.rebuildUIElements(true);
         }
      }
      
      public function clearActiveConfigDronesEffects() : void
      {
         var _loc3_:Drone = null;
         var _loc1_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         var _loc2_:Dictionary = _loc1_.equipmentManager.drones;
         for each(_loc3_ in _loc2_)
         {
            _loc3_.bonusEffects[Settings.activeConfig] = "0%/0%";
         }
      }
      
      public function removeSuspendView() : void
      {
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[false]);
      }
      
      private function initListener() : void
      {
         this.accordionView.addEventListener(InventoryEvent.UPDATE_DRONES_EFFECT,this.updateDroneDamage);
      }
      
      private function rebuildUIElements(param1:Boolean) : void
      {
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         this.accordionView.removeAllVisibleComponents();
         this.accordionView.createTabSpecificUI();
         facade.sendNotification(ApplicationNotificationNames.UPDATE_TOP_VIEW);
         this.accordionView.createMenuItems();
         this.accordionView.createAccordionMenuSections(_loc2_.equipmentManager.ship,_loc2_.equipmentManager.drones,_loc2_.equipmentManager.pet);
         this.accordionView.populateWithIcons(_loc2_.configManager.configs);
         if(_loc2_.equipmentManager.pet != null)
         {
            this.accordionView.changePetDisplayName(_loc2_.equipmentManager.pet.petName);
            this.accordionView.addEventListener(PopUpEvent.DISPLAY_PET_RENAME_POPUP,this.createRenamePetPopUp);
         }
         if(param1)
         {
            this.accordionView.reactivateShipView();
         }
         else
         {
            facade.sendNotification(ApplicationNotificationNames.UPDATE_TOP_VIEW);
            this.accordionView.deactivateShipView();
         }
      }
      
      private function createRenamePetPopUpAfterError(param1:String) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.RENAME_PET;
         _loc2_.callback = this.sendFinalNameChoiceToServer;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         _loc2_.errorMessage = param1;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function sendFinalNameChoiceToServer(param1:String) : void
      {
         param1 = param1.slice(0,-1);
         sendNotification(ApplicationNotificationNames.QUERY_CHANGE_PET_NAME,param1);
      }
      
      private function createSaveConfigSuccessPopUp(param1:PopUpEvent = null) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.GENERIC_POPUP;
         _loc2_.titleText = BPLocale.getItemInCategory("equipment_ui","popup_save_success_title");
         _loc2_.errorMessage = BPLocale.getItemInCategory("equipment_ui","popup_save_success_description");
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function createLoadConfigSuccessPopUp(param1:PopUpEvent = null) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.GENERIC_POPUP;
         _loc2_.titleText = BPLocale.getItemInCategory("equipment_ui","popup_load_success_title");
         _loc2_.errorMessage = BPLocale.getItemInCategory("equipment_ui","popup_load_success_description");
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function createLoadConfigWithMissingItemsPopUp(param1:PopUpEvent = null) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.GENERIC_POPUP;
         _loc2_.titleText = BPLocale.getItemInCategory("equipment_ui","popup_load_missing_equipment_title");
         _loc2_.errorMessage = BPLocale.getItemInCategory("equipment_ui","popup_load_missing_equipment_description");
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function createLoadConfigWithFailurePopUp(param1:PopUpEvent = null) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.GENERIC_POPUP;
         _loc2_.titleText = BPLocale.getItemInCategory("equipment_ui","popup_load_missing_equipment_title");
         _loc2_.errorMessage = BPLocale.getItemInCategory("equipment_ui","message_load_failed");
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function createRenamePetPopUp(param1:PopUpEvent = null) : void
      {
         var _loc2_:PopUpDefiner = new PopUpDefiner();
         _loc2_.popUpType = PopUpDefiner.RENAME_PET;
         _loc2_.callback = this.sendFinalNameChoiceToServer;
         _loc2_.cleanUpCallback = this.removeSuspendView;
         sendNotification(ApplicationNotificationNames.SHOW_POP_UP,_loc2_);
         sendNotification(ApplicationNotificationNames.TOGGLE_SUSPENDED_VIEW,[true,SuspendView.NO_MESSAGE]);
      }
      
      private function attemptedItemMoveToDroneEquipment(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_DRONE_EQUIPMENT,param1.transporter);
      }
      
      private function attemptedItemMoveToNDroneEquipment(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_N_DRONE_EQUIPMENT,param1.transporter);
      }
      
      private function attemptedItemMoveToShipEquipment(param1:MoveItemEvent) : void
      {
         sendNotification(ApplicationNotificationNames.QUERY_ITEMS_MOVED_TO_SHIP_EQUIPMENT,param1.transporter);
      }
      
      private function handleAccordionMenuCreated(param1:Event) : void
      {
         sendNotification(ApplicationNotificationNames.ACCORDIONS_READY);
      }
      
      private function handleFavouriteHanagarButtonClicked(param1:Event) : void
      {
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         var _loc3_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         var _loc4_:HangarSlotEntity = _loc3_.getCurrentHangarSlotVO();
      }
      
      private function handleMenuButtonClicked(param1:Event) : void
      {
         this.selectedMenuButtonID = this.accordionView.selectedMenu;
      }
      
      private function handleShipSelectionChanged(param1:Event) : void
      {
         var _loc2_:AccordionViewEntity = new AccordionViewEntity();
         _loc2_.type = AccordionViewEntity.SHIP;
         _loc2_.isSelected = this.accordionView.isShipSelected();
         _loc2_.instance = this.accordionView.shipEntityGraphic;
         sendNotification(ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_SELECTION_CHANGED,_loc2_);
      }
      
      private function handlePetSelectionChanged(param1:Event) : void
      {
         var _loc2_:AccordionViewEntity = new AccordionViewEntity();
         _loc2_.type = AccordionViewEntity.PET;
         _loc2_.isSelected = this.accordionView.isPetSelected();
         _loc2_.instance = this.accordionView.petEntityImage;
         sendNotification(ApplicationNotificationNames.ACCORDION_VIEW_ENTITY_SELECTION_CHANGED,_loc2_);
      }
      
      private function updateDroneDamage(param1:InventoryEvent) : void
      {
         var _loc9_:String = null;
         var _loc10_:Object = null;
         var _loc11_:SlotSetVO = null;
         var _loc12_:SlotItemVO = null;
         var _loc13_:ItemInstanceVO = null;
         var _loc14_:String = null;
         var _loc15_:AccordionMenuComponent = null;
         var _loc16_:TextFormat = null;
         var _loc17_:String = null;
         var _loc18_:String = null;
         var _loc19_:AccordionButtonComponent = null;
         var _loc20_:Drone = null;
         var _loc21_:String = null;
         var _loc22_:String = null;
         var _loc23_:String = null;
         var _loc24_:SlotItemVO = null;
         var _loc25_:String = null;
         var _loc2_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         var _loc3_:Dictionary = _loc2_.equipmentManager.drones;
         var _loc4_:Config = param1.info as Config;
         var _loc5_:Boolean = true;
         var _loc6_:Dictionary = _loc4_.equipments;
         var _loc7_:String = "Havoc";
         var _loc8_:String = "Hercules";
         for(_loc9_ in _loc6_)
         {
            if(_loc9_.substr(0,6) == "drone_")
            {
               _loc11_ = _loc6_[_loc9_]["slotSets"]["design"] as SlotSetVO;
               if(_loc11_.items.length >= 1)
               {
                  _loc12_ = _loc11_.items[0];
                  _loc13_ = _loc12_.itemInstance;
                  _loc14_ = _loc13_.itemInfo.name;
                  if(_loc14_ != _loc7_)
                  {
                     _loc5_ = false;
                     break;
                  }
               }
               else
               {
                  _loc5_ = false;
               }
            }
         }
         _loc10_ = this.accordionView.configsList[_loc4_.name];
         if(_loc10_)
         {
            _loc15_ = _loc10_["drone"] as AccordionMenuComponent;
            _loc16_ = new TextFormat();
            _loc17_ = "";
            for(_loc18_ in _loc15_.menuButtonComponents)
            {
               if(_loc18_ != "")
               {
                  _loc19_ = _loc15_.menuButtonComponents[_loc18_];
                  _loc20_ = _loc3_[_loc18_];
                  _loc21_ = "drone_" + _loc18_;
                  _loc22_ = "empty";
                  _loc23_ = "empty";
                  if(_loc6_[_loc21_]["slotSets"]["design"]["items"]["length"] > 0)
                  {
                     _loc24_ = _loc6_[_loc21_]["slotSets"]["design"]["items"][0] as SlotItemVO;
                     _loc22_ = ItemLocalisationKeys.BPLOCAL_CATEGORY__ITEMS + ItemLocalisationKeys.SEPARATOR + _loc24_.itemInstance.itemInfo.lootID + "_fullname";
                     _loc23_ = _loc24_.itemInstance.itemInfo.name;
                     if(_loc17_ == "")
                     {
                        _loc17_ = _loc22_;
                     }
                     _loc19_.updateDroneDesign(_loc22_);
                  }
                  else
                  {
                     _loc19_.updateDroneDesign();
                  }
                  if(_loc20_.bonusEffects[Settings.activeConfig] != "0%/0%")
                  {
                     _loc19_.setDroneEffectText(_loc20_);
                  }
                  else
                  {
                     _loc16_.color = 16777215;
                     _loc25_ = BPLocale.getItem("label_drone_info_effect").replace(/%VALUE%/,String(_loc20_.effect));
                     _loc19_.droneEffectText.text = _loc25_;
                     _loc19_.droneEffectText.setTextFormat(_loc16_);
                  }
               }
            }
         }
      }
   }
}

