package net.bigpoint.darkorbit.mvc.gui.windows.killUI.service
{
   import net.bigpoint.darkorbit.com.module.KillUiInfoMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.killUI.model.KillUIWindowProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class KillUIMessageCommandHandler extends AbstractKillUIMessageCommandHandler
   {
      
      public function KillUIMessageCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:KillUiInfoMessageCommand = null;
         var _loc2_:KillUIWindowProxy = getProxyAndInitWindow();
         if(_loc2_)
         {
            _loc3_ = param1.getBody() as KillUiInfoMessageCommand;
            _loc2_.viewData.updateFromInfoMessage(_loc3_);
         }
      }
   }
}

