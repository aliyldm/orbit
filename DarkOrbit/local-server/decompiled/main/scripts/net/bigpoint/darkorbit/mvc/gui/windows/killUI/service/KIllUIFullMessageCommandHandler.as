package net.bigpoint.darkorbit.mvc.gui.windows.killUI.service
{
   import net.bigpoint.darkorbit.com.module.KillUiFullMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.killUI.model.KillUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class KIllUIFullMessageCommandHandler extends AbstractKillUIMessageCommandHandler
   {
      
      public function KIllUIFullMessageCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:KillUiFullMessageCommand = null;
         var _loc2_:KillUIWindowProxy = getProxyAndInitWindow();
         if(_loc2_)
         {
            _loc3_ = param1.getBody() as KillUiFullMessageCommand;
            _loc2_.viewData.updateFromFullMessage(_loc3_);
         }
      }
   }
}

