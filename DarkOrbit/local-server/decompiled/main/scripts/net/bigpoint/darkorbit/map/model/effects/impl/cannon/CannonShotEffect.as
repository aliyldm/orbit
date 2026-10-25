package net.bigpoint.darkorbit.map.model.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   
   public class CannonShotEffect extends AbstractBoltEffect
   {
      
      private var _cannonType:int;
      
      public function CannonShotEffect(param1:MapEntity, param2:int, param3:int)
      {
         this._cannonType = param3;
         super(EffectIDList.CANNON_SHOT,param1,[param2],PERSISTANT);
      }
      
      public function get cannonType() : int
      {
         return this._cannonType;
      }
   }
}

