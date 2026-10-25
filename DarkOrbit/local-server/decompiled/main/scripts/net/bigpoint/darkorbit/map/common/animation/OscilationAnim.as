package net.bigpoint.darkorbit.map.common.animation
{
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   
   public class OscilationAnim implements IUpdatable
   {
      
      private var _target:Object;
      
      private var _property:String;
      
      private var _minValue:Number;
      
      private var _maxValue:Number;
      
      private var _timeScale:Number;
      
      private var _halfValueSpread:Number;
      
      private var _t:Number = Math.random() * Math.PI * 2;
      
      public function OscilationAnim(param1:Object, param2:String, param3:Number, param4:Number, param5:Number)
      {
         super();
         this._target = param1;
         this._property = param2;
         this._minValue = param3;
         this._maxValue = param4;
         this._halfValueSpread = (param4 - param3) * 0.5;
         this._timeScale = 2 * Math.PI / param5;
      }
      
      public function updateObj(param1:Number) : void
      {
         this._t += param1 * this._timeScale;
         this._target[this._property] = this._minValue + this._halfValueSpread * (Math.sin(this._t) + 1);
      }
   }
}

