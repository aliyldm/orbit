package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.RapidFireEffect;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class RapidFireEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "sparks_red.zip";
      
      private var _target:MapEntity;
      
      private var _shakeTween:TweenMax;
      
      public function RapidFireEffect3D(param1:MapView3D, param2:RapidFireEffect)
      {
         this._target = param2.source;
         super(param2,PARTICLES_FILE,this._target.position);
         this._shakeTween = TweenMax.to(this._target.position,0.075,{
            "z":2,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      override protected function cleanUpView() : void
      {
         this._shakeTween.restart();
         this._shakeTween.kill();
         super.cleanUpView();
      }
   }
}

