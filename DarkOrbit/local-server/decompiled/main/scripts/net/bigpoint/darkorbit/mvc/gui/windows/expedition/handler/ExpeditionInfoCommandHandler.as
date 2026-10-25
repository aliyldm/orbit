package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoCommand;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionInfoRequest;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.ExpeditionInfoProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExpeditionInfoCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function ExpeditionInfoCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:SimpleWindow = null;
         var _loc2_:ExpeditionInfoCommand = param1.getBody() as ExpeditionInfoCommand;
         ExpeditionInfoProxy.getProxy(this.facade).rcvExpeditionInfo(_loc2_);
         if(_loc2_.popup)
         {
            _loc3_ = guiManager.getWindow(GuiConstants.EXPEDITION_REWARD);
            if(!_loc3_)
            {
               GuiManager.instance.tryCreateAndOpen(GuiConstants.EXPEDITION_REWARD);
               GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new ExpeditionInfoRequest());
            }
         }
      }
   }
}

