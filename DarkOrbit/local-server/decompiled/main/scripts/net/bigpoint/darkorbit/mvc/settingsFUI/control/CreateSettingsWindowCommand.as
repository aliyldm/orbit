package net.bigpoint.darkorbit.mvc.settingsFUI.control
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.settingsFUI.SettingsWindowNotifications;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIProxy;
   import net.bigpoint.darkorbit.mvc.settingsFUI.model.SettingsWindowFUIVO;
   import net.bigpoint.darkorbit.mvc.settingsFUI.view.SettingsWindowConsts;
   import net.bigpoint.darkorbit.mvc.settingsFUI.view.SettingsWindowFUI;
   import net.bigpoint.darkorbit.mvc.settingsFUI.view.SettingsWindowFUIMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CreateSettingsWindowCommand extends DOAbstractAsyncCommand
   {
      
      public function CreateSettingsWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:SimpleWindow = (guiManager.getWindow(GuiConstants.SETTINGS_WINDOW) ? guiManager.getWindow(GuiConstants.SETTINGS_WINDOW) : guiManager.createWindow(GuiConstants.SETTINGS_WINDOW)) as SimpleWindow;
         var _loc3_:SimpleContainer = _loc2_.getContainer(0);
         var _loc4_:DisplayObjectContainer = new Sprite();
         _loc3_.addElement(_loc4_);
         UISystem.getInstance().loadAndBuildWithResKey(SettingsWindowConsts.XML_RES_KEY,_loc4_,this.handleBuildComplete,[_loc2_,_loc4_]);
      }
      
      private function handleBuildComplete(param1:SimpleWindow, param2:Sprite) : void
      {
         var _loc3_:Coreponent = param2.getChildAt(0) as Coreponent;
         var _loc4_:SettingsWindowFUIMediator = new SettingsWindowFUIMediator(new SettingsWindowFUI(_loc3_),param1);
         registerMediator(_loc4_);
         var _loc5_:SettingsWindowFUIProxy = new SettingsWindowFUIProxy(new SettingsWindowFUIVO());
         registerProxy(_loc5_);
         registerCommand(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_SAVE_SETTINGS,SettingsWindowFUISaveSettingsCommand);
         registerCommand(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_MODEL_CHANGES,SettingsWindowFUIApplySettingsCommand);
         registerCommand(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_SAVE_SETTINGS_USER_REQUEST,SettingsWindowFUISaveSettingsUserRequestCommand);
         registerCommand(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_SETTING_CHANGED,SettingsWindowFUISettingChangedCommand);
         registerCommand(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_CANCEL_SETTINGS,SettingsWindowFUISettingsCancelledCommand);
         registerCommand(SettingsWindowNotifications.SETTINGS_WINDOW_FUI_APPLY_SETTINGS_FROM_SERVER,SettingsWindowFUIApplySettingsFromServerCommand);
         _loc5_.setModelFromCurrentSettings();
      }
   }
}

