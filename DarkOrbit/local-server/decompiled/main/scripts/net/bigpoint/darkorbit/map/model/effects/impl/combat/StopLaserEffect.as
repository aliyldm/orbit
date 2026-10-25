package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   
   public class StopLaserEffect extends Effect
   {
      
      private var _attacker:MapEntity;
      
      public function StopLaserEffect(param1:MapEntity)
      {
         super(EffectIDList.STOP_LASER,NOT_PERSISTANT);
         this._attacker = param1;
      }
      
      public function get attacker() : MapEntity
      {
         return this._attacker;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._attacker != null;
      }
   }
}

