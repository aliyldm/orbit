package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.ExpeditionNotification;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab.ExpeditionInfoTabMediator1;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab.ExpeditionInfoTabMediator2;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab.ExpeditionInfoTabMediator3;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab.ExpeditionInfoTabMediator4;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.ExpeditionInfoProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.ExpeditionInfoView;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.ExpeditionTabAssigner;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView1;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView2;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView3;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView4;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.darkorbit.utils.URLLoaderUtils;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ExpeditionInfoMediator extends SimpleWindowMediator
   {
      
      private var _loadCounter:int = 0;
      
      private var _view:ExpeditionInfoView;
      
      private var tab1:ExpeditionInfoTabView1;
      
      private var tab2:ExpeditionInfoTabView2;
      
      private var tab3:ExpeditionInfoTabView3;
      
      private var tab4:ExpeditionInfoTabView4;
      
      private var tabMediator1:ExpeditionInfoTabMediator1;
      
      private var tabMediator2:ExpeditionInfoTabMediator2;
      
      private var tabMediator3:ExpeditionInfoTabMediator3;
      
      private var tabMediator4:ExpeditionInfoTabMediator4;
      
      private var _tabView:ExtendedTabView;
      
      public const EXPEDITION_REWARD_TAB1:String = "expedition_tab1";
      
      public const EXPEDITION_REWARD_TAB2:String = "expedition_tab2";
      
      public const EXPEDITION_REWARD_TAB3:String = "expedition_tab3";
      
      public const EXPEDITION_REWARD_TAB4:String = "expedition_tab4";
      
      public function ExpeditionInfoMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.tabMediator1 = new ExpeditionInfoTabMediator1(this.EXPEDITION_REWARD_TAB1,simpleWindow);
         this.tabMediator2 = new ExpeditionInfoTabMediator2(this.EXPEDITION_REWARD_TAB2,simpleWindow);
         this.tabMediator3 = new ExpeditionInfoTabMediator3(this.EXPEDITION_REWARD_TAB3,simpleWindow);
         this.tabMediator4 = new ExpeditionInfoTabMediator4(this.EXPEDITION_REWARD_TAB4,simpleWindow);
         facade.registerMediator(this.tabMediator1);
      }
      
      private function onShowHandler(param1:SimpleWindowEvent) : void
      {
      }
      
      private function onCloseHandler(param1:SimpleWindowEvent) : void
      {
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         simpleWindow.getUIContainer().visible = false;
         this.loadAndBuildWithResKey(this.EXPEDITION_REWARD_TAB1,param1);
         this.loadAndBuildWithResKey(this.EXPEDITION_REWARD_TAB2,param1);
         this.loadAndBuildWithResKey(this.EXPEDITION_REWARD_TAB3,param1);
         this.loadAndBuildWithResKey(this.EXPEDITION_REWARD_TAB4,param1);
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param1);
         }
      }
      
      protected function handleFinalContentLoaded(param1:Array) : void
      {
         var _loc2_:String = Settings.staticHost + "xml/events/expedition/expedition-boxes.xml?__cv=";
         URLLoaderUtils.getInstance().load(_loc2_,this.loadComplete);
      }
      
      private function loadComplete(param1:*) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         (simpleWindow as SimpleWindow).removeInprogressOverLay();
         simpleWindow.getUIContainer().visible = true;
         ExpeditionInfoProxy.getProxy(this.facade).viewData.setBoxesReward(param1);
         this._view = new ExpeditionInfoView(simpleWindow);
         this.tab1 = new ExpeditionInfoTabView1(this._view.root);
         this.tab2 = new ExpeditionInfoTabView2(this._view.root);
         this.tab3 = new ExpeditionInfoTabView3(this._view.root);
         this.tab4 = new ExpeditionInfoTabView4(this._view.root);
         this._tabView = new ExtendedTabView(simpleWindow.getUIContainer(),ExpeditionTabAssigner);
         this._tabView.tabItems = new <ITabItem>[this.tab1,this.tab2,this.tab3,this.tab4];
         this.tabMediator1.setView(this.tab1);
         this.tabMediator2.setView(this.tab2);
         this.tabMediator3.setView(this.tab3);
         this.tabMediator4.setView(this.tab4);
         this._tabView.tabChanged.add(this.tabChanged);
         this.updateView();
      }
      
      private function tabChanged(param1:*) : void
      {
         this.updateView();
      }
      
      private function updateView() : void
      {
         if(_uiReady)
         {
            this._view.inactiveContainer.removeEventListener(Event.ENTER_FRAME,this.handleCogEnterFrameEvent);
            if(ExpeditionInfoProxy.getProxy(this.facade).viewData.availabled)
            {
               this._view.root.visible = true;
               this._view.inactiveContainer.visible = false;
               switch(this._tabView.tabbar.selectedIndex)
               {
                  case 0:
                     this.tabMediator1.update();
                     break;
                  case 1:
                     this.tabMediator2.update();
                     break;
                  case 2:
                     this.tabMediator3.update();
                     break;
                  case 3:
                     this.tabMediator4.update();
               }
            }
            else
            {
               this._view.root.visible = false;
               this._view.inactiveContainer.visible = true;
               this._view.inactiveContainer.addEventListener(Event.ENTER_FRAME,this.handleCogEnterFrameEvent);
            }
         }
      }
      
      private function handleCogEnterFrameEvent(param1:Event) : void
      {
         this._view.cogSmall.rotation += -1;
         this._view.cogBig.rotation += 1;
      }
      
      private function loadAndBuildWithResKey(param1:String, param2:Array) : void
      {
         ++this._loadCounter;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc3_,this._internalHandleBuildComplete,[_loc3_,param2]);
      }
      
      private function _internalHandleBuildComplete(param1:Sprite, param2:Array) : void
      {
         var _loc4_:Container = null;
         var _loc3_:DisplayObjectContainer = window.getUIContainer().getChildByName("root") as DisplayObjectContainer;
         _loc4_ = param1.getChildAt(0) as Container;
         _loc4_.visible = false;
         _loc3_.addChild(_loc4_.getChildAt(0));
         --this._loadCounter;
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param2);
         }
      }
      
      override public function listNotificationInterests() : Array
      {
         return [ExpeditionNotification.DATA_AVAILABLED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         var _loc2_:String = param1.getName();
         switch(_loc2_)
         {
            case ExpeditionNotification.DATA_AVAILABLED:
               this.updateView();
         }
      }
   }
}

