package net.bigpoint.darkorbit.equipment.controller
{
   import net.bigpoint.darkorbit.equipment.model.managers.HangarManagerProxy;
   import net.bigpoint.darkorbit.equipment.view.mediators.ShipSelectorMediator;
   import org.puremvc.as3.interfaces.ICommand;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class InitShipSelectorCommand extends SimpleCommand implements ICommand
   {
      
      public function InitShipSelectorCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:HangarManagerProxy = facade.retrieveProxy(HangarManagerProxy.PROXY_NAME) as HangarManagerProxy;
         var _loc3_:ShipSelectorMediator = facade.retrieveMediator(ShipSelectorMediator.NAME) as ShipSelectorMediator;
         _loc3_.list = _loc2_.getAllHangarSlotEntities();
      }
   }
}

