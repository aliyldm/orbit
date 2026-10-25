package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitBase;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.hud.IconTrait;
   
   public class MirroredControlsEffect extends MapObjectEffect
   {
      
      private var _icon:EntityTraitBase;
      
      public function MirroredControlsEffect(param1:MapEntity)
      {
         super(EffectIDList.MIRRORED_CONTROLS_EFFECT,param1,PERSISTANT);
         this._icon = new IconTrait("mirrorControls");
      }
      
      override public function activate() : Boolean
      {
         Ship(source).addTrait(this._icon);
         if(source.id == Hero.userID)
         {
            ScreenManager.getInstance().eventManager.mirrorControls();
         }
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         if(source.id == Hero.userID)
         {
            ScreenManager.getInstance().eventManager.unmirrorControls();
         }
         if(this._icon)
         {
            source.removeTrait(this._icon);
            this._icon = null;
         }
         super.deactivate();
      }
   }
}

