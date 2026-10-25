package net.bigpoint.darkorbit.net.netty.handlers.returneeLogin
{
   import net.bigpoint.darkorbit.com.module.ReturneeLoginInitialRewardClaimableInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.model.ReturneeLoginOverviewProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ReturneeLoginInitialRewardClaimableInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ReturneeLoginInitialRewardClaimableInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:ReturneeLoginOverviewProxy = retrieveProxy(GuiConstants.RETURNEE_LOGIN_OVERVIEW) as ReturneeLoginOverviewProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.RETURNEE_LOGIN_OVERVIEW);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.RETURNEE_LOGIN_OVERVIEW) as ReturneeLoginOverviewProxy;
         }
         var _loc3_:ReturneeLoginInitialRewardClaimableInfoCommand = param1.getBody() as ReturneeLoginInitialRewardClaimableInfoCommand;
         _loc2_.updateClaimable(_loc3_);
      }
   }
}

