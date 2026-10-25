package net.bigpoint.darkorbit.net.netty.handlers.items
{
   import net.bigpoint.darkorbit.com.module.InventoryItemRemovedCommand;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InventoryItemRemovedHandler extends DOAbstractSimpleCommand
   {
      
      public function InventoryItemRemovedHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:InventoryItemRemovedCommand = param1.getBody() as InventoryItemRemovedCommand;
         var _loc3_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(_loc3_)
         {
            _loc3_.inventory.removeItem(_loc3_.inventory.getItemById(_loc2_.itemId));
         }
      }
   }
}

