package net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.view.components
{
   import com.bigpoint.utils.TextFormatter;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.eternalBlacklight.model.vo.EternalBlacklightBoosterVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class EternalBlacklightActiveBoosterAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _percent:Label;
      
      private var _state:Coreponent;
      
      public function EternalBlacklightActiveBoosterAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._percent = FuiComponentSelectorUtil.selectComponent("value",this) as Label;
         this._state = FuiComponentSelectorUtil.selectComponent("state",this) as Coreponent;
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
         var _loc2_:Boolean = false;
         var _loc1_:EternalBlacklightBoosterVO = data as EternalBlacklightBoosterVO;
         if(!_loc1_)
         {
            this.removeCallbacks();
            return;
         }
         loadResource("eternalBlacklight",this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.GAME);
         _loc2_ = _loc1_.percentage != 0;
         this._percent.registeredTextStyleName = _loc2_ ? "eternal_blacklight_booster_default" : "eternal_blacklight_booster_default_disabled";
         this._percent.text = TextFormatter.roundInteger(_loc1_.percentage) + "%";
         tooltipData = BPLocale.getItemInCategory("items","booster_types_" + _loc1_.category + "_name") + "\n \n" + BPLocale.getItemInCategory("items","booster_types_" + _loc1_.category + "_description");
         this._state.setSkinState(_loc2_ ? "owned" : "notOwned");
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback("eternalBlacklight",this.handleItemLoaded,AssetsProxy.GAME);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var item:EternalBlacklightBoosterVO;
         var finisher:SWFFinisher = param1;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         item = data as EternalBlacklightBoosterVO;
         if(item)
         {
            try
            {
               this._img.addChild(finisher.getEmbeddedBitmap(item.category));
            }
            catch(e:Error)
            {
            }
         }
      }
   }
}

