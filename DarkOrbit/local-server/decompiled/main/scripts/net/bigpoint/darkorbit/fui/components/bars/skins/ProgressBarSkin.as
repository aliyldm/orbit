package net.bigpoint.darkorbit.fui.components.bars.skins
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.fui.components.core.skins.BasicSkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import net.bigpoint.darkorbit.fui.components.core.skins.SkinLayerNames;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.ISkinLayer;
   import net.bigpoint.darkorbit.fui.components.core.skins.layers.Scale9BitmapLayer;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ProgressBarSkin extends BasicSkin implements IProgressBarSkin
   {
      
      private static var _skinLayerDefintions:Dictionary = new Dictionary();
      
      _skinLayerDefintions[SkinLayerNames.BAR] = {};
      _skinLayerDefintions[SkinLayerNames.NORMAL] = {};
      _skinLayerDefintions[SkinLayerNames.MASK] = {};
      
      private var _tweenTime:Number = 0;
      
      private var _value:Number = 0;
      
      public const tweenComplete:ISignal = new Signal();
      
      public function ProgressBarSkin()
      {
         super();
      }
      
      public function set tweenTime(param1:Number) : void
      {
         this._tweenTime = param1;
      }
      
      override public function getSkinLayerDefintions() : Dictionary
      {
         return _skinLayerDefintions;
      }
      
      override protected function preinitialize() : void
      {
         super.preinitialize();
      }
      
      public function set value(param1:Number) : void
      {
         this._value = param1;
         this.updateProgressBar(param1);
      }
      
      public function setValueNoTween(param1:Number) : void
      {
         this._value = param1;
         this.updateProgressBar(param1,false);
      }
      
      private function updateProgressBar(param1:Number, param2:Boolean = true) : void
      {
         var _loc3_:ISkinLayer = null;
         var _loc4_:Number = NaN;
         var _loc5_:Scale9BitmapLayer = null;
         if(_layers[SkinLayerNames.BAR] is ISkinLayer)
         {
            _loc3_ = _layers[SkinLayerNames.BAR] as ISkinLayer;
            if(_loc3_ is Scale9BitmapLayer)
            {
               _loc5_ = _loc3_ as Scale9BitmapLayer;
               _loc4_ = param1 * (_width - _loc5_.getMinWidth()) + _loc5_.getMinWidth();
            }
            else
            {
               _loc4_ = _width * param1;
            }
            TweenLite.killTweensOf(_loc3_,true);
            if(param2)
            {
               TweenLite.to(_loc3_,this._tweenTime,{
                  "width":_loc4_,
                  "ease":Linear.easeNone,
                  "onComplete":this.onTweenComplete
               });
            }
            else
            {
               _loc3_.width = _loc4_;
            }
            _loc3_.height = _height;
         }
      }
      
      override public function init() : void
      {
         super.init();
         if(_layers[SkinLayerNames.BAR])
         {
            addChild(_layers[SkinLayerNames.BAR]);
            showState(SkinLayerNames.BAR);
         }
         this.updateProgressBar(this._value);
      }
      
      override public function set width(param1:Number) : void
      {
         super.width = param1;
         this.updateProgressBar(this._value);
      }
      
      override public function set height(param1:Number) : void
      {
         super.height = param1;
         this.updateProgressBar(this._value);
      }
      
      override public function clone() : ISkin
      {
         var _loc1_:IProgressBarSkin = super.clone() as IProgressBarSkin;
         _loc1_.value = this._value;
         _loc1_.tweenTime = this._tweenTime;
         return _loc1_;
      }
      
      private function onTweenComplete() : void
      {
         this.tweenComplete.dispatch();
      }
   }
}

