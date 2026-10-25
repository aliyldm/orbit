package net.bigpoint.darkorbit.map.model.effects.impl.beam
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   
   public class WorldBossContinuousLaserBeamEffect extends MapObjectEffect
   {
      
      private var _sourcePosition:PointLite;
      
      private var _targetPosition:PointLite;
      
      public function WorldBossContinuousLaserBeamEffect(param1:MapEntity, param2:PointLite)
      {
         super(EffectIDList.WORLDBOSS_CONTINUOUS_LASER_BEAM_EFFECT,param1,PERSISTANT,null,-1);
         this._sourcePosition = param1.position;
         this._targetPosition = param2;
      }
      
      public function get sourcePosition() : PointLite
      {
         return this._sourcePosition;
      }
      
      public function get targetPosition() : PointLite
      {
         return this._targetPosition;
      }
   }
}

