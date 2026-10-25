package net.bigpoint.darkorbit.delete_in_eic
{
   import net.bigpoint.darkorbit.mvc.gui.common.abstract.model.DOAbstractProxy;
   
   public class InventoryProxy extends DOAbstractProxy
   {
      
      public static const NAME:String = "InventoryProxy";
      
      public function InventoryProxy()
      {
         super(NAME,new InventoryModel());
      }
      
      public function get inventory() : InventoryModel
      {
         return data as InventoryModel;
      }
   }
}

