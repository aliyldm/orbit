package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.main.view
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorCache;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.view.DispatchGateView;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.main.view.components.DispatchTabBarAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.view.DispatchRetrieverView;
   
   public class DispatchRootView
   {
      
      private var _fuiCache:FuiComponentSelectorCache;
      
      private var _tabView:ExtendedTabView;
      
      private var _uiContainer:Sprite;
      
      private var _simpleWindow:SimpleWindow;
      
      private var _retrieverView:DispatchRetrieverView;
      
      private var _gateView:DispatchGateView;
      
      public function DispatchRootView(param1:SimpleWindow)
      {
         super();
         this._uiContainer = param1.getUIContainer();
         this._simpleWindow = param1;
         this._fuiCache = new FuiComponentSelectorCache(this._uiContainer);
         this._tabView = new ExtendedTabView(this._uiContainer,DispatchTabBarAssigner);
         this._retrieverView = new DispatchRetrieverView(this.root);
         this._gateView = new DispatchGateView(this.root);
         this._tabView.tabItems = new <ITabItem>[this._retrieverView,this._gateView];
      }
      
      public function get root() : Coreponent
      {
         return this._fuiCache.selectComponent("root") as Coreponent;
      }
      
      public function get retriever() : DispatchRetrieverView
      {
         return this._retrieverView;
      }
      
      public function get gate() : DispatchGateView
      {
         return this._gateView;
      }
      
      public function get tabView() : ExtendedTabView
      {
         return this._tabView;
      }
      
      public function get labelTitle() : Label
      {
         return this._fuiCache.selectComponent("root.main.title") as Label;
      }
      
      public function get iconEvent() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.eventIcon") as Coreponent;
      }
      
      public function get iconPermitPlus() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.top.res_permit_plus.icon") as Coreponent;
      }
      
      public function get iconPermit() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.top.res_permit.icon") as Coreponent;
      }
      
      public function get iconGGEU() : Coreponent
      {
         return this._fuiCache.selectComponent("root.main.top.res_ggeu.icon") as Coreponent;
      }
      
      public function get labelPermitPlus() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.res_permit_plus.amount_bg.amount") as Label;
      }
      
      public function get labelPermit() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.res_permit.amount_bg.amount") as Label;
      }
      
      public function get labelGGEU() : Label
      {
         return this._fuiCache.selectComponent("root.main.top.res_ggeu.amount_bg.amount") as Label;
      }
      
      public function get btnHelp() : Button
      {
         return this._fuiCache.selectComponent("root.main.help_btn") as Button;
      }
      
      public function get labelQuickDelivery() : Label
      {
         return this._fuiCache.selectComponent("root.retriever.side.quick_delivery.amount_bg.amount") as Label;
      }
   }
}

