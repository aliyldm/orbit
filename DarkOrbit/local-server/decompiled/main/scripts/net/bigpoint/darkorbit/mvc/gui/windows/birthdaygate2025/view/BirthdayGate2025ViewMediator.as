package net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.view
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.porting.birthday2025.Birthday2025ClaimRequest;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemgrid.Grid;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowCreationVO;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindowEvent;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.windows.SimpleWindowCreationMap;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Constants;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Proxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.view.component.BirthdayGate2025ViewListItemRender;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.uistructures.HintWindowViewSetup;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class BirthdayGate2025ViewMediator extends SimpleWindowMediator
   {
      
      private var _view:BirthdayGate2025View;
      
      private var _proxy:BirthdayGate2025Proxy;
      
      private var _dataComplete:Boolean = false;
      
      public function BirthdayGate2025ViewMediator(param1:String, param2:SimpleWindow)
      {
         super(param1,param2);
      }
      
      override public function listNotificationInterests() : Array
      {
         return [BirthdayGate2025Constants.INIT_UI_RESOURCE_COMPLETE,BirthdayGate2025Constants.INIT_VIEW_DATA];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         super.handleNotification(param1);
         switch(param1.getName())
         {
            case BirthdayGate2025Constants.INIT_UI_RESOURCE_COMPLETE:
               if(this._view)
               {
                  this._view.loadGatePicComplete();
               }
               this.initData();
               break;
            case BirthdayGate2025Constants.INIT_VIEW_DATA:
               this._dataComplete = true;
               this.initData();
         }
      }
      
      public function get view() : BirthdayGate2025View
      {
         return this._view;
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         window.addEventListener(SimpleWindowEvent.ON_MINIMIZE,this.minimizeHandler);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.removeEventListener();
      }
      
      private function minimizeHandler(param1:SimpleWindowEvent) : void
      {
         this._proxy.isFirst = true;
      }
      
      private function addEventListener() : void
      {
         EventCenter.instance.addEventListener(BirthdayGate2025Constants.CLICK_REWARD_ITEM,this.clickItem);
         this._view.claimBtn.addEventListener(MouseEvent.CLICK,this.onClickClaimAll);
         this._view.next_page.addEventListener(MouseEvent.CLICK,this.onClickNextPage);
         this._view.prev_page.addEventListener(MouseEvent.CLICK,this.onClickPrevPage);
         this._view.first_page.addEventListener(MouseEvent.CLICK,this.onClickFirstPage);
         this._view.last_page.addEventListener(MouseEvent.CLICK,this.onClickLastPage);
      }
      
      private function removeEventListener() : void
      {
         window.removeEventListener(SimpleWindowEvent.ON_MINIMIZE,this.minimizeHandler);
         EventCenter.instance.removeEventListener(BirthdayGate2025Constants.CLICK_REWARD_ITEM,this.clickItem);
         this._view.claimBtn.removeEventListener(MouseEvent.CLICK,this.onClickClaimAll);
         this._view.next_page.removeEventListener(MouseEvent.CLICK,this.onClickNextPage);
         this._view.prev_page.removeEventListener(MouseEvent.CLICK,this.onClickPrevPage);
         this._view.first_page.removeEventListener(MouseEvent.CLICK,this.onClickFirstPage);
         this._view.last_page.removeEventListener(MouseEvent.CLICK,this.onClickLastPage);
      }
      
      override protected function handleLoadAndBuildContentCallback(param1:Array) : void
      {
         super.handleLoadAndBuildContentCallback(param1);
         this._proxy = BirthdayGate2025Proxy.getProxy(this.facade);
         this._view = new BirthdayGate2025View(this.simpleWindow);
         if(this._proxy.xmlReady && this._proxy.textureReady)
         {
            this._view.loadGatePicComplete();
         }
         this._view.rewardList.itemDataAssigner = BirthdayGate2025ViewListItemRender;
         this.addEventListener();
         this.initOpenView();
         this.initData();
      }
      
      private function flushUI() : void
      {
         this._view.title_label.text = BPLocale.getItemInCategory("","bday2025_overview_title");
         this._view.setTitleLineSize();
         var _loc1_:int = this._proxy.viewData.curPoints;
         var _loc2_:int = this._proxy.viewData.curLevelTotalPoint;
         this._view.progress_bar.minValue = 0;
         this._view.progress_bar.maxValue = _loc2_;
         this._view.progress_bar.currentValue = _loc1_;
         this._view.progress_bar_label.text = _loc1_ + "/" + _loc2_;
         this._view.next_label.text = this._proxy.viewData.curRewardLevel + "";
         this._view.rewardList.list = new VectorCollection(this._proxy.viewData.rewardItems);
         this._view.claimBtn.enabled = this._proxy.viewData.hasClaim;
         this.view.claimRedDot(this._proxy.viewData.hasClaim);
         this.updatePageLabel(this._view.rewardList);
      }
      
      private function clickItem(param1:GameEvent) : void
      {
         var _loc2_:int = param1.body as int;
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new Birthday2025ClaimRequest(_loc2_));
      }
      
      private function onClickClaimAll(param1:Event) : void
      {
         sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new Birthday2025ClaimRequest(0));
      }
      
      private function initData() : void
      {
         if(Boolean(this._view && this._dataComplete) && Boolean(this._proxy.xmlReady) && this._proxy.textureReady)
         {
            this.flushUI();
            if(this._proxy.isFirst)
            {
               this.showItemListCurPage();
               this._proxy.isFirst = false;
            }
         }
      }
      
      private function showItemListCurPage() : void
      {
         var _loc1_:Grid = this._view.rewardList;
         var _loc2_:int = Math.ceil(this._proxy.viewData.curRewardLevel / 8);
         _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
         _loc1_.setScrollPositionInPercent(_loc1_.getScrollPositionInPercent() + (_loc2_ - _loc1_.currentPage) * _loc1_.getScrollOnePageAmount());
         this.updatePageLabel(_loc1_);
      }
      
      private function onClickNextPage(param1:Event) : void
      {
         var _loc2_:Grid = this._view.rewardList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() + _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
      }
      
      private function onClickPrevPage(param1:Event) : void
      {
         var _loc2_:Grid = this._view.rewardList;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() - _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
      }
      
      private function onClickFirstPage(param1:Event) : void
      {
         var _loc2_:Grid = this._view.rewardList;
         _loc2_.setScrollPositionInPercent(0);
         this.updatePageLabel(_loc2_);
      }
      
      private function onClickLastPage(param1:Event) : void
      {
         var _loc2_:Grid = this._view.rewardList;
         _loc2_.setScrollPositionInPercent(1);
         this.updatePageLabel(_loc2_);
      }
      
      private function updatePageLabel(param1:Grid) : void
      {
         var _loc2_:int = param1.totalPage;
         var _loc3_:int = param1.currentPage;
         this._view.page_label.text = _loc3_ + "/" + _loc2_;
         this._view.first_page.enabled = _loc3_ != 1;
         this._view.prev_page.enabled = _loc3_ != 1;
         this._view.last_page.enabled = _loc3_ != _loc2_;
         this._view.next_page.enabled = _loc3_ != _loc2_;
      }
      
      private function initOpenView() : Boolean
      {
         var windowId:String = null;
         var window:IWindow = null;
         var uiSetup:HintWindowViewSetup = null;
         var creationVO:SimpleWindowCreationVO = null;
         try
         {
            windowId = BirthdayGate2025Constants.BIRTHDAY_2025;
            window = GuiManager.instance.getWindow(windowId);
            if(!window)
            {
               uiSetup = new HintWindowViewSetup();
               uiSetup.setUp();
               creationVO = SimpleWindowCreationMap.getById(windowId);
               if(creationVO)
               {
                  facade.sendNotification(GuiNotifications.CREATE_SIMPLE_WINDOW,creationVO);
                  window = guiManager.getWindow(windowId);
               }
               else
               {
                  window = guiManager.createWindow(windowId);
               }
            }
            window.maximize();
            return true;
         }
         catch(e:Error)
         {
         }
         return false;
      }
   }
}

