package net.bigpoint.darkorbit.mvc.gui.windows.spaceSearch.objectives.rewards.model
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.delete_in_eic.IconVO;
   import net.bigpoint.darkorbit.delete_in_eic.IconVOLoader;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class TabSpaceSearchRewardsDataAssigner extends DefaultItemDataAssigner
   {
      
      private var nameLabel:Label;
      
      private var _verticalDivider1:Coreponent;
      
      private var _verticalDivider2:Coreponent;
      
      private var _itemEndDivider:Coreponent;
      
      private var _bg:Coreponent;
      
      private var _bg_special:Coreponent;
      
      private var _icon_bg:Coreponent;
      
      private var _icon_bg_special:Coreponent;
      
      private var _icon_icon:Coreponent;
      
      private var _icon_btn:Button;
      
      private var _icon_amount:Label;
      
      private var _item_bg:Coreponent;
      
      private var _item_bg_special:Coreponent;
      
      private var _item_name:Label;
      
      private var _item_description:Label;
      
      private var _cost_exchange_btn:Button;
      
      private var currentVO:TabSpaceSearchRewardsListVO;
      
      private var _cost_claimedLabel:Label;
      
      private var iconLoader:IconVO;
      
      public function TabSpaceSearchRewardsDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.nameLabel = FuiComponentSelectorUtil.selectComponent("name",this) as Label;
         this._verticalDivider1 = FuiComponentSelectorUtil.selectComponent("vertical_divider_1",this) as Coreponent;
         this._verticalDivider2 = FuiComponentSelectorUtil.selectComponent("vertical_divider_2",this) as Coreponent;
         this._itemEndDivider = FuiComponentSelectorUtil.selectComponent("item_end_divider",this) as Coreponent;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._bg_special = FuiComponentSelectorUtil.selectComponent("bg_special",this) as Coreponent;
         this._icon_bg = FuiComponentSelectorUtil.selectComponent("icon.bg",this) as Coreponent;
         this._icon_bg_special = FuiComponentSelectorUtil.selectComponent("icon.bg_special",this) as Coreponent;
         this._icon_icon = FuiComponentSelectorUtil.selectComponent("icon.icon",this) as Coreponent;
         this._icon_btn = FuiComponentSelectorUtil.selectComponent("icon.btn",this) as Button;
         this._icon_amount = FuiComponentSelectorUtil.selectComponent("icon.amount",this) as Label;
         this._item_bg = FuiComponentSelectorUtil.selectComponent("item.bg",this) as Coreponent;
         this._item_bg_special = FuiComponentSelectorUtil.selectComponent("item.bg_special",this) as Coreponent;
         this._item_name = FuiComponentSelectorUtil.selectComponent("item.name",this) as Label;
         this._item_description = FuiComponentSelectorUtil.selectComponent("item.description",this) as Label;
         this._cost_exchange_btn = FuiComponentSelectorUtil.selectComponent("cost.exchange_btn",this) as Button;
         this._cost_claimedLabel = FuiComponentSelectorUtil.selectComponent("cost.claimedLabel",this) as Label;
      }
      
      private function get vo() : TabSpaceSearchRewardsListVO
      {
         return data as TabSpaceSearchRewardsListVO;
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         this.update();
      }
      
      public function update() : void
      {
         var _loc1_:ItemVO = null;
         var _loc2_:Bitmap = null;
         if(!this.vo)
         {
            return;
         }
         if(this.vo == this.currentVO)
         {
            return;
         }
         this.removeListeners();
         if(this.iconLoader)
         {
            this.iconLoader.stop();
            this.iconLoader = null;
         }
         this.nameLabel.text = this.vo.nameStr;
         this.setBG(this.vo.bp.special);
         this._cost_exchange_btn.enabled = this.vo.unlock;
         this._cost_exchange_btn.visible = !this.vo.received;
         this._cost_claimedLabel.visible = this.vo.received;
         if(this.vo.unlock && !this.vo.received)
         {
            this.addListeners();
         }
         this._icon_icon.removeChildren();
         this._item_name.text = BPLocale.getItem("SS_Rewards_conditions").replace("%NUMBER%",this.vo.range);
         this._item_description.text = "( " + this.vo.count + "/" + this.vo.range + " )";
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon_icon);
         if(Boolean(this.vo.bp.lootID) && this.vo.bp.lootID != "")
         {
            _loc1_ = ItemDataProviderHelper.getItem(this.vo.bp.lootID);
            this.iconLoader = IconVOLoader.getInstance().loadIcon(this._icon_icon,_loc1_,"100x100",AssetsProxy.ITEMS);
            this._icon_amount.text = this.vo.bp.lootAmount + "";
            this._icon_btn.tooltipData = _loc1_.fullname;
         }
         else if(Boolean(this.vo.bp.title) && this.vo.bp.title != "")
         {
            _loc2_ = ResourceManager.getBitmap("traininggroundsUI","title_icon");
            _loc2_.width = this._icon_icon.width;
            _loc2_.height = this._icon_icon.height;
            this._icon_icon.addChild(_loc2_);
            this._icon_btn.tooltipData = BPLocale.getItemInCategory("achievements",this.vo.bp.title);
            this._icon_amount.text = "1";
         }
         this.currentVO = this.vo;
      }
      
      private function setBG(param1:Boolean) : void
      {
         this._bg.visible = !param1;
         this._bg_special.visible = param1;
         this._item_bg.visible = !param1;
         this._item_bg_special.visible = param1;
         this._icon_bg.visible = !param1;
         this._icon_bg_special.visible = param1;
         this.drawDivider(param1);
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
      
      private function sendExchangeRequest(param1:MouseEvent) : void
      {
         if(this.vo)
         {
            if(this.vo.unlock && !this.vo.received)
            {
               this.vo.requestExchange.dispatch(this.vo);
            }
         }
      }
      
      private function addListeners() : void
      {
         if(this.vo)
         {
            if(this.vo.unlock && !this.vo.received)
            {
               if(this._cost_exchange_btn)
               {
                  this._cost_exchange_btn.addEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
               }
            }
         }
      }
      
      private function removeListeners() : void
      {
         if(this.vo)
         {
            if(this._cost_exchange_btn)
            {
               this._cost_exchange_btn.removeEventListener(MouseEvent.CLICK,this.sendExchangeRequest);
            }
         }
      }
   }
}

