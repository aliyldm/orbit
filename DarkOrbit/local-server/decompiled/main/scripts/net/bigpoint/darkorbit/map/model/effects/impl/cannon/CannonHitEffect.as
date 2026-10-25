package net.bigpoint.darkorbit.map.model.effects.impl.cannon
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class CannonHitEffect extends MapObjectEffect
   {
      
      private var _cannonType:int;
      
      public function CannonHitEffect(param1:MapEntity, param2:int)
      {
         super(EffectIDList.CANNON_HIT,param1,NOT_PERSISTANT,new EffectPattern(EffectIDList.BOSS_ESCAPE,"boss_escape"));
         this._cannonType = param2;
      }
      
      public function get cannonType() : int
      {
         return this._cannonType;
      }
   }
}

