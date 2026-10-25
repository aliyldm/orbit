package net.bigpoint.darkorbit.map.view2D.effects.impl.drive
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.CompactEffectGeometry2D;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectRange2D;
   import net.bigpoint.darkorbit.map.view2D.effects.impl.ShieldEffect2D;
   
   public class DriveShieldEffect2D extends ShieldEffect2D
   {
      
      public function DriveShieldEffect2D(param1:MapView2D, param2:ShieldEffect)
      {
         super(param1,param2,true,true,false);
      }
      
      override protected function initEffectVisuals() : void
      {
         if(!EffectRange2D.near((effect as ShieldEffect).source.position,800))
         {
            this.disposeView(true);
            return;
         }
         TweenMax.delayedCall(0.25,this.checkRange);
         this.clip.scaleX = this.clip.scaleY = (effect as ShieldEffect).runScale * effect.pattern.scale2D;
         CompactEffectGeometry2D.area(this,clip,effect.pattern.resKey);
         this.fps = effect.pattern.FPS;
         playAnimation(effect.pattern.isLoop,1,false,!effect.pattern.isLoop);
         clip.alpha = 1;
         if(effect.pattern.soundId != -1)
         {
            AudioManager.playSoundEffect(effect.pattern.soundId,false,false);
         }
      }
      
      private function checkRange() : void
      {
         if(disposed)
         {
            return;
         }
         if(!EffectRange2D.near((effect as ShieldEffect).source.position,800))
         {
            this.disposeView(true);
            return;
         }
         TweenMax.delayedCall(0.25,this.checkRange);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this.checkRange);
         super.disposeView(param1);
      }
   }
}

