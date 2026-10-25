package net.bigpoint.darkorbit.net.netty.handlers.npcEvent
{
   import net.bigpoint.darkorbit.com.module.NpcEventBossInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.npcEvent.model.NpcEventUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class NpcEventBossInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function NpcEventBossInfoCommandHandler()
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
         var _loc3_:NpcEventBossInfoCommand = param1.getBody() as NpcEventBossInfoCommand;
         _loc2_.updateBossInfo(_loc3_);
      }
   }
}

