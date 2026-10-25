package net.bigpoint.darkorbit.mvc.crafting.hyperforge.view.assigners
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.EquipAttributeModule;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class HyperforgeAttributeAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _currentLabel:Label;
      
      private var _rangeLabel:Label;
      
      private var _infoButton:Button;
      
      public function HyperforgeAttributeAssigner()
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
               this.update(param1 as EquipAttributeModule);
            }
         }
      }
      
      private function get dataVO() : EquipAttributeModule
      {
         return data as EquipAttributeModule;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("img",this) as Coreponent;
         this._currentLabel = FuiComponentSelectorUtil.selectComponent("current_label",this) as Label;
         this._rangeLabel = FuiComponentSelectorUtil.selectComponent("range_label",this) as Label;
         this._infoButton = FuiComponentSelectorUtil.selectComponent("info_button",this) as Button;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback("icons",this.handleItemLoaded,AssetsProxy.GAME);
      }
      
      private function update(param1:EquipAttributeModule) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         this._img.mouseEnabled = true;
         this._img.mouseChildren = true;
         if(param1.AttributeID == "-1")
         {
            this._currentLabel.text = "?%";
            this._rangeLabel.text = "+(?%~?%)";
            this._img.tooltipData = null;
            this._infoButton.tooltipData = null;
            this._infoButton.visible = false;
         }
         else
         {
            this._infoButton.visible = true;
            _loc2_ = "";
            _loc3_ = BPLocale.getItemInCategory("inventory","inventory_item_details_field_type");
            _loc4_ = BPLocale.getItem("shipupgrade_modifiertype_" + param1.AttributeID.toLowerCase());
            _loc2_ += _loc3_.replace("%VALUE%",_loc4_);
            _loc2_ += "\n";
            _loc2_ += BPLocale.getItem("window_forge_max_atr").replace("%VALUE%",param1.maxAttributeValue / 100 + "%");
            this._img.tooltipData = _loc2_;
            this._infoButton.tooltipData = _loc2_;
            this._currentLabel.text = "" + param1.AttributeValue / 100 + "%";
            this._rangeLabel.text = "+(" + param1.upMin / 100 + "%~" + param1.upMax / 100 + "%)";
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
            if(this.dataVO.AttributeID == "-1")
            {
               bitmap = finisher.getEmbeddedBitmap("unknow");
               bitmap.y = 2;
               this._img.addChild(bitmap);
               this._img.scaleX = 1;
               this._img.scaleY = 1;
            }
            else
            {
               this._img.addChild(finisher.getEmbeddedBitmap(this.dataVO.AttributeID.toLowerCase()));
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

