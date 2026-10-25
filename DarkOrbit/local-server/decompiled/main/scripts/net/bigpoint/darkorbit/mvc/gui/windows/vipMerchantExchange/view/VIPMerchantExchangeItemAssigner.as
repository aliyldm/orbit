package net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.view
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.vipMerchantExchange.model.VIPMerchantExchangeVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class VIPMerchantExchangeItemAssigner extends DefaultItemDataAssigner
   {
      
      private const costLabelCount:int = 4;
      
      private var _overallBG:Coreponent;
      
      private var _overallBGSpecial:Coreponent;
      
      private var _iconBG:Coreponent;
      
      private var _iconBGSpecial:Coreponent;
      
      private var _icon:Coreponent;
      
      private var _iconBtn:Button;
      
      private var _verticalDivider1:Coreponent;
      
      private var _descriptionBG:Coreponent;
      
      private var _descriptionBGSpecial:Coreponent;
      
      private var _itemName:Label;
      
      private var _itemDescription:Label;
      
      private var _limitLabel:Label;
      
      private var _limit:Label;
      
      private var _verticalDivider2:Coreponent;
      
      private var _costList:Vector.<Label>;
      
      private var _exchangeButton:Button;
      
      private var _maxedBG:Coreponent;
      
      private var _itemEndDivider:Coreponent;
      
      public function VIPMerchantExchangeItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._overallBG = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._overallBGSpecial = FuiComponentSelectorUtil.selectComponent("bg_special",this) as Coreponent;
         this._iconBG = FuiComponentSelectorUtil.selectComponent("icon.bg",this) as Coreponent;
         this._iconBGSpecial = FuiComponentSelectorUtil.selectComponent("icon.bg_special",this) as Coreponent;
         this._iconBtn = FuiComponentSelectorUtil.selectComponent("icon.btn",this) as Button;
         this._icon = FuiComponentSelectorUtil.selectComponent("icon.icon",this) as Coreponent;
         this._verticalDivider1 = FuiComponentSelectorUtil.selectComponent("vertical_divider_1",this) as Coreponent;
         this._descriptionBG = FuiComponentSelectorUtil.selectComponent("item.bg",this) as Coreponent;
         this._descriptionBGSpecial = FuiComponentSelectorUtil.selectComponent("item.bg_special",this) as Coreponent;
         this._itemName = FuiComponentSelectorUtil.selectComponent("item.name",this) as Label;
         this._itemDescription = FuiComponentSelectorUtil.selectComponent("item.description",this) as Label;
         this._limitLabel = FuiComponentSelectorUtil.selectComponent("item.limit_label",this) as Label;
         this._limit = FuiComponentSelectorUtil.selectComponent("item.limit",this) as Label;
         this._verticalDivider2 = FuiComponentSelectorUtil.selectComponent("vertical_divider_2",this) as Coreponent;
         this._costList = new Vector.<Label>();
         var _loc1_:int = 1;
         while(_loc1_ <= this.costLabelCount)
         {
            this._costList.push(FuiComponentSelectorUtil.selectComponent("cost.item_" + _loc1_,this) as Label);
            this._costList.push(FuiComponentSelectorUtil.selectComponent("cost.amount_" + _loc1_,this) as Label);
            _loc1_++;
         }
         this._exchangeButton = FuiComponentSelectorUtil.selectComponent("cost.exchange_btn",this) as Button;
         this._maxedBG = FuiComponentSelectorUtil.selectComponent("maxed_bg",this) as Coreponent;
         this._itemEndDivider = FuiComponentSelectorUtil.selectComponent("item_end_divider",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:VIPMerchantExchangeVO = param1 as VIPMerchantExchangeVO;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         loadResource(_loc2_.itemVO.getLoot100x100(),this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         this.setBG(this.VO.isSpecial);
         this.drawDivider(this.VO.isSpecial);
         this._iconBtn.tooltipData = this.VO.itemVO.descriptionName;
         this._itemName.text = this.VO.itemVO.fullname;
         this._itemDescription.text = this.VO.description;
         this._limitLabel.text = BPLocale.getItem("window_vip-exchange_limit") + ":";
         this._limit.text = this.VO.limitLocale;
         this._exchangeButton.enabled = this.VO.isExchangeable;
         var _loc3_:int = 0;
         var _loc4_:int = 1;
         var _loc5_:int = 0;
         while(_loc3_ < this._costList.length)
         {
            this._costList[_loc3_].text = _loc5_ < this.VO.costList.length ? this.VO.costList[_loc5_].itemVO.fullname : "";
            this._costList[_loc4_].text = _loc5_ < this.VO.costList.length ? this.VO.costList[_loc5_].costLocale : "";
            _loc3_ += 2;
            _loc4_ += 2;
            _loc5_++;
         }
         this._maxedBG.visible = this.VO.isEligible && this.VO.isCompleted;
      }
      
      private function addListeners() : void
      {
         if(this.VO)
         {
            this._exchangeButton.addEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
         }
      }
      
      private function removeListeners() : void
      {
         if(this.VO)
         {
            this._exchangeButton.removeEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
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
      
      public function get VO() : VIPMerchantExchangeVO
      {
         return data as VIPMerchantExchangeVO;
      }
      
      private function setBG(param1:Boolean) : *
      {
         this._overallBG.visible = !param1;
         this._overallBGSpecial.visible = param1;
         this._iconBG.visible = !param1;
         this._iconBGSpecial.visible = param1;
         this._descriptionBG.visible = !param1;
         this._descriptionBGSpecial.visible = param1;
      }
      
      private function drawDivider(param1:Boolean) : *
      {
         var _loc2_:Sprite = null;
         if(this._verticalDivider1 != null)
         {
            if(this._verticalDivider1.numChildren > 0)
            {
               this._verticalDivider1.removeChildAt(0);
            }
            _loc2_ = new Sprite();
            _loc2_.graphics.lineStyle(1,param1 ? 16776960 : 3631231);
            _loc2_.graphics.lineTo(0,this._verticalDivider1.height);
            this._verticalDivider1.addChild(_loc2_);
         }
         if(this._verticalDivider2 != null)
         {
            if(this._verticalDivider2.numChildren > 0)
            {
               this._verticalDivider2.removeChildAt(0);
            }
            _loc2_ = new Sprite();
            _loc2_.graphics.lineStyle(1,param1 ? 16776960 : 3631231);
            _loc2_.graphics.lineTo(0,this._verticalDivider2.height);
            this._verticalDivider2.addChild(_loc2_);
         }
         if(this._itemEndDivider != null)
         {
            if(this._itemEndDivider.numChildren > 0)
            {
               this._itemEndDivider.removeChildAt(0);
            }
            _loc2_ = new Sprite();
            _loc2_.graphics.lineStyle(1,3631231);
            _loc2_.graphics.lineTo(this._itemEndDivider.width,0);
            this._itemEndDivider.addChild(_loc2_);
         }
      }
      
      public function sendExchangeRequest(param1:MouseEvent) : void
      {
         this.VO.sendExchangeRequest();
      }
   }
}

