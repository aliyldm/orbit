package net.bigpoint.darkorbit.net.netty.handlers.eternalGate
{
   import net.bigpoint.darkorbit.com.module.EternalGateRankInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.EternalGateUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class EternalGateRankInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function EternalGateRankInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:EternalGateUIWindowProxy = retrieveProxy(GuiConstants.ETERNAL_GATE) as EternalGateUIWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.ETERNAL_GATE);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.ETERNAL_GATE) as EternalGateUIWindowProxy;
         }
         var _loc3_:EternalGateRankInfoCommand = param1.getBody() as EternalGateRankInfoCommand;
         _loc2_.updateRanking(_loc3_);
      }
   }
}

