package net.bigpoint.darkorbit.fui.components.list.itemlist
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.components.list.IItemDataAssigner;
   
   public class ItemListEvent extends Event
   {
      
      private static const NAME:String = "ItemListEvent.";
      
      public static const MOUSE_OVER:String = NAME + "mouseOver";
      
      public static const MOUSE_OUT:String = NAME + "mouseOut";
      
      public static const CLICKED:String = NAME + "clickeNd";
      
      public static const ITEM_SELECTION_CHANGED:String = NAME + "selectionChanged";
      
      public static const ITEMS_SELECTION_CHANGED:String = NAME + "selectionsChanged";
      
      public static const CLICKED_AND_CTRL_DOWN:String = NAME + "clickedAndCTRLDown";
      
      public static const SOURCE_CHANGED:String = NAME + "SourceChanged";
      
      private var _item:IItemDataAssigner;
      
      private var _itemVO:Object;
      
      private var _selectedItemsData:Vector.<Object>;
      
      public function ItemListEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function get itemVO() : Object
      {
         return this._itemVO;
      }
      
      public function set item(param1:IItemDataAssigner) : void
      {
         if(param1)
         {
            this._item = param1;
            this._itemVO = param1.data;
         }
      }
      
      public function get item() : IItemDataAssigner
      {
         return this._item;
      }
      
      public function get selectedItemsData() : Vector.<Object>
      {
         return this._selectedItemsData;
      }
      
      public function set selectedItemsData(param1:Vector.<Object>) : void
      {
         this._selectedItemsData = param1;
      }
   }
}

