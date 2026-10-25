package net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.view
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.monthlyDeluxe.model.MonthlyDeluxeVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class MonthlyDeluxeItemAssigner extends DefaultItemDataAssigner
   {
      
      private var _day:Label;
      
      private var _bg:Button;
      
      private var _img:Coreponent;
      
      private var _checkmark:Coreponent;
      
      private var _amount:Label;
      
      public function MonthlyDeluxeItemAssigner()
      {
         super();
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
      
      private function update() : void
      {
         var _loc1_:MonthlyDeluxeVO = data as MonthlyDeluxeVO;
         if(!_loc1_)
         {
            this.removeCallbacks();
            return;
         }
         var _loc2_:ItemVO = ItemDataProviderHelper.getItem(_loc1_.lootid);
         var _loc3_:String = _loc2_.getLootIcon();
         if(!hasResource(_loc3_,AssetsProxy.ITEMS))
         {
            _loc3_ = _loc2_.getLoot100x100();
         }
         this.setBgColorAndSize(_loc1_);
         loadResource(_loc3_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this._day.localizedText = "miniclient_reward_item_headline";
         this._day.text = this._day.text.replace("%VALUE%",_loc1_.index);
         this.setDisplay(_loc1_.state);
         this._img.tooltipData = new String(_loc2_.fullname);
         if(_loc2_.isItemValue(ItemFilterTypes.BoosterValue))
         {
            this._amount.text = _loc1_.amount + "h";
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
      
      private function setBgColorAndSize(param1:MonthlyDeluxeVO) : void
      {
         if(param1.index > 0 && param1.index % 7 == 0)
         {
            this._bg.setSkinState(SkinLayerNames.OVER);
         }
         this._bg.enabled = false;
      }
      
      private function setDisplay(param1:String) : void
      {
         switch(param1)
         {
            case MonthlyDeluxeVO.CLAIMED:
               this.greyOut();
            case MonthlyDeluxeVO.TODAY:
               this._checkmark.visible = true;
               break;
            case MonthlyDeluxeVO.MISSED:
               this.greyOut();
         }
      }
      
      private function greyOut() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = 0.5;
         this._day.alpha = _loc1_;
         this._bg.alpha = _loc1_;
         this._img.alpha = _loc1_;
         this._amount.alpha = _loc1_;
      }
   }
}

