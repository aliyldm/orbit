package net.bigpoint.darkorbit.net.netty.handlers.shipBoostEvent
{
   import net.bigpoint.darkorbit.com.module.ShipBoostEventInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.shipBoostEvent.model.ShipBoostEventWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ShipBoostEventInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ShipBoostEventInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:ShipBoostEventWindowProxy = retrieveProxy(GuiConstants.SHIP_BOOST_EVENT) as ShipBoostEventWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.SHIP_BOOST_EVENT);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.SHIP_BOOST_EVENT) as ShipBoostEventWindowProxy;
         }
         var _loc3_:ShipBoostEventInfoCommand = param1.getBody() as ShipBoostEventInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

