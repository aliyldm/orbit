package net.bigpoint.darkorbit.fui.components.list.itemslotbar
{
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.IItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.list.IList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.fui.system.manager.IAcceptedType;
   
   public class Slotbar extends ItemList implements IList
   {
      
      protected var _slotsetVO:ISlotsetVO;
      
      public function Slotbar()
      {
         super();
      }
      
      override protected function initializeItemsLayout() : void
      {
         _itemsLayout = new SlotbarLayout(this,_itemsContainer);
      }
      
      protected function get __layout() : SlotbarLayout
      {
         return _itemsLayout as SlotbarLayout;
      }
      
      public function set itemCountLimit(param1:uint) : void
      {
         this.__layout.itemCountLimit = param1;
      }
      
      public function set itemGapX(param1:uint) : void
      {
         this.__layout.gapX = param1;
         invalidate(InvalidationType.LAYOUT);
      }
      
      public function set itemGapY(param1:uint) : void
      {
         this.__layout.gapY = param1;
         invalidate(InvalidationType.LAYOUT);
      }
      
      override public function acceptType(param1:Object) : Boolean
      {
         var _loc4_:IAcceptedType = null;
         if(_acceptedTypes == null)
         {
            return false;
         }
         var _loc2_:uint = _acceptedTypes.length;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = this._slotsetVO.acceptedTypesAsArray[_loc3_] as IAcceptedType;
            if(param1 == _loc4_.classname)
            {
               return true;
            }
            _loc3_++;
         }
         return false;
      }
      
      public function update(param1:ISlotsetVO) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1.list == null)
         {
            return;
         }
         this._slotsetVO = param1;
         this.itemCountLimit = param1.size;
         acceptedDropTypes = param1.acceptedTypesAsArray;
         this._redrawEquipmentList_();
      }
      
      protected function _redrawEquipmentList_() : void
      {
         list = new VectorCollection(this.vo.list);
         invalidate(InvalidationType.FILLITEMS);
         forceRedraws();
      }
      
      override protected function handleItemClickEvent(param1:MouseEvent) : void
      {
         var _loc2_:IItemDataAssigner = null;
         var _loc3_:ItemListEvent = null;
         if(isControlKeyDown)
         {
            _loc2_ = param1.currentTarget as IItemDataAssigner;
            _loc3_ = new ItemListEvent(ItemListEvent.CLICKED_AND_CTRL_DOWN);
            _loc3_.item = _loc2_;
            _loc3_.selectedItemsData = getSelectedItemsData();
            dispatchEvent(_loc3_);
         }
         else
         {
            super.handleItemClickEvent(param1);
         }
      }
      
      public function get vo() : ISlotsetVO
      {
         return this._slotsetVO;
      }
   }
}

