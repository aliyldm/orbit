package net.bigpoint.darkorbit.fui.components.bars
{
   import net.bigpoint.darkorbit.fui.components.bars.skins.IProgressBarSkin;
   import net.bigpoint.darkorbit.fui.components.bars.skins.ProgressBarSkin;
   import net.bigpoint.darkorbit.fui.components.core.Coreponent;
   import net.bigpoint.darkorbit.fui.components.core.InvalidationType;
   import net.bigpoint.darkorbit.fui.components.core.skins.ISkin;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class ProgressBar extends Coreponent
   {
      
      private var _minValue:Number = 0;
      
      private var _maxValue:Number = 1;
      
      private var _currentValue:Number = 0;
      
      public const tweenComplete:ISignal = new Signal();
      
      public function ProgressBar()
      {
         super();
      }
      
      public function get minValue() : Number
      {
         return this._minValue;
      }
      
      public function set minValue(param1:Number) : void
      {
         if(param1 != this._minValue)
         {
            this._minValue = param1;
            this.clampCurrentValue();
            this.updateProgessbarSkin();
         }
      }
      
      public function get maxValue() : Number
      {
         return this._maxValue;
      }
      
      public function set maxValue(param1:Number) : void
      {
         if(param1 != this._maxValue)
         {
            this._maxValue = param1;
            this.clampCurrentValue();
            this.updateProgessbarSkin();
         }
      }
      
      public function get currentValue() : Number
      {
         return this._currentValue;
      }
      
      public function set currentValue(param1:Number) : void
      {
         if(param1 != this._currentValue)
         {
            this._currentValue = param1;
            this.clampCurrentValue();
            this.updateProgessbarSkin();
         }
      }
      
      public function setCurrentValueNoTween(param1:Number) : void
      {
         if(param1 != this._currentValue)
         {
            this._currentValue = param1;
            this.clampCurrentValue();
            this.updateProgessbarSkin(false);
         }
      }
      
      private function clampCurrentValue() : void
      {
         var _loc1_:Number = this._currentValue;
         _loc1_ = _loc1_ > this._maxValue ? this._maxValue : _loc1_;
         _loc1_ = _loc1_ < this._minValue ? this._minValue : _loc1_;
         this._currentValue = _loc1_;
      }
      
      override public function set skin(param1:ISkin) : void
      {
         if(skin is ProgressBarSkin)
         {
            (skin as ProgressBarSkin).tweenComplete.remove(this.onSkinTweenComplete);
         }
         super.skin = param1;
         invalidate(InvalidationType.SIZE);
         this.updateProgessbarSkin();
         if(skin is ProgressBarSkin)
         {
            (skin as ProgressBarSkin).tweenComplete.add(this.onSkinTweenComplete);
         }
      }
      
      override protected function drawSkin() : void
      {
         super.drawSkin();
         this.updateProgessbarSkin();
      }
      
      protected function updateProgessbarSkin(param1:Boolean = true) : void
      {
         if(skin is ProgressBarSkin)
         {
            if(param1)
            {
               (skin as IProgressBarSkin).value = this.ratio;
            }
            else
            {
               (skin as ProgressBarSkin).setValueNoTween(this.ratio);
            }
         }
      }
      
      protected function get ratio() : Number
      {
         var _loc1_:Number = 0;
         var _loc2_:Number = this.currentValue - this.minValue;
         var _loc3_:Number = this.maxValue - this.minValue;
         if(_loc3_ != 0)
         {
            _loc1_ = _loc2_ / _loc3_;
         }
         return _loc1_;
      }
      
      private function onSkinTweenComplete() : void
      {
         this.tweenComplete.dispatch();
      }
   }
}

