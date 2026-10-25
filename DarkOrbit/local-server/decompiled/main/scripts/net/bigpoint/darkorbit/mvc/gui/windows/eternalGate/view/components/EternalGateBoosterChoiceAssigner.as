package net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.view.components
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalGate.model.vo.EternalGateBoosterVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class EternalGateBoosterChoiceAssigner extends DefaultItemDataAssigner
   {
      
      private var _bg:Button;
      
      private var _img:Coreponent;
      
      private var _value:Label;
      
      public function EternalGateBoosterChoiceAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Button;
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._value = FuiComponentSelectorUtil.selectComponent("value",this) as Label;
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
               this.update();
            }
         }
      }
      
      private function update() : void
      {
         var _loc3_:String = null;
         var _loc1_:EternalGateBoosterVO = data as EternalGateBoosterVO;
         if(!_loc1_)
         {
            this.removeCallbacks();
            return;
         }
         loadResource("eternalGate",this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.GAME);
         var _loc2_:Boolean = _loc1_.percentage != 0;
         _loc3_ = BPLocale.getItemInCategory("items","booster_types_" + _loc1_.category + "_name");
         var _loc4_:String = _loc3_ + " +" + _loc1_.percentage + "%";
         this._value.registeredTextStyleName = _loc2_ ? "eternal_gate_booster_default" : "eternal_gate_booster_default_disabled";
         this._value.text = _loc2_ ? _loc4_ : "";
         tooltipData = _loc2_ ? _loc3_ + "\n \n" + BPLocale.getItemInCategory("items","booster_types_" + _loc1_.category + "_description") : "";
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback("eternalGate",this.handleItemLoaded,AssetsProxy.GAME);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var item:EternalGateBoosterVO;
         var finisher:SWFFinisher = param1;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         item = data as EternalGateBoosterVO;
         if(item)
         {
            try
            {
               this._img.addChild(finisher.getEmbeddedBitmap(item.category + "_100x100"));
               this._img.scaleX = 0.5;
               this._img.scaleY = 0.5;
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}

