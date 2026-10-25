package net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow
{
   import com.greensock.TweenLite;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.com.module.HintWindowAddComand;
   import net.bigpoint.darkorbit.com.module.HintWindowModule;
   import net.bigpoint.darkorbit.fui.system.modules.IUISetupModule;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.abstract.view.DOAbstractMediator;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.common.view.GuiMediator;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.content.IHintSystemContentDescription;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.components.HintSystemOverlistItemRendererEvent;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.uistructures.HintOverviewWindowSetup;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class HintSystemHintOverviewWindowMediator extends DOAbstractMediator
   {
      
      public static const NAME:String = "HintSystemHintOverviewWindowMediator";
      
      private var _uiSetupModule:IUISetupModule;
      
      public function HintSystemHintOverviewWindowMediator(param1:Object = null)
      {
         super(NAME,param1);
      }
      
      override public function onRegister() : void
      {
         setViewComponent(new HintOverviewWindow());
      }
      
      override public function onRemove() : void
      {
      }
      
      override public function listNotificationInterests() : Array
      {
         return [HintSystemNotifications.WINDOWLIST_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc3_:Vector.<IHintSystemContentDescription> = null;
         super.handleNotification(param1);
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case HintSystemNotifications.WINDOWLIST_CHANGED:
               _loc3_ = param1.getBody() as Vector.<IHintSystemContentDescription>;
               this.updateOverview(_loc3_);
         }
      }
      
      protected function updateOverview(param1:Vector.<IHintSystemContentDescription>) : void
      {
         var _loc2_:GuiMediator = retrieveMediator(GuiMediator.NAME) as GuiMediator;
         var _loc3_:SimpleWindow = _loc2_.view.guiManager.getWindow(GuiConstants.HELP_WINDOW) as SimpleWindow;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:Sprite = _loc3_.getContainer(0) as Sprite;
         _loc4_.mouseEnabled = false;
         if(!this.uiSetupModule.isInitialized())
         {
            this.uiSetupModule.setUp();
            this.overviewWindow.build(_loc4_,this.uiSetupModule.uiStructure);
            this.overviewWindow.addEventListener(HintSystemOverlistItemRendererEvent.ITEM_CLICKED,this.handleListItemClicked);
            this.resizeOverviewWindow(_loc3_);
            _loc3_.addEventListener(SimpleWindowEvent.ON_RESIZE,this.handleWindowResized);
            _loc3_.addEventListener(SimpleWindowEvent.RESIZE_START,this.handleWindowResizeStart);
            _loc3_.addEventListener(SimpleWindowEvent.RESIZE_STOP,this.handleWindowResizeStop);
         }
         this.overviewWindow.list = param1;
      }
      
      protected function handleWindowResized(param1:SimpleWindowEvent) : void
      {
         var _loc2_:Sprite = param1.target as Sprite;
         TweenLite.killDelayedCallsTo(this.resizeOverviewWindow);
         TweenLite.delayedCall(0.2,this.resizeOverviewWindow,[_loc2_]);
      }
      
      protected function handleWindowResizeStart(param1:SimpleWindowEvent) : void
      {
         this.overviewWindow.deactivate();
      }
      
      protected function handleWindowResizeStop(param1:SimpleWindowEvent) : void
      {
         this.overviewWindow.activate();
      }
      
      private function resizeOverviewWindow(param1:Sprite) : void
      {
         this.overviewWindow.setSize(param1.width - 9,param1.height - 29);
      }
      
      private function handleListItemClicked(param1:HintSystemOverlistItemRendererEvent) : void
      {
         var _loc2_:HintWindowModule = new HintWindowModule();
         _loc2_.content = param1.contentID;
         var _loc3_:HintWindowAddComand = new HintWindowAddComand(_loc2_,false,HintWindowAddComand.HINTWINDOWVISIBILITY_OPEN);
         _loc3_.openedFromArchive = true;
         sendNotification(HintSystemNotifications.OPEN_HINTWINDOW,_loc3_);
      }
      
      public function get overviewWindow() : HintOverviewWindow
      {
         return getViewComponent() as HintOverviewWindow;
      }
      
      public function get uiSetupModule() : IUISetupModule
      {
         if(this._uiSetupModule == null)
         {
            this._uiSetupModule = new HintOverviewWindowSetup();
         }
         return this._uiSetupModule;
      }
   }
}

