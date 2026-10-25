package net.bigpoint.darkorbit.net.netty.handlers.npcEvent
{
   import net.bigpoint.darkorbit.com.module.NpcEventTimeInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.npcEvent.model.NpcEventUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class NpcEventTimeInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function NpcEventTimeInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:NpcEventUIWindowProxy = retrieveProxy(GuiConstants.NPC_EVENT) as NpcEventUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.NPC_EVENT);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.NPC_EVENT) as NpcEventUIWindowProxy;
         }
         var _loc3_:NpcEventTimeInfoCommand = param1.getBody() as NpcEventTimeInfoCommand;
         _loc2_.updateTimer(_loc3_);
      }
   }
}

