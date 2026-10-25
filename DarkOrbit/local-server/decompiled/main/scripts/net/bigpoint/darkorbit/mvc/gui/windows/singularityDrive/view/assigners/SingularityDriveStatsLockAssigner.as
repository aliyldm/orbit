package net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.view.assigners
{
   import flash.display.Bitmap;
   import flash.events.Event;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBox;
   import net.bigpoint.darkorbit.fui.components.buttons.checkbox.CheckBoxEvent;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.singularityDrive.model.SingularityDriveStats;
   import net.bigpoint.darkorbit.mvc.gui.windows.warpControls.mode.WarpControlsItemTipConst;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class SingularityDriveStatsLockAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _positiveText:Label;
      
      private var _negativeText:Label;
      
      private var _unlockLabel:Label;
      
      private var _checkbox:CheckBox;
      
      public function SingularityDriveStatsLockAssigner()
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
         this._checkbox = FuiComponentSelectorUtil.selectComponent("lock_checkbox",this) as CheckBox;
         this._checkbox.addEventListener(CheckBoxEvent.EVENT_SELECTION_CHANGED,this.onSelectionChangeHandler);
      }
      
      private function onSelectionChangeHandler(param1:CheckBoxEvent) : void
      {
         var _loc2_:SingularityDriveProxy = SingularityDriveProxy.getProxy();
         var _loc3_:Vector.<int> = _loc2_.getLockDataByItemID(this.dataVO.itemID);
         var _loc4_:int = _loc3_.indexOf(this.dataVO.index + 1);
         if(_loc4_ != -1)
         {
            if(!this._checkbox.isSelected())
            {
               _loc3_.splice(_loc4_,1);
            }
         }
         else if(this._checkbox.isSelected())
         {
            if(_loc3_.length >= _loc2_.getMaxLockByItemId(this.dataVO.itemID) - 1)
            {
               this._checkbox.unselect();
               return;
            }
            _loc3_.push(this.dataVO.index + 1);
         }
         this.dispatchEvent(new Event(Event.CHANGE,true));
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
         var _loc2_:Vector.<int> = null;
         if(param1.attribute == "")
         {
            this._unlockLabel.visible = true;
            this._positiveText.visible = false;
            this._negativeText.visible = false;
            this._unlockLabel.text = BPLocale.getItem("update_engine_unlock").replace("%VALUE%",param1.unlockLevel + " ");
            tooltipData = null;
            this._checkbox.visible = false;
         }
         else
         {
            this._unlockLabel.visible = false;
            this._checkbox.visible = true;
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
            _loc2_ = SingularityDriveProxy.getProxy().getLockDataByItemID(this.dataVO.itemID);
            if(_loc2_.indexOf(this.dataVO.index + 1) != -1)
            {
               this._checkbox.select();
            }
            else
            {
               this._checkbox.unselect();
            }
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

