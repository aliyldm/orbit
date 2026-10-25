package net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.view
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.RankingsEventsInfoRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.list.dropdownbox.DropDownBoxEvent;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.model.ConnectionProxy;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.RankingsUIEventsData;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RankingsUIEventsMediator extends SimpleWindowMediator
   {
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _data:RankingsUIEventsData;
      
      private var _view:RankingsUIEventsView;
      
      private var _maximise:Boolean;
      
      private var _loadCounter:int = 0;
      
      public function RankingsUIEventsMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._view = new RankingsUIEventsView(simpleWindow);
         this.initFilteredViews();
         if(this._loadCounter == 0)
         {
            this.handleFinalContentLoaded(param1);
         }
      }
      
      public function manualLoad(param1:RankingsUIEventsView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         this._view = param1;
         this.initFilteredViews();
      }
      
      override public function onRemove() : void
      {
         this.removeListeners();
         super.onRemove();
         this._data = null;
      }
      
      private function initFilteredViews() : void
      {
         this.loadAndBuildWithResKey(GuiConstants.RANKINGS_EVENTS_WORLDBOSS,null);
         this.loadAndBuildWithResKey(GuiConstants.RANKINGS_EVENTS_TITLE_FRENZY,null);
      }
      
      private function loadAndBuildWithResKey(param1:String, param2:Array) : void
      {
         ++this._loadCounter;
         var _loc3_:DisplayObjectContainer = new Sprite();
         UISystem.getInstance().loadAndBuildWithResKey(param1,_loc3_,this._internalHandleBuildComplete,[_loc3_,param2]);
      }
      
      private function _internalHandleBuildComplete(param1:Sprite, param2:Array) : void
      {
         var _loc3_:DisplayObjectContainer = this._view.eventsRoot as DisplayObjectContainer;
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
         this.addListeners();
         this._view.init();
         this.data = retrieveWindowProxy().getData() as RankingsUIEventsData;
         this.buildCompleted.dispatch(this._view);
      }
      
      public function set data(param1:RankingsUIEventsData) : void
      {
         if(this._data)
         {
            this._data.changed.remove(this.onUpdate);
            this._data.countdown.changed.remove(this.onCountdownUpdate);
         }
         this._data = param1;
         if(this._data)
         {
            this._data.changed.add(this.onUpdate);
            this._data.countdown.changed.add(this.onCountdownUpdate);
            this.init();
         }
      }
      
      private function addListeners() : void
      {
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE_CLICKED,this.onWindowMinimize);
         window.addEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onWindowMaximize);
         this._view.filterBox.addEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onEventSelected);
         this._view.rankTypeChanged.add(this.onRankTypeUpdate);
      }
      
      private function removeListeners() : void
      {
         window.removeEventListener(SimpleWindowEvent.ON_MINIMIZE_CLICKED,this.onWindowMinimize);
         window.removeEventListener(SimpleWindowEvent.ON_MAXIMIZED,this.onWindowMaximize);
         this._view.filterBox.removeEventListener(DropDownBoxEvent.SELECTED_ENTRY_CHANGED,this.onEventSelected);
         this._view.rankTypeChanged.remove(this.onRankTypeUpdate);
      }
      
      private function init() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._data.eventRunning.value = false;
         this._maximise = true;
         this._view.currView.active = false;
         this.onEventSelected(null);
      }
      
      private function onUpdate() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.currView.updateRanking(this._data.rankings);
         this._view.currView.active = this._data.eventRunning.value;
         this._view.disableInteraction(false);
         this.onCountdownUpdate();
      }
      
      private function onWindowMaximize(param1:SimpleWindowEvent) : void
      {
         this._maximise = true;
      }
      
      private function onWindowMinimize(param1:SimpleWindowEvent) : void
      {
         this._maximise = false;
      }
      
      private function onEventSelected(param1:DropDownBoxEvent) : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         this._view.labelTitle.text = BPLocale.getItem(this._view.filterBox.currentEntryKey);
         this._view.setEventView(this._view.filterBox.currentEntryKey);
      }
      
      private function onRankTypeUpdate(param1:int) : void
      {
         this._data.rankType.value = param1;
         this.sendUpdateDataRequest();
      }
      
      private function sendUpdateDataRequest() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         var _loc1_:ConnectionProxy = facade.retrieveProxy(ConnectionProxy.NAME) as ConnectionProxy;
         _loc1_.sendNettyRequest(new RankingsEventsInfoRequest(this._data.rankType.value));
      }
      
      private function onCountdownUpdate() : void
      {
         if(this._data == null || !isUIReady())
         {
            return;
         }
         if(this._data.countdown.value <= 0)
         {
            this._data.setCountdown();
            if(this._data.eventRunning.value && this._maximise)
            {
               this.sendUpdateDataRequest();
            }
            return;
         }
      }
   }
}

