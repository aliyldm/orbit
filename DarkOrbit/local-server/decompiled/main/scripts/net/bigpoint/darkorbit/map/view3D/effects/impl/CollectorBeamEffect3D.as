package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.CollectorBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.TimerCountdownEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class CollectorBeamEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "collect_cargo.zip";
      
      private static const PARTICLES_LONG_FILE:String = "collect_cargo_long.zip";
      
      private var _effect:CollectorBeamEffect;
      
      private var _timeoutEffect:TimerCountdownEffect;
      
      public function CollectorBeamEffect3D(param1:MapView3D, param2:CollectorBeamEffect)
      {
         this._effect = param2;
         var _loc3_:String = PARTICLES_FILE;
         if(param2.countdownDuration > 4)
         {
            _loc3_ = PARTICLES_LONG_FILE;
         }
         super(param2,_loc3_,param2.source.position,null,true);
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         if(this._effect.useCountdownVisual)
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
         super.disposeView(param1);
      }
   }
}

