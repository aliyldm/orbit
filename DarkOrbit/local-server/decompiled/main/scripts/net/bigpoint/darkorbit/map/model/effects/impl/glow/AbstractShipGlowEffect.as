package net.bigpoint.darkorbit.map.model.effects.impl.glow
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class AbstractShipGlowEffect extends MapObjectEffect
   {
      
      private var _blurRadian:uint;
      
      private var _startImmediately:Boolean;
      
      private var _color:uint;
      
      private var _glowStrength:Number = 1.5;
      
      private var _pulseTime:Number = 0;
      
      private var _innerGlow:Boolean;
      
      public function AbstractShipGlowEffect(param1:int, param2:MapEntity, param3:uint = 16777215, param4:uint = 20, param5:Boolean = true, param6:EffectPattern = null, param7:int = -1)
      {
         super(param1,param2,PERSISTANT,param6,param7);
         this._color = param3;
         this._blurRadian = param4;
         this._startImmediately = param5;
      }
      
      public function get glowStrength() : Number
      {
         return this._glowStrength;
      }
      
      public function set glowStrength(param1:Number) : void
      {
         this._glowStrength = param1;
      }
      
      public function get pulseTime() : Number
      {
         return this._pulseTime;
      }
      
      public function set pulseTime(param1:Number) : void
      {
         this._pulseTime = param1;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function get blurRadian() : uint
      {
         return this._blurRadian;
      }
      
      public function get startImmediately() : Boolean
      {
         return this._startImmediately;
      }
      
      public function get innerGlow() : Boolean
      {
         return this._innerGlow;
      }
      
      public function set innerGlow(param1:Boolean) : void
      {
         this._innerGlow = param1;
      }
   }
}

