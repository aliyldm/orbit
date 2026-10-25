package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.map.model.traits.hud.MapObjectInfoTrait;
   
   public class HologramEffect extends MapObjectEffect
   {
      
      private var _infoTrait:MapObjectInfoTrait;
      
      private var _hpTrait:HPTrait;
      
      public function HologramEffect(param1:Ship)
      {
         super(EffectIDList.HOLOGRAM_EFFECT,param1,PERSISTANT);
      }
      
      override public function activate() : Boolean
      {
         this._infoTrait = source.getFirstTrait(MapObjectInfoTrait) as MapObjectInfoTrait;
         this._hpTrait = source.getFirstTrait(HPTrait) as HPTrait;
         source.removeTrait(this._infoTrait);
         source.removeTrait(this._hpTrait);
         source.addTrait(this._hpTrait);
         if(Boolean(this.ship) && Boolean(this.ship.drones))
         {
            this.ship.drones.visible.value = false;
         }
         return super.activate();
      }
      
      private function get ship() : Ship
      {
         return source as Ship;
      }
      
      override public function deactivate() : void
      {
         if(this._infoTrait)
         {
            source.addTrait(this._infoTrait);
            this._infoTrait = null;
            source.removeTrait(this._hpTrait);
            source.addTrait(this._hpTrait);
         }
         if(Boolean(this.ship) && Boolean(this.ship.drones))
         {
            this.ship.drones.visible.value = true;
         }
         super.deactivate();
      }
   }
}

