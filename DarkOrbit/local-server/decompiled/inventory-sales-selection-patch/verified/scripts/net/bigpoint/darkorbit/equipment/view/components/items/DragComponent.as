package net.bigpoint.darkorbit.equipment.view.components.items
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import net.bigpoint.darkorbit.equipment.events.ActionIdentifiers;
   import net.bigpoint.darkorbit.equipment.events.InventoryEvent;
   import net.bigpoint.darkorbit.equipment.events.ItemEvent;
   import net.bigpoint.darkorbit.equipment.events.MoveItemEvent;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.Config;
   import net.bigpoint.darkorbit.equipment.model.VO.Equipment;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.model.managers.ConfigManager;
   import net.bigpoint.darkorbit.equipment.model.transporter.Transporter;
   import net.bigpoint.darkorbit.equipment.view.components.AccordionView;
   import net.bigpoint.darkorbit.equipment.view.components.InventoryView;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuComponent;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuView;
   import net.bigpoint.darkorbit.equipment.view.components.menus.AccordionMenuComponent;
   import net.bigpoint.dataInterchange.DataInterchange;
   import net.bigpoint.utils.DisplayObjectHelper;
   
   public class DragComponent extends Sprite
   {
      
      private static var _instance:DragComponent;
      
      public var collisionViews:Array = [];
      
      public var multiSelection:Array;
      
      private var _currentDraggedIcon:InventoryItemComponent;
      
      private var _selectedItem:InventoryItemComponent;
      
      private var _currentSelectedItem:InventoryItemComponent;
      
      private var _previouslySelectedItem:InventoryItemComponent;
      
      private var _currentDraggedIconProxy:InventoryItemComponent;
      
      private var _hoveredSection:AccordionButtonComponent;
      
      private var multiSelector:MultiSelectionComponent;
      
      private var hoveredSectionSlotSet:String;
      
      private var _dragable:Boolean = true;
      
      private var lastDblc:Number = 0;
      
      private var doubleClickTime:Number = 200;
      
      private var startDragX:int = 0;
      
      private var startDragY:int = 0;
      
      public function DragComponent(param1:Function)
      {
         super();
         if(param1 != hidden)
         {
            throw new Error("DragComponent is a Singleton and can only be accessed through DragComponent.getInstance()");
         }
         this.multiSelector = MultiSelectionComponent.getInstance();
         this.multiSelector.dragComp = this;
      }
      
      private static function hidden() : void
      {
      }
      
      public static function getInstance() : DragComponent
      {
         if(_instance == null)
         {
            _instance = new DragComponent(hidden);
         }
         return _instance;
      }
      
      public function set dragable(param1:Boolean) : void
      {
         this._dragable = param1;
      }
      
      public function get dragable() : Boolean
      {
         return this._dragable;
      }
      
      public function addDraggableIcon(param1:InventoryItemComponent) : void
      {
         this.createListeners(param1);
      }
      
      public function removeDraggableIcon(param1:InventoryItemComponent) : void
      {
         this.removeListeners(param1);
      }
      
      public function addCollisionView(param1:IMenuView) : void
      {
         this.removeCollisionView(param1);
         this.collisionViews.push(param1);
      }
      
      public function removeCollisionView(param1:IMenuView) : void
      {
         var _loc2_:int = this.collisionViews.indexOf(param1);
         if(_loc2_ != -1)
         {
            this.collisionViews.splice(_loc2_,1);
         }
      }
      
      private function createListeners(param1:InventoryItemComponent) : void
      {
         param1.doubleClickEnabled = true;
         param1.mouseChildren = false;
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.handleObjectMouseDown);
         param1.addEventListener(MouseEvent.CLICK,this.handleObjectClicked);
      }
      
      private function removeListeners(param1:InventoryItemComponent) : void
      {
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleObjectMouseDown);
         param1.removeEventListener(MouseEvent.CLICK,this.handleObjectClicked);
      }
      
      private function handleObjectMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:Number = getTimer();
         var _loc3_:uint = _loc2_ - this.lastDblc;
         this.lastDblc = _loc2_;
         if(_loc3_ < this.doubleClickTime)
         {
            this.handleObjectDoubleClicked(param1);
         }
         else
         {
            if(this._currentDraggedIcon != null && this._currentDraggedIcon.isDrone)
            {
               this._currentDraggedIcon.setDeselected();
               this._selectedItem = null;
            }
            this._currentDraggedIcon = param1.currentTarget as InventoryItemComponent;
            if(this._currentDraggedIcon.isDrone || Settings.inventoryOpen || param1.ctrlKey || param1.shiftKey)
            {
               return;
            }
            if(this.multiSelection == null)
            {
               this.multiSelection = [];
            }
            if(this.multiSelection.length == 0)
            {
               this.multiSelection.push(this._currentDraggedIcon);
            }
            param1.stopPropagation();
            this.startDragging();
         }
      }
      
      private function handleObjectClicked(param1:MouseEvent) : void
      {
         var _loc2_:InventoryItemComponent = InventoryItemComponent(param1.currentTarget);
         if(_loc2_.isDrone || Settings.inventoryOpen && !param1.ctrlKey && !param1.shiftKey)
         {
            if(Settings.inventoryOpen)
            {
               this.multiSelector.removeSelectedStatusFromAllItems();
               this.multiSelection = [];
            }
            this.selectTarget(_loc2_);
            _loc2_.setSelected();
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECTED,this._currentDraggedIcon.itemID));
            return;
         }
         var _loc3_:InventoryItemComponent = this._currentDraggedIcon;
         this._currentDraggedIcon = _loc2_;
         if(param1.ctrlKey)
         {
            if(this._selectedItem == null)
            {
               this._selectedItem = InventoryItemComponent(_loc2_);
            }
            this.addCurrentItemToMultiSelect(_loc2_,_loc3_);
         }
         else if(param1.shiftKey)
         {
            this.markAllItemsOfTheSameType(_loc2_);
         }
         else
         {
            this.multiSelector.removeSelectedStatusFromAllItems();
            this._currentSelectedItem = _loc2_ as InventoryItemComponent;
            this.selectTarget(_loc2_);
            this.addCurrentItemToMultiSelect(_loc2_,_loc3_);
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECTED,this._currentDraggedIcon.itemID));
         }
      }
      
      private function handleObjectDoubleClicked(param1:MouseEvent) : void
      {
         if(Settings.inventoryOpen)
         {
            return;
         }
         var _loc2_:InventoryItemComponent = InventoryItemComponent(param1.currentTarget);
         if(_loc2_.isDrone)
         {
            this.selectTarget(_loc2_);
            _loc2_.setSelected();
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_SELECTED,this._currentDraggedIcon.itemID));
            return;
         }
         this._currentDraggedIcon = _loc2_;
         if(this.multiSelection != null && this.multiSelection.indexOf(this._currentDraggedIcon) == -1)
         {
            this.multiSelection.push(this._currentDraggedIcon);
         }
         this.quickMoveItem(this._currentDraggedIcon);
      }
      
      private function markAllItemsOfTheSameType(param1:Sprite) : void
      {
         this.multiSelector.removeSelectedStatusFromAllItems();
         this._currentSelectedItem = InventoryItemComponent(param1);
         if(this._previouslySelectedItem != null)
         {
            this._previouslySelectedItem.setDeselected();
         }
         this._currentDraggedIcon.setSelected();
         this._selectedItem = this._currentDraggedIcon;
         if(Boolean(this.multiSelection) && !this.currentIconIsPartOfSelection())
         {
            this.multiSelection = [];
            this.multiSelector.removeSelectedStatusFromAllItems();
         }
         dispatchEvent(new InventoryEvent(InventoryEvent.CHECK_INVENTORY_CONTEXT_BUTTON));
         dispatchEvent(new InventoryEvent(InventoryEvent.UPDATE_SELL_BUTTON));
         if(!this._currentDraggedIcon.buyableExtraSlot)
         {
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_MULTISELECTED,this._selectedItem.itemID,this._selectedItem.itemName));
         }
      }
      
      protected function addCurrentItemToMultiSelect(param1:Sprite, param2:InventoryItemComponent) : void
      {
         var _loc4_:int = 0;
         if(InventoryItemComponent(param1).isDrone)
         {
            this.multiSelector.removeSelectedStatusFromAllItems();
            return;
         }
         this._currentDraggedIcon = InventoryItemComponent(param1);
         var _loc3_:Boolean = this._currentDraggedIcon != null && this._currentDraggedIcon.menuSectionComponent != null;
         if(_loc3_ && !this._currentDraggedIcon.buyableExtraSlot)
         {
            this._currentDraggedIcon.toggleSelected();
            if(this.multiSelection == null)
            {
               this.multiSelection = [];
            }
            if(this._currentDraggedIcon.isSelected())
            {
               this.multiSelection.push(this._currentDraggedIcon);
            }
            else
            {
               _loc4_ = this.multiSelection.indexOf(this._currentDraggedIcon);
               if(_loc4_ > -1)
               {
                  this.multiSelection.removeAt(_loc4_);
               }
            }
            if(param2 != null && param2.isSelected() && this.multiSelection.indexOf(param2) < 0)
            {
               this.multiSelection.push(param2);
            }
            dispatchEvent(new ItemEvent(ItemEvent.ITEM_MULTISELECT_UPDATED));
         }
      }
      
      public function selectTarget(param1:Sprite) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:GridComponent = null;
         var _loc4_:Array = null;
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:Object = null;
         if(InventoryItemComponent(param1).isDrone)
         {
            this.multiSelector.removeSelectedStatusFromAllItems();
         }
         this._currentDraggedIcon = InventoryItemComponent(param1);
         if(param1 is InventoryItemComponent)
         {
            this._currentSelectedItem = param1 as InventoryItemComponent;
         }
         if(this._previouslySelectedItem != null)
         {
            this._previouslySelectedItem.setDeselected();
         }
         this._selectedItem = this._currentDraggedIcon;
         if(Boolean(this.multiSelection) && !this.currentIconIsPartOfSelection())
         {
            this.multiSelection = [];
            this.multiSelector.removeSelectedStatusFromAllItems();
         }
         dispatchEvent(new InventoryEvent(InventoryEvent.CHECK_INVENTORY_CONTEXT_BUTTON));
         dispatchEvent(new InventoryEvent(InventoryEvent.UPDATE_SELL_BUTTON));
         if(this._currentDraggedIcon.isLargeIcon)
         {
            this._previouslySelectedItem = this._currentDraggedIcon;
            return;
         }
         if(this._currentDraggedIcon.buyableExtraSlot)
         {
            this._previouslySelectedItem = this._currentDraggedIcon;
            _loc2_ = uint(this._currentDraggedIcon.indexInGrid);
            _loc3_ = this._currentDraggedIcon.menuSectionComponent as GridComponent;
            _loc4_ = _loc3_.iconsInThisMenu;
            if(_loc2_ > 0)
            {
               _loc5_ = _loc4_[_loc2_ - 1];
               if(!(_loc5_.buyableExtraSlot == false && this._currentDraggedIcon.buyableExtraSlot == true))
               {
                  return;
               }
            }
            _loc6_ = new Object();
            _loc6_.slotset = _loc3_.getParent().section.toLowerCase();
            _loc6_.target = _loc3_.getContainingViewID();
            switch(_loc6_.slotset)
            {
               case ActionIdentifiers.GEARS:
                  _loc6_.slotPrice = Settings.PET_GEAR_SLOT_PRICES[_loc2_];
                  break;
               case ActionIdentifiers.LASERS:
                  _loc6_.slotPrice = Settings.PET_LASER_SLOT_PRICES[_loc2_];
                  break;
               case ActionIdentifiers.GENERATORS:
                  _loc6_.slotPrice = Settings.PET_GENERATOR_SLOT_PRICES[_loc2_];
                  break;
               case ActionIdentifiers.PROTCOLS:
                  _loc6_.slotPrice = Settings.PET_PROTOCOL_SLOT_PRICES[_loc2_];
                  break;
               case ActionIdentifiers.HEAT:
                  _loc6_.slotPrice = Settings.PET_HEAT_SLOT_PRICES[_loc2_];
            }
            _loc6_.action = ActionIdentifiers.BUY_SLOT;
            dispatchEvent(new InventoryEvent(InventoryEvent.BUYABLE_SLOT_CLICKED,_loc6_));
            return;
         }
      }
      
      protected function startDragging() : void
      {
         var _loc3_:Number = Number(NaN);
         var _loc4_:Number = Number(NaN);
         var _loc5_:Boolean = false;
         if(!this.dragable)
         {
            return;
         }
         this.currentDraggedIconProxy = this.makeProxyDragObject(this._currentDraggedIcon);
         this.currentDraggedIconProxy.addEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         if(this.multiSelection != null)
         {
            _loc5_ = this.currentIconIsPartOfSelection();
            if(!_loc5_)
            {
               this.multiSelection.push(this._currentDraggedIcon);
               this._currentDraggedIcon.setSelected();
            }
            if(this.multiSelection.length > 1)
            {
               this.currentDraggedIconProxy.addStackUnderlay();
            }
         }
         else
         {
            this.multiSelector.resetAllIconsSelectedStatus();
            this._currentDraggedIcon.setSelected();
         }
         if(this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger() != null)
         {
            this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger().defineGrabbedIcon(this.currentDraggedIconProxy,this._currentDraggedIcon);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
         }
         this.currentDraggedIconProxy.alpha = 0.6;
         var _loc1_:Number = this._currentDraggedIcon.x;
         var _loc2_:Number = this._currentDraggedIcon.y;
         if(this._currentDraggedIcon.menuSectionComponent.getParent() is AccordionButtonComponent)
         {
            _loc3_ = this._currentDraggedIcon.menuSectionComponent.getParent().x + this._currentDraggedIcon.menuSectionComponent.getParent().parent.parent.parent.x;
            _loc4_ = this._currentDraggedIcon.menuSectionComponent.getParent().y + this._currentDraggedIcon.menuSectionComponent.getParent().parent.parent.parent.y;
         }
         else
         {
            _loc3_ = this._currentDraggedIcon.menuSectionComponent.getX();
            _loc4_ = this._currentDraggedIcon.menuSectionComponent.getY();
         }
         this.startDragX = _loc1_ + _loc3_;
         this.startDragY = _loc2_ + _loc4_;
         this.startDelayedIconProxyDrag();
      }
      
      private function startDelayedIconProxyDrag() : void
      {
         this.currentDraggedIconProxy.startDrag();
         this.parent.addChild(this.currentDraggedIconProxy);
         this.currentDraggedIconProxy.mouseEnabled = false;
         this.currentDraggedIconProxy.mouseChildren = false;
         this.currentDraggedIconProxy.x = this.startDragX;
         this.currentDraggedIconProxy.y = this.startDragY;
      }
      
      private function sortItems(param1:Dictionary, param2:Array, param3:String) : Array
      {
         var _loc6_:Equipment = null;
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < param2.length)
         {
            _loc6_ = this.getItem(param1,param2[_loc5_],param3);
            if(_loc6_)
            {
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         return _loc4_;
      }
      
      private function getItem(param1:Dictionary, param2:String, param3:String) : Equipment
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         for(_loc4_ in param1)
         {
            _loc5_ = _loc4_.substr(0,5);
            if(_loc5_ == param3)
            {
               _loc6_ = _loc4_.substr(param3.length + 1,_loc4_.length - 1);
               if(_loc6_ == param2)
               {
                  return param1[_loc4_];
               }
            }
         }
         return null;
      }
      
      private function quickMoveItem(param1:Sprite) : void
      {
         var _loc3_:Array = null;
         var _loc5_:IMenuView = null;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc2_:Sprite = param1;
         this._currentDraggedIcon = InventoryItemComponent(_loc2_);
         this.currentDraggedIconProxy = this.makeProxyDragObject(this._currentDraggedIcon);
         var _loc4_:Transporter = new Transporter();
         var _loc8_:int = 0;
         while(_loc8_ < this.collisionViews.length)
         {
            if(this.currentDraggedIconProxy.hitTestObject(DisplayObject((this.collisionViews[_loc8_] as IMenuView).getActualCollisionRegion())))
            {
               _loc5_ = this.collisionViews[_loc8_];
               _loc6_ = _loc5_.getCurrentlyOpenMenu();
               break;
            }
            _loc8_++;
         }
         switch(_loc6_)
         {
            case ActionIdentifiers.DRONES:
               this.handleMultiSectionQuickMove(_loc5_,_loc4_);
               break;
            default:
               this.handleOnlyOneSectionQuickMove(_loc5_,_loc7_,_loc3_,_loc4_);
         }
      }
      
      private function handleMultiSectionQuickMove(param1:IMenuView, param2:Transporter) : void
      {
         var _loc6_:AccordionView = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:AccordionMenuComponent = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Object = null;
         var _loc13_:String = null;
         var _loc14_:Config = null;
         var _loc15_:Array = null;
         var _loc16_:ItemInstanceVO = null;
         var _loc17_:int = 0;
         var _loc18_:String = null;
         var _loc19_:int = 0;
         var _loc20_:Equipment = null;
         var _loc21_:SlotSetVO = null;
         var _loc22_:String = null;
         var _loc23_:int = 0;
         var _loc24_:Dictionary = null;
         var _loc25_:InventoryItemComponent = null;
         var _loc26_:* = 0;
         var _loc27_:Array = null;
         var _loc28_:int = 0;
         param2 = new Transporter();
         var _loc3_:Array = [];
         var _loc4_:Array = [];
         if(param1 is AccordionView)
         {
            _loc6_ = param1 as AccordionView;
            _loc7_ = _loc6_.numChildren;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc9_ = _loc6_.getChildAt(_loc8_) as AccordionMenuComponent;
               if(_loc9_)
               {
                  _loc10_ = _loc9_.menuList;
                  _loc4_ = _loc4_.concat(_loc10_);
               }
               _loc8_++;
            }
         }
         var _loc5_:String = this._currentDraggedIcon.menuSectionComponent.getContainingViewID();
         switch(_loc5_)
         {
            case Settings.INVENTORY_NAME:
               _loc11_ = null;
               if(this.multiSelection != null)
               {
                  if(this.currentIconIsPartOfSelection())
                  {
                     if(this.multiSelection.length == 0)
                     {
                        _loc11_ = [this._currentDraggedIcon];
                     }
                     else
                     {
                        _loc11_ = this.multiSelection;
                     }
                  }
                  else
                  {
                     _loc11_ = [this._currentDraggedIcon];
                  }
               }
               else
               {
                  _loc11_ = [this._currentDraggedIcon];
               }
               _loc12_ = {};
               _loc13_ = this.currentDraggedIconProxy.group;
               _loc14_ = ConfigManager.getInstance().configs[Settings.activeConfig];
               _loc15_ = this.sortItems(_loc14_.equipments,_loc10_,"drone");
               _loc16_ = this.currentDraggedIconProxy.getItemInstanceData();
               _loc17_ = int(_loc15_.length);
               _loc19_ = 0;
               while(_loc19_ < _loc17_)
               {
                  _loc20_ = _loc15_[_loc19_];
                  _loc22_ = _loc20_.name.substr(6,_loc20_.name.length - 1);
                  if(_loc13_ == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                  {
                     _loc21_ = _loc20_.slotSets[DataInterchange.DESIGN_STATS];
                  }
                  else if(_loc13_ == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                  {
                     _loc21_ = _loc20_.slotSets[DataInterchange.DESIGN_VISUAL];
                  }
                  else
                  {
                     _loc21_ = _loc20_.slotSets[DataInterchange.DEFAULT];
                  }
                  _loc23_ = _loc21_.maxSlotCount - _loc21_.items.length;
                  _loc24_ = new Dictionary();
                  _loc26_ = int(_loc11_.length - 1);
                  if(_loc23_ > 0)
                  {
                     _loc27_ = [];
                     _loc28_ = 0;
                     while(_loc28_ < _loc23_ && _loc26_ >= 0)
                     {
                        if(_loc11_ != null)
                        {
                           _loc25_ = _loc11_[_loc26_];
                           if(_loc24_[_loc25_.itemName])
                           {
                              _loc26_--;
                              continue;
                           }
                           if(_loc25_.group.substr(0,6) == "Extra_")
                           {
                              _loc24_[_loc25_.itemName] = true;
                           }
                           _loc27_.push(_loc25_.itemID);
                           _loc11_.removeAt(_loc11_.indexOf(_loc25_));
                           _loc26_--;
                        }
                        _loc28_++;
                     }
                     _loc12_[_loc22_] = _loc27_;
                  }
                  _loc19_++;
               }
               param2.action = ActionIdentifiers.DRONE_EQUIP;
               param2.from["configId"] = Settings.activeConfig;
               param2.from["target"] = this._currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
               param2.from["droneItems"] = _loc12_;
               param2.to["configId"] = Settings.activeConfig;
               param2.to["target"] = param1.getCurrentlyOpenMenu().toLowerCase();
               if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
               {
                  _loc18_ = DataInterchange.DESIGN_STATS;
               }
               else if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
               {
                  _loc18_ = DataInterchange.DESIGN_VISUAL;
               }
               else
               {
                  _loc18_ = DataInterchange.DEFAULT;
               }
               param2.to["slotset"] = _loc18_;
               dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_N_DRONE_EQUIPMENT,param2));
               break;
            case ActionIdentifiers.DRONES:
               this.handleOnlyOneSectionQuickMove(param1,[],[],param2);
         }
      }
      
      private function handleOnlyOneSectionQuickMove(param1:IMenuView, param2:Array, param3:Array, param4:Transporter) : void
      {
         var _loc6_:AccordionView = null;
         var _loc7_:int = 0;
         var _loc8_:AccordionMenuComponent = null;
         var _loc9_:Config = null;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:Equipment = null;
         var _loc13_:SlotSetVO = null;
         var _loc14_:String = null;
         if(Settings.inventoryOpen)
         {
            return;
         }
         if(param1 is AccordionView)
         {
            _loc6_ = param1 as AccordionView;
            _loc7_ = 0;
            while(_loc7_ < _loc6_.numChildren)
            {
               if(_loc6_.getChildAt(_loc7_) is AccordionMenuComponent)
               {
                  _loc8_ = _loc6_.getChildAt(_loc7_) as AccordionMenuComponent;
                  param2 = _loc8_.menuList;
                  break;
               }
               _loc7_++;
            }
         }
         if(!Settings.inventoryOpen)
         {
            this.highlightPossibleDropAreas(this.currentDraggedIconProxy.group,param1);
         }
         var _loc5_:String = this._currentDraggedIcon.menuSectionComponent.getContainingViewID();
         switch(_loc5_)
         {
            case Settings.INVENTORY_NAME:
               if(this.multiSelection != null)
               {
                  if(this.currentIconIsPartOfSelection())
                  {
                     param3 = this.returnItemIDs(this.multiSelection);
                  }
                  else
                  {
                     param3 = this.returnItemIDs([this._currentDraggedIcon]);
                  }
               }
               else
               {
                  param3 = this.returnItemIDs([this._currentDraggedIcon]);
               }
               param4.from["configId"] = Settings.activeConfig;
               param4.to["configId"] = Settings.activeConfig;
               param4.from["target"] = this._currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
               param4.from["items"] = param3;
               param4.to["target"] = param1.getCurrentlyOpenMenu().toLowerCase();
               param4.action = ActionIdentifiers.MOVE;
               if(param1.getCurrentlyOpenMenu() == ActionIdentifiers.DRONES)
               {
                  _loc9_ = ConfigManager.getInstance().configs[Settings.activeConfig];
                  _loc10_ = this.sortItems(_loc9_.equipments,param2,"drone");
                  _loc11_ = 0;
                  while(_loc11_ < _loc10_.length)
                  {
                     _loc12_ = _loc10_[_loc11_];
                     _loc14_ = _loc12_.name.substr(6,_loc12_.name.length - 1);
                     if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                     {
                        _loc13_ = _loc12_.slotSets[DataInterchange.DESIGN_STATS];
                        param4.to["slotset"] = DataInterchange.DESIGN_STATS;
                     }
                     else if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                     {
                        _loc13_ = _loc12_.slotSets[DataInterchange.DESIGN_VISUAL];
                        param4.to["slotset"] = DataInterchange.DESIGN_VISUAL;
                     }
                     else
                     {
                        _loc13_ = _loc12_.slotSets[DataInterchange.DEFAULT];
                        param4.to["slotset"] = DataInterchange.DEFAULT;
                     }
                     if(_loc13_.items.length < _loc13_.maxSlotCount)
                     {
                        param4.to["droneId"] = _loc14_;
                        dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_DRONE_EQUIPMENT,param4));
                        break;
                     }
                     _loc11_++;
                  }
               }
               else
               {
                  if(this.currentDraggedIconProxy.group == DataInterchange.PET_DESIGN_STATS_TYPE_CLASS)
                  {
                     param4.to["slotset"] = DataInterchange.DESIGN_STATS;
                  }
                  else if(this.currentDraggedIconProxy.group == DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS)
                  {
                     param4.to["slotset"] = DataInterchange.DESIGN_VISUAL;
                  }
                  else
                  {
                     if(this.hoveredSectionSlotSet == null)
                     {
                        return;
                     }
                     param4.to["slotset"] = this.hoveredSectionSlotSet;
                  }
                  dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_SHIP_EQUIPMENT,param4));
               }
               break;
            case ActionIdentifiers.SHIP:
            case ActionIdentifiers.PET:
            case ActionIdentifiers.DRONES:
               if(this.multiSelection != null)
               {
                  if(this.currentIconIsPartOfSelection())
                  {
                     param3 = this.returnItemIDs(this.multiSelection);
                  }
                  else
                  {
                     param3 = this.returnItemIDs([this._currentDraggedIcon]);
                  }
               }
               else
               {
                  param3 = this.returnItemIDs([this._currentDraggedIcon]);
               }
               param4.from["configId"] = Settings.activeConfig;
               param4.to["configId"] = Settings.activeConfig;
               param4.from["target"] = this._currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
               param4.from["items"] = param3;
               param4.to["target"] = Settings.INVENTORY_NAME;
               param4.to["index"] = 0;
               param4.action = ActionIdentifiers.MOVE;
               if(this.currentDraggedIcon.menuSectionComponent.getContainingViewID() == ActionIdentifiers.DRONES)
               {
                  param4.from["droneId"] = this.currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
                  if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                  {
                     param4.action = ActionIdentifiers.MOVE_DRONE_DESIGN;
                     param4.from["slotset"] = DataInterchange.DESIGN_STATS;
                  }
                  else if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                  {
                     param4.from["slotset"] = DataInterchange.DESIGN_VISUAL;
                  }
                  else
                  {
                     param4.from["slotset"] = DataInterchange.DEFAULT;
                  }
               }
               else if(this.currentDraggedIconProxy.group == DataInterchange.PET_DESIGN_STATS_TYPE_CLASS)
               {
                  param4.from["slotset"] = DataInterchange.DESIGN_STATS;
               }
               else if(this.currentDraggedIconProxy.group == DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS)
               {
                  param4.from["slotset"] = DataInterchange.DESIGN_VISUAL;
               }
               else
               {
                  param4.from["slotset"] = this._currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
               }
               dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_INVENTORY,param4));
         }
         this.multiSelection = [];
         this.removeAllHighlightingFrom(param1);
      }
      
      private function makeProxyDragObject(param1:InventoryItemComponent) : InventoryItemComponent
      {
         var _loc2_:InventoryItemComponent = new InventoryItemComponent();
         _loc2_.init();
         _loc2_.itemName = param1.itemName;
         _loc2_.itemID = param1.itemID;
         _loc2_.group = param1.group;
         _loc2_.changeGraphic(param1.itemName);
         _loc2_.col = param1.col;
         _loc2_.row = param1.row;
         _loc2_.equippedInConfigs = param1.equippedInConfigs;
         _loc2_.menuSectionComponent = param1.menuSectionComponent;
         _loc2_.indexInGrid = param1.indexInGrid;
         _loc2_.canBeSelected = param1.canBeSelected;
         _loc2_.quantityField = param1.quantityField;
         _loc2_.quantity = param1.quantity;
         _loc2_.sellable = param1.sellable;
         return _loc2_;
      }
      
      private function currentIconIsPartOfSelection() : Boolean
      {
         var _loc2_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.multiSelection.length)
         {
            _loc2_ = this.multiSelection[_loc1_];
            if(_loc2_ == this._currentDraggedIcon)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      private function handleMouseMoved(param1:MouseEvent) : void
      {
         var _loc3_:IMenuView = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.collisionViews.length)
         {
            _loc3_ = this.collisionViews[_loc2_];
            if(this.currentDraggedIconProxy.hitTestObject(DisplayObject(_loc3_)))
            {
               if(!Settings.inventoryOpen)
               {
                  this.highlightPossibleDropAreas(this.currentDraggedIconProxy.group,_loc3_);
               }
               this.checkMenuSectionCollisions(this.currentDraggedIconProxy,_loc3_);
            }
            else
            {
               this.removeAllHighlightingFrom(_loc3_);
            }
            _loc2_++;
         }
         this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger().mouseMoveCallback();
      }
      
      private function checkMenuSectionCollisions(param1:InventoryItemComponent, param2:IMenuView) : void
      {
         var _loc4_:AccordionMenuComponent = null;
         var _loc5_:Dictionary = null;
         var _loc6_:AccordionButtonComponent = null;
         var _loc3_:Dictionary = param2.getCurrentlyActiveSection();
         if(_loc3_ != null)
         {
            _loc4_ = _loc3_[param2.getCurrentlyOpenMenu()];
            _loc5_ = _loc4_.menuButtonComponents;
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.open)
               {
                  if(this.currentDraggedIconProxy.hitTestObject(DisplayObject(_loc6_)))
                  {
                     this._hoveredSection = _loc6_;
                     break;
                  }
               }
               else
               {
                  this._hoveredSection = null;
               }
            }
         }
      }
      
      private function removeAllHighlightingFrom(param1:IMenuView) : void
      {
         var _loc3_:AccordionMenuComponent = null;
         var _loc4_:Dictionary = null;
         var _loc5_:AccordionButtonComponent = null;
         var _loc2_:Dictionary = param1.getCurrentlyActiveSection();
         if(_loc2_ != null)
         {
            _loc3_ = _loc2_[param1.getCurrentlyOpenMenu()];
            _loc4_ = _loc3_.menuButtonComponents;
            for each(_loc5_ in _loc4_)
            {
               TweenMax.to(_loc5_,0.3,{"colorMatrixFilter":{"brightness":1}});
            }
         }
      }
      
      private function highlightPossibleDropAreas(param1:String, param2:IMenuView) : void
      {
         var _loc4_:String = null;
         var _loc5_:AccordionMenuComponent = null;
         var _loc6_:Dictionary = null;
         var _loc7_:AccordionButtonComponent = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:GridComponent = null;
         var _loc3_:Dictionary = param2.getCurrentlyActiveSection();
         if(_loc3_ != null)
         {
            this.hoveredSectionSlotSet = null;
            _loc5_ = _loc3_[param2.getCurrentlyOpenMenu()];
            _loc6_ = _loc5_.menuButtonComponents;
            for each(_loc7_ in _loc6_)
            {
               if(_loc7_.section != "")
               {
                  _loc8_ = _loc7_.equippableSections;
                  _loc9_ = 0;
                  while(_loc9_ < _loc8_.length)
                  {
                     if(param1 == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                     {
                        _loc10_ = _loc7_.gridStatsDesign;
                     }
                     else if(param1 == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                     {
                        _loc10_ = _loc7_.gridVisualDesign;
                     }
                     else
                     {
                        _loc10_ = _loc7_.grid;
                     }
                     if(param1 == _loc8_[_loc9_])
                     {
                        if(_loc10_.iconsInThisMenu.length - _loc10_.lockedSlots <= _loc10_.nextFreeSpace)
                        {
                           _loc4_ = _loc7_.section;
                        }
                        else if(!(this.hoveredSectionSlotSet != null && _loc7_.section == "heat"))
                        {
                           this.hoveredSectionSlotSet = _loc7_.section;
                           TweenMax.to(_loc7_,0.3,{"colorMatrixFilter":{"brightness":1.3}});
                           if(_loc5_.menuName != "drone" && !_loc7_.open)
                           {
                              _loc5_.openOtherMenuSlot(_loc7_.id);
                           }
                        }
                     }
                     _loc9_++;
                  }
               }
            }
            if(this.hoveredSectionSlotSet == null)
            {
               this.hoveredSectionSlotSet = _loc4_;
            }
         }
      }
      
      public function handleObjectReleased(param1:MouseEvent) : void
      {
         var _loc4_:IMenuView = null;
         var _loc5_:IMenuView = null;
         this._previouslySelectedItem = this._currentDraggedIcon;
         if(this._previouslySelectedItem.isLargeIcon)
         {
            return;
         }
         this._currentDraggedIcon.alpha = 1;
         this.currentDraggedIconProxy.stopDrag();
         this.currentDraggedIconProxy.removeEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.handleObjectReleased);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoved);
         if(this.parent.contains(this.currentDraggedIconProxy))
         {
            this.parent.removeChild(this.currentDraggedIconProxy);
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.collisionViews.length)
         {
            _loc4_ = this.collisionViews[_loc2_];
            this.removeAllHighlightingFrom(_loc4_);
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.collisionViews.length)
         {
            _loc5_ = this.collisionViews[_loc3_];
            if(this.currentDraggedIconProxy.hitTestObject(DisplayObject(_loc5_.getActualCollisionRegion())))
            {
               if(param1 != null)
               {
                  this.rearrangeItem(_loc5_);
                  if(!param1.ctrlKey)
                  {
                     this.deselectAllDragComponents();
                  }
               }
               return;
            }
            _loc3_++;
         }
         if(this._currentDraggedIcon.menuSectionComponent.getParent() is InventoryView)
         {
            this._currentDraggedIcon.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
         }
         else
         {
            this._currentDraggedIcon.menuSectionComponent.putThisItemBack(this._currentDraggedIcon);
         }
         this.deselectAllDragComponents();
      }
      
      public function deselectAllDragComponents() : void
      {
         this.multiSelection = null;
         this._selectedItem = null;
         this._currentDraggedIcon = null;
         this.currentDraggedIconProxy = null;
         dispatchEvent(new ItemEvent(ItemEvent.ALL_ITEMS_DESELECTED));
      }
      
      private function rearrangeItem(param1:IMenuView) : void
      {
         if(param1.getCurrentlyOpenMenu() == ActionIdentifiers.DRONES && this._currentDraggedIcon.menuSectionComponent.getContainingViewID() == Settings.INVENTORY_NAME && this.multiSelection != null && this.multiSelection.length > 1 && this.currentIconIsPartOfSelection())
         {
            this.handleMultiSectionQuickMove(param1,new Transporter());
            return;
         }
         var _loc2_:String = null;
         var _loc3_:IMenuComponent = null;
         var _loc4_:Array = null;
         var _loc9_:Dictionary = null;
         var _loc10_:int = 0;
         var _loc11_:String = null;
         var _loc5_:Object = new Object();
         var _loc6_:Transporter = new Transporter();
         var _loc7_:Object = new Object();
         var _loc8_:Object = new Object();
         switch(param1.getViewID())
         {
            case Settings.INVENTORY_NAME:
               if(this._currentDraggedIcon.menuSectionComponent.getParent() is InventoryView)
               {
                  _loc9_ = this.currentDraggedIconProxy.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
                  if(_loc9_[ActionIdentifiers.PUT_DRAGGED_ITEM_BACK_FUNCTION] is Function)
                  {
                     _loc9_[ActionIdentifiers.PUT_DRAGGED_ITEM_BACK_FUNCTION];
                  }
                  else
                  {
                     _loc5_.action = ActionIdentifiers.MOVE;
                     _loc7_.target = param1.getViewID().toLowerCase();
                     _loc8_.target = param1.getViewID().toLowerCase();
                     _loc7_.items = new Array(_loc9_[ActionIdentifiers.DRAGGED_ITEM_INDEX]);
                     _loc8_.index = _loc9_[ActionIdentifiers.SWAPPED_ITEM_INDEX];
                     _loc5_.from = _loc7_;
                     _loc5_.to = _loc8_;
                     _loc10_ = int(_loc9_[ActionIdentifiers.DRAGGED_ITEM_QUANTITY]);
                     _loc11_ = _loc9_[ActionIdentifiers.SWAPPED_ITEM_GROUP];
                     dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEM_REARRANGED_WITHIN_INVENTORY,_loc5_));
                  }
               }
               else
               {
                  if(this.multiSelection != null)
                  {
                     if(this.currentIconIsPartOfSelection())
                     {
                        _loc4_ = this.returnItemIDs(this.multiSelection);
                     }
                     else
                     {
                        _loc4_ = this.returnItemIDs([this._selectedItem]);
                     }
                  }
                  else
                  {
                     _loc4_ = this.returnItemIDs([this._selectedItem]);
                  }
                  _loc6_.to.configId = Settings.activeConfig;
                  _loc6_.from.configId = Settings.activeConfig;
                  _loc6_.from.target = this._currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
                  _loc6_.from.items = _loc4_;
                  _loc6_.to.target = param1.getViewID().toLowerCase();
                  _loc6_.to.index = 0;
                  if(_loc6_.from.target == ActionIdentifiers.DRONES)
                  {
                     _loc6_.action = ActionIdentifiers.MOVE_DRONE_DESIGN;
                  }
                  else
                  {
                     _loc6_.action = ActionIdentifiers.MOVE;
                  }
                  if(this._currentDraggedIcon.menuSectionComponent.getContainingViewID() == ActionIdentifiers.DRONES)
                  {
                     _loc6_.from.droneId = this._currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
                     if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                     {
                        _loc6_.from.slotset = DataInterchange.DESIGN_STATS;
                     }
                     else if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                     {
                        _loc6_.from.slotset = DataInterchange.DESIGN_VISUAL;
                     }
                     else
                     {
                        _loc6_.from.slotset = DataInterchange.DEFAULT;
                     }
                  }
                  else
                  {
                     _loc6_.from.slotset = this._currentDraggedIcon.menuSectionComponent.getParent().section.toLowerCase();
                  }
                  dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_INVENTORY,_loc6_));
               }
               break;
            case Settings.ACCORDION_NAME:
               _loc3_ = this._currentDraggedIcon.menuSectionComponent;
               if(this._currentDraggedIcon.menuSectionComponent.getParent() is AccordionButtonComponent)
               {
                  this._currentDraggedIcon.menuSectionComponent.putThisItemBack(this._currentDraggedIcon);
               }
               else if((_loc3_.getFilterState() != ItemFilter.USER_FILTER || _loc3_.getFilterState() != ItemFilter.CONTEXT_FILTER) && this._hoveredSection != null)
               {
                  if(this.multiSelection != null)
                  {
                     if(this.currentIconIsPartOfSelection())
                     {
                        _loc4_ = this.returnItemIDs(this.multiSelection);
                     }
                     else
                     {
                        _loc4_ = this.returnItemIDs([this._selectedItem]);
                     }
                  }
                  else
                  {
                     _loc4_ = this.returnItemIDs([this._selectedItem]);
                  }
                  _loc6_ = new Transporter();
                  _loc6_.from.configId = Settings.activeConfig;
                  _loc6_.to.configId = Settings.activeConfig;
                  _loc6_.from.target = this._currentDraggedIcon.menuSectionComponent.getContainingViewID().toLowerCase();
                  _loc6_.from.items = _loc4_;
                  _loc6_.to.target = param1.getCurrentlyOpenMenu().toLowerCase();
                  _loc6_.action = ActionIdentifiers.MOVE;
                  if(param1.getCurrentlyOpenMenu() == ActionIdentifiers.DRONES)
                  {
                     _loc6_.to.droneId = this._hoveredSection.section.toLowerCase();
                     if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_STATS_TYPE_CLASS)
                     {
                        _loc6_.to.slotset = DataInterchange.DESIGN_STATS;
                        _loc6_.action = ActionIdentifiers.MOVE_DRONE_DESIGN;
                     }
                     else if(this.currentDraggedIconProxy.group == DataInterchange.DRONE_DESIGN_VISUAL_TYPE_CLASS)
                     {
                        _loc6_.to.slotset = DataInterchange.DESIGN_VISUAL;
                     }
                     else
                     {
                        _loc6_.to.slotset = DataInterchange.DEFAULT;
                     }
                     dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_DRONE_EQUIPMENT,_loc6_));
                  }
                  else
                  {
                     if(this.currentDraggedIconProxy.group == DataInterchange.PET_DESIGN_STATS_TYPE_CLASS)
                     {
                        _loc6_.to["slotset"] = DataInterchange.DESIGN_STATS;
                     }
                     else if(this.currentDraggedIconProxy.group == DataInterchange.PET_DESIGN_VISUAL_TYPE_CLASS)
                     {
                        _loc6_.to["slotset"] = DataInterchange.DESIGN_VISUAL;
                     }
                     else
                     {
                        if(this.hoveredSectionSlotSet == null)
                        {
                           return;
                        }
                        _loc6_.to["slotset"] = this.hoveredSectionSlotSet;
                     }
                     dispatchEvent(new MoveItemEvent(MoveItemEvent.ITEMS_MOVED_TO_SHIP_EQUIPMENT,_loc6_));
                  }
               }
               else
               {
                  this._currentDraggedIcon.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
               }
               break;
            default:
               if(this._currentDraggedIcon.menuSectionComponent.getParent() is InventoryView)
               {
                  this._currentDraggedIcon.menuSectionComponent.getGridRearranger().mouseReleaseCallback();
               }
         }
      }
      
      private function returnItemIDs(param1:Array) : Array
      {
         var _loc4_:InventoryItemComponent = null;
         if(param1 == null || param1.length == 0)
         {
            return new Array(this._currentDraggedIcon.itemID);
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc2_.push(_loc4_.itemID);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function get previouslySelectedItem() : InventoryItemComponent
      {
         return this._previouslySelectedItem;
      }
      
      public function get currentSelectedItem() : InventoryItemComponent
      {
         return this._currentSelectedItem;
      }
      
      public function get selectedItem() : InventoryItemComponent
      {
         return this._selectedItem;
      }
      
      public function get currentDraggedIcon() : InventoryItemComponent
      {
         return this._currentDraggedIcon;
      }
      
      public function set selectedItem(param1:InventoryItemComponent) : void
      {
         if(Boolean(this._selectedItem) && param1 != this._selectedItem)
         {
         }
         this._selectedItem = param1;
      }
      
      public function get currentDraggedIconProxy() : InventoryItemComponent
      {
         return this._currentDraggedIconProxy;
      }
      
      public function set currentDraggedIconProxy(param1:InventoryItemComponent) : void
      {
         if(Boolean(this._currentDraggedIconProxy) && param1 != this._currentDraggedIconProxy)
         {
            this._currentDraggedIconProxy.dispose();
            DisplayObjectHelper.removeDisplayObject(this._currentDraggedIconProxy);
         }
         this._currentDraggedIconProxy = param1;
      }
      
      public function dispose() : void
      {
         if(this._currentDraggedIcon)
         {
            this._currentDraggedIcon.dispose();
            DisplayObjectHelper.removeDisplayObject(this._currentDraggedIcon);
            this._currentDraggedIcon = null;
         }
         if(this._selectedItem)
         {
            this._selectedItem.dispose();
            DisplayObjectHelper.removeDisplayObject(this._selectedItem);
            this._selectedItem = null;
         }
         if(this._currentSelectedItem)
         {
            this._currentSelectedItem.dispose();
            DisplayObjectHelper.removeDisplayObject(this._currentSelectedItem);
            this._currentSelectedItem = null;
         }
         if(this._previouslySelectedItem)
         {
            this._previouslySelectedItem.dispose();
            DisplayObjectHelper.removeDisplayObject(this._previouslySelectedItem);
            this._previouslySelectedItem = null;
         }
         if(this._currentDraggedIconProxy)
         {
            this._currentDraggedIconProxy.dispose();
            DisplayObjectHelper.removeDisplayObject(this._currentDraggedIconProxy);
            this._currentDraggedIconProxy = null;
         }
         if(this._hoveredSection)
         {
            this._hoveredSection.dispose();
            this._hoveredSection = null;
         }
      }
   }
}

