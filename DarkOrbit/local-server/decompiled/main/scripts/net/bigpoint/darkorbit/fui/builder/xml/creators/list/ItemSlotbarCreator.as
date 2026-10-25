package net.bigpoint.darkorbit.fui.builder.xml.creators.list
{
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemslotbar.Slotbar;
   
   public class ItemSlotbarCreator extends ItemListCreator
   {
      
      public function ItemSlotbarCreator()
      {
         super();
      }
      
      override public function create(param1:XML) : ICoreponent
      {
         var _loc2_:Slotbar = new Slotbar();
         mapXMLNodeAttributes(_loc2_,param1);
         mapXMLChildrenToMethodHandler(_loc2_,param1);
         return _loc2_;
      }
   }
}

