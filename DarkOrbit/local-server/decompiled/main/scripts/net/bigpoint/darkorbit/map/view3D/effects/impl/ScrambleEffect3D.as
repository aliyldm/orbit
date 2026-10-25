package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.map.model.effects.impl.ScrambleEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.MapUberAsset3D;
   
   public class ScrambleEffect3D extends StandaloneParticle3D
   {
      
      private static const PARTICLES_FILE:String = "frost_sparcles.zip";
      
      private var _ship3d:MapUberAsset3D;
      
      private var _ship:Ship;
      
      public function ScrambleEffect3D(param1:MapView3D, param2:ScrambleEffect)
      {
         this._ship = param2.source as Ship;
         super(param2,PARTICLES_FILE,this._ship.position);
         scale = 0.3;
         this._ship3d = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait)) as MapUberAsset3D;
         TweenMax.to(this._ship3d,1,{
            "alpha":0.2,
            "repeat":-1,
            "yoyo":true
         });
      }
      
      override protected function cleanUpView() : void
      {
         TweenMax.killTweensOf(this._ship3d);
         if(this._ship.cloaked.value)
         {
            this._ship3d.alpha = 0.5;
         }
         else
         {
            this._ship3d.alpha = 1;
         }
         super.cleanUpView();
      }
   }
}

