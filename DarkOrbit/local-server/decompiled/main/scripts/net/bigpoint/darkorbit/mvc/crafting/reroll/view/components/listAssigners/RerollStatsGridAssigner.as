package net.bigpoint.darkorbit.mvc.crafting.reroll.view.components.listAssigners
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.UnstableAttributeModule;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RerollStatsGridAssigner extends DefaultItemDataAssigner
   {
      
      private static var CANNON_IGNORE_DEF_THERMAL:String = "CANNON_IGNORE_DEF_THERMAL";
      
      private static var CANNON_IGNORE_DEF_CORROSIVE:String = "CANNON_IGNORE_DEF_CORROSIVE";
      
      private static var CANNON_IGNORE_DEF_ELECTRO:String = "CANNON_IGNORE_DEF_ELECTRO";
      
      private var _img:Coreponent;
      
      private var _positiveText:Label;
      
      private var _negativeText:Label;
      
      private var _info_btn:Button;
      
      public function RerollStatsGridAssigner()
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
               this.update(param1 as UnstableAttributeModule);
            }
         }
      }
      
      private function get dataVO() : UnstableAttributeModule
      {
         return data as UnstableAttributeModule;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("img",this) as Coreponent;
         this._positiveText = FuiComponentSelectorUtil.selectComponent("item_stat_positive",this) as Label;
         this._negativeText = FuiComponentSelectorUtil.selectComponent("item_stat_negative",this) as Label;
         this._info_btn = FuiComponentSelectorUtil.selectComponent("info_button",this) as Button;
      }
      
      override public function dispose() : void
      {
         super.dispose();
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback("icons",this.handleItemLoaded,AssetsProxy.GAME);
      }
      
      private function update(param1:UnstableAttributeModule) : void
      {
         loadResource("icons",this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.GAME);
         var _loc2_:String = "";
         var _loc3_:String = BPLocale.getItemInCategory("inventory","inventory_item_details_field_type");
         var _loc4_:String = BPLocale.getItem("shipupgrade_modifiertype_" + param1.attribute.toLowerCase());
         _loc2_ += _loc3_.replace("%VALUE%",_loc4_);
         if(param1.boostValue >= 0)
         {
            this._positiveText.visible = true;
            this._negativeText.visible = false;
            this._positiveText.text = this.isCannonIgnoreDef(param1.attribute) ? param1.boostValue.toString() + "" : param1.boostValue.toString() + "%";
            _loc2_ += "\n";
            _loc2_ += BPLocale.getItem("window_forge_max_atr").replace("%VALUE%",this._positiveText.text);
         }
         else
         {
            this._positiveText.visible = false;
            this._negativeText.visible = true;
            this._negativeText.text = this.isCannonIgnoreDef(param1.attribute) ? param1.boostValue.toString() + "" : param1.boostValue.toString() + "%";
            _loc2_ += "\n";
            _loc2_ += BPLocale.getItem("window_forge_max_atr").replace("%VALUE%",this._negativeText.text);
         }
         tooltipData = _loc2_;
      }
      
      private function isCannonIgnoreDef(param1:String) : Boolean
      {
         return param1 == CANNON_IGNORE_DEF_CORROSIVE || param1 == CANNON_IGNORE_DEF_THERMAL || param1 == CANNON_IGNORE_DEF_ELECTRO;
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var finisher:SWFFinisher = param1;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         try
         {
            this._img.addChild(finisher.getEmbeddedBitmap(this.dataVO.attribute.toLowerCase()));
            this._img.scaleX = 0.3;
            this._img.scaleY = 0.3;
         }
         catch(e:Error)
         {
         }
      }
   }
}

