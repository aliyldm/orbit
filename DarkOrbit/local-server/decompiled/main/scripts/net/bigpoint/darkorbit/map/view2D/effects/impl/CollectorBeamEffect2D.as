package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.CollectorBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerCountdownEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractShipEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CollectorBeamEffect2D extends AbstractShipEffect2D
   {
      
      private var _effect:CollectorBeamEffect;
      
      private var _timeoutEffect:TimerCountdownEffect;
      
      public function CollectorBeamEffect2D(param1:MapView2D, param2:CollectorBeamEffect)
      {
         this._effect = param2;
         super(param1,param2,true,false);
      }
      
      private function get beamEffect() : CollectorBeamEffect
      {
         return effect as CollectorBeamEffect;
      }
      
      override protected function initEffectVisuals() : void
      {
         if(!shipView)
         {
            return;
         }
         shipView.addChildAt(this.clip,0);
         effectMc.alpha = 1;
         effectMc.x = 0;
         effectMc.y = ship.hitArea.clickRadius;
         playAnimation();
         if(this.beamEffect.useCountdownVisual)
         {
            this._timeoutEffect = new TimerCountdownEffect(this._effect.source,this._effect.countdownDuration);
            ScreenManager.getInstance().map.effects.addEffect(this._timeoutEffect);
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._timeoutEffect)
         {
            ScreenManager.getInstance().map.effects.removeEffect(this._timeoutEffect);
            this._timeoutEffect = null;
         }
         TweenMax.killDelayedCallsTo(this.handleLootCompleted);
         MovieClipUtils.removeDisplayObject(clip);
         this.handleLootCompleted();
      }
      
      private function handleLootCompleted() : void
      {
         if(effectMc)
         {
            TweenMax.to(effectMc,0.5,{
               "alpha":0,
               "onComplete":super.disposeView
            });
         }
         else
         {
            super.disposeView();
         }
      }
   }
}

