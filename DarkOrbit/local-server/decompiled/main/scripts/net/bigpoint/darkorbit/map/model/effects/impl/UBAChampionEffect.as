package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   
   public class UBAChampionEffect extends MapObjectEffect
   {
      
      private var _iconTrait:IconTrait;
      
      public function UBAChampionEffect(param1:MapEntity)
      {
         super(EffectIDList.UBA_CHAMPION_EFFECT,param1);
         this._iconTrait = new IconTrait("ubaChampion");
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

