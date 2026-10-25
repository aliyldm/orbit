package net.bigpoint.darkorbit.map.model.effects.impl
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   
   public class FortifyEffect extends MapObjectEffect
   {
      
      private var _hideShip:Boolean;
      
      public function FortifyEffect(param1:Ship, param2:Boolean = false)
      {
         this._hideShip = param2;
         super(EffectIDList.FORTIFY_EFFECT,param1,PERSISTANT,null,InGameCatalog.SOUND_ID_CITADEL_FORTIFY_START);
      }
      
      public function get hideShip() : Boolean
      {
         return this._hideShip;
      }
      
      override public function activate() : Boolean
      {
         if(source.id == Hero.userID)
         {
            ScreenManager.getInstance().eventManager.lockMovement();
            (source as Ship).moveTrait.allowRotation = false;
         }
         return super.activate();
      }
      
      override public function deactivate() : void
      {
         if(source.id == Hero.userID)
         {
            ScreenManager.getInstance().eventManager.unlockMovement();
            (source as Ship).moveTrait.allowRotation = true;
         }
         super.deactivate();
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_CITADEL_FORTIFY_STOP);
      }
   }
}

