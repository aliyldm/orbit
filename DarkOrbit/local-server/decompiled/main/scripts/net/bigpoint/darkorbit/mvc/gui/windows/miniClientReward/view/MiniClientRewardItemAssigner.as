package net.bigpoint.darkorbit.mvc.gui.windows.miniClientReward.view
{
   import flash.display.Bitmap;
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
   
   public class MiniClientRewardItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _day:Label;
      
      private var _bg:Button;
      
      private var _img:Coreponent;
      
      private var _checkmark:Coreponent;
      
      private var _amount:Label;
      
      public function MiniClientRewardItemAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         if(param1 == data)
         {
            super.data = param1;
         }
         else
         {
            this.removeCallbacks();
            super.data = param1;
            if(param1)
            {
               this.update();
            }
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._day = FuiComponentSelectorUtil.selectComponent("day",this) as Label;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Button;
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Button;
         this._checkmark = FuiComponentSelectorUtil.selectComponent("checkmark",this) as Coreponent;
         this._amount = FuiComponentSelectorUtil.selectComponent("amount",this) as Label;
      }
      
      private function init() : void
      {
         var _loc2_:Boolean = false;
         var _loc1_:MiniClientRewardVO = data as MiniClientRewardVO;
         _loc2_ = _loc1_ != null && _loc1_.isLast;
         this.setSize(_loc2_ ? 170 : 80,120);
         this._day.alpha = 1;
         this._bg.alpha = 1;
         this._img.alpha = 1;
         this._checkmark.alpha = 1;
         this._amount.alpha = 1;
         this._checkmark.visible = false;
         this._bg.registeredSkinName = _loc2_ ? "reward_last_bg" : "reward_bg";
         this._bg.setSkinState(SkinLayerNames.NORMAL);
         this._bg.x = 0;
         this._bg.y = 0;
         this._bg.width = _loc2_ ? 170 : 80;
         this._bg.height = 120;
         this._day.x = _loc2_ ? 5 : 0;
         this._day.y = 0;
         this._day.width = _loc2_ ? 160 : 66;
         this._img.x = _loc2_ ? -14 : 15;
         this._img.y = _loc2_ ? 10 : 34;
         this._img.width = _loc2_ ? 198 : 50;
         this._img.height = _loc2_ ? 98 : 50;
         this._img.alignX = "left";
         this._img.alignY = "top";
         this._img.marginLeft = 0;
         this._img.marginRight = 0;
         this._img.marginTop = 0;
         this._img.marginBottom = 0;
         this._checkmark.x = _loc2_ ? 64 : 15;
         this._amount.x = _loc2_ ? 5 : 0;
         this._amount.width = _loc2_ ? 160 : 80;
      }
      
      private function update() : void
      {
         var _loc1_:MiniClientRewardVO = data as MiniClientRewardVO;
         if(!_loc1_)
         {
            this.removeCallbacks();
            return;
         }
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(_loc1_.lootid);
         var _loc3_:String = _loc2_.getLootIcon();
         if(!hasResource(_loc3_,AssetsProxy.ITEMS))
         {
            _loc3_ = _loc1_.isLast ? _loc2_.getLootCustom(329,163) : _loc2_.getLoot100x100();
         }
         this.init();
         this.setBgColorAndSize(_loc1_);
         loadResource(_loc3_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this._day.localizedText = "miniclient_reward_item_headline";
         this._day.text = this._day.text.replace("%VALUE%",_loc1_.index);
         this.setIsClaimed(_loc1_.isClaimed);
         this._img.tooltipData = new String(_loc2_.fullname);
         if(_loc2_.isItemValue(ItemFilterTypes.BoosterValue))
         {
            this._amount.text = _loc1_.amount + "h";
         }
         else if(_loc1_.isLast)
         {
            this._amount.text = _loc2_.fullname;
         }
         else
         {
            this._amount.text = "x" + _loc1_.amount;
         }
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback("miniclientreward",this.handleItemLoaded,AssetsProxy.GAME);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this.setImageIcon(_loc2_);
      }
      
      private function setImageIcon(param1:Bitmap) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         param1.width = this._img.width;
         param1.height = this._img.height;
         this._img.addChild(param1);
      }
      
      private function setBgColorAndSize(param1:MiniClientRewardVO) : void
      {
         if(param1.isLast)
         {
            this._bg.registeredSkinName = "reward_last_bg";
            this.setSize(170,120);
            this.forceRedraw(InvalidationType.SIZE);
         }
         else if(param1.index > 0 && param1.special)
         {
            this._bg.setSkinState(SkinLayerNames.OVER);
            this.setSize(80,120);
            this.forceRedraw(InvalidationType.SIZE);
         }
         this._bg.enabled = false;
      }
      
      private function setIsClaimed(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         this._checkmark.visible = param1;
         if(param1)
         {
            _loc2_ = 0.5;
            this._day.alpha = _loc2_;
            this._bg.alpha = _loc2_;
            this._img.alpha = _loc2_;
            this._checkmark.alpha = _loc2_;
            this._amount.alpha = _loc2_;
         }
         else
         {
            this._day.alpha = 1;
            this._bg.alpha = 1;
            this._img.alpha = 1;
            this._checkmark.alpha = 1;
            this._amount.alpha = 1;
         }
      }
      
      private function offsetItem(param1:int, param2:int) : void
      {
         this._day.x += param1;
         this._bg.x += param1;
         this._img.x += param1;
         this._checkmark.x += param1;
         this._amount.x += param1;
         this._day.y += param2;
         this._bg.y += param2;
         this._img.y += param2;
         this._checkmark.y += param2;
         this._amount.y += param2;
      }
   }
}

