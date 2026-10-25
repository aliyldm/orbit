package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.mvc.settingsFUI.SettingsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.settingsFUI.control.CreateSettingsWindowCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitSettingsSystemCommand extends SimpleCommand
   {
      
      public function InitSettingsSystemCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.registerCommand(SettingsWindowNotifications.CREATE_SETTINGS_WINDOW,CreateSettingsWindowCommand);
      }
   }
}

