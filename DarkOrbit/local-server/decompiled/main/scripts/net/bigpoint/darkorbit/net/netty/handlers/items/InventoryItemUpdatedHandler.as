package net.bigpoint.darkorbit.net.netty.handlers.items
{
   import net.bigpoint.darkorbit.com.module.InventoryItemUpdatedCommand;
   import net.bigpoint.darkorbit.delete_in_eic.InventoryProxy;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InventoryItemUpdatedHandler extends DOAbstractSimpleCommand
   {
      
      public function InventoryItemUpdatedHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:InventoryItemUpdatedCommand = param1.getBody() as InventoryItemUpdatedCommand;
         var _loc3_:InventoryProxy = retrieveProxy(InventoryProxy.NAME) as InventoryProxy;
         if(!_loc3_)
         {
            registerProxy(_loc3_ = new InventoryProxy());
         }
         var _loc4_:ItemVO = ItemVO.fromModule(_loc2_.item);
         if(_loc4_)
         {
            _loc3_.inventory.updateItem(_loc4_);
            if(_loc4_.typeClass == ItemFilterTypes.Weapon__QuantumFluidCoreType || _loc4_.typeClass == ItemFilterTypes.Weapon__CannonType || _loc4_.typeClass == ItemFilterTypes.Weapon__CannonShieldType)
            {
               this.facade.sendNotification(GuiNotifications.WARP_CONTROLS_UPDATE);
            }
         }
      }
   }
}

