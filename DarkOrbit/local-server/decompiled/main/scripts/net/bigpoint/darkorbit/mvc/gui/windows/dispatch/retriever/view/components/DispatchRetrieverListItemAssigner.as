package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.DispatchCollectRetrieverRequest;
   import net.bigpoint.darkorbit.com.module.DispatchGetRewardPackageRequest;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.retriever.model.vo.DispatchRetrieverVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DispatchRetrieverListItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Coreponent;
      
      private var _btnHover:Button;
      
      private var _icon:Coreponent;
      
      private var _name:Label;
      
      private var _type:Label;
      
      private var _btnCollect:Button;
      
      private var _timeRequired:Label;
      
      private var _cost:Label;
      
      private var _btnChancesDropInfo:Button;
      
      private var _costMarginTop:int;
      
      private var _timer:Timer;
      
      private var _timeLeft:int;
      
      public function DispatchRetrieverListItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._btnHover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("name",this) as Label;
         this._type = FuiComponentSelectorUtil.selectComponent("type",this) as Label;
         this._btnCollect = FuiComponentSelectorUtil.selectComponent("collect_btn",this) as Button;
         this._timeRequired = FuiComponentSelectorUtil.selectComponent("time",this) as Label;
         this._cost = FuiComponentSelectorUtil.selectComponent("cost",this) as Label;
         this._costMarginTop = this._cost.marginTop;
         this._btnChancesDropInfo = FuiComponentSelectorUtil.selectComponent("info_btn",this) as Button;
         this._timer = new Timer(1000);
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeListeners();
            super.data = param1;
            this.addListeners();
            this.updateRetrieverItem();
         }
      }
      
      private function addListeners() : void
      {
         this._btnCollect.addEventListener(MouseEvent.CLICK,this.onClickCollectDispatch);
         this._btnChancesDropInfo.addEventListener(MouseEvent.CLICK,this.onClickShowRewardChancesPopup);
         this._timer.addEventListener(TimerEvent.TIMER,this.onTimerTick);
      }
      
      private function removeListeners() : void
      {
         this._btnCollect.removeEventListener(MouseEvent.CLICK,this.onClickCollectDispatch);
         this._btnChancesDropInfo.removeEventListener(MouseEvent.CLICK,this.onClickShowRewardChancesPopup);
         this._timer.removeEventListener(TimerEvent.TIMER,this.onTimerTick);
      }
      
      override public function set index(param1:int) : void
      {
         super.index = param1;
         this._bg.visible = param1 % 2 != 0;
      }
      
      override protected function drawSelection() : void
      {
         this._btnHover.visible = true;
         this._btnHover.enabled = !this.isSelected();
         super.drawSelection();
      }
      
      private function updateRetrieverItem() : void
      {
         var _loc1_:DispatchRetrieverVO = data as DispatchRetrieverVO;
         if(!_loc1_)
         {
            return;
         }
         this.updateRetrieverItemUI(_loc1_);
         this.updateRetrieverItemData(_loc1_);
      }
      
      private function updateRetrieverItemUI(param1:DispatchRetrieverVO) : void
      {
         this._type.visible = param1.isAvailable;
         this._timeRequired.visible = param1.isAvailable;
         this._cost.visible = param1.isAvailable;
         this._btnChancesDropInfo.visible = param1.isAvailable;
         this._btnCollect.visible = !param1.isAvailable;
      }
      
      private function updateRetrieverItemData(param1:DispatchRetrieverVO) : void
      {
         var _loc2_:Boolean = false;
         this._timer.stop();
         this.loadIcon(param1.iconId);
         this._name.text = param1.name;
         if(param1.isAvailable)
         {
            this._type.text = BPLocale.getItemInCategory("base","dispatch_label_type_retriever_" + param1.type);
            this._timeRequired.text = TimeFormatter.formatTimeValueFromSeconds(param1.defaultDuration,true);
            this._cost.text = param1.costListToString();
            this._cost.marginTop = param1.costList.length > 1 ? this._costMarginTop - 7 : this._costMarginTop;
         }
         else
         {
            _loc2_ = param1.duration <= 0;
            this._btnCollect.visible = _loc2_;
            this._type.visible = !_loc2_;
            if(!_loc2_)
            {
               this._timeLeft = param1.duration;
               this._type.text = TimeFormatter.formatTimeWithZero(this._timeLeft);
               this._timer.start();
            }
         }
      }
      
      private function loadIcon(param1:String) : void
      {
         var _loc2_:String = param1.substr(param1.lastIndexOf("_") + 1) + "_30x30";
         this._icon.loadResource(_loc2_,this.handleIconLoaded,this.handleIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleIconLoaded(param1:ImageFinisher = null) : void
      {
         this.setImageIcon(this._icon,new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleIconLoadError(param1:*) : void
      {
         this.setImageIcon(this._icon);
      }
      
      private function setImageIcon(param1:Coreponent, param2:Bitmap = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(param1);
         if(param2 != null)
         {
            param2.width = param1.width;
            param2.height = param1.height;
            param1.addChild(param2);
         }
      }
      
      private function onTimerTick(param1:TimerEvent) : void
      {
         var _loc2_:DispatchRetrieverVO = null;
         this._type.text = TimeFormatter.formatTimeWithZero(--this._timeLeft);
         if(this._timeLeft <= 0)
         {
            this._btnCollect.visible = true;
            this._type.visible = false;
            this._timer.stop();
            _loc2_ = data as DispatchRetrieverVO;
            if(_loc2_)
            {
               _loc2_.changedSignal.dispatch();
            }
         }
      }
      
      private function onClickCollectDispatch(param1:Event) : void
      {
         var _loc2_:DispatchRetrieverVO = data as DispatchRetrieverVO;
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchCollectRetrieverRequest(_loc2_.dispatchModule.slotId));
      }
      
      private function onClickShowRewardChancesPopup(param1:Event) : void
      {
         var _loc2_:DispatchRetrieverVO = data as DispatchRetrieverVO;
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchGetRewardPackageRequest(_loc2_.dispatchModule.id));
      }
   }
}

