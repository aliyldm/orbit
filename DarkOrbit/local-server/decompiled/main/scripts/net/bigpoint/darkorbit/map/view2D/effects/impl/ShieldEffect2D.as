package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   
   public class ShieldEffect2D extends AbstractMapObjectEffect2D
   {
      
      public function ShieldEffect2D(param1:MapView2D, param2:ShieldEffect, param3:Boolean = true, param4:Boolean = true, param5:Boolean = true)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function initEffectVisuals() : void
      {
         this.fps = effect.pattern.FPS;
         playAnimation(effect.pattern.isLoop,1,false);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_SHIELD_SELECTED);
         clip.alpha = effect.pattern.initAlpha;
         if(effect.pattern.initAlpha != 1)
         {
            TweenLite.to(clip,0.25,{
               "alpha":1,
               "onComplete":this.handleShield
            });
         }
         else
         {
            TweenLite.delayedCall(2,this.handleTimeoutEventDispatch);
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(disposed)
         {
            return;
         }
         TweenLite.killTweensOf(clip);
         TweenLite.killDelayedCallsTo(this.handleShield);
         TweenLite.killDelayedCallsTo(this.handleFadeOutShield);
         TweenLite.killDelayedCallsTo(this.handleTimeoutEventDispatch);
         TweenLite.killDelayedCallsTo(this.initEffectVisuals);
         super.disposeView(param1);
      }
      
      private function handleShield() : void
      {
         if(disposed)
         {
            return;
         }
         TweenLite.delayedCall(2,this.handleFadeOutShield);
      }
      
      private function handleFadeOutShield() : void
      {
         if(disposed)
         {
            return;
         }
         TweenLite.to(clip,0.75,{
            "alpha":0,
            "onComplete":this.handleTimeoutEventDispatch
         });
      }
      
      private function handleTimeoutEventDispatch() : void
      {
         if(disposed)
         {
            return;
         }
         var _loc1_:ShieldEffect = effect as ShieldEffect;
         if(_loc1_.persistent)
         {
            TweenLite.delayedCall(_loc1_.minSkinShieldTwinkle + Math.random() * (_loc1_.maxSkinShieldTwinkle - _loc1_.minSkinShieldTwinkle),this.initEffectVisuals);
         }
         else
         {
            this.disposeView();
         }
      }
   }
}

