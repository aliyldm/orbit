package net.bigpoint.darkorbit.equipment.view.components.items
{
   import com.adobe.utils.StringUtil;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.equipment.events.GridEvent;
   import net.bigpoint.darkorbit.equipment.model.Settings;
   import net.bigpoint.darkorbit.equipment.model.VO.item.ItemInstanceVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotItemVO;
   import net.bigpoint.darkorbit.equipment.model.VO.slot.SlotSetVO;
   import net.bigpoint.darkorbit.equipment.model.managers.FilterManager;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.view.components.buttons.DropDownButton;
   import net.bigpoint.darkorbit.equipment.view.components.interfaces.IMenuComponent;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.TooltipControl;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.ITooltipPreparer;
   import net.bigpoint.darkorbit.equipment.view.components.tooltip.preparation.TooltipPreparerFactory;
   import net.bigpoint.darkorbit.equipment.view.managers.FocusManager;
   import net.bigpoint.darkorbit.equipment.view.managers.IFocusable;
   import net.bigpoint.dataInterchange.DataInterchange;
   import net.bigpoint.utils.DisplayObjectHelper;
   import org.puremvc.as3.patterns.facade.Facade;
   
   public class GridComponent extends Sprite implements IMenuComponent, IFocusable
   {
      
      public static const OBJECT_NAME:String = "GridComponent";
      
      public static const NORMAL_GRID:String = "normal_grid";
      
      public static const BLOCK_BASED_GRID:String = "block_based_grid";
      
      public static var GRID_HORIZONTAL_SPACING:int = 10;
      
      public static var GRID_VERTICAL_SPACING:int = 6;
      
      public static var ITEMS_PER_BLOCK:int = 24;
      
      public static const DRAG_GROUP_ACCORDIONVIEW_ID:int = 1;
      
      public static const DRAG_GROUP_INVENTORYVIEW_ID:int = 2;
      
      public const STAGE_HEIGHT:Number = 430;
      
      public const HALF_STAGE_HEIGHT:Number = 215;
      
      public const TWEEN_SPEED:Number = 0.3;
      
      private var ITEM_WIDTH:Number = 34;
      
      private var ITEM_HEIGHT:Number = 34;
      
      public var GRID_MODE:String = "normal_grid";
      
      private var menuList:Array;
      
      public var selectedMenu:int = -1;
      
      public var menuName:String;
      
      public var associatedView:Sprite;
      
      private var offSetY:Number;
      
      private var offSetX:Number;
      
      public var ICONS_ACROSS:int = 4;
      
      public var BLOCKS_ACROSS:int = 1;
      
      public var ICONS_DOWN:int = 6;
      
      public var GAP_AMOUNT:int = 10;
      
      public var startYPos:Number = 0;
      
      public var rowTracker:int = 0;
      
      private var redrawBlockColumn:int = 0;
      
      private var redrawBlockRow:int = 0;
      
      protected var startingPointFromLeft:Number = 0;
      
      protected var startingPointFromTop:Number = 0;
      
      public var canRearrange:Boolean = false;
      
      public var nextFreeSpace:int;
      
      public var filterBy:String = "user";
      
      public var currentFilter:String = this.filterBy;
      
      protected var dragComp:DragComponent;
      
      private var blocksList:Array = [];
      
      private var _iconsInThisMenu:Array = [];
      
      private var visualBlockArray:Array = [];
      
      private var sortedItems:Array = [];
      
      private var nonFilteredItems:Array = [];
      
      private var emptyItems:Array = [];
      
      public var lockedSlots:int = 0;
      
      public var sectionName:String;
      
      public var slotSetName:String;
      
      public var verticallyAligned:Boolean = false;
      
      public var startXPos:Number = 0;
      
      private var hangarIDasFilter:int = 0;
      
      public var gridArranger:GridRearrangeComponent;
      
      public var lowestOfSortedItems:InventoryItemComponent;
      
      private var toolTipControl:TooltipControl;
      
      private var hangarManager:HangarManagerProxy;
      
      private var lastHangarWideEquippedItemIDsToRemove:Array;
      
      private var _dragGroupID:int;
      
      private var _eventListenerTracking:Dictionary = new Dictionary();
      
      public function GridComponent(param1:Boolean)
      {
         super();
         this.toolTipControl = TooltipControl.getInstance();
         this.cacheAsBitmap = true;
         this.offSetY = this.offSetY;
         this.offSetX = this.offSetX;
         if(this.dragComp == null)
         {
            this.dragComp = DragComponent.getInstance();
         }
         this.canRearrange = param1;
         this.gridArranger = new GridRearrangeComponent(this._iconsInThisMenu);
         this.gridArranger.addEventListener(GridEvent.FILL_IN_GAP,this.fillEmptyGridSquares);
         this.gridArranger.addEventListener(GridEvent.RE_ORDER_GRID,this.reOrderGridByGroups);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEvent);
         if(param1)
         {
            this.gridArranger.rearrangeActive = true;
         }
      }
      
      private function handleMouseMoveEvent(param1:MouseEvent) : void
      {
         this.focusing();
      }
      
      public function focusing() : void
      {
         dispatchEvent(new GridEvent(GridEvent.FOCUSED));
      }
      
      public function unfocusing() : void
      {
         dispatchEvent(new GridEvent(GridEvent.UNFOCUSED));
      }
      
      public function createGridMenu(param1:int, param2:Boolean = false) : void
      {
         var _loc3_:int = 0;
         var _loc6_:InventoryItemComponent = null;
         var _loc7_:int = 0;
         var _loc8_:InventoryItemComponent = null;
         this.verticallyAligned = param2;
         var _loc4_:Number = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1)
         {
            _loc6_ = new InventoryItemComponent();
            _loc6_.init();
            _loc6_.menuSectionComponent = this;
            _loc6_.group = ItemFilter.EMPTY_SPACE_FILTER;
            this.dragComp.addDraggableIcon(_loc6_);
            addChild(_loc6_);
            _loc7_ = _loc5_ % this.ICONS_ACROSS;
            if(param2)
            {
               _loc6_.x = this.rowTracker * _loc6_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
               _loc6_.y = _loc7_ * _loc6_.width + Math.floor(_loc7_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            }
            else
            {
               _loc6_.x = _loc7_ * _loc6_.width + Math.floor(_loc7_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
               _loc6_.y = this.rowTracker * _loc6_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            }
            _loc6_.col = _loc7_;
            _loc6_.row = this.rowTracker;
            _loc3_ = _loc6_.row * this.ICONS_ACROSS + _loc6_.col;
            _loc6_.indexInGrid = _loc3_;
            _loc8_ = this._iconsInThisMenu[_loc3_];
            if(_loc8_)
            {
               _loc8_.dispose();
               DisplayObjectHelper.removeDisplayObject(_loc8_);
            }
            this._iconsInThisMenu[_loc3_] = _loc6_;
            if(_loc7_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            _loc5_++;
         }
         this.addDragListeners(this._iconsInThisMenu);
         this.giveIconsToGridArranger(this._iconsInThisMenu);
         this.addGridToMultiSelector();
      }
      
      public function splitItemsIntoBlocks(param1:int) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:InventoryItemComponent = null;
         this.GRID_MODE = BLOCK_BASED_GRID;
         var _loc2_:int = 0;
         var _loc3_:int = Math.ceil(param1 / ITEMS_PER_BLOCK);
         var _loc4_:int = 0;
         while(_loc4_ <= _loc3_)
         {
            _loc5_ = [];
            _loc6_ = 0;
            while(_loc6_ < ITEMS_PER_BLOCK)
            {
               _loc7_ = new InventoryItemComponent();
               _loc7_.init();
               _loc7_.menuSectionComponent = this;
               this.toolTipControl.addToolTip(_loc7_,"Name: Item Name \nType: Item Type \nCharges: 1x10 to the 5000 \nDuration: Not Long");
               _loc7_.group = ItemFilter.EMPTY_SPACE_FILTER;
               this._iconsInThisMenu[_loc2_] = _loc7_;
               _loc7_.indexInGrid = _loc2_;
               _loc5_.push(_loc7_);
               _loc2_++;
               _loc6_++;
            }
            this.blocksList[_loc4_] = _loc5_;
            _loc4_++;
         }
         this.displayBlocks(this.blocksList);
      }
      
      private function displayBlocks(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Sprite = null;
         var _loc2_:int = 0;
         this.visualBlockArray.length = 0;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = _loc3_ % this.BLOCKS_ACROSS;
            _loc5_ = this.arrangeIndividualBlock(param1[_loc3_]);
            this.visualBlockArray.push(_loc5_);
            _loc5_.x = _loc4_ * (_loc5_.width + this.GAP_AMOUNT);
            _loc5_.y = _loc2_ * (_loc5_.height + this.GAP_AMOUNT);
            if(_loc4_ == this.BLOCKS_ACROSS - 1)
            {
               _loc2_++;
            }
            addChild(_loc5_);
            _loc3_++;
         }
      }
      
      private function arrangeIndividualBlock(param1:Array) : BlockComponent
      {
         var _loc5_:int = 0;
         var _loc6_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         var _loc3_:BlockComponent = new BlockComponent();
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = _loc4_ % this.ICONS_ACROSS;
            _loc6_ = param1[_loc4_];
            _loc6_.x = _loc5_ * _loc6_.width;
            _loc6_.y = _loc2_ * _loc6_.height;
            if(_loc5_ == this.ICONS_ACROSS - 1)
            {
               _loc2_++;
            }
            _loc3_.addChild(_loc6_);
            _loc3_.blockIndex = _loc4_;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function findContainingBlock(param1:int) : int
      {
         return int(Math.floor(param1 / ITEMS_PER_BLOCK) + 1);
      }
      
      public function globalToLocalIndex(param1:int) : int
      {
         var _loc2_:int = this.findContainingBlock(param1);
         if(_loc2_ == 1)
         {
            return param1;
         }
         var _loc3_:int = (_loc2_ - 1) * ITEMS_PER_BLOCK;
         return int(Math.abs(param1 - _loc3_));
      }
      
      private function reOrderGridByGroups(param1:GridEvent = null) : void
      {
         var _loc2_:ItemFilter = new ItemFilter();
         this.addDragListeners(this._iconsInThisMenu);
         var _loc3_:Array = _loc2_.sortAllItemsByGroup(this._iconsInThisMenu);
         this.reOrderIconArray(_loc3_);
         this.reDrawGridWithFilter(_loc3_);
         var _loc4_:Array = _loc2_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.removeDragListeners(_loc4_);
      }
      
      private function reOrderIconArray(param1:Array) : void
      {
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this._iconsInThisMenu[_loc3_] = param1[_loc3_];
            this._iconsInThisMenu[_loc3_].indexInGrid = _loc3_;
            _loc3_++;
         }
      }
      
      public function filterByContext(param1:Array, param2:Array = null, param3:Array = null, param4:String = null) : void
      {
         var _loc12_:InventoryItemComponent = null;
         var _loc13_:ItemInstanceVO = null;
         var _loc14_:Boolean = false;
         var _loc5_:ItemFilter = new ItemFilter();
         this.sortedItems = _loc5_.filterByArrayOfSpecificGroups(param1,this._iconsInThisMenu).slice();
         var _loc6_:HangarManagerProxy = Facade.getInstance().retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         var _loc7_:String = String(_loc6_.getSelectedHangarSlot().hangarID);
         var _loc8_:Array = [];
         var _loc9_:uint = this.sortedItems.length;
         var _loc10_:uint = 0;
         while(_loc10_ < _loc9_)
         {
            _loc12_ = this.sortedItems[_loc10_];
            _loc13_ = _loc12_.getItemInstanceData();
            _loc14_ = param4 == null || param4 == "" ? true : _loc13_.getEquipByOnly().indexOf(param4) != -1;
            if(!_loc13_.isEquippedInOtherHangar(_loc7_) && _loc14_)
            {
               _loc8_.push(_loc12_);
            }
            _loc10_++;
         }
         var _loc11_:Array = this.sortedItems = _loc8_;
         this.nonFilteredItems = _loc5_.getItemsNotInOtherArray(this._iconsInThisMenu,_loc11_);
         this.changeVisibleState(true,this._iconsInThisMenu);
         this.addDragListeners(this._iconsInThisMenu);
         this.removeDragListeners(this.nonFilteredItems);
         this.putToBack(this.nonFilteredItems);
         this.gridArranger.rearrangeActive = false;
         this.redrawGridWithSortedAndNonFilteredItems();
         this.lowestOfSortedItems = _loc11_[_loc11_.length - 1];
         this.removeAllEquippedOverlays(this._iconsInThisMenu);
         if(param3)
         {
            this.changeEquipmentState(_loc11_,param3);
         }
         this.currentFilter = ItemFilter.CONTEXT_FILTER;
      }
      
      private function removeAllHangarWideEquippedItems(param1:Array, param2:Array) : void
      {
         var _loc4_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         this.lastHangarWideEquippedItemIDsToRemove = param1;
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = 0;
            while(_loc4_ < param2.length)
            {
               _loc5_ = param2[_loc4_] as InventoryItemComponent;
               if(_loc5_.itemID == param1[_loc3_])
               {
                  param2.splice(_loc4_,1);
               }
               _loc4_++;
            }
            _loc3_++;
         }
      }
      
      public function fillEmptyGridSquares(param1:GridEvent = null) : void
      {
         this.changeVisibleState(true,this._iconsInThisMenu);
         var _loc2_:ItemFilter = new ItemFilter();
         this.addDragListeners(this._iconsInThisMenu);
         this.sortedItems = _loc2_.filterByParentGroup(this.currentFilter,this.gridArranger.allIcons);
         this.nonFilteredItems = _loc2_.getItemsNotInOtherArray(this.gridArranger.allIcons,this.sortedItems);
         this.emptyItems = _loc2_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.lowestOfSortedItems = this.sortedItems[this.sortedItems.length - 1];
         this.removeDragListeners(this.nonFilteredItems);
         this.putToBack(this.nonFilteredItems);
         this.changeVisibleState(false,this.nonFilteredItems);
         this.reDrawGridWithFilter(this.sortedItems);
         this.removeAllEquippedOverlays(this._iconsInThisMenu);
      }
      
      public function setHangarIDasFilter(param1:int) : void
      {
         this.hangarIDasFilter = param1;
      }
      
      public function filterGridOnMouseEvent(param1:MouseEvent = null) : void
      {
         var _loc2_:DropDownButton = DropDownButton(param1.currentTarget);
         this.filterGridByButton(_loc2_);
      }
      
      public function filterGridByButton(param1:DropDownButton) : void
      {
         var _loc2_:String = param1.filterKey;
         this.filterByKey(_loc2_);
      }
      
      private function filterByKey(param1:String) : void
      {
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc2_:Boolean = param1 == FilterManager.FILTER_USER;
         var _loc3_:uint = this._iconsInThisMenu.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            this._iconsInThisMenu[_loc4_].setDeselected();
            _loc4_++;
         }
         this.changeVisibleState(true,this._iconsInThisMenu);
         this.addDragListeners(this._iconsInThisMenu);
         var _loc5_:ItemFilter = new ItemFilter();
         if(_loc2_ && this.hangarIDasFilter != 0)
         {
            this.sortedItems = this.gridArranger.allIcons;
         }
         else
         {
            this.sortedItems = _loc5_.filterByParentGroup(param1,this.gridArranger.allIcons,true);
         }
         if(this.hangarIDasFilter != 0)
         {
            switch(param1)
            {
               case FilterManager.FILTER_RESSOURCES:
                  this.sortedItems = _loc5_.filterByParentGroup(FilterManager.FILTER_RESSOURCES,this.gridArranger.allIcons,true);
                  break;
               case FilterManager.FILTER_AMMUNITION:
                  this.sortedItems = _loc5_.filterByParentGroup(FilterManager.FILTER_AMMUNITION,this.gridArranger.allIcons,true);
                  break;
               default:
                  this.prefilterItemlistForSpecificHangar(this.hangarIDasFilter,_loc5_);
            }
            if(_loc2_)
            {
               _loc6_ = _loc5_.filterByParentGroup(FilterManager.FILTER_RESSOURCES,this.gridArranger.allIcons,true);
               _loc7_ = _loc5_.filterByParentGroup(FilterManager.FILTER_AMMUNITION,this.gridArranger.allIcons,true);
               this.sortedItems = this.sortedItems.concat(_loc6_);
               this.sortedItems = this.sortedItems.concat(_loc7_);
            }
         }
         this.nonFilteredItems = _loc5_.getItemsNotInOtherArray(this.gridArranger.allIcons,this.sortedItems);
         this.emptyItems = _loc5_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.lowestOfSortedItems = this.sortedItems[this.sortedItems.length - 1];
         this.removeDragListeners(this.nonFilteredItems);
         this.putToBack(this.nonFilteredItems);
         this.gridArranger.rearrangeActive = false;
         this.redrawGridWithSortedAndNonFilteredItems();
         this.removeAllEquippedOverlays(this._iconsInThisMenu);
         this.currentFilter = param1;
      }
      
      private function prefilterItemlistForSpecificHangar(param1:int, param2:ItemFilter) : void
      {
         var _loc8_:InventoryItemComponent = null;
         var _loc9_:int = 0;
         var _loc10_:InventoryItemComponent = null;
         var _loc3_:Array = this.hangarManager.getAllEquippedItemIDsForHangar(param1);
         var _loc4_:Array = [];
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:int = 0;
         while(_loc6_ < _loc3_.length)
         {
            _loc9_ = 0;
            while(_loc9_ < this.sortedItems.length)
            {
               _loc10_ = this.sortedItems[_loc9_];
               if(_loc10_.itemID == _loc3_[_loc6_])
               {
                  _loc4_.push(_loc10_);
                  _loc5_[_loc10_.itemID] = _loc10_;
               }
               _loc9_++;
            }
            _loc6_++;
         }
         this.sortedItems = _loc4_;
         var _loc7_:Array = [];
         for each(_loc8_ in _loc5_)
         {
            _loc7_.push(_loc8_);
         }
         this.sortedItems = _loc7_;
      }
      
      public function addAllEquippedOverlays(param1:Array) : void
      {
      }
      
      private function removeAllEquippedOverlays(param1:Array) : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc3_.setUnEquipped();
            _loc2_++;
         }
      }
      
      private function putToBack(param1:Array) : void
      {
         var _loc3_:DisplayObjectContainer = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_].parent;
            if(_loc3_)
            {
               _loc3_.setChildIndex(param1[_loc2_],0);
            }
            _loc2_++;
         }
      }
      
      public function changeEquipmentState(param1:Array, param2:Array) : void
      {
         var _loc7_:int = 0;
         var _loc8_:InventoryItemComponent = null;
         var _loc3_:Dictionary = new Dictionary();
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc7_ = int(param2[_loc4_]);
            _loc3_[_loc7_] = _loc7_;
            _loc4_++;
         }
         var _loc5_:uint = param1.length;
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc8_ = param1[_loc6_];
            if(_loc3_[_loc8_.itemID])
            {
               _loc8_.setEquipped();
            }
            if(_loc8_)
            {
               _loc8_.setContenActivation(visible);
               this.toolTipControl.setHiddenStatus(_loc8_,visible);
            }
            _loc6_++;
         }
      }
      
      public function changeVisibleState(param1:Boolean, param2:Array) : void
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc3_:uint = param2.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param2[_loc4_];
            if(_loc5_)
            {
               _loc5_.setContenActivation(param1);
               this.toolTipControl.setHiddenStatus(_loc5_,param1);
            }
            _loc4_++;
         }
      }
      
      private function calculateItemXPosition(param1:int, param2:Number) : Number
      {
         return param1 * param2;
      }
      
      private function calculateItemYPosition(param1:Number) : Number
      {
         return this.rowTracker * param1;
      }
      
      private function redrawGridWithSortedAndNonFilteredItems() : void
      {
         this.rowTracker = 0;
         this.redrawBlockRow = 0;
         this.redrawBlockColumn = 0;
         this.startingPointFromTop = 0;
         this.startingPointFromLeft = 0;
         this.changeVisibleState(false,this.nonFilteredItems);
         this.redrawGridElements(this.sortedItems,0,true);
         this.redrawGridElements(this.nonFilteredItems,this.sortedItems.length);
      }
      
      private function redrawGridElements(param1:Array, param2:uint = 0, param3:Boolean = false) : Point
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc9_:int = 0;
         var _loc4_:uint = param1.length;
         var _loc6_:uint = param2;
         this.calcStartPoint_ICONS_DOWN();
         this.calcStartPoint_BLOCKS_ACROSS();
         var _loc7_:int = 0;
         while(_loc7_ < _loc4_)
         {
            _loc5_ = param1[_loc7_];
            if(_loc5_ != null)
            {
               _loc9_ = _loc6_ % this.ICONS_ACROSS;
               _loc6_++;
               _loc5_.x = this.calculateItemXPosition(_loc9_,_loc5_.width);
               _loc5_.x += this.startingPointFromLeft;
               _loc5_.y = this.calculateItemYPosition(_loc5_.height);
               _loc5_.y += this.startingPointFromTop;
               if(_loc9_ == this.ICONS_ACROSS - 1)
               {
                  ++this.rowTracker;
               }
               this.calcStartPoint_ICONS_DOWN();
               this.calcStartPoint_BLOCKS_ACROSS();
            }
            _loc7_++;
         }
         var _loc8_:Point = new Point(0,0);
         if(_loc5_)
         {
            _loc8_ = new Point(_loc5_.x,_loc5_.y);
         }
         return _loc8_;
      }
      
      private function calcStartPoint_ICONS_DOWN() : void
      {
         if(this.rowTracker == this.ICONS_DOWN)
         {
            this.rowTracker = 0;
            ++this.redrawBlockColumn;
            this.startingPointFromLeft = (this.ICONS_ACROSS * this.ITEM_WIDTH + GRID_HORIZONTAL_SPACING) * this.redrawBlockColumn;
         }
      }
      
      private function calcStartPoint_BLOCKS_ACROSS() : void
      {
         if(this.redrawBlockColumn == this.BLOCKS_ACROSS)
         {
            ++this.redrawBlockRow;
            this.startingPointFromTop = (this.ICONS_DOWN * this.ITEM_HEIGHT + GRID_VERTICAL_SPACING) * this.redrawBlockRow;
            this.redrawBlockColumn = 0;
            this.startingPointFromLeft = 0;
         }
      }
      
      private function reDrawGridWithFilter_TheSecondComing(param1:Array) : Point
      {
         var _loc7_:InventoryItemComponent = null;
         var _loc10_:int = 0;
         this.rowTracker = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:uint = param1.length;
         var _loc8_:int = 0;
         while(_loc8_ < _loc6_)
         {
            _loc7_ = param1[_loc8_];
            _loc10_ = _loc8_ % this.ICONS_ACROSS;
            _loc7_.x = this.calculateItemXPosition(_loc10_,_loc7_.width);
            _loc7_.x += _loc4_;
            _loc7_.y = this.calculateItemYPosition(_loc7_.height);
            _loc7_.y += _loc5_;
            if(_loc10_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            if(this.rowTracker == this.ICONS_DOWN)
            {
               this.rowTracker = 0;
               _loc2_++;
               _loc4_ = (this.ICONS_ACROSS * this.ITEM_WIDTH + GRID_HORIZONTAL_SPACING) * _loc2_;
            }
            if(_loc2_ == this.BLOCKS_ACROSS)
            {
               _loc3_++;
               _loc5_ = (this.ICONS_DOWN * this.ITEM_HEIGHT + GRID_VERTICAL_SPACING) * _loc3_;
               _loc2_ = 0;
               _loc4_ = 0;
            }
            _loc8_++;
         }
         var _loc9_:Point = new Point(0,0);
         if(_loc7_)
         {
            _loc9_ = new Point(_loc7_.x,_loc7_.y);
         }
         return _loc9_;
      }
      
      private function reDrawGridWithFilter(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         this.rowTracker = 0;
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = _loc4_ % this.ICONS_ACROSS;
            if(this.verticallyAligned)
            {
               _loc7_ = this.rowTracker * _loc5_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
               _loc8_ = _loc6_ * _loc5_.width + Math.floor(_loc6_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            }
            else
            {
               _loc7_ = _loc6_ * _loc5_.width + Math.floor(_loc6_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
               _loc8_ = this.rowTracker * _loc5_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            }
            _loc5_.x = Math.round(_loc7_);
            _loc5_.y = Math.round(_loc8_);
            _loc5_.col = _loc6_;
            _loc5_.row = this.rowTracker;
            if(_loc6_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            _loc4_++;
         }
      }
      
      public function addDragListeners(param1:Array) : void
      {
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this.dragComp.addDraggableIcon(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public function removeDragListeners(param1:Array) : void
      {
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this.dragComp.removeDraggableIcon(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      public function removeNumberOfSlots(param1:int) : void
      {
         if(this._iconsInThisMenu.length <= param1)
         {
            return;
         }
         var _loc2_:int = this._iconsInThisMenu.length - param1;
         var _loc3_:int = Math.floor(_loc2_ / ITEMS_PER_BLOCK) + 1;
         _loc2_ = _loc3_ * ITEMS_PER_BLOCK;
         if(this._iconsInThisMenu.length > _loc2_)
         {
            this.changeNumberOfSlots(_loc2_);
         }
      }
      
      public function changeNumberOfSlots(param1:int) : void
      {
         var _loc4_:* = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:int = 0;
         var _loc7_:InventoryItemComponent = null;
         var _loc2_:int = param1 - this._iconsInThisMenu.length;
         var _loc3_:String = "adding";
         if(_loc2_ < 0)
         {
            _loc2_ = Math.abs(_loc2_);
            _loc3_ = "removing";
         }
         if(_loc3_ == "adding")
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc5_ = new InventoryItemComponent();
               _loc5_.init();
               _loc5_.menuSectionComponent = this;
               _loc5_.group = ItemFilter.EMPTY_SPACE_FILTER;
               this.dragComp.addDraggableIcon(_loc5_);
               this.gridArranger.allIcons.push(_loc5_);
               addChild(_loc5_);
               _loc4_++;
            }
         }
         else if(_loc3_ == "removing")
         {
            _loc6_ = 0;
            _loc4_ = int(this._iconsInThisMenu.length - 1);
            while(_loc4_ > 0)
            {
               if(_loc6_ != _loc2_)
               {
                  _loc7_ = this._iconsInThisMenu[_loc4_];
                  DisplayObjectHelper.removeDisplayObject(_loc7_);
                  _loc7_.dispose();
                  this._iconsInThisMenu.splice(_loc4_,1);
                  _loc6_++;
               }
               _loc4_--;
            }
         }
         this.resetNextEmptySlotIndex();
         this.reDrawGrid();
      }
      
      private function resetNextEmptySlotIndex() : void
      {
         var _loc4_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         var _loc2_:uint = this._iconsInThisMenu.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._iconsInThisMenu[_loc3_];
            if(_loc4_.group == ItemFilter.EMPTY_SPACE_FILTER)
            {
               _loc1_++;
            }
            _loc3_++;
         }
         this.nextFreeSpace = this._iconsInThisMenu.length - _loc1_;
      }
      
      public function addGridToMultiSelector() : void
      {
         var _loc1_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         _loc1_.addGridComponent(this);
      }
      
      public function removeGridFromMultiSelector() : void
      {
         var _loc1_:MultiSelectionComponent = MultiSelectionComponent.getInstance();
         _loc1_.removeGridComponent(this);
      }
      
      public function reDrawGrid() : void
      {
         var _loc1_:int = 0;
         var _loc5_:InventoryItemComponent = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         this.rowTracker = 0;
         var _loc2_:uint = this.gridArranger.allIcons.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc5_ = this.gridArranger.allIcons[_loc3_];
            _loc6_ = _loc3_ % this.ICONS_ACROSS;
            if(this.verticallyAligned)
            {
               _loc7_ = this.rowTracker * _loc5_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
               _loc8_ = _loc6_ * _loc5_.width + Math.floor(_loc6_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            }
            else
            {
               _loc7_ = _loc6_ * _loc5_.width + Math.floor(_loc6_ / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
               _loc8_ = this.rowTracker * _loc5_.height + Math.floor(this.rowTracker / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            }
            _loc5_.x = _loc7_;
            _loc5_.y = _loc8_;
            _loc5_.col = _loc6_;
            _loc5_.row = this.rowTracker;
            _loc1_ = _loc5_.row * this.ICONS_ACROSS + _loc5_.col;
            this._iconsInThisMenu[_loc1_] = _loc5_;
            if(_loc6_ == this.ICONS_ACROSS - 1)
            {
               ++this.rowTracker;
            }
            _loc3_++;
         }
         this.addDragListeners(this._iconsInThisMenu);
         this.giveIconsToGridArranger(this._iconsInThisMenu);
         var _loc4_:ItemFilter = new ItemFilter();
         this.emptyItems = _loc4_.filterBySpecificGroup(ItemFilter.EMPTY_SPACE_FILTER,this.gridArranger.allIcons);
         this.removeDragListeners(this.emptyItems);
      }
      
      public function populateEquipmentSide(param1:SlotSetVO) : void
      {
         var _loc3_:SlotItemVO = null;
         var _loc4_:InventoryItemComponent = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:ItemInstanceVO = null;
         var _loc2_:int = 0;
         for each(_loc3_ in param1.items)
         {
            _loc4_ = this._iconsInThisMenu[_loc2_];
            if(_loc4_ == null)
            {
               return;
            }
            _loc5_ = _loc3_.itemInstance.itemInfo.lootID.split("_");
            _loc6_ = _loc5_.pop();
            _loc7_ = _loc3_.itemInstance;
            _loc4_.group = _loc7_.itemInfo.group.name;
            _loc4_.itemID = _loc7_.ID;
            _loc4_.changeGraphic(_loc6_);
            if(!_loc7_.hasPetGearModifier())
            {
               _loc4_.setLevelText(_loc7_.getLevelValue());
            }
            else
            {
               _loc4_.setLevelTextWithModifier(_loc7_.getLevelValue());
            }
            _loc4_.setModuleHitpointState(_loc7_.getHitPointsInPercent());
            _loc4_.updateSetBonus(_loc7_.setBonus,_loc7_.setBonusActive,_loc7_.setBonusAmt);
            this.createTooltip(_loc4_);
            _loc2_++;
         }
         this.nextFreeSpace = _loc2_;
      }
      
      public function placeDroppedItemFromInventory(param1:InventoryItemComponent) : void
      {
         if(this.nextFreeSpace >= this.iconsInThisMenu.length)
         {
            return;
         }
         var _loc2_:InventoryItemComponent = this.iconsInThisMenu[this.nextFreeSpace];
         _loc2_.group = param1.group;
         _loc2_.itemID = param1.itemID;
         _loc2_.changeGraphic(param1.itemName);
         if(!param1.hasXModifier())
         {
            _loc2_.setLevelText(param1.getLevel());
         }
         else
         {
            _loc2_.setLevelTextWithModifier(param1.getLevel());
         }
         if(param1.setBonus)
         {
            _loc2_.updateSetBonus(param1.setBonus,param1.setBonusActive,param1.setBonusAmt);
         }
         else
         {
            this.toolTipControl.copyToolTipTo(param1,_loc2_);
         }
         ++this.nextFreeSpace;
      }
      
      public function clearEquippedItemIDsToRemove() : void
      {
         this.lastHangarWideEquippedItemIDsToRemove = [];
      }
      
      public function placeDroppedItemFromEquipment(param1:InventoryItemComponent, param2:Array) : void
      {
         var _loc5_:InventoryItemComponent = null;
         var _loc3_:ItemFilter = new ItemFilter();
         var _loc4_:Array = _loc3_.filterByArrayOfSpecificGroups(param2,this._iconsInThisMenu,true);
         var _loc6_:int = 0;
         while(_loc6_ < _loc4_.length)
         {
            _loc5_ = _loc4_[_loc6_];
            if(_loc5_.itemID == param1.itemID)
            {
               if(_loc5_.equippedInConfigs[Settings.activeConfig] == true)
               {
                  _loc5_.equippedInConfigs[Settings.activeConfig] = false;
                  _loc5_.checkEquippedStatus();
                  if(_loc5_.setBonus)
                  {
                     _loc5_.setBonusActive = false;
                     this.createTooltip(param1);
                  }
                  break;
               }
            }
            _loc6_++;
         }
      }
      
      public function placeSingleItem(param1:ItemInstanceVO, param2:int = -1) : void
      {
         var _loc8_:String = null;
         var _loc3_:InventoryItemComponent = param2 >= 0 ? this._iconsInThisMenu[param2] : this._iconsInThisMenu[param1.slot];
         if(!_loc3_)
         {
            return;
         }
         _loc3_.itemID = param1.ID;
         _loc3_.group = param1.itemInfo.group.name;
         _loc3_.sellable = param1.itemInfo.sellable;
         _loc3_.setModuleHitpointState(param1.getHitPointsInPercent());
         if(param1.hasPetGearModifier())
         {
            _loc3_.setLevelTextWithModifier(param1.getLevelValue());
         }
         else
         {
            _loc3_.setLevelText(param1.getLevelValue());
         }
         _loc3_.setModuleInstalledState(param1.moduleInstalled);
         if(param1.isShipUpgrade() && this.hangarManager != null)
         {
            _loc8_ = this.hangarManager.getCurrentHangarSlotVO().getShip().lootID;
            _loc3_.setUnstableModuleRestriction(param1.canShipEquipThisShipUpgrade(_loc8_));
         }
         var _loc4_:uint = param1.equippedInConfigs.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            if(param1.equippedInConfigs[_loc5_] != null)
            {
               _loc3_.equippedInConfigs[_loc5_] = true;
               _loc3_.checkEquippedStatus();
            }
            _loc5_++;
         }
         var _loc6_:Array = param1.itemInfo.lootID.split("_");
         var _loc7_:String = _loc6_.pop();
         if(Boolean(_loc7_.indexOf(DataInterchange.WORDPUZZLE_ID) != -1 && param1 != null) && Boolean(param1.wordpuzzleName) && StringUtil.beginsWith(param1.wordpuzzleName,DataInterchange.WORDPUZZLE_NAME_PREFIX))
         {
            _loc7_ = param1.wordpuzzleValue.toLowerCase();
            _loc3_.lootID = DataInterchange.WORDPUZZLE_ID;
         }
         _loc3_.changeGraphic(_loc7_);
         _loc3_.setQuantityValue(param1.quantity);
         _loc3_.updateSetBonus(param1.setBonus,param1.setBonusActive,param1.setBonusAmt);
         this.createTooltip(_loc3_);
      }
      
      private function createTooltip(param1:InventoryItemComponent) : void
      {
         if(param1.getItemInstanceData() == null)
         {
            return;
         }
         var _loc2_:ITooltipPreparer = TooltipPreparerFactory.create(param1);
         var _loc3_:String = _loc2_.getTooltipText();
         this.toolTipControl.removeToolTip(param1);
         this.toolTipControl.addToolTip(param1,_loc3_,param1.setBonus,param1.quantity);
      }
      
      public function updateSetBonusesTooltip(param1:Boolean = false) : void
      {
         var _loc3_:InventoryItemComponent = null;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         if(this.iconsInThisMenu == null)
         {
            return;
         }
         if(param1)
         {
            for each(_loc3_ in this.iconsInThisMenu)
            {
               if(_loc3_.setBonus)
               {
                  _loc3_.hideSetBonusTooltipText = true;
                  this.createTooltip(_loc3_);
               }
            }
            return;
         }
         var _loc2_:Object = new Object();
         for each(_loc3_ in this.iconsInThisMenu)
         {
            if(_loc3_.setBonus && _loc3_.itemName != "")
            {
               _loc5_ = _loc2_[_loc3_.itemName];
               if(_loc5_ == null)
               {
                  _loc5_ = new Array();
                  _loc5_.push(_loc3_.setBonusAmt);
                  _loc5_.push(1);
                  _loc2_[_loc3_.itemName] = _loc5_;
               }
               else
               {
                  _loc5_[1] += 1;
               }
            }
         }
         for(_loc4_ in _loc2_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_ != null)
            {
               _loc6_ = _loc5_[0] <= _loc5_[1];
               for each(_loc3_ in this.iconsInThisMenu)
               {
                  if(_loc3_.itemName == _loc4_)
                  {
                     if(!_loc3_.hideSetBonusTooltipText)
                     {
                        _loc3_.setBonusActive = _loc6_;
                     }
                     _loc3_.hideSetBonusTooltipText = false;
                     this.createTooltip(_loc3_);
                  }
               }
            }
         }
      }
      
      public function returnItemToOriginalMenu(param1:InventoryItemComponent, param2:Boolean = false) : void
      {
         if(param2)
         {
            param1.group = ItemFilter.EMPTY_SPACE_FILTER;
            param1.itemID = "null";
            param1.changeGraphic("empty");
            param1.removeLevelText();
            param1.updateSetBonus(false);
            this.toolTipControl.removeToolTip(param1);
            if(this.menuName == DataInterchange.DESIGN_VISUAL)
            {
               this.toolTipControl.addToolTip(param1,BPLocale.getItem("label_dronedesign_desc_visual"));
            }
            if(this.menuName == DataInterchange.DESIGN_STATS)
            {
               this.toolTipControl.addToolTip(param1,BPLocale.getItem("label_dronedesign_desc_stats"));
            }
         }
         this.putThisItemBack(param1);
      }
      
      public function putThisItemBack(param1:InventoryItemComponent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.group == ItemFilter.EMPTY_SPACE_FILTER)
         {
         }
         if(this.verticallyAligned)
         {
            _loc2_ = param1.row * param1.height + Math.floor(param1.row / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
            _loc3_ = param1.col * param1.width + Math.floor(param1.col / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
         }
         else
         {
            _loc2_ = param1.col * param1.width + Math.floor(param1.col / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
            _loc3_ = param1.row * param1.height + Math.floor(param1.row / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
         }
         param1.x = _loc2_;
         param1.y = _loc3_;
         addChild(param1);
      }
      
      private function giveIconsToGridArranger(param1:Array) : void
      {
         if(this.gridArranger != null)
         {
            this.gridArranger.allIcons = this.iconsInThisMenu;
         }
      }
      
      public function updateStackQuantity(param1:ItemInstanceVO) : void
      {
         var _loc4_:InventoryItemComponent = null;
         var _loc2_:uint = this._iconsInThisMenu.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._iconsInThisMenu[_loc3_];
            if(_loc4_.itemID == param1.ID)
            {
               _loc4_.setQuantityValue(param1.quantity);
            }
            _loc3_++;
         }
      }
      
      public function deleteItem(param1:String) : void
      {
         var _loc4_:InventoryItemComponent = null;
         var _loc2_:uint = this._iconsInThisMenu.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._iconsInThisMenu[_loc3_].itemID == param1)
            {
               _loc4_ = this._iconsInThisMenu[_loc3_];
               _loc4_.itemID = null;
               _loc4_.quantityField.text = "";
               _loc4_.removeQuantityOverlay();
               _loc4_.group = ItemFilter.EMPTY_SPACE_FILTER;
               _loc4_.equippedInConfigs = [];
               _loc4_.checkEquippedStatus();
               _loc4_.clearModuleHitpointState();
               _loc4_.changeGraphic("empty");
               _loc4_.removeLevelText();
               this.toolTipControl.removeToolTip(_loc4_);
               this.removeDragListeners([_loc4_]);
               return;
            }
            _loc3_++;
         }
      }
      
      public function selectItem(param1:String) : void
      {
         var _loc4_:InventoryItemComponent = null;
         var _loc2_:uint = this._iconsInThisMenu.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._iconsInThisMenu[_loc3_];
            if(_loc4_.itemID != null && _loc4_.itemID == param1)
            {
               _loc4_.setSelected();
            }
            _loc3_++;
         }
      }
      
      public function unlockOneSlot() : void
      {
         var _loc2_:InventoryItemComponent = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._iconsInThisMenu.length)
         {
            _loc2_ = this._iconsInThisMenu[_loc1_];
            if(_loc2_.buyableExtraSlot)
            {
               _loc2_.group = ItemFilter.EMPTY_SPACE_FILTER;
               _loc2_.removeUnlockableSlotIcon();
               _loc2_.setDeselected();
               --this.lockedSlots;
               this.removeDragListeners([_loc2_]);
               return;
            }
            _loc1_++;
         }
      }
      
      public function createUnlockableSlots(param1:int) : void
      {
         var _loc6_:InventoryItemComponent = null;
         var _loc2_:int = 0;
         var _loc3_:Array = [];
         var _loc4_:int;
         var _loc5_:* = _loc4_ = this._iconsInThisMenu.length - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = this._iconsInThisMenu[_loc5_];
            _loc6_.addUnlockableSlotIcon();
            _loc6_.group = ItemFilter.UNLOCKABLE_ITEM;
            _loc3_.push(_loc6_);
            ++this.lockedSlots;
            if(++_loc2_ == param1)
            {
               this.addDragListeners(_loc3_);
               return;
            }
            _loc5_--;
         }
      }
      
      private function setToOriginalCoordinates(param1:InventoryItemComponent, param2:Number, param3:Number) : void
      {
         param1.x = param2 * param1.width + Math.floor(param2 / GRID_HORIZONTAL_SPACING) * this.GAP_AMOUNT + this.startXPos;
         param1.y = param3 * param1.height + Math.floor(param3 / GRID_VERTICAL_SPACING) * this.GAP_AMOUNT + this.startYPos;
      }
      
      public function getStartingYPosition() : Number
      {
         return this.startYPos;
      }
      
      public function getGridRearranger() : GridRearrangeComponent
      {
         return this.gridArranger;
      }
      
      public function getParent() : Object
      {
         return this.parent;
      }
      
      public function getY() : Number
      {
         return this.y;
      }
      
      public function getX() : Number
      {
         return this.x;
      }
      
      public function addThisChild(param1:InventoryItemComponent) : void
      {
         this.addChild(param1);
      }
      
      public function getFilterState() : String
      {
         return this.currentFilter;
      }
      
      public function getObjectType() : String
      {
         return OBJECT_NAME;
      }
      
      public function getContainingViewID() : String
      {
         return this.sectionName;
      }
      
      public function getSlotSetName() : String
      {
         return this.slotSetName;
      }
      
      public function containsIconInThisMenu(param1:String) : Boolean
      {
         var _loc2_:uint = this._iconsInThisMenu.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            if(this._iconsInThisMenu[_loc3_].itemID == param1)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function injectHangarManager(param1:HangarManagerProxy) : void
      {
         this.hangarManager = param1;
      }
      
      public function set dragGroupID(param1:int) : void
      {
         this._dragGroupID = param1;
      }
      
      public function get dragGroupID() : int
      {
         return this._dragGroupID;
      }
      
      public function dispose() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Function = null;
         FocusManager.getInstance().remove(this);
         MultiSelectionComponent.getInstance().removeGridComponent(this);
         this.disposeAllIcons();
         mask = null;
         this.gridArranger.allIcons = null;
         for(_loc1_ in this._eventListenerTracking)
         {
            _loc2_ = _loc1_ as Function;
            if(Boolean(_loc2_))
            {
               this.removeEventListener(this._eventListenerTracking[_loc2_],_loc2_);
               delete this._eventListenerTracking[_loc2_];
            }
         }
         DisplayObjectHelper.removeDisplayObject(this);
      }
      
      private function disposeAllIcons(param1:Boolean = false) : void
      {
         var _loc2_:InventoryItemComponent = null;
         while(this._iconsInThisMenu.length > 0)
         {
            _loc2_ = this._iconsInThisMenu.pop();
            _loc2_.dispose();
            DisplayObjectHelper.removeDisplayObject(_loc2_);
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         this._eventListenerTracking[param2] = param1;
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         delete this._eventListenerTracking[param2];
      }
      
      public function get iconsInThisMenu() : Array
      {
         return this._iconsInThisMenu;
      }
   }
}

