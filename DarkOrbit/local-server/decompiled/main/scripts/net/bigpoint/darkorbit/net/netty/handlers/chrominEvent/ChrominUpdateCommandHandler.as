package net.bigpoint.darkorbit.net.netty.handlers.chrominEvent
{
   import net.bigpoint.darkorbit.com.module.ChrominUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.chrominEvent.model.ChrominWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ChrominUpdateCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ChrominUpdateCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:ChrominWindowProxy = retrieveProxy(GuiConstants.CHROMIN_EVENT) as ChrominWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.CHROMIN_EVENT);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.CHROMIN_EVENT) as ChrominWindowProxy;
         }
         var _loc3_:ChrominUpdateCommand = param1.getBody() as ChrominUpdateCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

