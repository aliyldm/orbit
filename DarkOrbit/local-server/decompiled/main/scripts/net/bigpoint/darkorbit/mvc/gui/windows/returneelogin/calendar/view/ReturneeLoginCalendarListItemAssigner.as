package net.bigpoint.darkorbit.mvc.gui.windows.returneelogin.calendar.view
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.model.MiniClientRewardVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ReturneeLoginCalendarListItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Button;
      
      private var _day:Label;
      
      private var _icon:Coreponent;
      
      private var _amount:Label;
      
      private var _checkmark:Coreponent;
      
      public function ReturneeLoginCalendarListItemAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Button;
         this._day = FuiComponentSelectorUtil.selectComponent("day",this) as Label;
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._amount = FuiComponentSelectorUtil.selectComponent("amount",this) as Label;
         this._checkmark = FuiComponentSelectorUtil.selectComponent("checkmark",this) as Coreponent;
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:MiniClientRewardVO = param1 as MiniClientRewardVO;
         if(!_loc2_)
         {
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         this.tooltipData = this.VO.fullname;
         this.setInfo();
         this.setLastItem();
         this.loadIcon();
         this.isClaimed = _loc2_.isClaimed;
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
      }
      
      private function loadIcon() : void
      {
         var _loc1_:String = this.VO.getLootIcon();
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this.MiniVO.isLast ? this.VO.getLootCustom(329,163) : this.VO.getLoot100x100();
         }
         loadResource(_loc1_,this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this._icon.width;
         _loc2_.height = this._icon.height;
         this._icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._icon);
      }
      
      public function get MiniVO() : MiniClientRewardVO
      {
         return data as MiniClientRewardVO;
      }
      
      public function get VO() : ItemVO
      {
         return ItemDataProviderHelper.getItem(this.MiniVO.lootid);
      }
      
      private function setInfo() : void
      {
         this._bg.enabled = false;
         if(!this.MiniVO.isLast && this.MiniVO.index > 0 && this.MiniVO.index % 7 == 0)
         {
            this._bg.setSkinState(SkinLayerNames.OVER);
         }
         this._day.text = BPLocale.getItem("miniclient_reward_item_headline").replace("%VALUE%",this.MiniVO.index);
         if(this.MiniVO.isLast)
         {
            this._amount.text = this.VO.fullname;
            return;
         }
         this._amount.text = this.VO.isItemValue(ItemFilterTypes.BoosterValue) ? this.MiniVO.amount + "h" : "x" + this.MiniVO.amount;
      }
      
      private function setLastItem() : void
      {
         if(!this.MiniVO.isLast)
         {
            return;
         }
         this.width = 240;
         this.height = 120;
         this.invalidate(InvalidationType.LAYOUT);
         this._bg.registeredSkinName = "calendar_last_bg";
         this._bg.width = this.width;
         this._bg.height = this.height;
         this._icon.width = 180;
         this._icon.height = 90;
         this._day.alignX = "left";
         this._day.registeredTextStyleName = "calendar";
         this._amount.width = 200;
         this._amount.alignX = "center";
         this._amount.registeredTextStyleName = "calendar_center";
         this._checkmark.marginLeft = (this.width - this._checkmark.width) / 2;
         marginLeft = this.MiniVO.index == 7 ? -40 : -80;
         if(this.MiniVO.index > 7 && this.MiniVO.index % 7 == 0)
         {
            this.marginTop = this.height + 10;
            this.marginLeft = -325;
         }
         invalidate(InvalidationType.POSITION);
      }
      
      private function set isClaimed(param1:Boolean) : void
      {
         this._checkmark.visible = param1;
         var _loc2_:Number = param1 ? 0.5 : 1;
         this._day.alpha = _loc2_;
         this._bg.alpha = _loc2_;
         this._icon.alpha = _loc2_;
         this._checkmark.alpha = _loc2_;
         this._amount.alpha = _loc2_;
      }
   }
}

