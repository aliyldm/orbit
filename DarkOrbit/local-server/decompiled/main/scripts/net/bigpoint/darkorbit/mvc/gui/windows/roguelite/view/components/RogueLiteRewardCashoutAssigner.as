package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items.StarLevelDisplayHelper;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RogueLiteRewardCashoutAssigner extends DefaultItemDataAssigner
   {
      
      private var _icon:Coreponent;
      
      private var _amount:Label;
      
      private var _state:Coreponent;
      
      private var _starLayer:Sprite;
      
      public function RogueLiteRewardCashoutAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this._amount = FuiComponentSelectorUtil.selectComponent("amount",this) as Label;
         this._state = FuiComponentSelectorUtil.selectComponent("state",this) as Coreponent;
         this._starLayer = new Sprite();
         this._starLayer.name = "starLayer";
         this._starLayer.mouseEnabled = false;
         this._starLayer.mouseChildren = false;
         this._starLayer.x = this._icon.x;
         this._starLayer.y = this._icon.y;
         this._starLayer.graphics.beginFill(0,0);
         this._starLayer.graphics.drawRect(0,0,this._icon.width,this._icon.height);
         this._starLayer.graphics.endFill();
         addChild(this._starLayer);
      }
      
      override public function set data(param1:Object) : void
      {
         var _loc2_:ItemVO = param1 as ItemVO;
         if(!_loc2_)
         {
            StarLevelDisplayHelper.render(this._starLayer,null);
            visible = false;
            return;
         }
         this.removeListeners();
         super.data = _loc2_;
         this.addListeners();
         StarLevelDisplayHelper.render(this._starLayer,_loc2_);
         loadResource(_loc2_.getLoot100x100(),this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
         this.setAmount();
         this._state.visible = _loc2_.amount <= 0;
         this.setTooltip();
      }
      
      private function addListeners() : void
      {
      }
      
      private function removeListeners() : void
      {
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
      
      public function get VO() : ItemVO
      {
         return data as ItemVO;
      }
      
      private function setAmount() : void
      {
         if(this.VO.amount >= 999)
         {
            this._amount.text = "> 999";
         }
         else
         {
            this._amount.text = TextFormatter.roundInteger(this.VO.amount);
         }
      }
      
      private function setTooltip() : void
      {
         var _loc1_:String = BPLocale.getItem("tdm_result_window_ttip_item_headline") + ": " + this.VO.fullname + "\n" + BPLocale.getItem("label_traininggrounds_results_reward_amount") + ": " + this.VO.amount + "\n\n" + this.VO.descriptionName;
         tooltipData = _loc1_;
      }
   }
}

