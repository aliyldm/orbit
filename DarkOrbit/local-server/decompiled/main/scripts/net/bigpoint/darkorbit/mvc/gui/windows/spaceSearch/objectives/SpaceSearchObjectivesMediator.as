package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.TabSpaceSearchMissionsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.TabSpaceSearchMissionsView;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.missions.model.TabSpaceSearchMissionsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.TabSpaceSearchRewardsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.TabSpaceSearchRewardsView;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model.TabSpaceSearchRewardsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchRedDotData;
   import net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.ui.model.SpaceSearchRedDotProxy;
   
   public class SpaceSearchObjectivesMediator extends SimpleWindowMediator
   {
      
      private var _loadCounter:int = 0;
      
      private var missions:TabSpaceSearchMissionsMediator;
      
      private var rewards:TabSpaceSearchRewardsMediator;
      
      private var _view:SpaceSearchObjectivesView;
      
      private var redDotData:SpaceSearchRedDotData;
      
      public function SpaceSearchObjectivesMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this.missions = new TabSpaceSearchMissionsMediator(GuiConstants.SPACE_SEARCH_OBJECTIVES_MISSIONS,simpleWindow,TabSpaceSearchMissionsProxy.getOrCreateProxy(this.facade).viewData);
         facade.registerMediator(this.missions);
         this.rewards = new TabSpaceSearchRewardsMediator(GuiConstants.SPACE_SEARCH_OBJECTIVES_REWARDS,simpleWindow,TabSpaceSearchRewardsProxy.getOrCreateProxy(this.facade).viewData);
         facade.registerMediator(this.rewards);
         this.redDotData = SpaceSearchRedDotProxy.getOrCreateProxy(this.facade).viewData;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.loadAndBuildWithResKey(GuiConstants.SPACE_SEARCH_OBJECTIVES_MISSIONS,param1);
         this.loadAndBuildWithResKey(GuiConstants.SPACE_SEARCH_OBJECTIVES_REWARDS,param1);
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
         var mediator:SpaceSearchObjectivesMediator = null;
         var callbackParams:Array = param1;
         mediator = this;
         this._view = new SpaceSearchObjectivesView(simpleWindow);
         this.missions.setView(this._view.missionsView);
         this.rewards.setView(this._view.rewardsView);
         this._view.clearButton.visible = false;
         this._view.clearButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            simpleWindow.minimize();
            mediator.clear(GuiConstants.SPACE_SEARCH_OBJECTIVES);
            mediator.clear(GuiConstants.SPACE_SEARCH_OBJECTIVES_MISSIONS);
            mediator.clear(GuiConstants.SPACE_SEARCH_OBJECTIVES_REWARDS);
         });
         this.manualLoadMediator(GuiConstants.SPACE_SEARCH_OBJECTIVES_MISSIONS,TabSpaceSearchMissionsView,this._view.missionsView);
         this.manualLoadMediator(GuiConstants.SPACE_SEARCH_OBJECTIVES_REWARDS,TabSpaceSearchRewardsView,this._view.rewardsView);
         this.missions.refreshData();
         this._view.tab.tabChanged.add(this.tsbChanged);
         this.redDotData.tryUpdate();
      }
      
      private function tsbChanged(param1:*) : void
      {
         if(param1)
         {
            if(param1 == this._view.missionsView)
            {
               this.missions.refreshData();
            }
            else if(param1 == this._view.rewardsView)
            {
               this.rewards.refreshData();
            }
         }
         this.redDotData.tryUpdate();
      }
      
      private function manualLoadMediator(param1:String, param2:Class, param3:ITabItem) : void
      {
         var _loc4_:* = retrieveMediator(param1) as param2;
         if(_loc4_ != null)
         {
            _loc4_.manualLoad(param3);
         }
      }
   }
}

