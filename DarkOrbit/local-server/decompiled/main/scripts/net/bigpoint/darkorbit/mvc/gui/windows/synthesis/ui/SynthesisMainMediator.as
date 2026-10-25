package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemListEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.CannonSynthesisProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.SynthesisConst;
   
   public class SynthesisMainMediator extends SimpleWindowMediator
   {
      
      public const SYNTHESISVIEWXML:String = "synthesis_upgrade";
      
      private var _view:SynthesisMain;
      
      private var _synthesisView:CannonSynthesisView;
      
      private var _synthesisViewMediator:CannonSynthesisViewMediator;
      
      private var _proxy:CannonSynthesisProxy;
      
      private var _currentType:String;
      
      private var _loadCounter:int = 0;
      
      public function SynthesisMainMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._proxy = CannonSynthesisProxy.getProxy(GameFacade.getInstance());
         this._proxy.viewData.change.add(this.handleDataChanged);
         this._synthesisViewMediator = new CannonSynthesisViewMediator(SynthesisConst.SYNTHESIS + "_content",simpleWindow);
         this._synthesisViewMediator.useInternalTypeButtons = false;
         facade.registerMediator(this._synthesisViewMediator);
      }
      
      override public function onRemove() : void
      {
         if(Boolean(this._view) && Boolean(this._view.tabbar))
         {
            this._view.tabbar.removeEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabChanged);
         }
         if(this._proxy)
         {
            this._proxy.viewData.change.remove(this.handleDataChanged);
         }
         if(this._synthesisViewMediator)
         {
            facade.removeMediator(this._synthesisViewMediator.getMediatorName());
         }
         super.onRemove();
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         simpleWindow.getUIContainer().visible = false;
         this.loadAndBuildWithResKey(this.SYNTHESISVIEWXML,param1);
         if(this._loadCounter == 0)
         {
            this.loadComplete(param1);
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
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:Container = null;
         _loc3_ = window.getUIContainer().getChildByName("root") as DisplayObjectContainer;
         _loc4_ = param1.getChildAt(0) as Container;
         _loc4_.visible = false;
         _loc3_.addChild(_loc4_.getChildAt(0));
         --this._loadCounter;
         if(this._loadCounter == 0)
         {
            this.loadComplete(param2);
         }
      }
      
      private function loadComplete(param1:*) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         (simpleWindow as SimpleWindow).removeInprogressOverLay();
         simpleWindow.getUIContainer().visible = true;
         this._view = new SynthesisMain(simpleWindow);
         this._view.tabbar.itemDataAssigner = SynthesisTabAssigner;
         this._view.tabbar.addEventListener(ItemListEvent.ITEM_SELECTION_CHANGED,this.handleTabChanged);
         this._synthesisView = new CannonSynthesisView(simpleWindow);
         this._synthesisViewMediator.setView(this._synthesisView);
         this._uiReady = true;
         this.refreshTabsAndData();
      }
      
      private function handleDataChanged() : void
      {
         this.refreshTabsAndData();
      }
      
      private function refreshTabsAndData() : void
      {
         if(!this._uiReady || !this._proxy || !this._proxy.viewData.viewListDataComplet)
         {
            return;
         }
         this.refreshTabs();
         if((Boolean(!this._currentType || this._proxy.viewData.getTabTypeIndex(this._currentType) < 0)) && Boolean(this._proxy.viewData.MainTabTypes) && this._proxy.viewData.MainTabTypes.length > 0)
         {
            this._currentType = this._proxy.viewData.MainTabTypes[0];
         }
         this._synthesisViewMediator.useInternalTypeButtons = true;
         this._synthesisViewMediator.refreshData(this._proxy.viewData,this._currentType);
      }
      
      private function refreshTabs() : void
      {
         var _loc1_:Vector.<String> = this._proxy.viewData.MainTabTypes;
         this._view.tabbar.list = new VectorCollection(_loc1_);
         var _loc2_:int = this._currentType ? this._proxy.viewData.getTabTypeIndex(this._currentType) : 0;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         this._view.tabbar.selectedIndex = _loc2_;
      }
      
      private function handleTabChanged(param1:ItemListEvent) : void
      {
         var _loc2_:int = this._view.tabbar.selectedIndex;
         if(_loc2_ < 0 || _loc2_ >= this._proxy.viewData.MainTabTypes.length)
         {
            return;
         }
         this._currentType = this._proxy.viewData.MainTabTypes[_loc2_];
         this._synthesisViewMediator.refreshData(this._proxy.viewData,this._currentType);
      }
   }
}

