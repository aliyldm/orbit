package net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.view
{
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.strikeAndExit.root.shop.model.StrikeAndExitShopItemVO;
   
   public class StrikeAndExitShopItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _iconBG:Coreponent;
      
      private var _iconBGSpecial:Coreponent;
      
      private var _icon:Coreponent;
      
      private var _iconBtn:Button;
      
      private var _iconAmount:Label;
      
      private var _overallBG:Coreponent;
      
      private var _overallBGSpecial:Coreponent;
      
      private var _descriptionBG:Coreponent;
      
      private var _descriptionBGSpecial:Coreponent;
      
      private var _itemName:Label;
      
      private var _itemDescription:Label;
      
      private var _limit:Label;
      
      private var _item:Label;
      
      private var _amount:Label;
      
      private var _cost_icon:Coreponent;
      
      private var _exchangeButton:Button;
      
      private var _verticalDivider1:Coreponent;
      
      private var _verticalDivider2:Coreponent;
      
      private var _itemEndDivider:Coreponent;
      
      public function StrikeAndExitShopItemAssigner()
      {
         super();
      }
      
      private function get vo() : StrikeAndExitShopItemVO
      {
         return data as StrikeAndExitShopItemVO;
      }
      
      override public function set data(param1:Object) : void
      {
         this.removeListeners();
         super.data = param1;
         this.addListeners();
         this.update();
      }
      
      public function update() : void
      {
         if(!this.vo)
         {
            return;
         }
         var _loc1_:ItemVO = this.vo.itemVO;
         IconVOLoader.getInstance().loadIcon(this._icon,_loc1_,"100x100",AssetsProxy.ITEMS);
         this._iconAmount.text = this.vo.amount + "";
         this._iconBtn.tooltipData = this.vo.itemVO.descriptionName;
         this.setBG(this.vo.isSpecial);
         this._itemName.text = _loc1_.fullname;
         this._itemDescription.text = this.vo.itemType;
         this._limit.text = "" + this.vo.limit + "/" + this.vo.max;
         IconVOLoader.getInstance().loadIcon(this._cost_icon,this.vo.costVo,"100x100",AssetsProxy.ITEMS);
         this._item.text = this.vo.costVo.fullname;
         this._amount.text = this.vo.costAmount + "";
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
         this._iconAmount = FuiComponentSelectorUtil.selectComponent("icon.amount",this) as Label;
         this._descriptionBG = FuiComponentSelectorUtil.selectComponent("item.bg",this) as Coreponent;
         this._descriptionBGSpecial = FuiComponentSelectorUtil.selectComponent("item.bg_special",this) as Coreponent;
         this._itemName = FuiComponentSelectorUtil.selectComponent("item.name",this) as Label;
         this._itemDescription = FuiComponentSelectorUtil.selectComponent("item.description",this) as Label;
         this._limit = FuiComponentSelectorUtil.selectComponent("item.limit",this) as Label;
         this._item = FuiComponentSelectorUtil.selectComponent("cost.item",this) as Label;
         this._amount = FuiComponentSelectorUtil.selectComponent("cost.amount",this) as Label;
         this._cost_icon = FuiComponentSelectorUtil.selectComponent("cost.icon",this) as Coreponent;
         this._exchangeButton = FuiComponentSelectorUtil.selectComponent("cost.exchange_btn",this) as Button;
         this._itemEndDivider = FuiComponentSelectorUtil.selectComponent("item_end_divider",this) as Coreponent;
         this._verticalDivider2 = FuiComponentSelectorUtil.selectComponent("vertical_divider_2",this) as Coreponent;
         this._verticalDivider1 = FuiComponentSelectorUtil.selectComponent("vertical_divider_1",this) as Coreponent;
      }
      
      private function setBG(param1:Boolean) : void
      {
         this._overallBG.visible = !param1;
         this._overallBGSpecial.visible = param1;
         this._iconBG.visible = !param1;
         this._iconBGSpecial.visible = param1;
         this._descriptionBG.visible = !param1;
         this._descriptionBGSpecial.visible = param1;
         this.drawDivider(param1);
      }
      
      public function sendExchangeRequest(param1:MouseEvent) : void
      {
         this.vo.sendExchangeRequest();
      }
      
      private function addListeners() : void
      {
         if(this._exchangeButton)
         {
            if(this.vo)
            {
               this._exchangeButton.enabled = this.vo.limit > 0;
               if(this._exchangeButton.isEnabled())
               {
                  this._exchangeButton.addEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
               }
            }
         }
      }
      
      private function removeListeners() : void
      {
         if(this._exchangeButton)
         {
            this._exchangeButton.removeEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
         }
      }
      
      private function drawDivider(param1:Boolean) : void
      {
         var _loc2_:Sprite = null;
         if(this._verticalDivider1)
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
         if(this._verticalDivider2)
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
         if(this._itemEndDivider)
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
   }
}

