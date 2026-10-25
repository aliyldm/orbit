package net.bigpoint.darkorbit.mvc.crafting.assembly.view.ui
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.ReplacementTypeModule;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.crafting.assembly.model.AssemblyLootCount;
   import net.bigpoint.darkorbit.net.JavascriptCallVO;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class IngredientAssigner extends DefaultItemDataAssigner
   {
      
      protected var _img:Coreponent;
      
      protected var _name:Label;
      
      protected var _ownedAmount:Label;
      
      protected var _amount:Label;
      
      protected var _help:Button;
      
      protected var _shop:Button;
      
      public function IngredientAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         this.removeListeners();
         super.data = param1;
         if(param1 is AssemblyLootCount)
         {
            this.update();
            this.addListeners();
         }
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("content.img",this) as Coreponent;
         this._name = FuiComponentSelectorUtil.selectComponent("content.item_name",this) as Label;
         this._ownedAmount = FuiComponentSelectorUtil.selectComponent("content.owned_amount",this) as Label;
         this._amount = FuiComponentSelectorUtil.selectComponent("content.amount",this) as Label;
         this._help = FuiComponentSelectorUtil.selectComponent("content.help",this) as Button;
         this._shop = FuiComponentSelectorUtil.selectComponent("content.shop",this) as Button;
         this._shop.addEventListener(MouseEvent.CLICK,this.handleShopButtonClicked);
      }
      
      override public function dispose() : void
      {
         this.removeListeners();
         super.dispose();
      }
      
      private function removeListeners() : void
      {
         var _loc1_:AssemblyLootCount = data as AssemblyLootCount;
         if(this._shop)
         {
            this._shop.removeEventListener(MouseEvent.CLICK,this.handleShopButtonClicked);
         }
         if(!_loc1_)
         {
            return;
         }
         _loc1_.count.changed.remove(this.update);
         AssemblyInteractionView.buildAmount.changed.remove(this.update);
      }
      
      private function addListeners() : void
      {
         var _loc1_:AssemblyLootCount = data as AssemblyLootCount;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.count.changed.add(this.update);
         AssemblyInteractionView.buildAmount.changed.add(this.update);
      }
      
      protected function update() : void
      {
         var _loc1_:AssemblyLootCount = null;
         var _loc5_:String = null;
         _loc1_ = data as AssemblyLootCount;
         if(!_loc1_)
         {
            return;
         }
         loadResource(_loc1_.itemVO.getLoot30x30(Hero.factionName),this.handleLoadComplete,this.handleLoadFail,AssetsProxy.ITEMS);
         this._name.text = TextUtils.getTranslationByType(_loc1_.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         var _loc2_:Number = _loc1_.count.value;
         var _loc3_:Number = this.getTotal(_loc1_);
         var _loc4_:Boolean = _loc2_ < _loc3_;
         if(_loc4_)
         {
            _loc5_ = HtmlTextUtils.coloriseText(16711680,TextFormatter.roundInteger(_loc2_));
         }
         else
         {
            _loc5_ = TextFormatter.roundInteger(_loc2_);
         }
         _loc5_ += " /";
         this._ownedAmount.text = _loc5_;
         this._amount.text = TextFormatter.roundInteger(_loc3_);
         var _loc6_:String = TextFormatter.roundInteger(_loc2_) + " / " + TextFormatter.roundInteger(_loc3_);
         if(_loc4_)
         {
            _loc6_ += "\n" + HtmlTextUtils.coloriseText(16711680,BPLocale.getItem("crafting_tooltip_insufficient_amount"));
         }
         tooltipData = _loc6_;
         this._help.tooltipData = _loc1_.itemVO.sourceName;
      }
      
      protected function getTotal(param1:AssemblyLootCount) : Number
      {
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(AssemblyInteractionView.costFactor.value == 1)
         {
            return param1.total * AssemblyInteractionView.buildAmount.value;
         }
         _loc2_ = AssemblyInteractionView.costFactor.value;
         _loc3_ = AssemblyInteractionView.craftLimit.value;
         _loc4_ = Number.pow(_loc2_,_loc3_) - Number.pow(_loc2_,_loc3_ + AssemblyInteractionView.buildAmount.value);
         _loc5_ = param1.total * _loc4_ / (1 - _loc2_);
         return Number.round(_loc5_);
      }
      
      protected function handleLoadFail(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      protected function handleLoadComplete(param1:ImageFinisher) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
      
      private function handleShopButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:JavascriptCallVO = new JavascriptCallVO("internalDock","seo_title_shop","internalDockShips");
         var _loc3_:AssemblyLootCount = data as AssemblyLootCount;
         if(!_loc3_)
         {
            return;
         }
         _loc2_.lootID = _loc3_.lootId;
         JavascriptProxy.referToURLviaVO(_loc2_);
      }
   }
}

