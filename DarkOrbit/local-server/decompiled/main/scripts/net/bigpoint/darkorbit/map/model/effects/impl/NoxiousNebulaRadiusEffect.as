package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class NoxiousNebulaRadiusEffect extends Effect
   {
      
      public static const MIN_RADIUS:Number = 200;
      
      public static const MIN_DURATION:Number = 5000;
      
      private var _radius:Number;
      
      private var _pos:PointLite;
      
      public function NoxiousNebulaRadiusEffect(param1:PointLite, param2:Number = 200, param3:Number = 5000)
      {
         super(EffectIDList.NOXIOUS_NEBULA_RADIUS_EFFECT,TIME_OUT);
         this._pos = param1;
         this._radius = param2 <= MIN_RADIUS ? MIN_RADIUS : param2;
         timeOutTime = param3 <= 0 ? MIN_DURATION : param3;
      }
      
      public function get radius() : Number
      {
         return this._radius;
      }
      
      public function get position() : PointLite
      {
         return this._pos;
      }
   }
}

