package net.bigpoint.darkorbit.net.netty.handlers.items
{
   import net.bigpoint.darkorbit.com.module.InventoryItemModule;
   import net.bigpoint.darkorbit.com.module.UserInventoryModule;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.discount.model.DiscountProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UserInventoryHandler extends DOAbstractSimpleCommand
   {
      
      public function UserInventoryHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc7_:InventoryItemModule = null;
         var _loc8_:ItemVO = null;
         super.execute(param1);
         var _loc2_:UserInventoryModule = param1.getBody() as UserInventoryModule;
         var _loc3_:DiscountProxy = retrieveProxy(DiscountProxy.NAME) as DiscountProxy;
         if(!_loc3_)
         {
            sendNotification(AssemblyNotifications.INIT);
            _loc3_ = retrieveProxy(DiscountProxy.NAME) as DiscountProxy;
         }
         if(!_loc3_)
         {
            registerProxy(_loc3_ = new DiscountProxy());
         }
         _loc3_.updateFromServer(_loc2_);
         var _loc4_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(!_loc4_)
         {
            registerProxy(_loc4_ = new InventoryProxy());
         }
         var _loc5_:int = int(_loc2_.inventoryItemModules.length);
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = _loc2_.inventoryItemModules[_loc6_];
            _loc8_ = ItemVO.fromModule(_loc7_);
            if(_loc8_)
            {
               _loc4_.inventory.updateItem(_loc8_,false);
            }
            _loc6_++;
         }
         _loc4_.inventory.dispatchItemChanged();
      }
   }
}

