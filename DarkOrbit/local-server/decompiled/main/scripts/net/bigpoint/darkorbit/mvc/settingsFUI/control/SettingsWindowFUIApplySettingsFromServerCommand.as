package net.bigpoint.darkorbit.mvc.settingsFUI.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SettingsWindowFUIApplySettingsFromServerCommand extends DOAbstractSimpleCommand
   {
      
      public function SettingsWindowFUIApplySettingsFromServerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         (facade.retrieveProxy(SettingsWindowFUIProxy.NAME) as SettingsWindowFUIProxy).setModelFromCurrentSettings();
      }
   }
}

