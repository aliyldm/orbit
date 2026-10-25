package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.bundle.view.ReturneeLoginBundleView;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.view.ReturneeLoginCalendarView;
   import net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.overview.view.ReturneeLoginOverviewView;
   
   public class ReturneeLoginRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:ExtendedTabView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _overviewView:ReturneeLoginOverviewView;
      
      private var _calendarView:ReturneeLoginCalendarView;
      
      private var _bundleView:ReturneeLoginBundleView;
      
      public function ReturneeLoginRootView(param1:SimpleWindow, param2:Vector.<ITabItem> = null)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new ExtendedTabView(this._uiContainer);
         this._overviewView = new ReturneeLoginOverviewView(this.root);
         this._calendarView = new ReturneeLoginCalendarView(this.root);
         this._bundleView = new ReturneeLoginBundleView(this.root);
         this._tabView.tabItems = new <ITabItem>[this._overviewView,this._calendarView,this._bundleView];
         this._tabView.tabChanged.add(this.onTabChanged);
         this.onTabChanged(this._overviewView);
      }
      
      public function get overview() : ReturneeLoginOverviewView
      {
         return this._overviewView;
      }
      
      public function get calendar() : ReturneeLoginCalendarView
      {
         return this._calendarView;
      }
      
      public function get bundle() : ReturneeLoginBundleView
      {
         return this._bundleView;
      }
      
      public function get tabView() : ExtendedTabView
      {
         return this._tabView;
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      private function onTabChanged(param1:ITabItem) : void
      {
         this._simpleWindow.setSize(param1.view.width + 10,param1.view.height + 70);
      }
   }
}

