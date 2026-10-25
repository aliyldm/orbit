package net.bigpoint.darkorbit.fui.components.list.itemlist
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.ICollection;
   import net.bigpoint.darkorbit.fui.components.core.layout.ILayout;
   import net.bigpoint.darkorbit.fui.components.list.IItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.list.IList;
   import net.bigpoint.darkorbit.fui.components.list.layouts.AbstractItemListLayout;
   import net.bigpoint.darkorbit.fui.components.list.layouts.HorizontalItemListLayout;
   import net.bigpoint.darkorbit.fui.components.list.layouts.VerticalItemListLayout;
   import net.bigpoint.darkorbit.fui.components.scroll.IScrollContainer;
   import net.bigpoint.darkorbit.fui.components.scroll.ScrollEvent;
   import net.bigpoint.darkorbit.fui.system.utils.displayobject.DisplayObjectPool;
   import net.bigpoint.darkorbit.fui.system.utils.selector.IMultiSelector;
   
   public class ItemList extends Container implements IList, IScrollContainer
   {
      
      protected static const ITEM_CONTAINER:String = "itemsContainer";
      
      public static const UNSELECTED_INDEX:int = -1;
      
      private static var _multiSelectGroupIDtoInstances:Array = [];
      
      protected var _itemList:ICollection;
      
      protected var _itemsLayout:AbstractItemListLayout;
      
      protected var _itemRendererTemplate:XML = DefaultItemDataAssigner.DEFAULT_ITEMRENDERER_TEMPLATE;
      
      private var _itemDataAssigner:Class = DefaultItemDataAssigner;
      
      protected var _itemsContainer:Container;
      
      protected var _objectPool:DisplayObjectPool;
      
      protected var _scrollPosition:Number = 0;
      
      protected var _scrollMouseSpeed:Number = 50;
      
      protected var isControlKeyDown:Boolean = false;
      
      protected var isShiftKeyDown:Boolean = false;
      
      protected var _selectedItemIDs:Dictionary = new Dictionary();
      
      protected var _lastSelectedItem:IItemDataAssigner;
      
      protected var _lastSelectedItemIndex:int = -1;
      
      protected var _multiSelectable:Boolean = false;
      
      protected var _multiSelectGroupId:String;
      
      protected var _previousSelectedItemsLength:int = -1;
      
      protected var _previousSelectedItemsChecksum:int = -1;
      
      protected var _currentSelectedItemsChecksum:int = -1;
      
      protected var _startDragItem:IItemDataAssigner;
      
      protected var _allowDeselection:Boolean;
      
      protected var __mouseUpDownEventsOnSameTarget__active:Boolean;
      
      public function ItemList()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         _alignment = new ItemListAlignment(this);
         this._objectPool = new DisplayObjectPool();
         this._itemsContainer = new Container();
         this._itemsContainer.name = ITEM_CONTAINER;
         this.addChild(this._itemsContainer);
         _minWidth = 40;
         _minHeight = 40;
         this.initializeItemsLayout();
      }
      
      override protected function addEventListeners() : void
      {
         super.addEventListeners();
         addEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelEvent);
         addEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverEvent);
         addEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutEvent);
         addEventListener(MouseEvent.ROLL_OUT,this.handleMouseOutEvent);
         addEventListener("releaseOutside",this.handleMouseOutEvent);
         addEventListener(Event.REMOVED_FROM_STAGE,this.handleRemovedFromStage);
         if(stage)
         {
            stage.addEventListener(Event.MOUSE_LEAVE,this.handleMouseOutEvent);
         }
      }
      
      private function handleRemovedFromStage(param1:Event) : void
      {
         this.removeKeyboardListeners();
      }
      
      override protected function removeEventListeners() : void
      {
         super.removeEventListeners();
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleMouseWheelEvent);
         removeEventListener(MouseEvent.MOUSE_OVER,this.handleMouseOverEvent);
         removeEventListener(MouseEvent.MOUSE_OUT,this.handleMouseOutEvent);
         removeEventListener(MouseEvent.ROLL_OUT,this.handleMouseOutEvent);
         removeEventListener("releaseOutside",this.handleMouseOutEvent);
         if(stage)
         {
            stage.removeEventListener(Event.MOUSE_LEAVE,this.handleMouseOutEvent);
         }
      }
      
      protected function initializeItemsLayout() : void
      {
         this._itemsLayout = new VerticalItemListLayout(this,this._itemsContainer);
      }
      
      override protected function draw() : void
      {
         super.draw();
         if(isInvalidate(InvalidationType.FILLITEMS) && this._itemList != null)
         {
            this.fillItems();
         }
      }
      
      override protected function drawSize() : void
      {
         super.drawSize();
         var _loc1_:Number = getCalculatedWidth();
         var _loc2_:Number = this.getCalculatedHeight();
         this._itemsContainer.setSize(_loc1_,_loc2_);
         invalidate(InvalidationType.LAYOUT);
      }
      
      override protected function drawLayout() : void
      {
         if(this._itemList == null)
         {
            return;
         }
         this.drawItems();
         validate(InvalidationType.LAYOUT);
         validate(InvalidationType.FILLITEMS);
         this.calculateViewToContentSizeRatio();
      }
      
      protected function calculateViewToContentSizeRatio() : void
      {
         var _loc1_:ScrollEvent = new ScrollEvent(ScrollEvent.SCROLLCONTAINER_VERTICAL_SIZE_CHANGED);
         _loc1_.contentSize = this._itemsLayout.sigmaItemSize * this._itemList.length;
         _loc1_.viewSize = this._itemsLayout is HorizontalItemListLayout ? this.getCalculatedWidth() : this.getCalculatedHeight();
         dispatchEvent(_loc1_);
      }
      
      protected function drawItems() : void
      {
         this.createItems();
         this.fillItems();
         this._itemsLayout.execute();
      }
      
      override public function dispose() : void
      {
         this._objectPool.dispose();
         this._itemsLayout.dispose();
         this.removeAllVisibleItems();
         super.dispose();
         this._itemList = null;
      }
      
      public function clearList() : void
      {
         this.removeAllVisibleItems();
         this._itemList = null;
      }
      
      protected function createItems() : void
      {
         var _loc3_:Coreponent = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         var _loc1_:uint = uint(this._itemsLayout.getVisibleItemsCount());
         var _loc2_:int = _loc1_ - this._itemsContainer.numChildren;
         if(_loc2_ > 0)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = this.getPoolItem();
               this._itemsContainer.addChild(_loc3_);
               _loc4_++;
            }
         }
         else
         {
            _loc5_ = Math.abs(_loc2_);
            _loc6_ = 0;
            while(_loc6_ < _loc5_)
            {
               this.removePoolItem();
               _loc6_++;
            }
            this._itemsContainer.forceRedraw(InvalidationType.LAYOUT);
         }
      }
      
      public function allItemsDisplayed() : Boolean
      {
         if(!this._itemsContainer || !this._itemList)
         {
            return false;
         }
         return (this.layout is VerticalItemListLayout ? this._itemsContainer.height : this._itemsContainer.width) >= this._itemsLayout.sigmaItemSize * this._itemList.length;
      }
      
      public function getScrollOneItemAmount() : Number
      {
         if(this._itemList == null || this._itemsLayout == null)
         {
            return 0;
         }
         return 1 / (this._itemList.length - this._itemsLayout.pageSize);
      }
      
      public function getScrollOnePageAmount() : Number
      {
         if(this._itemList == null || this._itemsLayout == null)
         {
            return 0;
         }
         return this._itemsLayout.pageSize / (this._itemList.length - this._itemsLayout.pageSize);
      }
      
      protected function getPoolItem() : Coreponent
      {
         var _loc1_:Coreponent = null;
         if(this._objectPool.isEmpty())
         {
            _loc1_ = this.createItemAndPutIntoPool();
         }
         _loc1_ = this._objectPool.getObject() as Coreponent;
         _loc1_.invalidate(InvalidationType.SIZE);
         _loc1_.invalidate(InvalidationType.POSITION);
         this.addItemEventListeners(_loc1_);
         return _loc1_;
      }
      
      protected function createItemAndPutIntoPool() : Coreponent
      {
         var _loc1_:Coreponent = null;
         var _loc2_:DisplayObjectContainer = null;
         if(this._itemRendererTemplate)
         {
            _loc1_ = new this._itemDataAssigner() as Coreponent;
            _loc2_ = _loc1_ as DisplayObjectContainer;
            UISystem.getInstance().build(this._itemRendererTemplate,_loc2_,true);
            this._objectPool.putObject(_loc1_);
            return _loc1_;
         }
         return null;
      }
      
      public function get itemHeight() : Number
      {
         var _loc1_:DisplayObject = this._objectPool.getObject() || this.createItemAndPutIntoPool();
         var _loc2_:Number = _loc1_.height;
         var _loc3_:Coreponent = _loc1_ as Coreponent;
         if(_loc3_)
         {
            _loc2_ = _loc2_ + _loc3_.marginTop + _loc3_.marginBottom;
         }
         this._objectPool.putObject(_loc1_);
         return _loc2_;
      }
      
      public function get itemWidth() : Number
      {
         var _loc1_:DisplayObject = this._objectPool.getObject() || this.createItemAndPutIntoPool();
         var _loc2_:Number = _loc1_.width;
         this._objectPool.putObject(_loc1_);
         return _loc2_;
      }
      
      protected function removePoolItem() : void
      {
         var _loc1_:DisplayObject = this._itemsContainer.removeChildAt(0);
         var _loc2_:IItemDataAssigner = _loc1_ as IItemDataAssigner;
         if(_loc2_ != null)
         {
            _loc2_.data = null;
         }
         this.removeItemEventListeners(_loc1_);
         this._objectPool.putObject(_loc1_);
      }
      
      protected function getOffset() : uint
      {
         var _loc1_:int = int(this._itemList.length);
         if(this._itemsLayout.isDisposed())
         {
            this._itemsLayout.itemListComponent = this;
            this._itemsLayout.itemsContainer = this._itemsContainer;
         }
         var _loc2_:Number = this._itemsLayout.pageSize;
         var _loc3_:Number = _loc1_ - _loc2_;
         var _loc4_:Number = Math.max(0,_loc3_);
         return this.calcScrollOffset(_loc4_);
      }
      
      protected function fillItems() : void
      {
         var _loc1_:IItemDataAssigner = null;
         var _loc6_:uint = 0;
         var _loc2_:uint = uint(this._itemsContainer.numChildren);
         var _loc3_:int = int(this._itemList.length);
         var _loc4_:int = int(this.getOffset());
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            _loc1_ = this._itemsContainer.getChildAt(_loc5_) as IItemDataAssigner;
            _loc6_ = _loc4_ + _loc5_;
            _loc1_.clearIndex();
            if(_loc6_ < _loc3_)
            {
               _loc1_.data = this._itemList.getItemAt(_loc6_);
               _loc1_.index = _loc6_;
            }
            else
            {
               _loc1_.data = null;
               _loc1_.index = -1;
            }
            if(_loc1_.isIndexValid())
            {
               if(this._selectedItemIDs[_loc1_.index])
               {
                  _loc1_.select();
               }
               else
               {
                  _loc1_.deselect();
               }
            }
            else
            {
               _loc1_.deselect();
            }
            _loc5_++;
         }
      }
      
      protected function calcScrollOffset(param1:Number) : uint
      {
         return Math.round(param1 * this._scrollPosition);
      }
      
      protected function removeAllVisibleItems() : void
      {
         while(this._itemsContainer.numChildren > 0)
         {
            this.removeItem();
         }
      }
      
      protected function removeItem() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:IItemDataAssigner = null;
         _loc1_ = this._itemsContainer.getChildAt(0) as Sprite;
         this.removeItemEventListeners(_loc1_);
         _loc2_ = _loc1_ as IItemDataAssigner;
         _loc2_.dispose();
      }
      
      protected function addItemEventListeners(param1:DisplayObject) : void
      {
         param1.addEventListener(MouseEvent.CLICK,this.handleItemClickEvent);
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.handleItemMouseOver);
         param1.addEventListener(MouseEvent.MOUSE_OUT,this.handleItemMouseOut);
         param1.addEventListener(MouseEvent.MOUSE_DOWN,this.handleItemMouseDown);
         param1.addEventListener(MouseEvent.MOUSE_UP,this.handleItemMouseUp);
      }
      
      protected function removeItemEventListeners(param1:DisplayObject) : void
      {
         param1.removeEventListener(MouseEvent.CLICK,this.handleItemClickEvent);
         param1.removeEventListener(MouseEvent.MOUSE_OVER,this.handleItemMouseOver);
         param1.removeEventListener(MouseEvent.MOUSE_OUT,this.handleItemMouseOut);
         param1.removeEventListener(MouseEvent.MOUSE_DOWN,this.handleItemMouseDown);
         param1.removeEventListener(MouseEvent.MOUSE_UP,this.handleItemMouseUp);
      }
      
      protected function addKeyboardListeners() : void
      {
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
      }
      
      protected function removeKeyboardListeners() : void
      {
         if(stage)
         {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown);
            stage.removeEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp);
         }
      }
      
      protected function handleKeyDown(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.CONTROL:
               this.isControlKeyDown = true;
               break;
            case Keyboard.SHIFT:
               this.isShiftKeyDown = true;
         }
      }
      
      protected function handleKeyUp(param1:KeyboardEvent) : void
      {
         switch(param1.keyCode)
         {
            case Keyboard.HOME:
               this.setScrollPositionInPercent(0);
               break;
            case Keyboard.END:
               this.setScrollPositionInPercent(1);
         }
         this.isControlKeyDown = false;
         this.isShiftKeyDown = false;
      }
      
      protected function handleMouseOverEvent(param1:Event) : void
      {
         this.addKeyboardListeners();
      }
      
      protected function handleMouseOutEvent(param1:Event) : void
      {
         this.removeKeyboardListeners();
         this.isControlKeyDown = false;
         this.isShiftKeyDown = false;
      }
      
      protected function handleMouseWheelEvent(param1:MouseEvent) : void
      {
      }
      
      protected function handleItemMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:IMultiSelector = UISystem.getInstance().multiSelector;
         if(Boolean(_loc2_) && _loc2_.isSelecting())
         {
            return;
         }
         var _loc3_:IItemDataAssigner = param1.currentTarget as IItemDataAssigner;
         var _loc4_:ItemListEvent = new ItemListEvent(ItemListEvent.MOUSE_OVER);
         _loc4_.item = _loc3_;
         dispatchEvent(_loc4_);
      }
      
      protected function handleItemMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:IMultiSelector = UISystem.getInstance().multiSelector;
         if(Boolean(_loc2_) && _loc2_.isSelecting())
         {
            return;
         }
         var _loc3_:IItemDataAssigner = param1.currentTarget as IItemDataAssigner;
         var _loc4_:ItemListEvent = new ItemListEvent(ItemListEvent.MOUSE_OUT);
         _loc4_.item = _loc3_;
         dispatchEvent(_loc4_);
      }
      
      protected function handleItemClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:IItemDataAssigner = param1.currentTarget as IItemDataAssigner;
         var _loc3_:ItemListEvent = new ItemListEvent(ItemListEvent.CLICKED);
         _loc3_.item = _loc2_;
         dispatchEvent(_loc3_);
      }
      
      protected function handleItemMouseDown(param1:MouseEvent) : void
      {
         var _loc3_:IMultiSelector = null;
         this.__mouseUpDownEventsOnSameTarget__active = true;
         var _loc2_:IItemDataAssigner = param1.currentTarget as IItemDataAssigner;
         if(_isDraggable)
         {
            this._selectItem_(_loc2_);
            this._startDrag_(_loc2_);
            _loc3_ = UISystem.getInstance().multiSelector;
            if(_loc3_)
            {
               _loc3_.stop();
            }
         }
      }
      
      protected function handleItemMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:IMultiSelector = null;
         var _loc3_:IItemDataAssigner = null;
         if(_isDraggable)
         {
            this._stopDrag_();
            _loc2_ = UISystem.getInstance().multiSelector;
            if(_loc2_)
            {
               _loc2_.start();
            }
         }
         else if(this.__mouseUpDownEventsOnSameTarget__active)
         {
            _loc3_ = param1.currentTarget as IItemDataAssigner;
            this._selectItem_(_loc3_);
         }
         this.__mouseUpDownEventsOnSameTarget__active = false;
      }
      
      protected function filterNoneDraggables(param1:Vector.<ICoreponent>) : Vector.<ICoreponent>
      {
         var _loc5_:ICoreponent = null;
         var _loc2_:Vector.<ICoreponent> = new Vector.<ICoreponent>();
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(!((Boolean(_loc5_)) && !_loc5_.isDraggable()))
            {
               _loc2_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      protected function _startDrag_(param1:IItemDataAssigner) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(!isDraggable() || !param1.isDraggable())
         {
            return;
         }
         var _loc2_:Vector.<ICoreponent> = Vector.<ICoreponent>(this.getAllSelectedAndVisibleItems());
         _loc2_ = this.filterNoneDraggables(_loc2_);
         if(_loc2_.length >= 1)
         {
            _loc3_ = param1 as DisplayObject;
            _loc4_ = -_loc3_.mouseX + 1;
            _loc5_ = -_loc3_.mouseY + 1;
            UISystem.getInstance().dragNDropManager.dragStart(_loc2_,_loc4_,_loc5_,this);
         }
         this._startDragItem = param1;
         this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEventToCheckDragStartAbortCondition);
      }
      
      protected function _stopDrag_() : void
      {
         if(!isDraggable())
         {
            return;
         }
         if(this.stage)
         {
            this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleMouseMoveEventToCheckDragStartAbortCondition);
         }
         UISystem.getInstance().dragNDropManager.stopStartDragTimer();
      }
      
      protected function handleMouseMoveEventToCheckDragStartAbortCondition(param1:MouseEvent) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this._startDragItem)
         {
            _loc2_ = Number(this._startDragItem.globalPosition.x);
            _loc3_ = Number(this._startDragItem.globalPosition.y);
            _loc4_ = _loc2_ + this._startDragItem.width;
            _loc5_ = _loc3_ + this._startDragItem.height;
            if(param1.stageX >= _loc2_ && param1.stageX <= _loc4_)
            {
               return;
            }
            if(param1.stageY >= _loc3_ && param1.stageY <= _loc5_)
            {
               return;
            }
            this._stopDrag_();
            this._startDragItem = null;
         }
      }
      
      protected function _selectItem_(param1:IItemDataAssigner) : void
      {
         if(param1.data == null)
         {
            return;
         }
         if(!this._multiSelectable)
         {
            this.selectItem(param1);
         }
         else if(this.isControlKeyDown)
         {
            this._selectItem__CTRLKEY(param1);
         }
         else if(this.isShiftKeyDown)
         {
            this._selectItem__SHIFTKEY(param1);
         }
         else if(!param1.isSelected())
         {
            this.selectItem(param1);
         }
         this.dispatchItemsSelectionEvent();
      }
      
      protected function _selectItem__CTRLKEY(param1:IItemDataAssigner) : void
      {
         this.switchSelection(param1);
      }
      
      protected function _selectItem__SHIFTKEY(param1:IItemDataAssigner) : void
      {
         this.setSelectionToSelectItem(param1);
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc3_:IItemDataAssigner = null;
         var _loc2_:Number = this._itemList ? this._itemList.length : 0;
         if(param1 >= 0 && param1 < _loc2_)
         {
            if(this._itemsContainer.numChildren > param1)
            {
               _loc3_ = this._itemsContainer.getChildAt(param1) as IItemDataAssigner;
            }
            if(_loc3_ != null && _loc3_.data == this._itemList.getItemAt(param1))
            {
               this.selectItem(_loc3_);
            }
            else
            {
               this.setSelectionIndices(param1,param1);
            }
         }
      }
      
      public function isOnlyOneItemSelected() : Boolean
      {
         var _loc2_:Object = null;
         var _loc1_:uint = 0;
         for each(_loc2_ in this._selectedItemIDs)
         {
            _loc1_++;
            if(_loc1_ > 1)
            {
               return false;
            }
         }
         if(_loc1_ == 1)
         {
            return true;
         }
         return false;
      }
      
      public function isItemSelected(param1:IItemDataAssigner) : Boolean
      {
         return this._selectedItemIDs[param1.index] == null ? false : true;
      }
      
      protected function setSelectionToSelectItem(param1:IItemDataAssigner) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:uint = uint(this._lastSelectedItemIndex);
         this.markItemSelection(param1,true);
         var _loc3_:uint = uint(param1.index);
         this.setSelectionIndices(_loc2_,_loc3_);
      }
      
      protected function setSelectionIndices(param1:uint, param2:uint) : void
      {
         var _loc7_:Boolean = false;
         var _loc3_:uint = Math.min(param1,param2);
         var _loc4_:uint = Math.max(param1,param2);
         var _loc5_:uint = _loc4_ - _loc3_;
         var _loc6_:uint = _loc3_ + _loc5_;
         if(_loc3_ != this._lastSelectedItemIndex)
         {
            this._lastSelectedItemIndex = _loc3_;
            _loc7_ = true;
         }
         this._clearSelectedInternalItemList();
         var _loc8_:int = int(_loc3_);
         while(_loc8_ <= _loc6_)
         {
            this._selectedItemIDs[_loc8_] = {};
            _loc8_++;
         }
         this.fillItems();
         if(_loc7_)
         {
            this.dispatchItemsSelectionEvent();
         }
      }
      
      protected function switchSelection(param1:IItemDataAssigner) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(this.isItemSelected(param1))
         {
            this.markItemSelection(param1,false);
         }
         else
         {
            this.markItemSelection(param1,true);
         }
      }
      
      protected function markItemSelection(param1:IItemDataAssigner, param2:Boolean) : void
      {
         if(param2)
         {
            param1.select();
            this._selectedItemIDs[param1.index] = param1;
            this._lastSelectedItem = param1;
            this._lastSelectedItemIndex = param1.index;
         }
         else
         {
            param1.deselect();
            this._selectedItemIDs[param1.index] = null;
            delete this._selectedItemIDs[param1.index];
         }
      }
      
      public function selectItem(param1:IItemDataAssigner) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Boolean = this.isItemSelected(param1);
         if(_loc2_ && this.isOnlyOneItemSelected())
         {
            if(this._allowDeselection)
            {
               this.markItemSelection(param1,false);
               this.dispatchItemSelectionEvent(param1);
            }
            return;
         }
         this._clearSelectedInternalItemList();
         this.deselectAllVisibleItems();
         this.markItemSelection(param1,true);
         this.scrollToSelection();
         this.dispatchItemSelectionEvent(param1);
      }
      
      public function clearSelection() : void
      {
         this.deselectAll();
      }
      
      public function deselectAll() : void
      {
         this._clearSelectedInternalItemList();
         this.deselectAllVisibleItems();
      }
      
      protected function deselectAllVisibleItems() : void
      {
         var _loc2_:IItemDataAssigner = null;
         var _loc1_:uint = uint(this._itemsContainer.numChildren);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this._itemsContainer.getChildAt(_loc3_) as IItemDataAssigner;
            _loc2_.unselect();
            _loc3_++;
         }
         this._lastSelectedItemIndex = UNSELECTED_INDEX;
         this._lastSelectedItem = null;
      }
      
      protected function getAllSelectedAndVisibleItems(param1:Boolean = false) : Vector.<IItemDataAssigner>
      {
         var _loc4_:IItemDataAssigner = null;
         var _loc6_:Vector.<ItemList> = null;
         var _loc7_:Vector.<IItemDataAssigner> = null;
         var _loc8_:ItemList = null;
         var _loc2_:Vector.<IItemDataAssigner> = new Vector.<IItemDataAssigner>();
         var _loc3_:uint = uint(this._itemsContainer.numChildren);
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = this._itemsContainer.getChildAt(_loc5_) as IItemDataAssigner;
            if(_loc4_.isSelected())
            {
               _loc2_.push(_loc4_);
            }
            _loc5_++;
         }
         if(Boolean(this._multiSelectGroupId) && !param1)
         {
            _loc6_ = _multiSelectGroupIDtoInstances[this._multiSelectGroupId];
            if(_loc6_)
            {
               for each(_loc8_ in _loc6_)
               {
                  if(_loc8_.ID != this.ID)
                  {
                     _loc7_ = _loc8_.getAllSelectedAndVisibleItems(true);
                     if((Boolean(_loc7_)) && _loc7_.length > 0)
                     {
                        _loc2_ = _loc2_.concat(_loc7_);
                     }
                  }
               }
            }
         }
         return _loc2_;
      }
      
      protected function getAllVisibleItems() : Vector.<IItemDataAssigner>
      {
         var _loc1_:Vector.<IItemDataAssigner> = new Vector.<IItemDataAssigner>();
         var _loc2_:uint = uint(this._itemsContainer.numChildren);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_.push(this._itemsContainer.getChildAt(_loc3_) as IItemDataAssigner);
            _loc3_++;
         }
         return _loc1_;
      }
      
      protected function dispatchItemSelectionEvent(param1:IItemDataAssigner) : void
      {
         var _loc2_:ItemListEvent = new ItemListEvent(ItemListEvent.ITEM_SELECTION_CHANGED);
         _loc2_.item = param1;
         dispatchEvent(_loc2_);
      }
      
      protected function dispatchItemsSelectionEvent() : void
      {
         var _loc1_:Vector.<Object> = this.getSelectedItemsData();
         var _loc2_:ItemListEvent = new ItemListEvent(ItemListEvent.ITEMS_SELECTION_CHANGED);
         _loc2_.selectedItemsData = _loc1_;
         dispatchEvent(_loc2_);
      }
      
      protected function compareSelectedItemChecksum(param1:Vector.<Object>) : Boolean
      {
         var _loc2_:Boolean = false;
         if(this._previousSelectedItemsChecksum != this._currentSelectedItemsChecksum)
         {
            this._previousSelectedItemsChecksum = this._currentSelectedItemsChecksum;
            _loc2_ = true;
         }
         return _loc2_;
      }
      
      public function get selectedIndex() : int
      {
         return this._lastSelectedItemIndex;
      }
      
      public function get selectedItem() : IItemDataAssigner
      {
         return this._lastSelectedItem;
      }
      
      public function get selectedItems() : Vector.<IItemDataAssigner>
      {
         var _loc2_:IItemDataAssigner = null;
         var _loc1_:Vector.<IItemDataAssigner> = new Vector.<IItemDataAssigner>();
         if(this._selectedItemIDs)
         {
            for each(_loc2_ in this._selectedItemIDs)
            {
               _loc1_.push(_loc2_);
            }
         }
         return _loc1_;
      }
      
      public function getSelectedItemsData() : Vector.<Object>
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:Object = null;
         this._currentSelectedItemsChecksum = 0;
         var _loc1_:Vector.<Object> = new Vector.<Object>();
         for(_loc2_ in this._selectedItemIDs)
         {
            _loc3_ = uint(_loc2_);
            _loc4_ = this._itemList.getItemAt(_loc3_);
            this._currentSelectedItemsChecksum += _loc3_;
            _loc1_.push(_loc4_);
         }
         return _loc1_;
      }
      
      protected function _clearSelectedInternalItemList() : void
      {
         this._previousSelectedItemsChecksum = -1;
         this._selectedItemIDs = new Dictionary();
         this._lastSelectedItem = null;
      }
      
      public function checkMultiSelectorAreaCollisions(param1:Rectangle) : void
      {
         var _loc4_:IItemDataAssigner = null;
         var _loc2_:Vector.<IItemDataAssigner> = this.getAllVisibleItems();
         var _loc3_:uint = _loc2_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_ = _loc2_[_loc5_];
            this.checkSelectionAreaCollision(param1,_loc4_);
            _loc5_++;
         }
      }
      
      public function finishMultiSelectorAreaCollisions() : void
      {
         var _loc3_:IItemDataAssigner = null;
         var _loc1_:Vector.<IItemDataAssigner> = this.getAllSelectedAndVisibleItems();
         var _loc2_:uint = _loc1_.length;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = _loc1_[_loc4_];
            if(_loc3_.isSelected())
            {
               this.markItemSelection(_loc3_,true);
            }
            _loc4_++;
         }
         this.dispatchItemsSelectionEvent();
      }
      
      protected function checkSelectionAreaCollision(param1:Rectangle, param2:IItemDataAssigner) : void
      {
         var _loc3_:Number = Number(param2.globalPosition.x);
         var _loc4_:Number = Number(param2.globalPosition.y);
         var _loc5_:Number = Number(param2.width);
         var _loc6_:Number = Number(param2.height);
         var _loc7_:Rectangle = new Rectangle(_loc3_,_loc4_,_loc5_,_loc6_);
         if(param1.intersects(_loc7_))
         {
            if(param2.data != null)
            {
               param2.select();
            }
            else
            {
               param2.deselect();
            }
         }
         else
         {
            param2.deselect();
         }
      }
      
      public function scrollToSelection() : void
      {
      }
      
      public function set list(param1:ICollection) : void
      {
         if(param1 == this._itemList || param1 == null)
         {
         }
         this._clearSelectedInternalItemList();
         this._itemList = param1;
         invalidate(InvalidationType.LAYOUT);
         dispatchEvent(new ItemListEvent(ItemListEvent.SOURCE_CHANGED));
      }
      
      public function get list() : ICollection
      {
         return this._itemList;
      }
      
      public function setScrollPositionInPercent(param1:Number, param2:uint = 2) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 != this._scrollPosition)
         {
            this._scrollPosition = param1;
            forceRedraw(InvalidationType.FILLITEMS);
            dispatchEvent(new ScrollEvent(ScrollEvent.SCROLL_POSITION_CHANGED,this._scrollPosition));
         }
      }
      
      public function getScrollPositionInPercent() : Number
      {
         return this._scrollPosition;
      }
      
      public function set scrollMouseSpeed(param1:Number) : void
      {
         param1 = param1 <= 0 ? 0 : (param1 >= 1000 ? 1000 : param1);
         this._scrollMouseSpeed = param1;
      }
      
      public function get scrollMouseSpeed() : Number
      {
         return this._scrollMouseSpeed;
      }
      
      public function set itemRendererTemplate(param1:XML) : void
      {
         this._itemRendererTemplate = param1;
      }
      
      public function set itemDataAssigner(param1:Class) : void
      {
         this._itemDataAssigner = param1;
         var _loc2_:Coreponent = this.getPoolItem();
         if(_loc2_)
         {
            this._itemsLayout.assignItemSize(_loc2_);
         }
      }
      
      public function set itemGap(param1:uint) : void
      {
         this._itemsLayout.gap = param1;
         invalidate(InvalidationType.LAYOUT);
      }
      
      public function get itemGap() : uint
      {
         return this._itemsLayout.gap;
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
      }
      
      override public function setSize(param1:Number, param2:Number) : void
      {
         super.setSize(param1,param2);
      }
      
      override public function set layout(param1:ILayout) : void
      {
         var _loc2_:uint = 0;
         if(this._itemsLayout)
         {
            this._itemsLayout.dispose();
            _loc2_ = this._itemsLayout.gap;
         }
         this._itemsLayout = param1 as AbstractItemListLayout;
         this._itemsLayout.itemListComponent = this;
         this._itemsLayout.itemsContainer = this._itemsContainer;
         this._itemsLayout.gap = _loc2_;
         if(this._itemDataAssigner)
         {
            this.itemDataAssigner = this._itemDataAssigner;
         }
      }
      
      override public function getCalculatedHeight() : Number
      {
         return Number(super.getCalculatedHeight());
      }
      
      public function get itemsContainer() : Container
      {
         return this._itemsContainer;
      }
      
      override protected function maskWithSkin() : void
      {
         super.maskWithSkin();
      }
      
      override public function set mask(param1:DisplayObject) : void
      {
         super.mask = param1;
      }
      
      override public function get layout() : ILayout
      {
         return this._itemsLayout;
      }
      
      public function set multiselectable(param1:Boolean) : void
      {
         this._multiSelectable = param1;
         var _loc2_:IMultiSelector = UISystem.getInstance().multiSelector;
         if(_loc2_)
         {
            if(this._multiSelectable)
            {
               _loc2_.register(this);
            }
            else
            {
               _loc2_.unregister(this);
            }
         }
      }
      
      public function get multiselectable() : Boolean
      {
         return this._multiSelectable;
      }
      
      public function set multiSelectGroupId(param1:String) : void
      {
         var _loc3_:Vector.<ItemList> = null;
         var _loc4_:uint = 0;
         var _loc5_:ItemList = null;
         if(param1 == null)
         {
            _loc3_ = this._multiSelectGroupId[this._multiSelectGroupId];
            if(_loc3_)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_];
                  if(_loc5_.ID == this.ID)
                  {
                     _loc3_.splice(_loc4_,1);
                  }
                  _loc4_++;
               }
               if(_loc3_.length == 0)
               {
                  _multiSelectGroupIDtoInstances[this._multiSelectGroupId] = null;
                  delete _multiSelectGroupIDtoInstances[this._multiSelectGroupId];
               }
            }
         }
         this._multiSelectGroupId = param1;
         if(_multiSelectGroupIDtoInstances[this._multiSelectGroupId] == null)
         {
            _multiSelectGroupIDtoInstances[this._multiSelectGroupId] = new Vector.<ItemList>();
         }
         var _loc2_:Vector.<ItemList> = _multiSelectGroupIDtoInstances[this._multiSelectGroupId];
         _loc2_.push(this);
      }
      
      public function get multiSelectGroupId() : String
      {
         return this._multiSelectGroupId;
      }
      
      public function set allowDeselection(param1:Boolean) : void
      {
         this._allowDeselection = param1;
      }
      
      public function get visibleItemsCount() : int
      {
         return this._itemsContainer.numChildren;
      }
      
      public function get itemDataAssigner() : Class
      {
         return this._itemDataAssigner;
      }
      
      public function get selectedItemData() : Object
      {
         return this.list ? this.list.getItemAt(this.selectedIndex) : null;
      }
   }
}

