package net.bigpoint.darkorbit.fui.components.list.itemlist
{
   import flash.events.MouseEvent;
   
   public class ItemListDecorator
   {
      
      private var _mouseX:Number = 0;
      
      private var _itemList:ItemList;
      
      public function ItemListDecorator(param1:ItemList)
      {
         super();
         this._itemList = param1;
         this._itemList.addEventListener(MouseEvent.MOUSE_DOWN,this.handleItemListMouseDown);
         this._itemList.addEventListener(MouseEvent.MOUSE_UP,this.handleItemListMouseUp);
         this._itemList.addEventListener(MouseEvent.MOUSE_OVER,this.handleItemListMouseOver);
      }
      
      private function handleItemListMouseOver(param1:MouseEvent) : void
      {
         this._itemList.removeEventListener(MouseEvent.MOUSE_OVER,this.handleItemListMouseOver);
         this._itemList.addEventListener(MouseEvent.MOUSE_OUT,this.handleItemListMouseOut);
         this._itemList.addEventListener(MouseEvent.MOUSE_WHEEL,this.handleItemListMouseWheel);
      }
      
      private function handleItemListMouseOut(param1:MouseEvent) : void
      {
         this._itemList.removeEventListener(MouseEvent.MOUSE_OUT,this.handleItemListMouseOut);
         this._itemList.removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleItemListMouseWheel);
         this._itemList.addEventListener(MouseEvent.MOUSE_OVER,this.handleItemListMouseOver);
      }
      
      private function handleItemListMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:Number = param1.delta < 0 ? 1 : -1;
         this._itemList.setScrollPositionInPercent(this._itemList.getScrollPositionInPercent() + _loc2_ / this._itemList.list.length);
      }
      
      private function handleItemListMouseUp(param1:MouseEvent) : void
      {
         this._itemList.removeEventListener(MouseEvent.MOUSE_MOVE,this.handleItemListMouseMove);
         this._itemList.removeEventListener(MouseEvent.RELEASE_OUTSIDE,this.handleItemListMouseUp);
      }
      
      private function handleItemListMouseDown(param1:MouseEvent) : void
      {
         this._mouseX = param1.stageX;
         this._itemList.addEventListener(MouseEvent.MOUSE_MOVE,this.handleItemListMouseMove);
         this._itemList.addEventListener(MouseEvent.RELEASE_OUTSIDE,this.handleItemListMouseUp);
      }
      
      private function handleItemListMouseMove(param1:MouseEvent) : void
      {
         this._itemList.setScrollPositionInPercent(this._itemList.getScrollPositionInPercent() + (this._mouseX - param1.stageX) * 0.001 * this._itemList.list.length);
         this._mouseX = param1.stageX;
      }
   }
}

