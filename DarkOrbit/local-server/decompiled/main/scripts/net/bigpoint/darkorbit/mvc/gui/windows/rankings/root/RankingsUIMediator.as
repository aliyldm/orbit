package net.bigpoint.darkorbit.mvc.gui.windows.rankings.root
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.RankingsUIEventsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.model.RankingsUIEventsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.rankings.events.root.view.RankingsUIEventsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.RogueLiteUIWindowMediator;
   
   public class RankingsUIMediator extends SimpleWindowMediator
   {
      
      private var _subviews:Vector.<ITabItem> = new Vector.<ITabItem>(0);
      
      private var _loadCounter:int = 0;
      
      private var _eventsData:RankingsUIEventsData;
      
      public function RankingsUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         var _loc1_:RankingsUIEventsProxy = null;
         super.onRegister();
         facade.registerProxy(_loc1_ = new RankingsUIEventsProxy(GuiConstants.RANKINGS_EVENTS));
         registerMediator(new RankingsUIEventsMediator(GuiConstants.RANKINGS_EVENTS,simpleWindow));
         this._eventsData = _loc1_.viewData;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.loadAndBuildWithResKey(GuiConstants.RANKINGS_EVENTS,param1);
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
         var _loc2_:RankingsUIView = new RankingsUIView(simpleWindow,this._subviews);
         this.manualLoadMediator(GuiConstants.RANKINGS_EVENTS,RankingsUIEventsMediator,_loc2_.events);
         var _loc3_:Map = ScreenManager.getInstance().map;
         if(RogueLiteUIWindowMediator.FORBIDDEN_MAP.indexOf(_loc3_.mapID) >= 0)
         {
            return;
         }
      }
   }
}

