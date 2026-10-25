package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   
   public class SpotLightEffect extends MapObjectEffect
   {
      
      private var _iconTrait:IconTrait;
      
      public function SpotLightEffect(param1:Ship)
      {
         super(EffectIDList.SPOT_LIGHT,param1);
         this._iconTrait = new IconTrait("spotlight");
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

