package net.bigpoint.darkorbit.net.netty.handlers.returneeLogin
{
   import net.bigpoint.darkorbit.com.module.ReturneeLoginBundleInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.model.ReturneeLoginBundleProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ReturneeLoginBundleInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ReturneeLoginBundleInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:ReturneeLoginBundleProxy = retrieveProxy(GuiConstants.RETURNEE_LOGIN_BUNDLE) as ReturneeLoginBundleProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.RETURNEE_LOGIN);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.RETURNEE_LOGIN_BUNDLE) as ReturneeLoginBundleProxy;
         }
         var _loc3_:ReturneeLoginBundleInfoCommand = param1.getBody() as ReturneeLoginBundleInfoCommand;
         _loc2_.updateExpiringDay(_loc3_);
      }
   }
}

