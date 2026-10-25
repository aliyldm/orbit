package net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.UISystem;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Container;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.mileageMarket.model.MileageMarketVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class MileageMarketItemAssigner extends DefaultItemDataAssigner
   {
      
      private static const PREFIX:String = "items_package_";
      
      private static const ARROW:String = " <font fontFamily=\'Arial\'>→</font> ";
      
      private var _icon:Coreponent;
      
      private var _packName:Label;
      
      private var _packInfo:Button;
      
      private var _packPrice:Label;
      
      private var _discountContainer:Container;
      
      private var _btnMinus:Button;
      
      private var _labelVal:Label;
      
      private var _btnPlus:Button;
      
      private var _btnApply:Button;
      
      private var _btnBuy:Button;
      
      private var _warningContainer:Container;
      
      private var _maxedBG:Coreponent;
      
      private var _itemEndDivider:Coreponent;
      
      private var _spinVal:BindableInt = new BindableInt(0,0);
      
      public function MileageMarketItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon.icon",this) as Coreponent;
         this._packName = FuiComponentSelectorUtil.selectComponent("details.top.name",this) as Label;
         this._packInfo = FuiComponentSelectorUtil.selectComponent("details.top.info",this) as Button;
         this._packPrice = FuiComponentSelectorUtil.selectComponent("details.bottom.price",this) as Label;
         this._discountContainer = FuiComponentSelectorUtil.selectComponent("discount",this) as Container;
         this._btnMinus = FuiComponentSelectorUtil.selectComponent("discount.spinContainer.btnMinus",this) as Button;
         this._labelVal = FuiComponentSelectorUtil.selectComponent("discount.spinContainer.labelVal",this) as Label;
         this._btnPlus = FuiComponentSelectorUtil.selectComponent("discount.spinContainer.btnPlus",this) as Button;
         this._btnApply = FuiComponentSelectorUtil.selectComponent("discount.btn_apply",this) as Button;
         this._btnBuy = FuiComponentSelectorUtil.selectComponent("discount.btn_buy",this) as Button;
         this._warningContainer = FuiComponentSelectorUtil.selectComponent("warning",this) as Container;
         this._maxedBG = FuiComponentSelectorUtil.selectComponent("maxed_bg",this) as Coreponent;
         this._itemEndDivider = FuiComponentSelectorUtil.selectComponent("item_end_divider",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:MileageMarketVO = param1 as MileageMarketVO;
         if(!_loc2_)
         {
            visible = false;
            this._btnApply.enabled = false;
            this._btnBuy.enabled = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         loadResource(this.VO.bundleId + "_100x100",this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         this.drawDivider();
         this._packName.text = BPLocale.getItemInCategory("items",PREFIX + this.VO.bundleId + "_fullname");
         this._packInfo.tooltipData = BPLocale.getItemInCategory("items",PREFIX + this.VO.bundleId + "_description");
         this.resetVO();
      }
      
      private function addListeners() : void
      {
         if(this.VO)
         {
            this.VO.coinsUpdated.add(this.resetVO);
            this.VO.update.add(this.onBundleUpdate);
            this.VO.requestApplyCancel.add(this.onApplyCancelRequest);
            this._btnMinus.addEventListener(MouseEvent.CLICK,this.decreaseSpin);
            this._btnPlus.addEventListener(MouseEvent.CLICK,this.increaseSpin);
            this._btnApply.addEventListener(MouseEvent.CLICK,this.sendApplyRequest);
            this._btnBuy.addEventListener(MouseEvent.CLICK,this.sendBuyRequest);
         }
      }
      
      private function removeListeners() : void
      {
         if(this.VO)
         {
            this.VO.coinsUpdated.remove(this.resetVO);
            this.VO.update.remove(this.onBundleUpdate);
            this.VO.requestApplyCancel.remove(this.onApplyCancelRequest);
            this._btnMinus.removeEventListener(MouseEvent.CLICK,this.decreaseSpin);
            this._btnPlus.removeEventListener(MouseEvent.CLICK,this.increaseSpin);
            this._btnApply.removeEventListener(MouseEvent.CLICK,this.sendApplyRequest);
            this._btnBuy.removeEventListener(MouseEvent.CLICK,this.sendBuyRequest);
         }
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
         var _loc2_:* = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._icon.width;
         _loc2_.height = this._icon.height;
         this._icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
      }
      
      public function get VO() : MileageMarketVO
      {
         return data as MileageMarketVO;
      }
      
      private function drawDivider() : *
      {
         var _loc1_:Sprite = null;
         if(this._itemEndDivider != null)
         {
            if(this._itemEndDivider.numChildren > 0)
            {
               this._itemEndDivider.removeChildAt(0);
            }
            _loc1_ = new Sprite();
            _loc1_.graphics.lineStyle(1,3631231);
            _loc1_.graphics.lineTo(this._itemEndDivider.width,0);
            this._itemEndDivider.addChild(_loc1_);
         }
      }
      
      private function resetVO() : void
      {
         UISystem.getInstance().tooltipManager.attemptToRemoveTooltip();
         this._spinVal.maxValue = this.VO.maxSteps == 0 ? this.VO.maxDiscountSteps : this.VO.maxSteps;
         this.updateSpinValue();
         this.updateVisual();
      }
      
      private function setPrice() : *
      {
         if(this.VO.bought || this.VO.priceError)
         {
            this._packPrice.text = "";
         }
         else if(this._spinVal.value == 0)
         {
            this._packPrice.text = this.VO.price;
         }
         else
         {
            this._packPrice.useHTML = true;
            this._packPrice.text = "<b>" + this.VO.price + ARROW + this.VO.getDiscountedString(this._spinVal.value) + "</b>";
         }
      }
      
      private function updateVisual() : *
      {
         this.setPrice();
         if(this.VO.priceError)
         {
            this._warningContainer.visible = true;
            this._discountContainer.visible = false;
            this._btnMinus.enabled = false;
            this._btnPlus.enabled = false;
            this._btnApply.enabled = false;
            this._btnBuy.enabled = false;
            this._maxedBG.visible = false;
         }
         else
         {
            this._warningContainer.visible = false;
            this._discountContainer.visible = true;
            this._btnMinus.enabled = this.VO.claimedDiscountSteps == 0 && this._spinVal.value > 0;
            this._btnPlus.enabled = this.VO.claimedDiscountSteps == 0 && this._spinVal.value < this._spinVal.maxValue;
            this._btnApply.visible = !this.VO.bought && this.VO.claimedDiscountSteps == 0;
            this._btnApply.enabled = this._btnApply.visible && this._spinVal.value > 0;
            this._btnBuy.visible = this.VO.claimedDiscountSteps > 0;
            this._btnBuy.enabled = !this._maxedBG.visible && this._btnBuy.visible && this.VO.claimedDiscountSteps > 0;
            this._maxedBG.visible = this.VO.bought;
         }
      }
      
      private function updateSpinValue() : void
      {
         this.spinVal = this.VO.claimedDiscountSteps;
      }
      
      private function decreaseSpin(param1:MouseEvent) : void
      {
         this.spinVal = this._spinVal.value - 1;
      }
      
      private function increaseSpin(param1:MouseEvent) : void
      {
         this.spinVal = this._spinVal.value + 1;
      }
      
      private function set spinVal(param1:Number) : void
      {
         if(this._spinVal.value != param1 || param1 == 0)
         {
            this._spinVal.value = param1;
            this._labelVal.text = TextFormatter.roundInteger(this._spinVal.value);
            this.updateVisual();
         }
      }
      
      private function onBundleUpdate() : void
      {
         this.updateSpinValue();
         this.resetVO();
      }
      
      public function sendApplyRequest(param1:MouseEvent) : void
      {
         this._btnMinus.enabled = false;
         this._btnPlus.enabled = false;
         this._btnApply.enabled = false;
         this.VO.sendApplyRequest(this._spinVal.value);
      }
      
      private function onApplyCancelRequest() : void
      {
         this.updateVisual();
      }
      
      public function sendBuyRequest(param1:MouseEvent) : void
      {
         this.VO.sendBuyRequest();
      }
   }
}

