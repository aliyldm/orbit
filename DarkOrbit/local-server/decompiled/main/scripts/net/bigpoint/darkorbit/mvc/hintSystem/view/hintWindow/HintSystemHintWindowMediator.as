package net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow
{
   import flash.display.Bitmap;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.fui.components.image.ImageSlideShowElement;
   import net.bigpoint.darkorbit.fui.system.modules.IUISetupModule;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.common.view.ScreenNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemConstants;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemHintWindowOnActionVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.vo.HintSystemPlaylistVO;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.uistructures.HintWindowViewSetup;
   import net.bigpoint.darkorbit.mvc.map.MapNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HintSystemHintWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "HintSystemMediator";
      
      private static var CREATION_COUNTER:uint = 0;
      
      private var _uiSetupModule:IUISetupModule;
      
      private var win:HintWindow;
      
      private var contentVO:IHintSystemContentDescription;
      
      private var _characterBitmap:Bitmap;
      
      private var _characterBackroundBitmap:Bitmap;
      
      public function HintSystemHintWindowMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
      }
      
      override public function onRemove() : void
      {
      }
      
      override public function listNotificationInterests() : Array
      {
         return [HintSystemNotifications.SHOW_HINTWINDOW,ScreenNotifications.SCREEN_VIEWPORT_RESIZED,MapNotification.CLEANUP];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:IHintSystemContentDescription = null;
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case HintSystemNotifications.SHOW_HINTWINDOW:
               _loc3_ = param1.getBody() as IHintSystemContentDescription;
               this.createHintWindow(_loc3_);
               break;
            case ScreenNotifications.SCREEN_VIEWPORT_RESIZED:
               this.centerWindow();
               break;
            case MapNotification.CLEANUP:
               if(Boolean(this.win) && Boolean(this.contentVO))
               {
                  if(this.contentVO.closeHintWindowOnMapJump)
                  {
                     this.removeWindow();
                  }
               }
         }
      }
      
      protected function createHintWindow(param1:IHintSystemContentDescription) : void
      {
         var _loc4_:Class = null;
         var _loc5_:String = null;
         ++CREATION_COUNTER;
         this.uiSetupModule.setUp();
         if(this.win)
         {
            this.removeWindowEventListeners();
            this.removeWindow();
         }
         this.contentVO = param1;
         this.win = new HintWindow();
         this.addWindowEventListeners();
         this.win.build(param1.viewStructureAsXML);
         var _loc2_:DisplayObjectContainer = this.getHintWindowLayer();
         _loc2_.addChild(this.win);
         this.centerWindow();
         var _loc3_:uint = param1.content.viewState;
         this.win.show(_loc3_);
         this.win.update(param1);
         if(_loc3_ == HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN)
         {
            this.updateExtendedView();
         }
         if(param1.content.onOpenTriggeredMVCCommand != null)
         {
            _loc4_ = param1.content.onOpenTriggeredMVCCommand;
            _loc5_ = HintSystemNotifications.ON_OPEN_HINTWINDOW;
            this.registerMVCAndExecuteCommand(_loc5_,param1,_loc4_);
         }
      }
      
      private function registerMVCAndExecuteCommand(param1:String, param2:IHintSystemContentDescription, param3:Class) : void
      {
         var _loc4_:HintSystemHintWindowOnActionVO = new HintSystemHintWindowOnActionVO();
         _loc4_.notificationName = param1;
         _loc4_.contentVO = param2;
         facade.registerCommand(param1,param3);
         facade.sendNotification(param1,_loc4_);
      }
      
      private function addWindowEventListeners() : void
      {
         this.win.addEventListener(HintWindow.EVENT_CLOSE_WINDOW_ANIMATION_FINISHED,this.handleCloseWindowAnimationFinishEvent);
         this.win.addEventListener(HintWindow.EVENT_FADE_TO_EXTENDEDVIEW_FINISHED,this.handleFadeToExtendedViewEvent);
         this.win.addEventListener(HintWindow.EVENT_CLOSE,this.handleCloseWindowEvent);
         this.win.addEventListener(HintWindow.EVENT_CONFIRMATION01_CLICKED,this.handleConfirmation01Clicked);
         this.win.addEventListener(HintWindow.EVENT_CONFIRMATION02_CLICKED,this.handleConfirmation02Clicked);
      }
      
      private function removeWindowEventListeners() : void
      {
         this.win.removeEventListener(HintWindow.EVENT_CLOSE_WINDOW_ANIMATION_FINISHED,this.handleCloseWindowAnimationFinishEvent);
         this.win.removeEventListener(HintWindow.EVENT_FADE_TO_EXTENDEDVIEW_FINISHED,this.handleFadeToExtendedViewEvent);
         this.win.removeEventListener(HintWindow.EVENT_CLOSE,this.handleCloseWindowEvent);
         this.win.removeEventListener(HintWindow.EVENT_CONFIRMATION01_CLICKED,this.handleConfirmation01Clicked);
         this.win.removeEventListener(HintWindow.EVENT_CONFIRMATION02_CLICKED,this.handleConfirmation02Clicked);
      }
      
      protected function handleConfirmation01Clicked(param1:Event) : void
      {
         if(this.contentVO != null)
         {
            sendNotification(HintSystemNotifications.HINT_WINDOW_CONFIRMATION_CLICKED,[this.contentVO,HintSystemConstants.CONFIRMATION_BUTTON_01]);
            this.contentVO = null;
         }
      }
      
      protected function handleConfirmation02Clicked(param1:Event) : void
      {
         if(this.contentVO != null)
         {
            sendNotification(HintSystemNotifications.HINT_WINDOW_CONFIRMATION_CLICKED,[this.contentVO,HintSystemConstants.CONFIRMATION_BUTTON_02]);
            this.contentVO = null;
         }
      }
      
      public function handleCloseWindowEvent(param1:Event = null) : void
      {
         this.removeWindow();
      }
      
      protected function removeWindow() : void
      {
         if(this.contentVO != null)
         {
            sendNotification(HintSystemNotifications.CLOSE_HINTWINDOW,[this.contentVO]);
            this.contentVO = null;
         }
      }
      
      public function cleanUpView() : void
      {
         if(this.win)
         {
            this.win.cleanUp();
         }
      }
      
      protected function getHintWindowLayer() : DisplayObjectContainer
      {
         return ScreenManager.getInstance().getPopupLayer();
      }
      
      protected function handleFadeToExtendedViewEvent(param1:Event = null) : void
      {
         if(this.win)
         {
            this.win.update(this.contentVO,false);
            this.updateExtendedView();
         }
      }
      
      protected function updateExtendedView() : void
      {
         if(this._characterBackroundBitmap)
         {
            this.win.setCharacterBackground(this._characterBackroundBitmap);
         }
         if(this._characterBitmap)
         {
            this.win.setCharacter(this._characterBitmap);
         }
         var _loc1_:HintSystemPlaylistVO = this.contentVO.content.playlistVO;
         sendNotification(HintSystemNotifications.LOAD_SLIDESHOW_IMAGES,_loc1_);
      }
      
      public function centerWindow() : void
      {
         if(this.win)
         {
            this.win.x = ScreenManager.getHalfScreenWidth() - (this.win.width >> 1);
            this.win.y = 70;
         }
      }
      
      public function setPlaylist(param1:Vector.<ImageSlideShowElement>, param2:Boolean) : void
      {
         if(this.win)
         {
            this.win.setPlaylist(param1,param2);
         }
      }
      
      public function backgroundLoadCallback(param1:ImageFinisher) : void
      {
         this._characterBackroundBitmap = param1.getBitmap();
      }
      
      public function characterLoadCallback(param1:ImageFinisher) : void
      {
         this._characterBitmap = param1.getBitmap();
      }
      
      public function get uiSetupModule() : IUISetupModule
      {
         if(this._uiSetupModule == null)
         {
            this._uiSetupModule = new HintWindowViewSetup();
         }
         return this._uiSetupModule;
      }
      
      public function startCloseAnimation(param1:Point) : void
      {
         if(this.win)
         {
            this.win.startCloseAnimation(param1);
         }
      }
      
      protected function handleCloseWindowAnimationFinishEvent(param1:Event) : void
      {
         sendNotification(HintSystemNotifications.HINT_WINDOW_CLOSE_ANIMATION_FINISHED);
      }
      
      public function getHintWindow() : HintWindow
      {
         return this.win;
      }
      
      public function get creationCounter() : uint
      {
         return CREATION_COUNTER;
      }
   }
}

