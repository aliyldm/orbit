package net.bigpoint.darkorbit.map.model.effects.impl.combat
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class AbsorbationBeamEffect extends MapObjectEffect
   {
      
      private var _target:Ship;
      
      private var _isElite:Boolean;
      
      public function AbsorbationBeamEffect(param1:MapEntity, param2:Ship, param3:Boolean = false)
      {
         this._isElite = param3;
         this._target = param2;
         super(EffectIDList.ABSORBATION_EFFECT,param1,Effect.NOT_PERSISTANT,null,InGameCatalog.SOUND_ID_PIRATE_BATTLERAY_HEAL);
      }
      
      public function get target() : Ship
      {
         return this._target;
      }
      
      public function get isElite() : Boolean
      {
         return this._isElite;
      }
      
      override public function isValid() : Boolean
      {
         return Boolean(super.isValid()) && this._target != null;
      }
      
      override public function activate() : Boolean
      {
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_PIRATE_BATTLERAY_HEAL,false,false,source.position.x,source.position.y);
         return super.activate();
      }
   }
}

