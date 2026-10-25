package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class MapObjectGlowRingEffect extends MapObjectEffect
   {
      
      private var _endDiameter:Number;
      
      private var _startDiameter:Number;
      
      private var _endAlpha:Number;
      
      private var _peakAlpha:Number;
      
      private var _ringColor:int;
      
      private var _explosionLike:Boolean;
      
      private var _cycleTime:Number = 4;
      
      private var _loop:Boolean;
      
      public function MapObjectGlowRingEffect(param1:MapEntity, param2:Number = 80, param3:Number = 0, param4:int = 0, param5:Boolean = false, param6:Number = 4, param7:Boolean = true, param8:Boolean = true, param9:Number = 0, param10:Number = 1)
      {
         super(EffectIDList.MAPOBJECT_GLOWING_RING_EFFECT,param1,param7 ? PERSISTANT : NOT_PERSISTANT);
         this._endDiameter = param3;
         this._ringColor = param4;
         this._explosionLike = param5;
         this._cycleTime = param6;
         this._startDiameter = param2;
         this._loop = param8;
         this._endAlpha = param9;
         this._peakAlpha = param10;
      }
      
      public function get position() : PointLite
      {
         return source.position;
      }
      
      public function get endDiameter() : Number
      {
         return this._endDiameter;
      }
      
      public function set endDiameter(param1:Number) : void
      {
         this._endDiameter = param1;
      }
      
      public function get startDiameter() : Number
      {
         return this._startDiameter;
      }
      
      public function set startDiameter(param1:Number) : void
      {
         this._startDiameter = param1;
      }
      
      public function get endAlpha() : Number
      {
         return this._endAlpha;
      }
      
      public function set endAlpha(param1:Number) : void
      {
         this._endAlpha = param1;
      }
      
      public function get peakAlpha() : Number
      {
         return this._peakAlpha;
      }
      
      public function set peakAlpha(param1:Number) : void
      {
         this._peakAlpha = param1;
      }
      
      public function get ringColor() : int
      {
         return this._ringColor;
      }
      
      public function set ringColor(param1:int) : void
      {
         this._ringColor = param1;
      }
      
      public function get explosionLike() : Boolean
      {
         return this._explosionLike;
      }
      
      public function set explosionLike(param1:Boolean) : void
      {
         this._explosionLike = param1;
      }
      
      public function get cycleTime() : Number
      {
         return this._cycleTime;
      }
      
      public function set cycleTime(param1:Number) : void
      {
         this._cycleTime = param1;
      }
      
      public function get loop() : Boolean
      {
         return this._loop;
      }
      
      public function set loop(param1:Boolean) : void
      {
         this._loop = param1;
      }
   }
}

