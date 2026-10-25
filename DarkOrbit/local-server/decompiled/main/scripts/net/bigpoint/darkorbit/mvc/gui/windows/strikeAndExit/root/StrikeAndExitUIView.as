package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root
{
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.view.StrikeAndExitOverviewView;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.view.StrikeAndExitShopView;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.vanguardMart.view.StrikeAndExitVanguardMartView;
   
   public class StrikeAndExitUIView
   {
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:StrikeAndExitTabView;
      
      private var _shopView:StrikeAndExitShopView;
      
      private var _overviewView:StrikeAndExitOverviewView;
      
      private var _martView:StrikeAndExitVanguardMartView;
      
      public function StrikeAndExitUIView(param1:SimpleWindow)
      {
         super();
         if(param1.helpBtn)
         {
            param1.removeHelpBtnClick();
         }
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new StrikeAndExitTabView(this._uiContainer);
         this._shopView = new StrikeAndExitShopView(this.root);
         this._shopView.visible = false;
         this._overviewView = new StrikeAndExitOverviewView(this.root);
         this._overviewView.visible = false;
         this._martView = new StrikeAndExitVanguardMartView(this.root);
         this._martView.visible = false;
         this._tabView.tabItems = new <ITabItem>[this._overviewView,this._shopView,this._martView];
         this._tabView.tabChanged.add(this.onTabChanged);
         this.onTabChanged(this._martView);
      }
      
      public function get tab() : StrikeAndExitTabView
      {
         return this._tabView;
      }
      
      public function get overview() : StrikeAndExitOverviewView
      {
         return this._overviewView;
      }
      
      public function get shop() : StrikeAndExitShopView
      {
         return this._shopView;
      }
      
      public function get mart() : StrikeAndExitVanguardMartView
      {
         return this._martView;
      }
      
      public function get helpBtn() : StatesButtonDecorator
      {
         return this._simpleWindow.helpBtn;
      }
      
      private function onTabChanged(param1:ITabItem) : void
      {
         this._simpleWindow.setSize(param1.view.width,param1.view.height);
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get refreshButton() : Button
      {
         return this._fuiCache.selectComponent("root.tabbarContainer.clearButton") as Button;
      }
   }
}

