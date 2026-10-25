package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class PhaseOutEffect extends MapObjectEffect
   {
      
      public function PhaseOutEffect(param1:Ship)
      {
         super(EffectIDList.PHASE_OUT_EFFECT,param1,PERSISTANT);
      }
      
      override public function deactivate() : void
      {
         super.deactivate();
      }
   }
}

