package net.bigpoint.darkorbit.net.netty.handlers.agatusEvent
{
   import net.bigpoint.darkorbit.com.module.AgatusEventBossInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.agatusEvent.model.AgatusEventUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AgatusEventBossInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function AgatusEventBossInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:AgatusEventUIWindowProxy = retrieveProxy(GuiConstants.AGATUS_EVENT) as AgatusEventUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.AGATUS_EVENT);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.AGATUS_EVENT) as AgatusEventUIWindowProxy;
         }
         var _loc3_:AgatusEventBossInfoCommand = param1.getBody() as AgatusEventBossInfoCommand;
         _loc2_.updateBossInfo(_loc3_);
      }
   }
}

