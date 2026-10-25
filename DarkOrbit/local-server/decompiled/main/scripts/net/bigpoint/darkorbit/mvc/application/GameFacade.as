package net.bigpoint.darkorbit.mvc.application
{
   import net.bigpoint.darkorbit.mvc.application.controller.ApplicationInitAsyncMacroCommand;
   import net.bigpoint.darkorbit.mvc.application.controller.init.InitConnectionCommand;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.application.notification.ApplicationNotifications;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.JavaScriptCallNotification;
   import net.bigpoint.darkorbit.mvc.common.KeyboardNotifications;
   import net.bigpoint.darkorbit.mvc.common.controller.assets.InitUnloadFinisherCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.javaScript.AddJavaScriptDelayedCallbackCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.javaScript.FullScreenChangeCompleteCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.javaScript.JavaScriptCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.key.LockKeyboardCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.key.UnlockKeyboardCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.net.NetControllerPrepCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.screen.FullScreenOffCommand;
   import net.bigpoint.darkorbit.mvc.common.controller.screen.ScreenViewportResizedCommand;
   import net.bigpoint.darkorbit.mvc.common.sounds.SoundNotifications;
   import net.bigpoint.darkorbit.mvc.common.sounds.controller.PlaySoundTriggerModuleCommand;
   import net.bigpoint.darkorbit.mvc.common.view.ScreenNotifications;
   import net.bigpoint.darkorbit.mvc.contactsWindow.controller.ContactsWindowHeroMapChangedCommand;
   import net.bigpoint.darkorbit.mvc.global.contorl.OnConnectionLostMacroCommand;
   import net.bigpoint.darkorbit.mvc.global.contorl.OnHeroInitMacroCommand;
   import net.bigpoint.darkorbit.mvc.global.notifications.GameNotifications;
   import net.bigpoint.darkorbit.mvc.helpwindow.HelpVideoNotification;
   import net.bigpoint.darkorbit.mvc.helpwindow.control.OpenHelpVideoPopupMacroCommand;
   import net.bigpoint.darkorbit.mvc.hints.HintsNotifications;
   import net.bigpoint.darkorbit.mvc.hints.controller.InitHintCommand;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.assets.MapAssetNotification;
   import net.bigpoint.darkorbit.mvc.mapElements.common.controller.AbortLaserAttackCommand;
   import net.bigpoint.darkorbit.mvc.mapElements.common.controller.DeselectTargetCommand;
   import net.bigpoint.darkorbit.mvc.stats.StatsNotifications;
   import net.bigpoint.darkorbit.mvc.stats.controller.StatsControllerPrepCommand;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.consts.TDMResultWindowNotifications;
   import net.bigpoint.darkorbit.mvc.tdm.matchresultWindow.controller.OpenTDMResultWindowAsyncMacroCommand;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusNotification;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.controler.OpenTdmStatusWindowMacroAsyncCommand;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.controller.WordPuzzleInitWindowCommand;
   import net.bigpoint.darkorbit.mvc.wordPuzzle.notfications.WordPuzzleNotification;
   import org.puremvc.as3.multicore.interfaces.IFacade;
   import org.puremvc.as3.multicore.patterns.facade.Facade;
   
   public class GameFacade extends Facade implements IFacade
   {
      
      public static const MULTITON_KEY:String = "Game";
      
      public function GameFacade()
      {
         super(MULTITON_KEY);
      }
      
      public static function getInstance() : GameFacade
      {
         if(instanceMap[MULTITON_KEY] == null)
         {
            instanceMap[MULTITON_KEY] = new GameFacade();
         }
         return GameFacade(instanceMap[MULTITON_KEY]);
      }
      
      override protected function initializeController() : void
      {
         super.initializeController();
         registerCommand(ApplicationNotifications.STARTUP,ApplicationInitAsyncMacroCommand);
         registerCommand(GameNotifications.HERO_INIT,OnHeroInitMacroCommand);
         registerCommand(GameNotifications.CONNECTION_LOST,OnConnectionLostMacroCommand);
         registerCommand(KeyboardNotifications.LOCK_KEYBOARD,LockKeyboardCommand);
         registerCommand(KeyboardNotifications.UNLOCK_KEYBOARD,UnlockKeyboardCommand);
         registerCommand(StatsNotifications.READY,StatsControllerPrepCommand);
         registerCommand(JavaScriptCallNotification.ADD_DELAYED_CALLBACK,AddJavaScriptDelayedCallbackCommand);
         registerCommand(JavaScriptCallNotification.CALL_JAVA_SCRIPT,JavaScriptCommand);
         registerCommand(ConnectionNotifications.INIT,InitConnectionCommand);
         registerCommand(ConnectionNotifications.READY,NetControllerPrepCommand);
         registerCommand(MapNotification.NEW_MAP_INIT_FINISHED,ContactsWindowHeroMapChangedCommand);
         registerCommand(MapAssetNotification.DESELECT_TARGET,DeselectTargetCommand);
         registerCommand(MapAssetNotification.ABORT_LASER_ATTACK,AbortLaserAttackCommand);
         registerCommand(AssetNotifications.UNLOAD_FINISHER_PROXY_READY,InitUnloadFinisherCommand);
         registerCommand(ScreenNotifications.FULLSCREEN_CHANGE,FullScreenOffCommand);
         registerCommand(ScreenNotifications.FULLSCREEN_CHANGE_COMPLETE,FullScreenChangeCompleteCommand);
         registerCommand(ScreenNotifications.SCREEN_VIEWPORT_RESIZED,ScreenViewportResizedCommand);
         registerCommand(TDMResultWindowNotifications.SHOW,OpenTDMResultWindowAsyncMacroCommand);
         registerCommand(TDMStatusNotification.UPDATE,OpenTdmStatusWindowMacroAsyncCommand);
         registerCommand(WordPuzzleNotification.INIT,WordPuzzleInitWindowCommand);
         registerCommand(HintsNotifications.INIT_HINT,InitHintCommand);
         registerCommand(SoundNotifications.PLAY_SOUND_TRIGGER_MODULE,PlaySoundTriggerModuleCommand);
         registerCommand(HelpVideoNotification.SHOW,OpenHelpVideoPopupMacroCommand);
      }
      
      public function startup(param1:StartupVO) : void
      {
         sendNotification(ApplicationNotifications.STARTUP,param1);
      }
      
      public function forwardNotification(param1:String, param2:Object = null, param3:String = null) : void
      {
         sendNotification(param1,param2,param3);
      }
   }
}

