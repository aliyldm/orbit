package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   
   public class GenericHUDIconEffect extends MapObjectEffect
   {
      
      private var _iconTrait:IconTrait;
      
      public function GenericHUDIconEffect(param1:MapEntity, param2:String)
      {
         super(EffectIDList.GENERIC_HUD_ICON,param1,PERSISTANT);
         this._iconTrait = new IconTrait(param2);
      }
      
      override public function activate() : Boolean
      {
         source.addTrait(this._iconTrait);
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         source.removeTrait(this._iconTrait);
         super.deactivate();
      }
   }
}

