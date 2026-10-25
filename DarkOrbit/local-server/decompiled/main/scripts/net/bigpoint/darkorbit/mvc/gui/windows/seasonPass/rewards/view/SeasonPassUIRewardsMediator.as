package net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.HighlightTypeModule;
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardClaimAllRequest;
   import net.bigpoint.darkorbit.com.module.SeasonPassRewardClaimRequest;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.featuresMenu.FeaturesMenuConstants;
   import net.bigpoint.darkorbit.mvc.gui.highlights.HighLightItemNotification;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.CreatePopupView;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.SeasonPassUIPopUpUtils;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model.SeasonPassUIData;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.main.model.SeasonPassUIProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.SeasonPassUIRewardsData;
   import net.bigpoint.darkorbit.mvc.gui.windows.seasonPass.rewards.model.vo.SeasonPassLevelItemVO;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class SeasonPassUIRewardsMediator extends SimpleWindowMediator
   {
      
      public static const RED_DOT_HIGHLIGHTER:HighlightItemVO = new HighlightItemVO(GuiConstants.SEASON_PASS,FeaturesMenuConstants.MENU_ID,HighlightTypeModule.HIGHLIGHTTYPE_RED_DOT);
      
      public var buildCompleted:ISignal = new Signal();
      
      private var _rewardsData:SeasonPassUIRewardsData;
      
      private var _view:SeasonPassUIRewardsView;
      
      private var _seasonPassData:SeasonPassUIData;
      
      public function SeasonPassUIRewardsMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this._rewardsData = null;
      }
      
      public function set rewardsData(param1:SeasonPassUIRewardsData) : void
      {
         if(this._rewardsData)
         {
            this._rewardsData.onSeasonPassItemChanged.removeAll();
         }
         this._rewardsData = param1;
         if(this._rewardsData)
         {
            this._rewardsData.onSeasonPassItemChanged.add(this.updateGoldPassStatus);
            this._rewardsData.onSeasonPassItemChanged.add(this.updateClaimableStatus);
            this.update();
         }
      }
      
      public function set seasonPassData(param1:SeasonPassUIData) : void
      {
         if(this._seasonPassData)
         {
            this._seasonPassData.levelServer.changed.remove(this.updateLevel);
         }
         this._seasonPassData = param1;
         if(this._seasonPassData)
         {
            this._seasonPassData.levelServer.changed.add(this.updateLevel);
         }
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         var _loc2_:SeasonPassUIProxy = retrieveProxy(GuiConstants.SEASON_PASS) as SeasonPassUIProxy;
         this.seasonPassData = _loc2_.viewData;
         this._view = new SeasonPassUIRewardsView(simpleWindow);
         this.rewardsData = retrieveWindowProxy().getData() as SeasonPassUIRewardsData;
         this.addListeners();
         this.buildCompleted.dispatch(this._view);
      }
      
      private function addListeners() : void
      {
         this._view.claimAllButton.addEventListener(MouseEvent.CLICK,this.onClickClaimAll);
         this._view.buyGoldPassButton.addEventListener(MouseEvent.CLICK,this.onClickBuyGoldPass);
         this._view.buyExtGoldPassButton.addEventListener(MouseEvent.CLICK,this.onClickBuyExtGoldPass);
         this._view.nextPageButton.addEventListener(MouseEvent.CLICK,this.onClickNextPage);
         this._view.prevPageButton.addEventListener(MouseEvent.CLICK,this.onClickPrevPage);
         this._view.firstPageButton.addEventListener(MouseEvent.CLICK,this.onClickFirstPage);
         this._view.lastPageButton.addEventListener(MouseEvent.CLICK,this.onClickLastPage);
         this._view.level50Button.addEventListener(MouseEvent.CLICK,this.onClickLevel50Page);
      }
      
      public function manualLoad(param1:SeasonPassUIRewardsView) : void
      {
         super.handleLoadAndBuildContentCallback(null);
         var _loc2_:SeasonPassUIProxy = retrieveProxy(GuiConstants.SEASON_PASS) as SeasonPassUIProxy;
         this.seasonPassData = _loc2_.viewData;
         this._view = param1;
         this.rewardsData = retrieveWindowProxy().getData() as SeasonPassUIRewardsData;
         this.addListeners();
      }
      
      public function update() : void
      {
         if(this._rewardsData == null || !isUIReady())
         {
            return;
         }
         this.updateItems();
         this._view.buyGoldPassButton.visible = this._rewardsData.goldPassLocked;
         this._view.buyExtGoldPassButton.visible = this._rewardsData.extGoldPassLocked;
         this.updateLevel();
      }
      
      public function onClickClaim(param1:int, param2:Boolean, param3:Boolean) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SeasonPassRewardClaimRequest(param1,param2,param3));
      }
      
      public function get goldPassLocked() : Boolean
      {
         return this._rewardsData.goldPassLocked;
      }
      
      private function onClickClaimAll(param1:Event) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new SeasonPassRewardClaimAllRequest());
      }
      
      private function onClickBuyGoldPass(param1:Event) : void
      {
         var event:Event = param1;
         var handleOk:Function = function():void
         {
            JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials",null);
         };
         SeasonPassUIPopUpUtils.createPopupBanner(GuiConstants.SEASON_PASS_POPUP_BUY_GOLD_PASS,handleOk);
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["seasonPass"]);
      }
      
      private function onClickBuyExtGoldPass(param1:Event) : void
      {
         if(this._rewardsData.goldPassLocked)
         {
            CreatePopupView.getInstance().createPopup(this.buyExtGoldPass,BPLocale.getItem("sp_popup_buy_extra-pass"));
         }
         else
         {
            this.buyExtGoldPass();
         }
      }
      
      private function buyExtGoldPass() : void
      {
         var handleOk:Function = function():void
         {
            JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials",null);
         };
         SeasonPassUIPopUpUtils.createPopupBanner(GuiConstants.SEASON_PASS_POPUP_BUY_EXT_GOLD_PASS,handleOk);
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["seasonPass"]);
      }
      
      private function onClickNextPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.itemList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() + _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
         this.updateLevelHighlight();
      }
      
      private function onClickPrevPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.itemList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() - _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
         this.updateLevelHighlight();
      }
      
      private function onClickFirstPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.itemList;
         _loc2_.setScrollPositionInPercent(0);
         this.updatePageLabel(_loc2_);
         this.updateLevelHighlight();
      }
      
      private function onClickLastPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.itemList;
         _loc2_.setScrollPositionInPercent(1);
         this.updatePageLabel(_loc2_);
         this.updateLevelHighlight();
      }
      
      private function onClickLevel50Page(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.itemList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollOnePageAmount() * 4);
         this.updatePageLabel(_loc2_);
         this.updateLevelHighlight();
      }
      
      private function scrollToItem(param1:int) : void
      {
         var _loc2_:int = int(param1 / 10);
         var _loc3_:ItemList = this._view.itemList;
         _loc3_.setScrollPositionInPercent(_loc3_.getScrollOnePageAmount() * _loc2_);
         this.updatePageLabel(_loc3_);
         this.updateLevelHighlight();
      }
      
      private function updateLevelHighlight() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this._seasonPassData.levelServer.value - 1;
         var _loc2_:ItemList = this._view.itemList;
         var _loc3_:int = int(_loc2_.getScrollPositionInPercent() / _loc2_.getScrollOnePageAmount()) + 1;
         if(_loc3_ != int(_loc1_ / 10) + 1)
         {
            this._view.itemHighlight.visible = false;
         }
         else
         {
            this._view.itemHighlight.visible = true;
            this._view.itemHighlight.marginLeft = 60 + _loc1_ % 10 * 60;
         }
      }
      
      private function updateLevel(param1:Boolean = true) : void
      {
         var _loc2_:int = this._seasonPassData.levelServer.value - 1;
         var _loc3_:int = 0;
         while(_loc3_ < this._rewardsData.levelItems.length)
         {
            this._rewardsData.levelItems[_loc3_].isLevelClaimable = _loc3_ <= _loc2_;
            _loc3_++;
         }
         this.updateClaimableStatus();
         if(param1)
         {
            this.scrollToItem(_loc2_);
         }
      }
      
      private function updateClaimableStatus() : void
      {
         var _loc2_:SeasonPassLevelItemVO = null;
         var _loc1_:Boolean = false;
         for each(_loc2_ in this._rewardsData.levelItems)
         {
            _loc1_ ||= _loc2_.isGoldItemClaimable && !_loc2_.isGoldLocked || _loc2_.isFreeItemClaimable || _loc2_.isExtGoldItemClaimable && !_loc2_.isExtGoldLocked;
         }
         this._view.claimAllButton.enabled = _loc1_;
         this.updateDotHighlighter(_loc1_);
      }
      
      private function updateDotHighlighter(param1:Boolean) : void
      {
         if(param1)
         {
            sendNotification(HighLightItemNotification.ADD_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
         }
         else
         {
            sendNotification(HighLightItemNotification.REMOVE_HIGHLIGHT,RED_DOT_HIGHLIGHTER);
         }
      }
      
      private function updatePageLabel(param1:ItemList) : void
      {
         var _loc2_:int = int(1 / param1.getScrollOnePageAmount()) + 1;
         var _loc3_:int = int(param1.getScrollPositionInPercent() / param1.getScrollOnePageAmount()) + 1;
         this._view.pageLabel.text = _loc3_ + "/" + _loc2_;
         this._view.firstPageButton.enabled = _loc3_ != 1;
         this._view.prevPageButton.enabled = _loc3_ != 1;
         this._view.lastPageButton.enabled = _loc3_ != _loc2_;
         this._view.nextPageButton.enabled = _loc3_ != _loc2_;
         this._view.level50Button.enabled = _loc3_ < 5;
      }
      
      private function updateGoldPassStatus() : void
      {
         this.updateItems();
         this._view.buyGoldPassButton.visible = this._rewardsData.goldPassLocked;
         this._view.buyExtGoldPassButton.visible = this._rewardsData.extGoldPassLocked;
         this.updateLevel(false);
      }
      
      private function updateItems() : void
      {
         var _loc2_:SeasonPassLevelItemVO = null;
         if(this._view.itemList.list)
         {
            for each(_loc2_ in this._view.itemList.list)
            {
               _loc2_.onClaimItem.removeAll();
            }
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._rewardsData.levelItems.length)
         {
            this._rewardsData.levelItems[_loc1_].onClaimItem.add(this.onClickClaim);
            _loc1_++;
         }
         this.updateClaimableStatus();
         this._view.list = this._rewardsData.levelItems;
      }
   }
}

