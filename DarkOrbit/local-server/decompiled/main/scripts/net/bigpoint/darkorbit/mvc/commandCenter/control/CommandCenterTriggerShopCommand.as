package net.bigpoint.darkorbit.mvc.commandCenter.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CommandCenterTriggerShopCommand extends DOAbstractSimpleCommand
   {
      
      public function CommandCenterTriggerShopCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:CommandCenterProxy = retrieveProxy(GuiConstants.COMMAND_CENTER) as CommandCenterProxy;
         var _loc3_:Boolean = _loc2_.triggerShopButtonAction();
         if(!_loc3_)
         {
            JavascriptProxy.referToURL("internalDock",null,"internalDockShips&checkOffer",true);
            JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["uridium"]);
         }
      }
   }
}

