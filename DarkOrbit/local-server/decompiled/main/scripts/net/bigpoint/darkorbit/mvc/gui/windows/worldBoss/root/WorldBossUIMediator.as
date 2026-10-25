package net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.root
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.com.module.porting.publicWorldBoss.PublicWorldBossRequest;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.RogueLiteUIWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.model.WorldBossUIOverviewData;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.model.WorldBossUIOverviewProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.view.WorldBossUIOverviewMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model.WorldBossUIProgressData;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.model.WorldBossUIProgressProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.progress.view.WorldBossUIProgressMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.model.WorldBossUIRankingRewardsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rankingRewards.view.WorldBossUIRankingRewardsMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.model.WorldBossUIRewardsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.rewards.view.WorldBossUIRewardsMediator;
   
   public class WorldBossUIMediator extends SimpleWindowMediator
   {
      
      private static const publicWorldBossRequest:PublicWorldBossRequest = new PublicWorldBossRequest(0);
      
      private var _subviews:Vector.<ITabItem> = new Vector.<ITabItem>(0);
      
      private var _loadCounter:int = 0;
      
      private var _overviewData:WorldBossUIOverviewData;
      
      private var _rewardsData:WorldBossUIRewardsData;
      
      private var _rankingRewardsData:WorldBossUIRankingRewardsData;
      
      private var _progressData:WorldBossUIProgressData;
      
      public function WorldBossUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         var _loc1_:WorldBossUIOverviewProxy = null;
         var _loc2_:WorldBossUIRewardsProxy = null;
         var _loc3_:WorldBossUIRankingRewardsProxy = null;
         var _loc4_:WorldBossUIProgressProxy = null;
         super.onRegister();
         facade.registerProxy(_loc1_ = new WorldBossUIOverviewProxy(GuiConstants.WORLD_BOSS_OVERVIEW));
         facade.registerProxy(_loc4_ = new WorldBossUIProgressProxy(GuiConstants.WORLD_BOSS_PROGRESS));
         facade.registerProxy(_loc2_ = new WorldBossUIRewardsProxy(GuiConstants.WORLD_BOSS_REWARDS));
         facade.registerProxy(_loc3_ = new WorldBossUIRankingRewardsProxy(GuiConstants.WORLD_BOSS_REWARDS_RANKING));
         registerMediator(new WorldBossUIOverviewMediator(GuiConstants.WORLD_BOSS_OVERVIEW,simpleWindow));
         registerMediator(new WorldBossUIProgressMediator(GuiConstants.WORLD_BOSS_PROGRESS,simpleWindow));
         registerMediator(new WorldBossUIRewardsMediator(GuiConstants.WORLD_BOSS_REWARDS,simpleWindow));
         registerMediator(new WorldBossUIRankingRewardsMediator(GuiConstants.WORLD_BOSS_REWARDS_RANKING,simpleWindow));
         this._overviewData = _loc1_.viewData;
         this._rewardsData = _loc2_.viewData;
         this._rankingRewardsData = _loc3_.viewData;
         this._progressData = _loc4_.viewData;
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.loadAndBuildWithResKey(GuiConstants.WORLD_BOSS_OVERVIEW,param1);
         this.loadAndBuildWithResKey(GuiConstants.WORLD_BOSS_PROGRESS,param1);
         this.loadAndBuildWithResKey(GuiConstants.WORLD_BOSS_REWARDS,param1);
         this.loadAndBuildWithResKey(GuiConstants.WORLD_BOSS_REWARDS_RANKING,param1);
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
         var map:Map;
         var _view:WorldBossUIView = null;
         var mediator:WorldBossUIMediator = null;
         var callbackParams:Array = param1;
         _view = new WorldBossUIView(simpleWindow,this._subviews);
         this.manualLoadMediator(GuiConstants.WORLD_BOSS_OVERVIEW,WorldBossUIOverviewMediator,_view.overview);
         this.manualLoadMediator(GuiConstants.WORLD_BOSS_PROGRESS,WorldBossUIProgressMediator,_view.progressRewards);
         this.manualLoadMediator(GuiConstants.WORLD_BOSS_REWARDS,WorldBossUIRewardsMediator,_view.rewards);
         this.manualLoadMediator(GuiConstants.WORLD_BOSS_REWARDS_RANKING,WorldBossUIRankingRewardsMediator,_view.rankingRewards);
         mediator = this;
         _view.refreshButton.visible = false;
         _view.refreshButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            simpleWindow.minimize();
            mediator.clear(GuiConstants.PUBLIC_WORLD_BOSS,GuiConstants.WORLD_BOSS_OVERVIEW,GuiConstants.WORLD_BOSS_REWARDS,GuiConstants.WORLD_BOSS_PROGRESS,GuiConstants.WORLD_BOSS_REWARDS_RANKING);
         });
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,publicWorldBossRequest);
         map = ScreenManager.getInstance().map;
         if(RogueLiteUIWindowMediator.FORBIDDEN_MAP.indexOf(map.mapID) >= 0)
         {
            return;
         }
      }
   }
}

