package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.bindables.BindableNumber;
   import com.bigpoint.utils.bindables.BindableString;
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.delete_in_eic.ItemDataProviderHelper;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.components.tooltip.BindableStringToolTipAssigner;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.AssemblyConsts;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class UpgradeSkipIngredientsListAssigner extends DefaultItemDataAssigner
   {
      
      public static var skipCostPercentage:BindableNumber = new BindableNumber(AssemblyConsts.MIN_SKIP_COST_FACTOR,AssemblyConsts.MIN_SKIP_COST_FACTOR);
      
      private var _img:Coreponent;
      
      private var _itemName:Label;
      
      private var _ownedAmount:Label;
      
      private var _amount:Label;
      
      private var _info:Button;
      
      private var _toolTipText:BindableString = new BindableString("");
      
      public function UpgradeSkipIngredientsListAssigner()
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
            this.removeSignalListeners();
            super.data = param1;
            if(param1)
            {
               this.update(param1 as AssemblyLootCount);
            }
         }
      }
      
      private function get itemData() : AssemblyLootCount
      {
         return data as AssemblyLootCount;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("content.img",this) as Coreponent;
         this._itemName = FuiComponentSelectorUtil.selectComponent("content.item_name",this) as Label;
         this._ownedAmount = FuiComponentSelectorUtil.selectComponent("content.owned_amount",this) as Label;
         this._amount = FuiComponentSelectorUtil.selectComponent("content.amount",this) as Label;
         this._info = FuiComponentSelectorUtil.selectComponent("content.upgradeInfo",this) as Button;
         this.tooltipDataAssigner = new BindableStringToolTipAssigner();
      }
      
      override public function dispose() : void
      {
         this.removeSignalListeners();
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         if(!data || !this.itemData)
         {
            return;
         }
         var _loc1_:ItemVO = ItemDataProviderHelper.getItem(this.itemData.lootId);
         removeLoadResourceCallback(_loc1_.getLoot30x30(Hero.factionName),this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update(param1:AssemblyLootCount) : void
      {
         this._itemName.text = param1.itemVO.codeName;
         this._info.tooltipData = this.itemData.itemVO.sourceName;
         this.tooltipData = this._toolTipText;
         this.updatePercentage();
         loadResource(param1.itemVO.getLoot30x30(),this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this.addSignalListeners();
         this.updateStates();
      }
      
      private function updatePercentage() : void
      {
         var _loc3_:String = null;
         var _loc1_:Number = Math.round(this.itemData.total * UpgradeSkipIngredientsListAssigner.skipCostPercentage.value);
         this._toolTipText.value = this.itemData.count.value + "/" + _loc1_;
         this._amount.text = TextFormatter.roundInteger(_loc1_);
         var _loc2_:Number = this.itemData.count.value;
         var _loc4_:Boolean = _loc2_ < _loc1_;
         if(_loc4_)
         {
            _loc3_ = HtmlTextUtils.coloriseText(16711680,TextFormatter.roundInteger(_loc2_));
         }
         else
         {
            _loc3_ = TextFormatter.roundInteger(_loc2_);
         }
         _loc3_ += " /";
         this._ownedAmount.text = _loc3_;
      }
      
      private function addSignalListeners() : void
      {
         skipCostPercentage.changed.add(this.updatePercentage);
      }
      
      private function removeSignalListeners() : void
      {
         skipCostPercentage.changed.remove(this.updatePercentage);
      }
      
      private function updateStates() : void
      {
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         var _loc2_:Bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this._img.addChild(_loc2_);
      }
   }
}

