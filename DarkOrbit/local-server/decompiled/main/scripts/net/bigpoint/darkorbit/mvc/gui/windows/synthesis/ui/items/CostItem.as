package net.bigpoint.darkorbit.mvc.gui.windows.synthesis.ui.items
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.porting.hangar.HangarShipEquipmentInventoryItem;
   import net.bigpoint.darkorbit.com.module.porting.synthesis.SynthesisCostLootCommand;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.CannonSynthesisProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.synthesis.model.SynthesisConst;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CostItem extends DefaultItemDataAssigner
   {
      
      private var cost_icon:Coreponent;
      
      private var cost_item_name:Label;
      
      private var cost_num_label:Label;
      
      private var tip_info:Button;
      
      private var _itemData:SynthesisCostLootCommand;
      
      private var _itemVo:ItemVO;
      
      private var _isEnough:Boolean = false;
      
      public function CostItem()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         super.data = param1;
         if(!param1)
         {
            return;
         }
         this._itemData = param1 as SynthesisCostLootCommand;
         this.removeCallbacks();
         this._itemVo = ItemDataProviderHelper.getItem(this._itemData.lootId);
         this.update();
      }
      
      public function get isEnough() : Boolean
      {
         return this._isEnough;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this.cost_icon = FuiComponentSelectorUtil.selectComponent("icon",this) as Coreponent;
         this.cost_item_name = FuiComponentSelectorUtil.selectComponent("cost_item_name",this) as Label;
         this.cost_num_label = FuiComponentSelectorUtil.selectComponent("cost_num_label",this) as Label;
         this.tip_info = FuiComponentSelectorUtil.selectComponent("tip_info",this) as Button;
      }
      
      private function update() : void
      {
         var _loc4_:String = null;
         var _loc1_:CannonSynthesisProxy = CannonSynthesisProxy.getProxy(GameFacade.getInstance());
         var _loc2_:HangarShipEquipmentInventoryItem = _loc1_.viewData.getInventoryItemByLootId(this._itemData.lootId);
         var _loc3_:int = _loc2_ ? int(_loc2_.itemCount) : 0;
         if(this._itemData.lootId == SynthesisConst.LOOTID_URIDIUM)
         {
            _loc3_ = Hero.uridiumAmount;
         }
         if(_loc3_ >= this._itemData.amount)
         {
            this._isEnough = true;
         }
         else
         {
            this._isEnough = false;
         }
         if(this._isEnough)
         {
            _loc4_ = HtmlTextUtils.coloriseText(15592941,TextFormatter.roundInteger(_loc3_));
         }
         else
         {
            _loc4_ = HtmlTextUtils.coloriseText(16711680,TextFormatter.roundInteger(_loc3_));
         }
         this.cost_item_name.text = this._itemVo.fullname;
         this.cost_num_label.useHTML = true;
         this.cost_num_label.text = _loc4_ + "/" + this._itemData.amount;
         this.tip_info.tooltipData = this._itemVo.sourceName;
         this.loadIcon();
      }
      
      private function removeCallbacks() : void
      {
         if(!this._itemVo)
         {
            return;
         }
         var _loc1_:String = this._itemVo.getLootIcon();
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot30x30();
         }
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot100x100();
         }
         removeLoadResourceCallback(_loc1_,this.handleItemIconLoaded,AssetsProxy.ITEMS);
      }
      
      private function loadIcon() : void
      {
         var _loc1_:String = this._itemVo.getLootIcon();
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot30x30();
         }
         if(!hasResource(_loc1_,AssetsProxy.ITEMS))
         {
            _loc1_ = this._itemVo.getLoot100x100();
         }
         loadResource(_loc1_,this.handleItemIconLoaded,this.handleItemIconLoadError,AssetsProxy.ITEMS);
      }
      
      private function handleItemIconLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.cost_icon);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         _loc2_.width = this.cost_icon.width;
         _loc2_.height = this.cost_icon.height;
         this.cost_icon.addChild(_loc2_);
      }
      
      private function handleItemIconLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this.cost_icon);
      }
   }
}

