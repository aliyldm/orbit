package net.bigpoint.darkorbit.map.view3D.effects.impl.drive
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.EffectRange3D;
   import net.bigpoint.darkorbit.map.view3D.effects.impl.ShieldEffect3D;
   
   public class DriveShieldEffect3D extends ShieldEffect3D
   {
      
      public function DriveShieldEffect3D(param1:MapView3D, param2:ShieldEffect)
      {
         super(param1,param2);
         this.fixedScale = param2.runScale;
      }
      
      override public function updateObj(param1:Number) : void
      {
         if(!EffectRange3D.near(_effect.source.position,800))
         {
            this.disposeView(true);
            return;
         }
         super.updateObj(param1);
      }
      
      override protected function updateScale() : void
      {
         this.scale = _effect.runScale * _effect.pattern.scale;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         super.disposeView(param1);
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         if(_effect.pattern.soundId != -1)
         {
            AudioManager.playSoundEffect(_effect.pattern.soundId,false,false,_effect.source.position.x,_effect.source.position.y);
         }
      }
   }
}

