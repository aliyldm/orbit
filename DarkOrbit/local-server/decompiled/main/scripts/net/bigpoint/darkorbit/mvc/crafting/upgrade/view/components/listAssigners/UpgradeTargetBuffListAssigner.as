package net.bigpoint.darkorbit.mvc.crafting.upgrade.view.components.listAssigners
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.delete_in_eic.buffs.UpgradeBuff;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.crafting.overview.view.CraftingConst;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class UpgradeTargetBuffListAssigner extends DefaultItemDataAssigner
   {
      
      protected static const BUFF_POSITIVE_TEXT_STYLE:String = "crafting_buff_positive";
      
      protected static const BUFF_NEGATIVE_TEXT_STYLE:String = "crafting_buff_negative";
      
      private var _img:Coreponent;
      
      private var _currentPercentage:Label;
      
      private var _newPercentage:Label;
      
      public function UpgradeTargetBuffListAssigner()
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
            super.data = param1;
            if(param1)
            {
               this.update(param1 as UpgradeBuff);
            }
         }
      }
      
      private function get itemBuffData() : UpgradeBuff
      {
         return data as UpgradeBuff;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("content.img",this) as Coreponent;
         this._currentPercentage = FuiComponentSelectorUtil.selectComponent("content.currentPercentage",this) as Label;
         this._newPercentage = FuiComponentSelectorUtil.selectComponent("content.newPercentage",this) as Label;
      }
      
      private function update(param1:UpgradeBuff) : void
      {
         tooltipData = BPLocale.getItem("crafting_" + param1.currentBuff.buffType.toLowerCase() + "_buff_tooltip");
         var _loc2_:Number = param1.currentBuff.bonusPercent;
         this._currentPercentage.text = TextFormatter.round(_loc2_,1) + "%";
         var _loc3_:Number = param1.targetBuff.bonusPercent;
         var _loc4_:Number = _loc3_ - _loc2_;
         var _loc5_:String = _loc4_ < 0 ? "-" : "+";
         this._newPercentage.registeredTextStyleName = _loc4_ < 0 ? BUFF_NEGATIVE_TEXT_STYLE : BUFF_POSITIVE_TEXT_STYLE;
         this._newPercentage.text = _loc5_ + TextFormatter.round(_loc4_,1) + "%";
         loadResource(CraftingConst.ASSET_LIB,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.GAME);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var _loc2_:String = null;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         if(this.itemBuffData != null)
         {
            _loc2_ = this.itemBuffData.currentBuff.buffType.toLocaleLowerCase();
            if(param1.hasEmbeddedObject(_loc2_))
            {
               this._img.addChild(param1.getEmbeddedBitmap(_loc2_));
            }
         }
      }
   }
}

