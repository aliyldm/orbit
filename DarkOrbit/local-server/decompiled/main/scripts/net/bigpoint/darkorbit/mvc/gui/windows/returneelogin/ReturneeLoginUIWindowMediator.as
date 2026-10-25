package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.model.ReturneeLoginBundleData;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.model.ReturneeLoginBundleProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.view.ReturneeLoginBundleMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.model.ReturneeLoginCalendarData;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.model.ReturneeLoginCalendarProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.view.ReturneeLoginCalendarMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.model.ReturneeLoginOverviewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.model.ReturneeLoginOverviewProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.view.ReturneeLoginOverviewMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.view.ReturneeLoginRootView;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.RogueLiteUIWindowMediator;
   
   public class ReturneeLoginUIWindowMediator extends SimpleWindowMediator
   {
      
      public static const RED_DOT_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.RETURNEE_LOGIN,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT);
      
      private var _subviews:Vector.<ITabItem> = new Vector.<ITabItem>(0);
      
      private var _loadCounter:int = 0;
      
      private var overviewData:ReturneeLoginOverviewData;
      
      private var calendarData:ReturneeLoginCalendarData;
      
      private var bundleData:ReturneeLoginBundleData;
      
      public function ReturneeLoginUIWindowMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         var _loc1_:ReturneeLoginOverviewProxy = null;
         var _loc2_:ReturneeLoginCalendarProxy = null;
         var _loc3_:ReturneeLoginBundleProxy = null;
         super.onRegister();
         facade.registerProxy(_loc1_ = new ReturneeLoginOverviewProxy(GuiConstants.RETURNEE_LOGIN_OVERVIEW));
         facade.registerProxy(_loc2_ = new ReturneeLoginCalendarProxy(GuiConstants.RETURNEE_LOGIN_CALENDAR));
         facade.registerProxy(_loc3_ = new ReturneeLoginBundleProxy(GuiConstants.RETURNEE_LOGIN_BUNDLE));
         registerMediator(new ReturneeLoginOverviewMediator(GuiConstants.RETURNEE_LOGIN_OVERVIEW,simpleWindow));
         registerMediator(new ReturneeLoginCalendarMediator(GuiConstants.RETURNEE_LOGIN_CALENDAR,simpleWindow));
         registerMediator(new ReturneeLoginBundleMediator(GuiConstants.RETURNEE_LOGIN_BUNDLE,simpleWindow));
         this.overviewData = _loc1_.viewData;
         this.calendarData = _loc2_.viewData;
         this.bundleData = _loc3_.viewData;
         this.overviewData.claimable.changed.add(this.updateHighlighter);
         this.calendarData.claimable.changed.add(this.updateHighlighter);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.loadAndBuildWithResKey(GuiConstants.RETURNEE_LOGIN_OVERVIEW,param1);
         this.loadAndBuildWithResKey(GuiConstants.RETURNEE_LOGIN_CALENDAR,param1);
         this.loadAndBuildWithResKey(GuiConstants.RETURNEE_LOGIN_BUNDLE,param1);
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param1);
         }
      }
      
      private function manualLoadMediator(param1:String, param2:Class, param3:ITabItem) : void
      {
         var _loc4_:* = retrieveMediator(param1) as param2;
         if(_loc4_ != null)
         {
            _loc4_.manualLoad(param3);
         }
      }
      
      private function loadAndBuildWithResKey(param1:String, param2:Array) : void
      {
         ++this._loadCounter;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc3_,this._internalHandleBuildComplete,[_loc3_,param2]);
      }
      
      private function _internalHandleBuildComplete(param1:Sprite, param2:Array) : void
      {
         var _loc3_:DisplayObjectContainer = window.getUIContainer().getChildByName("root") as DisplayObjectContainer;
         var _loc4_:Container = param1.getChildAt(0) as Container;
         _loc3_.addChild(_loc4_.getChildAt(0));
         --this._loadCounter;
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param2);
         }
      }
      
      protected function handleFinalContentLoaded(param1:Array) : void
      {
         var _loc4_:int = 0;
         var _loc2_:ReturneeLoginRootView = new ReturneeLoginRootView(simpleWindow,this._subviews);
         this.manualLoadMediator(GuiConstants.RETURNEE_LOGIN_OVERVIEW,ReturneeLoginOverviewMediator,_loc2_.overview);
         this.manualLoadMediator(GuiConstants.RETURNEE_LOGIN_CALENDAR,ReturneeLoginCalendarMediator,_loc2_.calendar);
         this.manualLoadMediator(GuiConstants.RETURNEE_LOGIN_BUNDLE,ReturneeLoginBundleMediator,_loc2_.bundle);
         var _loc3_:Map = ScreenManager.getInstance().map;
         if(RogueLiteUIWindowMediator.FORBIDDEN_MAP.indexOf(_loc3_.mapID) >= 0)
         {
            return;
         }
         if(this.overviewData.claimable.value)
         {
            simpleWindow.maximize();
         }
         else if(this.calendarData.claimable.value)
         {
            simpleWindow.maximize();
            _loc4_ = _loc2_.tabView.tabbar.list.indexOf(_loc2_.calendar.title);
            _loc2_.tabView.tabbar.selectedIndex = _loc4_;
         }
         else if(this.bundleData.countdownTimer.value > 0)
         {
            simpleWindow.maximize();
            _loc4_ = _loc2_.tabView.tabbar.list.indexOf(_loc2_.bundle.title);
            _loc2_.tabView.tabbar.selectedIndex = _loc4_;
         }
      }
      
      private function updateHighlighter() : void
      {
         if(this.overviewData.claimable.value || this.calendarData.claimable.value)
         {
            sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
         }
         else
         {
            sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
         }
      }
   }
}

