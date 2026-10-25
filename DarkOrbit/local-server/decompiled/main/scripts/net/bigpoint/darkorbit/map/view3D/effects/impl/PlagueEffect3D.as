package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.easing.Quad;
   import net.bigpoint.darkorbit.map.model.effects.impl.PlagueEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.utils.ExtMath;
   
   public class PlagueEffect3D extends StandaloneParticle3D
   {
      
      private static const URL:String = "plague_infected_fx.zip";
      
      private var _ship:Ship;
      
      public function PlagueEffect3D(param1:MapView3D, param2:PlagueEffect)
      {
         this._ship = param2.source as Ship;
         super(param2,URL,param2.source.position);
      }
      
      override public function updateObj(param1:Number) : void
      {
         super.updateObj(param1);
         if(Boolean(this._ship) && Boolean(view))
         {
            view.rotationY = Quad.easeOut(param1,view.rotationY,ExtMath.getShortAngleDegrees(view.rotationY,this._ship.rotation.degrees),0.25);
         }
      }
      
      override protected function initAndPlay() : void
      {
         super.initAndPlay();
         if(Boolean(this._ship) && Boolean(view))
         {
            view.rotationY = this._ship.rotation.degrees;
         }
      }
   }
}

