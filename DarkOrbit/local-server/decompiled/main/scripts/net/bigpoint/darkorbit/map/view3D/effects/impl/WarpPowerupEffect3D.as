package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import away3d.containers.ObjectContainer3D;
   import com.greensock.TweenLite;
   import net.bigpoint.darkorbit.map.model.effects.impl.WarpPowerupEffect;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   
   public class WarpPowerupEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "warp_power_up.zip";
      
      private var _ship:ObjectContainer3D;
      
      public function WarpPowerupEffect3D(param1:MapView3D, param2:WarpPowerupEffect)
      {
         super(param2,URL,param2.source.position);
         this._ship = param1.mainContainer.getViewByTrait(param2.source.getFirstTrait(UberDisplayTrait));
         addEvent("explosion",this.fadeOutShip);
      }
      
      private function fadeOutShip() : void
      {
         TweenLite.to(this._ship,0.6,{
            "scaleX":0,
            "scaleY":0,
            "scaleZ":0
         });
      }
   }
}

