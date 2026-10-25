package net.bigpoint.darkorbit.net.netty.handlers.payloadEscort
{
   import net.bigpoint.darkorbit.com.module.PayloadEscortKeyInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.payloadEscort.model.PayloadEscortUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PayloadEscortKeyInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PayloadEscortKeyInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:PayloadEscortUIWindowProxy = retrieveProxy(GuiConstants.PAYLOAD_ESCORT) as PayloadEscortUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.PAYLOAD_ESCORT);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.PAYLOAD_ESCORT) as PayloadEscortUIWindowProxy;
         }
         var _loc3_:PayloadEscortKeyInfoCommand = param1.getBody() as PayloadEscortKeyInfoCommand;
         _loc2_.updateKeys(_loc3_);
      }
   }
}

