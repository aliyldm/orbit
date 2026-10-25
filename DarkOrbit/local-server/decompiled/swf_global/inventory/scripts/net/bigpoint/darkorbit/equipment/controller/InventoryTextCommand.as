package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.application.ApplicationNotificationNames;
   import net.bigpoint.darkorbit.equipment.model.ConnectionProxy;
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class InventoryTextCommand extends SimpleCommand implements ICommand
   {
      
      public function InventoryTextCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         var _loc3_:String = param1.getBody() as String;
         var _loc4_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.PROXY_NAME) as ConnectionProxy;
         var _loc5_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         switch(_loc2_)
         {
            case ApplicationNotificationNames.FIND_SELECTED_ITEM_INFO:
               _loc4_.getSelectedItemInfo(_loc3_,ApplicationNotificationNames.FIND_SELECTED_ITEM_INFO);
               break;
            case ApplicationNotificationNames.CHANGE_SELECTED_DESIGN:
               _loc4_.changeSelectedDesignRequest(_loc3_,_loc5_.getSelectedHangarSlot().hangarID);
         }
      }
   }
}

