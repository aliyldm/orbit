package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import com.bigpoint.utils.TextFormatter;
   import flash.display.Bitmap;
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
   import net.bigpoint.darkorbit.utils.HtmlTextUtils;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SingularityDriveCostAssigner extends DefaultItemDataAssigner
   {
      
      protected var _img:Coreponent;
      
      protected var _name:Label;
      
      protected var _ownedAmount:Label;
      
      protected var _amount:Label;
      
      protected var _help:Button;
      
      public function SingularityDriveCostAssigner()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         this.removeLister();
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
         this._help = FuiComponentSelectorUtil.selectComponent("content.upgradeInfo",this) as Button;
      }
      
      private function removeLister() : void
      {
         var _loc1_:AssemblyLootCount = data as AssemblyLootCount;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.count.changed.remove(this.update);
      }
      
      private function addListeners() : void
      {
         var _loc1_:AssemblyLootCount = data as AssemblyLootCount;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.count.changed.add(this.update);
      }
      
      protected function update() : void
      {
         var _loc2_:Number = NaN;
         var _loc5_:String = null;
         var _loc1_:AssemblyLootCount = data as AssemblyLootCount;
         if(!_loc1_)
         {
            return;
         }
         loadResource(_loc1_.itemVO.getLoot30x30(Hero.factionName),this.handleLoadComplete,this.handleLoadFail,AssetsProxy.ITEMS);
         this._name.text = TextUtils.getTranslationByType(_loc1_.lootId,ReplacementTypeModule.REPLACEMENTTYPE_LOOT_ID_CODE);
         _loc2_ = _loc1_.count.value;
         var _loc3_:int = _loc1_.total;
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
      
      protected function handleLoadFail(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      protected function handleLoadComplete(param1:ImageFinisher) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
   }
}

