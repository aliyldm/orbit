package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root
{
   import com.bigpoint.utils.ui.buttons.StatesButtonDecorator;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.tooltip.DefaultTooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.components.tooltip.ITooltipDataAssigner;
   import net.bigpoint.darkorbit.fui.system.manager.TipUtil;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.view.components.ITabItem;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.model.StrikeAndExitOverviewProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.overview.view.StrikeAndExitOverviewMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.view.StrikeAndExitShopMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.vanguardMart.view.StrikeAndExitVanguardMartMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.worldBoss.overview.view.WorldBossUIOverviewMediator;
   
   public class StrikeAndExitUIMediator extends SimpleWindowMediator
   {
      
      private var _loadCounter:int = 0;
      
      private var _view:StrikeAndExitUIView;
      
      private var shop:StrikeAndExitShopMediator;
      
      private var overview:StrikeAndExitOverviewMediator;
      
      private var vanguardMart:StrikeAndExitVanguardMartMediator;
      
      private var helpBtn:StatesButtonDecorator;
      
      private var _currentTooltipContainer:Container;
      
      protected var _tooltipDataAssigner:ITooltipDataAssigner = new DefaultTooltipDataAssigner();
      
      protected var _tooltipData:Object;
      
      protected var _showTooltipIntervalID:uint = 0;
      
      public function StrikeAndExitUIMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
         param2.helpBtn.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         param2.helpBtn.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
      }
      
      protected function mouseOver(param1:MouseEvent) : void
      {
         this._showTooltipIntervalID = setTimeout(this.showTooltip,300);
      }
      
      protected function mouseOut(param1:*) : void
      {
         TipUtil.removeCurrentTooltipContainer(this._currentTooltipContainer);
         clearTimeout(this._showTooltipIntervalID);
      }
      
      protected function showTooltip() : void
      {
         if(this.helpBtn)
         {
            if(!this._tooltipData)
            {
               this._tooltipData = BPLocale.getItem("strikeandexit_info");
            }
            if(!this._currentTooltipContainer)
            {
               this._currentTooltipContainer = TipUtil.createTip("SAE_TIP");
            }
            TipUtil.showTip(this.helpBtn,this._currentTooltipContainer,this._tooltipDataAssigner,this._tooltipData);
         }
      }
      
      override public function onRegister() : void
      {
         var _loc1_:StrikeAndExitShopProxy = null;
         var _loc2_:StrikeAndExitOverviewProxy = null;
         var _loc3_:StrikeAndExitShopProxy = null;
         super.onRegister();
         facade.registerProxy(_loc1_ = new StrikeAndExitShopProxy(GuiConstants.STRIKE_AND_EXIT_SHOP));
         this.shop = new StrikeAndExitShopMediator(GuiConstants.STRIKE_AND_EXIT_SHOP,simpleWindow,_loc1_.viewData);
         registerMediator(this.shop);
         facade.registerProxy(_loc2_ = new StrikeAndExitOverviewProxy(GuiConstants.STRIKE_AND_EXIT_OVERVIEW));
         this.overview = new StrikeAndExitOverviewMediator(GuiConstants.STRIKE_AND_EXIT_OVERVIEW,simpleWindow,_loc2_.viewData);
         registerMediator(this.overview);
         facade.registerProxy(_loc3_ = new StrikeAndExitShopProxy(GuiConstants.STRIKE_AND_EXIT_VANGUARD_MART));
         this.vanguardMart = new StrikeAndExitVanguardMartMediator(simpleWindow,_loc3_.viewData);
         registerMediator(this.vanguardMart);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this.loadAndBuildWithResKey(GuiConstants.STRIKE_AND_EXIT_SHOP,param1);
         this.loadAndBuildWithResKey(GuiConstants.STRIKE_AND_EXIT_OVERVIEW,param1);
         this.loadAndBuildWithResKey(GuiConstants.STRIKE_AND_EXIT_VANGUARD_MART,param1);
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
         var mediator:StrikeAndExitUIMediator = null;
         var callbackParams:Array = param1;
         mediator = this;
         this._view = new StrikeAndExitUIView(simpleWindow);
         this.helpBtn = this._view.helpBtn;
         this.shop.setView(this._view.shop);
         this.overview.setView(this._view.overview);
         this.vanguardMart.setView(this._view.mart);
         this.manualLoadMediator(GuiConstants.STRIKE_AND_EXIT_OVERVIEW,WorldBossUIOverviewMediator,this._view.overview);
         this.manualLoadMediator(GuiConstants.STRIKE_AND_EXIT_SHOP,WorldBossUIOverviewMediator,this._view.shop);
         this.manualLoadMediator(GuiConstants.STRIKE_AND_EXIT_VANGUARD_MART,WorldBossUIOverviewMediator,this._view.mart);
         this._view.refreshButton.visible = false;
         this._view.refreshButton.addEventListener(MouseEvent.CLICK,function(param1:MouseEvent):void
         {
            simpleWindow.minimize();
            mediator.clear(GuiConstants.STRIKE_AND_EXIT,GuiConstants.STRIKE_AND_EXIT_SHOP,GuiConstants.STRIKE_AND_EXIT_OVERVIEW,GuiConstants.STRIKE_AND_EXIT_VANGUARD_MART);
         });
         this.overview.refreshData();
         this._view.tab.tabChanged.add(this.tsbChanged);
      }
      
      private function testUI(param1:Event) : void
      {
         var _loc4_:SimpleWindowCreationVO = null;
         var _loc2_:String = GuiConstants.STRIKE_AND_EXIT_INFO;
         var _loc3_:IWindow = guiManager.getWindow(_loc2_);
         if(!_loc3_)
         {
            _loc4_ = SimpleWindowCreationMap.getById(_loc2_);
            if(_loc4_)
            {
               facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,_loc4_);
               _loc3_ = guiManager.getWindow(_loc2_);
            }
            else
            {
               _loc3_ = guiManager.createWindow(_loc2_);
            }
         }
         _loc3_.maximize();
      }
      
      private function tsbChanged(param1:*) : void
      {
         if(param1)
         {
            if(param1 == this._view.shop)
            {
               this.shop.refreshData();
            }
            if(param1 == this._view.overview)
            {
               this.overview.refreshData();
            }
            if(param1 == this._view.mart)
            {
               this.vanguardMart.refreshData();
            }
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
   }
}

