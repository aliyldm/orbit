package net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.confirmations.general
{
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemButtonActionDescriptionVO;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemAbstractConfirmationClickCommand extends SimpleCommand
   {
      
      public function HintSystemAbstractConfirmationClickCommand()
      {
         super();
      }
      
      protected function registerAndExecuteCommand(param1:Class, param2:IHintSystemContentDescription) : void
      {
         var _loc3_:String = null;
         if(param1 != null)
         {
            _loc3_ = HintSystemNotifications.HINT_WINDOW_CONFIRMATION_CLICKED + "." + String(param1);
            if(!facade.hasCommand(_loc3_))
            {
               facade.registerCommand(_loc3_,param1);
            }
            facade.sendNotification(_loc3_,[param2,_loc3_]);
         }
      }
      
      protected function executeExternalInterface(param1:HintSystemButtonActionDescriptionVO) : void
      {
         var _loc2_:String = null;
         if(param1.externalInterfaceMethodName != null)
         {
            _loc2_ = param1.externalInterfaceMethodName;
            JavascriptProxy.call(JavascriptProxy.FUNCTION_REFER_TO_EXTERNAL_URL_IN_NEW_WINDOW,[_loc2_]);
         }
         if(param1.externalInterfaceVO != null)
         {
            JavascriptProxy.referToURLviaVO(param1.externalInterfaceVO);
         }
      }
   }
}

