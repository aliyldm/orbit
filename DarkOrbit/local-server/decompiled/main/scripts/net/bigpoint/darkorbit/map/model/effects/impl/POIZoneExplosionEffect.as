package net.bigpoint.darkorbit.map.model.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class POIZoneExplosionEffect extends Effect
   {
      
      private var _position:PointLite;
      
      public function POIZoneExplosionEffect(param1:PointLite, param2:Boolean = false)
      {
         super(EffectIDList.POIZONE_EXPLOSION_EFFECT,NOT_PERSISTANT);
         this._position = param1;
      }
      
      public function get position() : PointLite
      {
         return this._position;
      }
   }
}

