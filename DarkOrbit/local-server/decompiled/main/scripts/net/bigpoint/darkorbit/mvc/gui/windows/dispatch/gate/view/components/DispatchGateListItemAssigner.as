package net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.view.components
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.com.module.DispatchCollectGateRewardRequest;
   import net.bigpoint.darkorbit.com.module.DispatchGateModule;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.dispatch.gate.model.vo.DispatchGateVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class DispatchGateListItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Coreponent;
      
      private var _btnHover:Button;
      
      private var _icon:Coreponent;
      
      private var _name:Label;
      
      private var _timeRequired:Label;
      
      private var _cost:Label;
      
      private var _btn:Button;
      
      private var _bitmaps:Dictionary = new Dictionary();
      
      public function DispatchGateListItemAssigner()
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
         this._timeRequired = FuiComponentSelectorUtil.selectComponent("time",this) as Label;
         this._cost = FuiComponentSelectorUtil.selectComponent("cost",this) as Label;
         this._btn = FuiComponentSelectorUtil.selectComponent("collect_btn",this) as Button;
         this._btn.addEventListener(MouseEvent.CLICK,this.handleClickCollect);
      }
      
      override public function set data(param1:Object) : void
      {
         if(this.gateVO)
         {
            this.gateVO.onCollect.remove(this.handleCollection);
            this.gateVO.removeTimeLeftListener(this.updateTimeReq);
            this.gateVO.removeStatusChangedListener(this.updateGateStatus);
         }
         super.data = param1;
         if(this.gateVO)
         {
            this.gateVO.onCollect.add(this.handleCollection);
            this.gateVO.addTimeLeftListener(this.updateTimeReq);
            this.gateVO.addStatusChangedListener(this.updateGateStatus);
            this.updateUI();
         }
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
      
      public function get gateVO() : DispatchGateVO
      {
         return data as DispatchGateVO;
      }
      
      private function updateUI() : void
      {
         var _loc1_:Bitmap = this._bitmaps[this.gateVO.iconId + "_30x30"];
         if(_loc1_)
         {
            this.handleItemIcon(_loc1_);
         }
         else
         {
            loadResource(this.gateVO.iconId + "_30x30",this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         }
         this._name.text = BPLocale.getItemInCategory("galaxyGates",this.gateVO.dispatchName);
         this.updateGateStatus();
      }
      
      private function updateGateStatus() : void
      {
         switch(this.gateVO.status)
         {
            case DispatchGateModule.STATUSTYPE_READY_TO_COLLECT:
               this.updateUIAsReadyForCollect();
               break;
            case DispatchGateModule.STATUSTYPE_IN_PROGRESS:
               this.updateUIAsInProgress();
               break;
            case DispatchGateModule.STATUSTYPE_AVAILABLE:
            default:
               this.updateUIAsAvailable();
         }
      }
      
      private function updateUIAsAvailable() : void
      {
         this._timeRequired.visible = true;
         this._cost.visible = true;
         this._btn.visible = false;
         this._timeRequired.text = TimeFormatter.formatTimeValueFromSeconds(this.gateVO.timeLeft);
         this._cost.text = this.gateVO.costsToString();
      }
      
      private function updateUIAsInProgress() : void
      {
         this._timeRequired.visible = true;
         this._cost.visible = false;
         this._btn.visible = false;
         this._timeRequired.text = TimeFormatter.formatTimeWithZero(this.gateVO.timeLeft);
      }
      
      private function updateUIAsReadyForCollect() : void
      {
         this._timeRequired.visible = false;
         this._cost.visible = false;
         this._btn.visible = true;
      }
      
      private function updateTimeReq() : void
      {
         if(!data)
         {
            return;
         }
         this._timeRequired.text = TimeFormatter.formatTimeWithZero(this.gateVO.timeLeft);
         if(this.gateVO.timeLeft < 0)
         {
            this.gateVO.status = DispatchGateModule.STATUSTYPE_READY_TO_COLLECT;
            this.updateUIAsReadyForCollect();
         }
      }
      
      private function handleCollection() : void
      {
         this.gateVO.onCollect.dispatch(this.gateVO);
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         this._bitmaps[param1.fileVO.id] = new Bitmap(param1.getBitmap().bitmapData);
         if(!this.gateVO)
         {
            return;
         }
         var _loc2_:Bitmap = this._bitmaps[this.gateVO.dispatchId + "_30x30"];
         if(_loc2_)
         {
            this.handleItemIcon(_loc2_);
         }
      }
      
      private function handleItemIcon(param1:Bitmap) : *
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
         this._icon.addChild(param1);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
      }
      
      private function handleClickCollect(param1:MouseEvent) : void
      {
         GameFacade.getInstance().sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new DispatchCollectGateRewardRequest(this.gateVO.gateId));
      }
   }
}

