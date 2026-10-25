package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   
   public class NeutralizingTargetEffect extends MapObjectEffect
   {
      
      private var _icon:EntityTraitBase;
      
      public function NeutralizingTargetEffect(param1:MapEntity, param2:int = 1, param3:EffectPattern = null, param4:int = -1)
      {
         super(EffectIDList.NEUTRALIZING_TARGET,param1,param2,param3,param4);
         this._icon = new IconTrait("neutralizingTarget");
      }
      
      override public function activate() : Boolean
      {
         Ship(source).addTrait(this._icon);
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         if(this._icon)
         {
            source.removeTrait(this._icon);
            this._icon = null;
         }
         super.deactivate();
      }
   }
}

