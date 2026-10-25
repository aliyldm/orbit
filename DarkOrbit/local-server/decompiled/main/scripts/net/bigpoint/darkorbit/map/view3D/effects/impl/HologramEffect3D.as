package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.model.effects.impl.HologramEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   
   public class HologramEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "spawn.zip";
      
      private var _ship:MapUberAsset3D;
      
      public function HologramEffect3D(param1:MapView3D, param2:HologramEffect)
      {
         super(param2,PARTICLES_FILE,param2.source.position);
         this._ship = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         TweenMax.to(this._ship,0.3,{
            "alpha":0.1,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      override protected function cleanUpView() : void
      {
         TweenMax.killTweensOf(this._ship);
         this._ship.alpha = 1;
         super.cleanUpView();
      }
   }
}

