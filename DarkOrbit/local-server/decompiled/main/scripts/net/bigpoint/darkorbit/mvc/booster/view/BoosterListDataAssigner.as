package net.bigpoint.darkorbit.mvc.booster.view
{
   import com.bigpoint.utils.TextFormatter;
   import com.bigpoint.utils.TimeFormatter;
   import com.bigpoint.utils.bindables.BindableCountDown;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.fui.components.buttons.button.Button;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.booster.BoosterConsts;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterCategory;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.common.view.components.TextureAtlasBitmapFont;
   import net.bigpoint.darkorbit.net.netty.handlers.BeaconHandler;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class BoosterListDataAssigner extends DefaultItemDataAssigner
   {
      
      private var _img:Coreponent;
      
      private var _hover:Button;
      
      private var _time:Label;
      
      private var _category:Label;
      
      private var _percent:Label;
      
      private var _expand:Button;
      
      private var _bg:Coreponent;
      
      private var _minimumTimer:BindableCountDown;
      
      private var _state:Coreponent;
      
      private var _number:Coreponent;
      
      private var _bf:TextureAtlasBitmapFont;
      
      public function BoosterListDataAssigner()
      {
         super();
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._hover = FuiComponentSelectorUtil.selectComponent("hover",this) as Button;
         this._time = FuiComponentSelectorUtil.selectComponent("time",this) as Label;
         this._category = FuiComponentSelectorUtil.selectComponent("category",this) as Label;
         this._percent = FuiComponentSelectorUtil.selectComponent("percent",this) as Label;
         this._expand = FuiComponentSelectorUtil.selectComponent("expand",this) as Button;
         this._bg = FuiComponentSelectorUtil.selectComponent("bg",this) as Coreponent;
         this._state = FuiComponentSelectorUtil.selectComponent("state",this) as Coreponent;
         this._number = FuiComponentSelectorUtil.selectComponent("number",this) as Coreponent;
         this._number.addChild(this._bf = new TextureAtlasBitmapFont());
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
            this.removeListeners();
            super.data = param1;
            this.addListeners();
            if(param1)
            {
               this.update();
            }
         }
      }
      
      private function removeCallbacks() : void
      {
         removeLoadResourceCallback(BoosterConsts.ASSET_LIB,this.handleItemLoaded,AssetsProxy.GAME);
      }
      
      private function updateTime() : void
      {
         this._time.text = TimeFormatter.getSmartFormatedTimeSmall(this._minimumTimer.value);
         var _loc1_:Boolean = this._minimumTimer.value < 60 * 5;
         this._bf.setColor(this.textColor);
         this._state.setSkinState(_loc1_ ? "low" : "normal");
      }
      
      private function get textColor() : int
      {
         var _loc1_:BoosterCategory = data as BoosterCategory;
         if(!_loc1_)
         {
            return 7763574;
         }
         var _loc2_:Boolean = this._minimumTimer ? this._minimumTimer.value < 300 : false;
         return _loc2_ ? 13369344 : (_loc1_.hasActiveBoosters ? 15461355 : 7763574);
      }
      
      private function update() : void
      {
         var _loc1_:BoosterCategory = data as BoosterCategory;
         if(!_loc1_)
         {
            this.removeCallbacks();
            this.removeListeners();
            return;
         }
         loadResource(BoosterConsts.ASSET_LIB,this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.GAME);
         var _loc2_:Boolean = _loc1_.hasActiveBoosters;
         this._category.registeredTextStyleName = _loc2_ ? BoosterConsts.BOOSTER_HEADLINE_DEFAULT : BoosterConsts.BOOSTER_HEADLINE_DEFAULT_DISABLED;
         this._percent.registeredTextStyleName = _loc2_ ? BoosterConsts.BOOSTER_DEFAULT : BoosterConsts.BOOSTER_DEFAULT_DISABLED;
         this._category.text = _loc1_.translation;
         this._percent.text = _loc2_ ? "+" + TextFormatter.round(_loc1_.totalPercent,2) + "%" : "-";
         this._bf.setValue(_loc1_.activeBoostersCount.toString(),this.textColor);
         tooltipData = _loc1_.description;
         this.updateTimerReference();
         this._state.setSkinState(_loc2_ ? "normal" : "none");
         if(this._minimumTimer)
         {
            this.updateTime();
         }
         else
         {
            this._time.text = "";
         }
         this.updateCountDown();
         BeaconHandler.inStation.changed.add(this.updateCountDown);
      }
      
      private function updateTimerReference() : void
      {
         var _loc1_:BoosterCategory = data as BoosterCategory;
         if(this._minimumTimer)
         {
            this._minimumTimer.changed.remove(this.updateTime);
            this._minimumTimer.complete.remove(this.update);
         }
         this._minimumTimer = _loc1_.getMinimumTimer();
         if(this._minimumTimer)
         {
            this._minimumTimer.changed.add(this.updateTime);
            this._minimumTimer.complete.add(this.update);
         }
      }
      
      private function updateCountDown() : void
      {
         var _loc1_:BoosterCategory = data as BoosterCategory;
         if(!_loc1_)
         {
            return;
         }
         if(this._minimumTimer)
         {
            if(BeaconHandler.inStation.value)
            {
               this._minimumTimer.stop();
            }
            else
            {
               this._minimumTimer.recover();
            }
         }
      }
      
      override protected function drawSelection() : void
      {
         super.drawSelection();
         if(isSelected())
         {
            this._bg.visible = true;
            this._expand.registeredSkinName = "booster_arrow_left";
         }
         else
         {
            this._bg.visible = false;
            this._expand.registeredSkinName = "booster_arrow_right";
         }
      }
      
      private function addListeners() : void
      {
         var _loc1_:BoosterCategory = data as BoosterCategory;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.changed.add(this.update);
      }
      
      private function removeListeners() : void
      {
         if(this._minimumTimer)
         {
            this._minimumTimer.changed.remove(this.updateTime);
            this._minimumTimer.complete.remove(this.update);
         }
         var _loc1_:BoosterCategory = data as BoosterCategory;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.changed.remove(this.update);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:SWFFinisher = null) : void
      {
         var boosterCategory:BoosterCategory;
         var finisher:SWFFinisher = param1;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         boosterCategory = data as BoosterCategory;
         if(boosterCategory)
         {
            try
            {
               this._img.addChild(finisher.getEmbeddedBitmap(boosterCategory.category.toLocaleLowerCase()));
            }
            catch(e:Error)
            {
            }
         }
      }
      
      override public function dispose() : void
      {
         this.removeListeners();
         super.dispose();
      }
   }
}

