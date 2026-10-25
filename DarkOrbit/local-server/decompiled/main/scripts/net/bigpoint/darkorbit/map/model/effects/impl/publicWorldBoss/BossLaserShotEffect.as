package net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss
{
   import com.bigpoint.utils.PointLite;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   
   public class BossLaserShotEffect extends AbstractBoltEffect
   {
      
      public const DISTANCE:Number = 2000;
      
      private var _targetPosition:*;
      
      public function BossLaserShotEffect(param1:MapEntity, param2:PointLite)
      {
         super(EffectIDList.BOSS_LASER_SHOT,param1,[param2],NOT_PERSISTANT);
         this._targetPosition = param2;
      }
      
      override public function get targetPosition() : PointLite
      {
         return this._targetPosition;
      }
   }
}

