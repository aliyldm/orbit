package net.bigpoint.darkorbit
{
   import flash.events.Event;
   import flash.text.StyleSheet;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.managers.InfiltrationGameManager;
   import net.bigpoint.darkorbit.managers.QuestManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.mvc.application.notification.ApplicationNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.settings.Settings;
   import spark.components.SkinnableContainer;
   import spark.core.SpriteVisualElement;
   
   public class Main extends SpriteVisualElement
   {
      
      public static var VERSION:String;
      
      public static var gameXML:XML;
      
      public static var css:StyleSheet;
      
      public static var scheduledDisconnect:Boolean;
      
      public static var helpLink:String;
      
      public static var serverVersion:String = "Unknown";
      
      public static const mouseEventsEnabled:Boolean = false;
      
      public var screenManager:ScreenManager;
      
      public var guiManager:GuiManager;
      
      public var questManager:QuestManager;
      
      public var ifgManager:InfiltrationGameManager;
      
      private var _windowContainer:SkinnableContainer;
      
      public var userAskedForLogout:Boolean = false;
      
      private var gameFacade:GameFacade;
      
      public var appWindow:MainClientApplication;
      
      private var _connectionManager:ConnectionManager;
      
      public function Main()
      {
         super();
         EmbeddedFonts.initialize();
         this.addEventListener(Event.ADDED_TO_STAGE,this.handleClientAddedToStage);
      }
      
      private function handleClientAddedToStage(param1:Event = null) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleClientAddedToStage);
         Settings.parsePlayerVersion();
         var _loc2_:StartupVO = new StartupVO(this,this.stage);
         this.gameFacade = GameFacade.getInstance();
         this.gameFacade.startup(_loc2_);
         stage.dispatchEvent(new Event(Event.INIT));
         this.forwardEventDispatch(new Event(Event.INIT));
      }
      
      [SecureSWF(rename="off")]
      public function forwardEventDispatch(param1:Event) : void
      {
         this.appWindow.systemManager.dispatchEvent(param1);
      }
      
      public function initApplication() : void
      {
         var _loc1_:StartupVO = new StartupVO(this,this.stage);
         this.gameFacade.forwardNotification(ApplicationNotifications.BOOTUP,_loc1_);
         this.gameFacade.removeCommand(ApplicationNotifications.BOOTUP);
         this.forwardEventDispatch(new Event("gameclient_start",true));
      }
      
      public function BBDEAD(param1:String) : void
      {
         this._connectionManager.sendMapLoadedRequest(param1);
      }
      
      public function getConnectionManager() : ConnectionManager
      {
         var _loc1_:ConnectionProxy = null;
         if(this._connectionManager == null)
         {
            _loc1_ = this.gameFacade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
            this._connectionManager = _loc1_.connectionManager;
         }
         return this._connectionManager;
      }
      
      public function getGuiManager() : GuiManager
      {
         return this.guiManager;
      }
      
      public function getQuestManager() : QuestManager
      {
         if(this.questManager == null)
         {
            this.questManager = new QuestManager(this);
         }
         return this.questManager;
      }
      
      public function getInfiltrationGameManager() : InfiltrationGameManager
      {
         return this.ifgManager;
      }
      
      public function setScheduledDisconnect(param1:Boolean) : void
      {
         scheduledDisconnect = param1;
      }
      
      public function getScheduledDisconnect() : Boolean
      {
         return scheduledDisconnect;
      }
      
      public function init(param1:MainClientApplication, param2:SkinnableContainer) : void
      {
         this.appWindow = param1;
         this._windowContainer = param2;
         this._windowContainer.width = stage.width;
         this._windowContainer.height = stage.height;
         FlexWindowManager.getInstance().init(param2);
      }
      
      public function get windowContainer() : SkinnableContainer
      {
         return this._windowContainer;
      }
   }
}

