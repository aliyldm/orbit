package net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.view.component
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemFilterTypes;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale9BitmapLayer;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.BirthdayGate2025Constants;
   import net.bigpoint.darkorbit.mvc.gui.windows.birthdaygate2025.model.vo.Birthday2025PointRewardItemData;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.EventCenter;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.golbalEvent.GameEvent;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class BirthdayGate2025ViewListItemRender extends DefaultItemDataAssigner
   {
      
      private var _indexLabel:Label;
      
      private var _bg:Coreponent;
      
      private var _pic:Button;
      
      private var _checkmark:Coreponent;
      
      private var _amount:Label;
      
      private var _item_highlight:Coreponent;
      
      public function BirthdayGate2025ViewListItemRender()
      {
         super();
      }
      
      private function get vo() : Birthday2025PointRewardItemData
      {
         return this.data as Birthday2025PointRewardItemData;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._indexLabel = FuiComponentSelectorUtil.selectComponent("index_label",this) as Label;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._pic = FuiComponentSelectorUtil.selectComponent("pic",this) as Button;
         this._pic.mouseEnabled = false;
         this._pic.mouseChildren = false;
         this._checkmark = FuiComponentSelectorUtil.selectComponent("checkmark",this) as Coreponent;
         this._checkmark.mouseEnabled = false;
         this._checkmark.mouseChildren = false;
         this._amount = FuiComponentSelectorUtil.selectComponent("amount",this) as Label;
         this._item_highlight = FuiComponentSelectorUtil.selectComponent("item_highlight",this) as Coreponent;
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.clickItem);
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.beginFill(16776960,0);
         _loc2_.drawRect(0,0,this.width,this.height);
         _loc2_.endFill();
         this.addChildAt(_loc1_,2);
      }
      
      private function clickItem(param1:MouseEvent) : void
      {
         if(!this.vo.isClaim && this.vo.canClaim)
         {
            EventCenter.instance.dispatchEvent(new GameEvent(BirthdayGate2025Constants.CLICK_REWARD_ITEM,this.vo.index));
         }
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
         var _loc2_:ItemVO = null;
         var _loc3_:String = null;
         var _loc1_:Birthday2025PointRewardItemData = data as Birthday2025PointRewardItemData;
         this._indexLabel.text = _loc1_.index + "";
         if(!_loc1_ || !_loc1_.lootId)
         {
            this.removeCallbacks();
            return;
         }
         _loc2_ = this.vo.itemVo;
         _loc3_ = _loc2_.getLoot30x30();
         if(!hasResource(_loc3_,AssetsProxy.ITEMS))
         {
            _loc3_ = _loc2_.getLoot100x100();
         }
         if(!hasResource(_loc3_,AssetsProxy.ITEMS))
         {
            _loc3_ = _loc2_.getLootIcon();
         }
         this._item_highlight.visible = this.vo.canClaim && !this.vo.isClaim;
         this.setBgColorAndSize(_loc1_);
         loadResource(_loc3_,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this._indexLabel.text = _loc1_.index + "";
         this.buttonMode = this.vo.canClaim;
         this.setIsClaimed(_loc1_.isClaim);
         this.tooltipData = _loc2_.fullname;
         if(_loc2_.isItemValue(ItemFilterTypes.BoosterValue))
         {
            this._amount.text = _loc1_.lootAmount + "h";
         }
         else
         {
            this._amount.text = "x" + _loc1_.lootAmount;
         }
      }
      
      private function removeCallbacks() : void
      {
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._pic);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this.setImageIcon(_loc2_);
      }
      
      private function setImageIcon(param1:Bitmap) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._pic);
         param1.width = this._pic.width;
         param1.height = this._pic.height;
         this._pic.addChild(param1);
      }
      
      private function setBgColorAndSize(param1:Birthday2025PointRewardItemData) : void
      {
         this._bg.removeChildren();
         var _loc2_:String = param1.bg == "" ? "rewardbg_blue" : param1.bg;
         var _loc3_:AssetsProxy = GameFacade.getInstance().retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc4_:BitmapData = _loc3_.getBitmapDataFromAtlas(_loc2_,BirthdayGate2025Constants.UI_ATLASXML);
         var _loc5_:Scale9BitmapLayer = new Scale9BitmapLayer(_loc4_,11,32,31,34,this._bg.width,this._bg.height);
         this._bg.addChild(_loc5_);
         this._bg.enabled = false;
      }
      
      override public function dispose() : void
      {
         this.removeEventListeners();
         super.dispose();
      }
      
      private function setIsClaimed(param1:Boolean) : void
      {
         var _loc2_:Number = NaN;
         this._checkmark.visible = param1;
         if(param1)
         {
            _loc2_ = 0.8;
            this._checkmark.alpha = _loc2_;
         }
      }
   }
}

