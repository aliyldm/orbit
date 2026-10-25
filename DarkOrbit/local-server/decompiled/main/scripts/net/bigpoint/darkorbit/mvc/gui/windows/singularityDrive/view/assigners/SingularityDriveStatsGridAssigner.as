package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveStats;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsItemTipConst;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SingularityDriveStatsGridAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _positiveText:Label;
      
      private var _negativeText:Label;
      
      private var _unlockLabel:Label;
      
      public function SingularityDriveStatsGridAssigner()
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
               this.update(param1 as SingularityDriveStats);
            }
         }
      }
      
      private function get dataVO() : SingularityDriveStats
      {
         return data as SingularityDriveStats;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("img",this) as Coreponent;
         this._positiveText = FuiComponentSelectorUtil.selectComponent("item_stat_positive",this) as Label;
         this._negativeText = FuiComponentSelectorUtil.selectComponent("item_stat_negative",this) as Label;
         this._unlockLabel = FuiComponentSelectorUtil.selectComponent("unlock_info",this) as Label;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback("icons",this.handleItemLoaded,AssetsProxy.GAME);
      }
      
      private function update(param1:SingularityDriveStats) : void
      {
         if(param1.attribute == "")
         {
            this._unlockLabel.visible = true;
            this._positiveText.visible = false;
            this._negativeText.visible = false;
            this._unlockLabel.text = BPLocale.getItem("update_engine_unlock").replace("%VALUE%",param1.unlockLevel + " ");
            tooltipData = null;
         }
         else
         {
            this._unlockLabel.visible = false;
            if(param1.boostValue >= 0)
            {
               this._positiveText.visible = true;
               this._negativeText.visible = false;
               this._positiveText.text = param1.boostValue.toString() + (WarpControlsItemTipConst.PARSEINT_TYPE.indexOf(param1.attribute.toUpperCase()) == -1 ? "%" : "");
            }
            else
            {
               this._positiveText.visible = false;
               this._negativeText.visible = true;
               this._negativeText.text = param1.boostValue.toString() + (WarpControlsItemTipConst.PARSEINT_TYPE.indexOf(param1.attribute.toUpperCase()) == -1 ? "%" : "");
            }
            tooltipData = BPLocale.getItem("shipupgrade_modifiertype_" + param1.attribute.toLowerCase());
         }
         loadResource("icons",this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.GAME);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var bitmap:Bitmap = null;
         var finisher:SWFFinisher = param1;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         try
         {
            if(this.dataVO.attribute == "")
            {
               bitmap = finisher.getEmbeddedBitmap("unknow");
               bitmap.y = 2;
               this._img.addChild(bitmap);
               this._img.scaleX = 1;
               this._img.scaleY = 1;
            }
            else
            {
               this._img.addChild(finisher.getEmbeddedBitmap(this.dataVO.attribute.toLowerCase()));
               this._img.scaleX = 0.3;
               this._img.scaleY = 0.3;
            }
         }
         catch(e:Error)
         {
         }
      }
   }
}

