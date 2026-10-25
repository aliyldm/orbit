package net.bigpoint.darkorbit.fui.components.list
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.ICollection;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.StringItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DropDownList extends Coreponent implements ICoreponent
   {
      
      private var _itemList:ItemList;
      
      private var _originalListPosition:Point;
      
      private var _isOpen:Boolean;
      
      private var _assigner:Class;
      
      private var _itemRendererTemplate:XML;
      
      private var _itemInstance:IItemDataAssigner;
      
      public function DropDownList()
      {
         super();
         addEventListeners();
      }
      
      public function setItemDataAssigner(param1:Class, param2:Class) : void
      {
         this._assigner = param1;
         this.disposeItemRenderer();
         if(this._itemList)
         {
            this._itemList.itemDataAssigner = param2;
         }
         invalidate(InvalidationType.SKIN);
      }
      
      private function disposeItemRenderer() : void
      {
         if(this._itemInstance)
         {
            this._itemInstance.removeEventListener(MouseEvent.CLICK,this.handleClicked);
            this._itemInstance.data = null;
            MovieClipUtils.removeDisplayObject(this._itemInstance as DisplayObject);
            this._itemInstance = null;
         }
      }
      
      public function set itemList(param1:ItemList) : void
      {
         if(this._itemList)
         {
            this._itemList.removeEventListener(ItemListEvent.SOURCE_CHANGED,this.handleSourceChanged);
         }
         this._itemList = param1;
         if(this._itemList)
         {
            this._itemList.addEventListener(ItemListEvent.SOURCE_CHANGED,this.handleSourceChanged);
            this._itemList.itemDataAssigner = this._assigner || StringItemDataAssigner;
            this._itemList.forceRedraw(InvalidationType.POSITION);
            this._originalListPosition = new Point(this._itemList.x,this._itemList.y);
         }
      }
      
      override protected function drawSkin() : void
      {
         super.drawSkin();
         this._itemInstance = this._itemInstance || this.buildAssigner();
         this._itemInstance.data = this._itemList.selectedItemData;
         this._itemInstance.addEventListener(MouseEvent.CLICK,this.handleClicked);
      }
      
      private function buildAssigner() : IItemDataAssigner
      {
         var _loc1_:Class = this._assigner || StringItemDataAssigner;
         var _loc2_:IItemDataAssigner = addChild(new _loc1_() as DisplayObject) as IItemDataAssigner;
         var _loc3_:DisplayObjectContainer = _loc2_ as DisplayObjectContainer;
         UISystem.getInstance().build(this._itemRendererTemplate,_loc3_,true);
         _loc2_.selected = false;
         return _loc2_;
      }
      
      private function handleSourceChanged(param1:ItemListEvent) : void
      {
         setTimeout(this.updateOnListChanged,1);
      }
      
      private function updateOnListChanged() : void
      {
         this._itemList.selectedIndex = 0;
      }
      
      private function handleClicked(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         if(!this._isOpen)
         {
            this.activateList();
         }
         else
         {
            this.deactivateList();
         }
      }
      
      private function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      private function deactivateList(param1:Event = null) : void
      {
         MovieClipUtils.removeDisplayObject(this._itemList);
         this._itemList.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleListClicked);
         this._itemInstance.selected = false;
         UISystem.getInstance().stage.removeEventListener(MouseEvent.CLICK,this.deactivateList);
         this._isOpen = false;
      }
      
      private function activateList(param1:Event = null) : void
      {
         this._itemList.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleListClicked);
         UISystem.getInstance().stage.addEventListener(MouseEvent.CLICK,this.deactivateList);
         var _loc2_:Point = localToGlobal(this._originalListPosition);
         this._itemList.x = _loc2_.x;
         this._itemList.y = _loc2_.y;
         this._itemInstance.selected = true;
         UISystem.getInstance().popupManager.add(this._itemList);
         this._itemList.invalidate(InvalidationType.SKIN);
         this._isOpen = true;
      }
      
      private function handleListClicked(param1:ItemListEvent = null) : void
      {
         if(this._itemInstance != null)
         {
            if(this._itemInstance.data != this._itemList.selectedItem)
            {
               param1 = new ItemListEvent(ItemListEvent.ITEM_SELECTION_CHANGED,true);
               this._itemInstance.data = this._itemList.selectedItem;
               param1.item = this._itemList.selectedItem;
               dispatchEvent(param1);
            }
         }
         this.deactivateList();
      }
      
      public function get selectedItem() : Object
      {
         var _loc1_:IItemDataAssigner = this._itemList.selectedItem;
         return _loc1_ ? _loc1_.data : null;
      }
      
      public function set itemRendererTemplate(param1:XML) : void
      {
         this._itemRendererTemplate = param1;
      }
      
      public function set list(param1:ICollection) : void
      {
         this._itemList.list = param1;
         if(this._itemList.selectedIndex == ItemList.UNSELECTED_INDEX)
         {
            this._itemList.selectedIndex = 0;
         }
         invalidate(InvalidationType.SKIN);
      }
      
      public function get list() : ICollection
      {
         return this._itemList.list;
      }
   }
}

