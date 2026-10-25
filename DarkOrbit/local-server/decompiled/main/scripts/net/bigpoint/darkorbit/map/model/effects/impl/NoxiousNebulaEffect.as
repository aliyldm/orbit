package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class NoxiousNebulaEffect extends Effect
   {
      
      public static const MIN_RADIUS:Number = 200;
      
      public static const MIN_DURATION:Number = 5000;
      
      public static const PEAK_ALPHA:Number = 0.4;
      
      public static const RING_COLOUR:int = 16230819;
      
      private var _pos:PointLite;
      
      private var _radius:Number;
      
      public function NoxiousNebulaEffect(param1:PointLite, param2:Number = 200, param3:Number = 5000)
      {
         super(EffectIDList.NOXIOUS_NEBULA_EFFECT,TIME_OUT);
         this._pos = param1;
         this._radius = param2 <= MIN_RADIUS ? MIN_RADIUS : param2;
         timeOutTime = param3 < 0 ? MIN_DURATION : param3;
      }
      
      public function get position() : PointLite
      {
         return this._pos;
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      public function get diameter() : Number
      {
         return this._radius * 2;
      }
   }
}

