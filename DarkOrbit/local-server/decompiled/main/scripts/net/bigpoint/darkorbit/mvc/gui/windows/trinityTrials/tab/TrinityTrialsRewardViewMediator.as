package net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.tab
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.ItemList;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.items.TrinityTrialsRewardListItemRenderer;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsConst;
   import net.bigpoint.darkorbit.mvc.gui.windows.trinityTrials.model.TrinityTrialsMainProxy;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   
   public class TrinityTrialsRewardViewMediator extends SimpleWindowMediator
   {
      
      private var _view:TrinityTrialsRewardView;
      
      private var _proxy:TrinityTrialsMainProxy;
      
      private var dataUpdate:Boolean;
      
      public var isFirst:Boolean = true;
      
      public function TrinityTrialsRewardViewMediator(param1:String, param2:IWindow)
      {
         super(param1,param2);
      }
      
      override public function onRegister() : void
      {
         super.onRegister();
         this._proxy = TrinityTrialsMainProxy.getProxy();
         this._proxy.viewData.dataChange.add(this.update);
      }
      
      override public function onRemove() : void
      {
         super.onRemove();
         this.removeEventListener();
      }
      
      private function addEventListener() : void
      {
         this._view.next_page.addEventListener(MouseEvent.CLICK,this.onClickNextPage);
         this._view.prev_page.addEventListener(MouseEvent.CLICK,this.onClickPrevPage);
         this._view.first_page.addEventListener(MouseEvent.CLICK,this.onClickFirstPage);
         this._view.last_page.addEventListener(MouseEvent.CLICK,this.onClickLastPage);
         this._view.level_Max_page.addEventListener(MouseEvent.CLICK,this.onClickLastPage);
         this._view.buy_button.addEventListener(MouseEvent.CLICK,this.onClickBuy);
      }
      
      private function removeEventListener() : void
      {
         this._view.next_page.removeEventListener(MouseEvent.CLICK,this.onClickNextPage);
         this._view.prev_page.removeEventListener(MouseEvent.CLICK,this.onClickPrevPage);
         this._view.first_page.removeEventListener(MouseEvent.CLICK,this.onClickFirstPage);
         this._view.last_page.removeEventListener(MouseEvent.CLICK,this.onClickLastPage);
         this._view.level_Max_page.removeEventListener(MouseEvent.CLICK,this.onClickLastPage);
         this._view.buy_button.removeEventListener(MouseEvent.CLICK,this.onClickBuy);
      }
      
      public function update(param1:String) : void
      {
         if(param1 != TrinityTrialsConst.TAB_1)
         {
            return;
         }
         this.dataUpdate = true;
         this.setListData();
      }
      
      private function setListData() : void
      {
         if(this._view)
         {
            this.flushUI();
            this.dataUpdate = false;
            this._view.reward_list.itemDataAssigner = TrinityTrialsRewardListItemRenderer;
            this._view.reward_list.list = new VectorCollection(this._proxy.viewData.getPassItems());
            if(this.isFirst)
            {
               this.isFirst = false;
               this.showItemListCurPage();
            }
         }
      }
      
      public function setView(param1:TrinityTrialsRewardView) : void
      {
         this._view = param1;
         if(this.isFirst)
         {
            this.removeEventListener();
            this.addEventListener();
         }
         if(this.dataUpdate)
         {
            this.setListData();
         }
      }
      
      private function flushUI() : void
      {
         this._view.buy_button.visible = !this._proxy.viewData.rewardData.isVip;
         this.set_info_label_text();
         this.set_time_label_text();
         this.set_max_level_page_text();
         var _loc1_:int = this._proxy.viewData.rewardData.currentExp;
         var _loc2_:int = this._proxy.viewData.rewardData.nextLevelExp;
         this._view.progress_bar.minValue = 0;
         this._view.progress_bar.maxValue = _loc2_ == 0 ? _loc1_ : _loc2_;
         this._view.progress_bar.setCurrentValueNoTween(_loc1_);
         if(_loc2_ == 0)
         {
            this._view.progress_bar_label_current.text = _loc1_ + "";
         }
         else
         {
            this._view.progress_bar_label_current.text = _loc1_ + "/" + _loc2_;
         }
         this._view.progress_bar_label_next.text = this._proxy.viewData.rewardData.currentLevel + "";
      }
      
      private function set_info_label_text() : void
      {
         var _loc4_:String = null;
         var _loc1_:String = BPLocale.getItemInCategory("","trinitytrials_pass_info");
         var _loc2_:Vector.<int> = this._proxy.viewData.rewardData.vipParams;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = "%VALUE" + (_loc3_ + 1) + "%";
            _loc1_ = _loc1_.replace(_loc4_,_loc2_[_loc3_] + "");
            _loc3_++;
         }
         this._view.info_label.text = _loc1_;
      }
      
      private function set_time_label_text() : void
      {
         var _loc1_:String = TimeFormatter.getSmartFormatedTime(this._proxy.viewData.rewardData.remainSeconds);
         this._view.time_label.text = BPLocale.getItemInCategory("","trinitytrials_pass_time").replace("%VALUE%",_loc1_);
      }
      
      private function set_max_level_page_text() : void
      {
         this._view.level_Max_page.text = BPLocale.getItemInCategory("","trinitytrials_pass_max_level").replace("%VALUE%",this._proxy.viewData.rewardData.normalItemList.length + "");
      }
      
      private function showItemListCurPage() : void
      {
         var _loc1_:ItemList = this._view.reward_list;
         var _loc2_:int = Math.ceil(this._proxy.viewData.rewardData.currentLevel / 10);
         _loc2_ = _loc2_ < 0 ? 0 : _loc2_;
         var _loc3_:int = int(_loc1_.getScrollPositionInPercent() / _loc1_.getScrollOnePageAmount()) + 1;
         _loc1_.setScrollPositionInPercent(_loc1_.getScrollPositionInPercent() + (_loc2_ - _loc3_) * _loc1_.getScrollOnePageAmount());
         this.updatePageLabel(_loc1_);
      }
      
      private function onClickNextPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.reward_list;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() + _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
      }
      
      private function onClickPrevPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.reward_list;
         _loc2_.setScrollPositionInPercent(_loc2_.getScrollPositionInPercent() - _loc2_.getScrollOnePageAmount());
         this.updatePageLabel(_loc2_);
      }
      
      private function onClickFirstPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.reward_list;
         _loc2_.setScrollPositionInPercent(0);
         this.updatePageLabel(_loc2_);
      }
      
      private function onClickLastPage(param1:Event) : void
      {
         var _loc2_:ItemList = this._view.reward_list;
         _loc2_.setScrollPositionInPercent(1);
         this.updatePageLabel(_loc2_);
      }
      
      private function updatePageLabel(param1:ItemList) : void
      {
         var _loc2_:int = int(1 / param1.getScrollOnePageAmount()) + 1;
         var _loc3_:int = int(param1.getScrollPositionInPercent() / param1.getScrollOnePageAmount()) + 1;
         this._view.page_label.text = _loc3_ + "/" + _loc2_;
         this._view.first_page.enabled = _loc3_ != 1;
         this._view.prev_page.enabled = _loc3_ != 1;
         this._view.last_page.enabled = _loc3_ != _loc2_;
         this._view.next_page.enabled = _loc3_ != _loc2_;
         this._view.level_Max_page.enabled = _loc3_ != _loc2_;
      }
      
      private function onClickBuy(param1:MouseEvent) : void
      {
         JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials",null);
         JavascriptProxy.call(JavascriptProxy.FUNCTION_OPEN_PAYMENT_POPUP,["TrinityVip"]);
      }
   }
}

