package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   
   public class DominationEffect extends MapObjectEffect
   {
      
      private var _iconTrait:IconTrait;
      
      public function DominationEffect(param1:MapEntity)
      {
         super(EffectIDList.DOMINATION_ICON_EFFECT,param1,PERSISTANT);
         this._iconTrait = new IconTrait("domination");
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

