package net.bigpoint.darkorbit.fui.components.list.slideshow
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.ICollection;
   import net.bigpoint.darkorbit.fui.components.list.IItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.list.IList;
   import net.bigpoint.darkorbit.fui.components.list.slideshow.transitions.CrossFadeTransition;
   import net.bigpoint.darkorbit.fui.components.list.slideshow.transitions.IItemTransition;
   import net.bigpoint.darkorbit.fui.components.scroll.IScrollContainer;
   import net.bigpoint.darkorbit.fui.system.utils.displayobject.DisplayObjectPool;
   
   public class ItemSlideShow extends Container implements IList, IScrollContainer
   {
      
      protected static const ITEM_CONTAINER:String = "itemsContainer";
      
      private var _itemList:ICollection;
      
      private var _itemDataAssigner:Class;
      
      private var _itemRendererTemplate:XML;
      
      private var _itemsContainer:Container;
      
      private var _objectPool:DisplayObjectPool;
      
      private var _index:int;
      
      private var _currentItem:Coreponent;
      
      private var _backupItem:Coreponent;
      
      private var _transition:IItemTransition = new CrossFadeTransition();
      
      public function ItemSlideShow()
      {
         super();
      }
      
      override protected function initialize() : void
      {
         super.initialize();
         this._objectPool = new DisplayObjectPool();
         this._itemsContainer = new Container();
         this._itemsContainer.name = ITEM_CONTAINER;
         this.addChild(this._itemsContainer);
         _minWidth = 40;
         _minHeight = 40;
      }
      
      override protected function drawLayout() : void
      {
         super.drawLayout();
         if(this._itemList == null)
         {
            return;
         }
         this.drawItems();
         validate(InvalidationType.LAYOUT);
         validate(InvalidationType.FILLITEMS);
      }
      
      public function set list(param1:ICollection) : void
      {
         this._itemList = param1;
         this._index = 0;
         invalidate(InvalidationType.LAYOUT);
      }
      
      public function get list() : ICollection
      {
         return this._itemList;
      }
      
      public function setScrollPositionInPercent(param1:Number, param2:uint = 2) : void
      {
      }
      
      public function getScrollPositionInPercent() : Number
      {
         return 0;
      }
      
      public function set itemDataAssigner(param1:Class) : void
      {
         this._itemDataAssigner = param1;
      }
      
      public function set itemRendererTemplate(param1:XML) : void
      {
         this._itemRendererTemplate = param1;
      }
      
      protected function drawItems() : void
      {
         this.createItems();
         this.fillItems();
      }
      
      protected function createItems() : void
      {
         if(!this._backupItem)
         {
            this._backupItem = this.getPoolItem();
            this._itemsContainer.addChild(this._backupItem);
         }
         if(!this._currentItem)
         {
            this._currentItem = this.getPoolItem();
            this._itemsContainer.addChild(this._currentItem);
         }
      }
      
      protected function fillItems() : void
      {
         var _loc1_:IItemDataAssigner = null;
         var _loc3_:Coreponent = null;
         var _loc2_:int = int(this._itemList.length);
         if(this.index < _loc2_)
         {
            _loc1_ = this._backupItem as IItemDataAssigner;
            _loc1_.data = this._itemList.getItemAt(this.index);
            _loc1_.index = this.index;
            this._itemsContainer.swapChildren(this._currentItem,this._backupItem);
            this._transition.fromTo(this._currentItem,this._backupItem);
            _loc3_ = this._backupItem;
            this._backupItem = this._currentItem;
            this._currentItem = _loc3_;
         }
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
         return _loc1_;
      }
      
      protected function removePoolItem() : void
      {
         var _loc1_:DisplayObject = this._itemsContainer.removeChildAt(0);
         var _loc2_:IItemDataAssigner = _loc1_ as IItemDataAssigner;
         if(_loc2_ != null)
         {
            _loc2_.data = null;
         }
         this._objectPool.putObject(_loc1_);
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
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(param1:int) : void
      {
         var _loc2_:uint = this._itemList ? this._itemList.length : 0;
         if(param1 < 0)
         {
            param1 = _loc2_ - 1;
         }
         var _loc3_:int = param1 % _loc2_;
         if(this._index != _loc3_)
         {
            this._index = _loc3_;
            invalidate(InvalidationType.LAYOUT);
         }
      }
   }
}

