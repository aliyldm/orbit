package net.bigpoint.darkorbit.net.netty.handlers.miniClientReward
{
   import net.bigpoint.darkorbit.com.module.MiniClientRewardInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model.MiniClientRewardWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MiniClientRewardInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function MiniClientRewardInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:MiniClientRewardWindowProxy = retrieveProxy(GuiConstants.MINICLIENT_REWARD) as MiniClientRewardWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.MINICLIENT_REWARD);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.MINICLIENT_REWARD) as MiniClientRewardWindowProxy;
         }
         var _loc3_:MiniClientRewardInfoCommand = param1.getBody() as MiniClientRewardInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

