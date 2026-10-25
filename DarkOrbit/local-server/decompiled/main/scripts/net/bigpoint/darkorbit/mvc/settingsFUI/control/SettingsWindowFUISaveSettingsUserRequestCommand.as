package net.bigpoint.darkorbit.mvc.settingsFUI.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SettingsWindowFUISaveSettingsUserRequestCommand extends DOAbstractSimpleCommand
   {
      
      public function SettingsWindowFUISaveSettingsUserRequestCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         this.fuiProxy.handleSaveSettingsUserRequest(param1.getBody() as int);
      }
      
      private function get fuiProxy() : SettingsWindowFUIProxy
      {
         return facade.retrieveProxy(SettingsWindowFUIProxy.NAME) as SettingsWindowFUIProxy;
      }
   }
}

