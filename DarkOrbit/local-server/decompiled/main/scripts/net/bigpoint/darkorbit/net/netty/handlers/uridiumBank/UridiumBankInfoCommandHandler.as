package net.bigpoint.darkorbit.net.netty.handlers.uridiumBank
{
   import net.bigpoint.darkorbit.com.module.UridiumBankInfoCommand;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.uridiumbank.model.UridiumBankWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class UridiumBankInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function UridiumBankInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         super.execute(param1);
         var _loc2_:UridiumBankWindowProxy = retrieveProxy(GuiConstants.URIDIUM_BANK) as UridiumBankWindowProxy;
         if(!_loc2_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(GuiConstants.URIDIUM_BANK);
            sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
            _loc2_ = retrieveProxy(GuiConstants.URIDIUM_BANK) as UridiumBankWindowProxy;
         }
         var _loc3_:UridiumBankInfoCommand = param1.getBody() as UridiumBankInfoCommand;
         _loc2_.updateInfo(_loc3_);
      }
   }
}

