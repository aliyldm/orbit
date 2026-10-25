package net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.root
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
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.RogueLiteUIWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model.TitleFrenzyUIOverviewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.model.TitleFrenzyUIOverviewProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.overview.view.TitleFrenzyUIOverviewMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.model.TitleFrenzyUIRankingRewardsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.titleFrenzy.rankingRewards.view.TitleFrenzyUIRankingRewardsMediator;
   
   public class TitleFrenzyUIMediator extends SimpleWindowMediator
   {
      
      private var _subviews:Vector.<ITabItem> = new Vector.<ITabItem>(0);
      
      private var _loadCounter:int = 0;
      
      private var _overviewData:TitleFrenzyUIOverviewData;
      
      private var _rankingRewardsData:TitleFrenzyUIRankingRewardsData;
      
      public function TitleFrenzyUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         var _loc1_:TitleFrenzyUIOverviewProxy = null;
         var _loc2_:TitleFrenzyUIRankingRewardsProxy = null;
         super.onRegister();
         facade.registerProxy(_loc1_ = new TitleFrenzyUIOverviewProxy(GuiConstants.TITLE_FRENZY_OVERVIEW));
         facade.registerProxy(_loc2_ = new TitleFrenzyUIRankingRewardsProxy(GuiConstants.TITLE_FRENZY_RANKING_REWARDS));
         registerMediator(new TitleFrenzyUIOverviewMediator(GuiConstants.TITLE_FRENZY_OVERVIEW,simpleWindow));
         registerMediator(new TitleFrenzyUIRankingRewardsMediator(GuiConstants.TITLE_FRENZY_RANKING_REWARDS,simpleWindow));
         this._overviewData = _loc1_.viewData;
         this._rankingRewardsData = _loc2_.viewData;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.loadAndBuildWithResKey(GuiConstants.TITLE_FRENZY_OVERVIEW,param1);
         this.loadAndBuildWithResKey(GuiConstants.TITLE_FRENZY_RANKING_REWARDS,param1);
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
         var _loc2_:TitleFrenzyUIView = new TitleFrenzyUIView(simpleWindow,this._subviews);
         this.manualLoadMediator(GuiConstants.TITLE_FRENZY_OVERVIEW,TitleFrenzyUIOverviewMediator,_loc2_.overview);
         this.manualLoadMediator(GuiConstants.TITLE_FRENZY_RANKING_REWARDS,TitleFrenzyUIRankingRewardsMediator,_loc2_.rankingRewards);
         var _loc3_:Map = ScreenManager.getInstance().map;
         if(RogueLiteUIWindowMediator.FORBIDDEN_MAP.indexOf(_loc3_.mapID) >= 0)
         {
            return;
         }
      }
   }
}

