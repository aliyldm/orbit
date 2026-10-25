package net.bigpoint.darkorbit.mvc.gui.controller.init
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.common.model.GuiProxy;
   import net.bigpoint.darkorbit.mvc.gui.common.view.GuiMediator;
   import net.bigpoint.darkorbit.mvc.gui.controller.ParseWindowsXmlData;
   import net.bigpoint.darkorbit.mvc.gui.controller.SaveBarsSettingsCommand;
   import net.bigpoint.darkorbit.mvc.gui.controller.logic.ChangeWindowsPositionsCommand;
   import net.bigpoint.darkorbit.mvc.gui.controller.logic.CloseKillscreenCommand;
   import net.bigpoint.darkorbit.mvc.gui.controller.logic.ToggleAllWindowsCommand;
   import net.bigpoint.darkorbit.mvc.gui.controller.requests.SendWindowUpdateRequest;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.controller.logic.ToggleWindowCommand;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.AddGlobalNotificationMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.LogMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.ShowBigMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.ShowScreenMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.ShowSimpleMessageCommand;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.GlobalNotificationsMediator;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.MessagesMediator;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.components.InstantLogView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.controller.CreateSimpleWindowCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.controller.DestroySimpleWindowCommand;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.controller.FeatureInitCommand;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitGuiCommand extends DOAbstractSimpleCommand
   {
      
      public function InitGuiCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         registerCommand(GuiNotifications.PARSE_WINDOWS_XML_DATA,ParseWindowsXmlData);
         registerCommand(GuiNotifications.CLOSE_KILLSCREEN,CloseKillscreenCommand);
         registerCommand(GuiNotifications.SAVE_BARS_SETTINGS,SaveBarsSettingsCommand);
         registerCommand(GuiNotifications.UPDATE_WINDOWS_POSITIONS,ChangeWindowsPositionsCommand);
         registerCommand(GuiNotifications.SEND_WINDOW_UPDATE_REQUEST,SendWindowUpdateRequest);
         registerCommand(GuiNotifications.TOGGLE_WINDOW_BY_ID,ToggleWindowCommand);
         registerCommand(GuiNotifications.TOGGLE_ALL_WINDOWS,ToggleAllWindowsCommand);
         registerCommand(GuiNotifications.ADD_GLOBAL_NOTIFICATION_MESSAGE,AddGlobalNotificationMessageCommand);
         registerCommand(GuiNotifications.LOG_MESSAGE,LogMessageCommand);
         registerCommand(GuiNotifications.SHOW_MESSAGE_SCREEN,ShowScreenMessageCommand);
         registerCommand(GuiNotifications.SHOW_MESSAGE_BIG,ShowBigMessageCommand);
         registerCommand(GuiNotifications.SHOW_MESSAGE_SMALL,ShowSimpleMessageCommand);
         registerCommand(GuiNotifications.CREATE_SIMPLE_WINDOW,CreateSimpleWindowCommand);
         registerCommand(GuiNotifications.DESTROY_SIMPLE_WINDOW,DestroySimpleWindowCommand);
         registerCommand(GuiNotifications.FEATURE_INIT,FeatureInitCommand);
         facade.registerProxy(new GuiProxy());
         registerMediator(new GuiMediator(_loc2_.main));
         registerMediator(new MessagesMediator(new InstantLogView(Settings.instantLogViewConfig)));
         registerMediator(new GlobalNotificationsMediator());
      }
   }
}

