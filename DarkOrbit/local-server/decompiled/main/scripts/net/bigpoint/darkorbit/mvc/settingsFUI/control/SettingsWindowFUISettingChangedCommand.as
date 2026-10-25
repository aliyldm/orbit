package net.bigpoint.darkorbit.mvc.settingsFUI.control
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsCheckBoxItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsDropDownBoxItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsKeyBindingItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsSliderNStepsItemVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class SettingsWindowFUISettingChangedCommand extends DOAbstractSimpleCommand
   {
      
      public function SettingsWindowFUISettingChangedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(param1.getBody() is SettingsCheckBoxItemVO)
         {
            this.fuiProxy.handleCheckBoxValueChangedInWindow(param1.getBody() as SettingsCheckBoxItemVO);
         }
         else if(param1.getBody() is SettingsDropDownBoxItemVO)
         {
            this.fuiProxy.handleDropDownBoxValueChangedInWindow(param1.getBody() as SettingsDropDownBoxItemVO);
         }
         else if(param1.getBody() is SettingsSliderNStepsItemVO)
         {
            this.fuiProxy.handleSliderNStepsValueChangedInWindow(param1.getBody() as SettingsSliderNStepsItemVO);
         }
         else if(param1.getBody() is SettingsKeyBindingItemVO)
         {
            this.fuiProxy.handleKeybindingValueChangedInWindow(param1.getBody() as SettingsKeyBindingItemVO);
         }
      }
      
      private function get fuiProxy() : SettingsWindowFUIProxy
      {
         return facade.retrieveProxy(SettingsWindowFUIProxy.NAME) as SettingsWindowFUIProxy;
      }
   }
}

