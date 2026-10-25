package net.bigpoint.darkorbit.delete_in_eic
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InventoryCleanupCommand extends SimpleCommand
   {
      
      public function InventoryCleanupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:InventoryProxy = facade.retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(_loc2_)
         {
            _loc2_.inventory.clear();
         }
      }
   }
}

