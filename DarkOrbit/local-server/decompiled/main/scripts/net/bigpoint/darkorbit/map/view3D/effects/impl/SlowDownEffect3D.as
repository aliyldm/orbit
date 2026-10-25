package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SlowDownEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class SlowDownEffect3D implements IDisposable, IUpdatable
   {
      
      private static const URL_STATIONARY:String = "slow_down.zip";
      
      private static const URL_MOVING:String = "slow_down_trail.zip";
      
      private var stationary:StandaloneParticle3D;
      
      private var moving:StandaloneParticle3D;
      
      private var _effect:MapObjectEffect;
      
      public function SlowDownEffect3D(param1:MapView3D, param2:SlowDownEffect)
      {
         super();
         this._effect = param2;
         this.stationary = new StandaloneParticle3D(param2,URL_STATIONARY,param2.source.position,this._effect.source);
         if(this.ship.moveTrait.isMoving)
         {
            this.moving = new StandaloneParticle3D(param2,URL_MOVING,param2.source.position,this._effect.source);
         }
         this.ship.moveTrait.moveStarted.add(this.moveStarted);
         this.ship.moveTrait.moveStopped.add(this.moveStopped);
         World3D.instance.mapView.addUpdatable(this);
      }
      
      private function moveStopped() : void
      {
         if(this.moving)
         {
            TweenLite.killTweensOf(this.moving.view);
            this.moving.disposeView();
            this.moving = null;
         }
      }
      
      private function getShortAngleDegrees(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = (param2 - param1) % 360;
         if(_loc3_ != _loc3_ % 180)
         {
            _loc3_ = _loc3_ < 0 ? _loc3_ + 360 : _loc3_ - 360;
         }
         return _loc3_;
      }
      
      public function updateObj(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(this.stationary.view)
         {
            this.stationary.view.rotationY = this.ship.rotation.degrees - 90;
         }
         if(Boolean(this.moving) && Boolean(this.moving.view))
         {
            _loc2_ = Math.atan2(this.ship.moveTrait.destination.y - this.ship.position.y,this.ship.moveTrait.destination.x - this.ship.position.x) * FastMath.RADTODEG + 90;
            this.moving.view.rotationY = Quad.easeOut(param1,this.moving.view.rotationY,this.getShortAngleDegrees(this.moving.view.rotationY,_loc2_),0.25);
         }
      }
      
      private function moveStarted() : void
      {
         if(this.moving == null)
         {
            this.moving = new StandaloneParticle3D(this._effect,URL_MOVING,this.ship.position,this._effect.source);
         }
      }
      
      private function get ship() : Ship
      {
         return this._effect.source as Ship;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this.ship.moveTrait.moveStarted.remove(this.moveStarted);
         this.ship.moveTrait.moveStopped.remove(this.moveStopped);
         World3D.instance.mapView.removeUpdatable(this);
         this.moveStopped();
         this.stationary.disposeView();
      }
   }
}

