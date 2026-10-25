package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.com.module.porting.trinitytrials.TrinityTrialsUIRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ExtendedTabView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab.TrinityTrialsDropInfoView;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab.TrinityTrialsDropInfoViewMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab.TrinityTrialsRewardView;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab.TrinityTrialsRewardViewMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab.TrinityTrialsUpLevelView;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab.TrinityTrialsUpLevelViewMediator;
   
   public class TrinityTrialsMainViewMediator extends SimpleWindowMediator
   {
      
      private var _view:TrinityTrialsMainView;
      
      private var _tab1View:TrinityTrialsRewardView;
      
      private var _tab1ViewMediator:TrinityTrialsRewardViewMediator;
      
      private var _tab2View:TrinityTrialsUpLevelView;
      
      private var _tab2ViewMediator:TrinityTrialsUpLevelViewMediator;
      
      private var _tab3View:TrinityTrialsDropInfoView;
      
      private var _tab3ViewMediator:TrinityTrialsDropInfoViewMediator;
      
      private var _loadCounter:int = 0;
      
      public function TrinityTrialsMainViewMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         this._tab1ViewMediator = new TrinityTrialsRewardViewMediator(TrinityTrialsConst.TAB_1,this.simpleWindow);
         facade.registerMediator(this._tab1ViewMediator);
         this._tab2ViewMediator = new TrinityTrialsUpLevelViewMediator(TrinityTrialsConst.TAB_2,this.simpleWindow);
         facade.registerMediator(this._tab2ViewMediator);
         this._tab3ViewMediator = new TrinityTrialsDropInfoViewMediator(TrinityTrialsConst.TAB_3,this.simpleWindow);
         facade.registerMediator(this._tab3ViewMediator);
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE_CLICKED,this.clearTab);
      }
      
      private function clearTab(param1:*) : void
      {
         if(this._tab1ViewMediator)
         {
            this._tab1ViewMediator.isFirst = true;
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         this._view = new TrinityTrialsMainView(this.simpleWindow);
         simpleWindow.getUIContainer().visible = false;
         this._view.numChildren;
         this.loadAndBuildWithResKey(TrinityTrialsConst.TAB_1,param1);
         this.loadAndBuildWithResKey(TrinityTrialsConst.TAB_2,param1);
         this.loadAndBuildWithResKey(TrinityTrialsConst.TAB_3,param1);
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param1);
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
         simpleWindow.getUIContainer().visible = true;
         super.handleLoadAndBuildContentCallback(param1);
         var _loc2_:ExtendedTabView = new ExtendedTabView(simpleWindow.getUIContainer());
         _loc2_.tabChanged.add(this.changeView);
         this._tab1View = new TrinityTrialsRewardView(this._view.viewRoot);
         this._tab2View = new TrinityTrialsUpLevelView(this._view.viewRoot);
         this._tab3View = new TrinityTrialsDropInfoView(this._view.viewRoot);
         _loc2_.tabItems = new <ITabItem>[this._tab1View,this._tab2View,this._tab3View];
         this._tab1ViewMediator.setView(this._tab1View);
         this._tab2ViewMediator.setView(this._tab2View);
         this._tab3ViewMediator.setView(this._tab3View);
      }
      
      private function changeView(param1:ITabItem) : *
      {
         var _loc2_:int = 0;
         var _loc3_:TrinityTrialsMainProxy = TrinityTrialsMainProxy.getProxy();
         switch(param1.title)
         {
            case this._tab1View.title:
               _loc2_ = TrinityTrialsUIRequest.OPTIONALTYPE_PASS;
               _loc3_.sendUIRequest(_loc2_);
               break;
            case this._tab2View.title:
               _loc2_ = TrinityTrialsUIRequest.OPTIONALTYPE_DROP_LEVEL;
               _loc3_.sendUIRequest(_loc2_);
         }
      }
   }
}

