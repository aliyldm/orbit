package net.bigpoint.darkorbit.mvc.booster.view.details
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.list.itemlist.DefaultItemDataAssigner;
   import net.bigpoint.darkorbit.fui.components.text.label.Label;
   import net.bigpoint.darkorbit.fui.system.utils.FuiComponentSelectorUtil;
   import net.bigpoint.darkorbit.mvc.booster.BoosterConsts;
   import net.bigpoint.darkorbit.mvc.booster.model.BoosterCategory;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.BoosterItem;
   import net.bigpoint.darkorbit.mvc.booster.model.boosterItems.PlayerBoosterItem;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.net.netty.handlers.BeaconHandler;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class BoosterDetailDataAssigner extends DefaultItemDataAssigner
   {
      
      private static var _currentData:BoosterCategory;
      
      public static const MISS_ING:Object = {};
      
      private var _img:Coreponent;
      
      private var _boosterName:Label;
      
      private var _effect:Label;
      
      private var _value:Label;
      
      private var _state:Coreponent;
      
      public function BoosterDetailDataAssigner()
      {
         super();
      }
      
      public static function set currentData(param1:BoosterCategory) : void
      {
         _currentData = param1;
      }
      
      override public function assignChildren() : void
      {
         super.assignChildren();
         this._img = FuiComponentSelectorUtil.selectComponent("pic",this) as Coreponent;
         this._boosterName = FuiComponentSelectorUtil.selectComponent("boosterName",this) as Label;
         this._effect = FuiComponentSelectorUtil.selectComponent("effect",this) as Label;
         this._value = FuiComponentSelectorUtil.selectComponent("value",this) as Label;
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
            this.removeListeners();
            super.data = param1;
            if(param1)
            {
               this.update(this.booster);
               this.addListeners();
            }
         }
      }
      
      private function get booster() : BoosterItem
      {
         return data as BoosterItem;
      }
      
      private function removeCallbacks() : void
      {
         var _loc1_:BoosterItem = data as BoosterItem;
         if(!_loc1_)
         {
            return;
         }
         removeLoadResourceCallback(this.booster.item.getLoot30x30(),this.handleItemLoaded,AssetsProxy.ITEMS);
      }
      
      private function update(param1:BoosterItem) : void
      {
         tooltipData = param1.item.fullname + "\n \n" + param1.getDescription(_currentData.category);
         this._boosterName.registeredTextStyleName = param1.owned ? BoosterConsts.BOOSTER_HEADLINE_DEFAULT : BoosterConsts.BOOSTER_HEADLINE_DEFAULT_DISABLED;
         this._value.registeredTextStyleName = param1.owned ? BoosterConsts.BOOSTER_DEFAULT : BoosterConsts.BOOSTER_DEFAULT_DISABLED;
         this._effect.registeredTextStyleName = param1.owned ? BoosterConsts.BOOSTER_DEFAULT : BoosterConsts.BOOSTER_DEFAULT_DISABLED;
         loadResource(param1.item.getLoot30x30(),this.handleItemLoaded,this.handleItemLoadError,AssetsProxy.ITEMS);
         this._boosterName.text = param1.item.codeName;
         this.updateValue();
         this._state.setSkinState(param1.owned ? "owned" : "notOwned");
         this.updateCountDown();
         BeaconHandler.inStation.changed.add(this.updateCountDown);
      }
      
      private function updateCountDown() : void
      {
         var _loc1_:PlayerBoosterItem = data as PlayerBoosterItem;
         if(!_loc1_)
         {
            return;
         }
         if(BeaconHandler.inStation.value)
         {
            _loc1_.countdown.stop();
         }
         else
         {
            _loc1_.countdown.recover();
         }
      }
      
      private function updateValue() : void
      {
         var _loc1_:BoosterItem = data as BoosterItem;
         if(!_loc1_)
         {
            return;
         }
         this._value.text = _loc1_.getValueText(_currentData.category);
         this._effect.text = _loc1_.getEffectText(_currentData.category);
      }
      
      private function addListeners() : void
      {
         var _loc1_:PlayerBoosterItem = data as PlayerBoosterItem;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.countdown.changed.add(this.updateValue);
      }
      
      private function removeListeners() : void
      {
         var _loc1_:PlayerBoosterItem = data as PlayerBoosterItem;
         if(!_loc1_)
         {
            return;
         }
         _loc1_.countdown.changed.remove(this.updateValue);
      }
      
      private function handleItemLoadError(param1:*) : void
      {
         var _loc2_:BoosterItem = data as BoosterItem;
         MISS_ING[_loc2_.item.lootID] = true;
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
      }
      
      private function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         MovieClipUtils.cleanupDisplayObjectContainer(this._img);
         this._img.addChild(new Bitmap(param1.getBitmap().bitmapData));
      }
      
      override public function dispose() : void
      {
         this.removeListeners();
         super.dispose();
      }
   }
}

