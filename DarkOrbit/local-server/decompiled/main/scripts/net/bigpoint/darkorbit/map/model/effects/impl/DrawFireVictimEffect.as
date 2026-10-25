package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   
   public class DrawFireVictimEffect extends MapObjectEffect
   {
      
      private var _iconTrait:IconTrait;
      
      public function DrawFireVictimEffect(param1:MapEntity)
      {
         super(EffectIDList.DRAW_FIRE_VICTIM_EFFECT,param1,PERSISTANT);
         this._iconTrait = new IconTrait("drawFire");
      }
      
      override public function activate() : Boolean
      {
         source.addTrait(this._iconTrait);
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         this.removeTrait();
         super.deactivate();
      }
      
      private function removeTrait() : void
      {
         source.removeTrait(this._iconTrait);
      }
   }
}

