package net.bigpoint.darkorbit.fui.components.list.itemslotbar
{
   import flash.display.DisplayObjectContainer;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.layout.ILayout;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.GridItemListLayout;
   
   public class SlotbarLayout extends GridItemListLayout implements ILayout
   {
      
      protected var _itemCountLimit:uint;
      
      public function SlotbarLayout(param1:Container = null, param2:Container = null)
      {
         super(param1,param2);
      }
      
      override public function execute(param1:DisplayObjectContainer = null) : void
      {
         layoutItems();
      }
      
      override public function getVisibleItemsCount() : int
      {
         return this._itemCountLimit;
      }
      
      public function set itemCountLimit(param1:uint) : void
      {
         this._itemCountLimit = param1;
      }
   }
}

