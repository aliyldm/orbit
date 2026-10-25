package net.bigpoint.darkorbit.map.view3D.effects.combat.laser
{
   import away3d.containers.ObjectContainer3D;
   import away3d.core.base.Geometry;
   import away3d.entities.Mesh;
   import away3d.entities.ParticleGroup;
   import away3d.primitives.PlaneGeometry;
   import away3d.tools.commands.Merge;
   import away3d.tools.helpers.MeshHelper;
   import flash.display.MovieClip;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.utils.Helper;
   import net.bigpoint.darkorbit.map.view3D.utils.IPoolable;
   import net.bigpoint.darkorbit.pattern.LaserPattern;
   import org.osflash.signals.Promise;
   
   public class LaserBullet3D extends ObjectContainer3D implements IPoolable, IDisposable
   {
      
      private static var _doublePlaneGeo:Geometry;
      
      private static var _singlePlaneGeo:Geometry;
      
      private static const DOUBLE_PLANE:String = "doublePlane";
      
      private static const SINGLE_PLANE:String = "singlePlane";
      
      private static const PARTICLE:String = "particle";
      
      private static const TMP:Vector3D = new Vector3D();
      
      private var _bulletLength:Number = 0;
      
      private var _particles:ParticleGroup;
      
      private var _mesh:Mesh;
      
      private var _laserPattern:LaserPattern;
      
      private var _resKey:String;
      
      private var _lookAt:Vector3D;
      
      private var _particlesPromise:Promise;
      
      private var _active:Boolean = true;
      
      public function LaserBullet3D(param1:LaserPattern, param2:String)
      {
         super();
         this._laserPattern = param1;
         this._resKey = param2;
         var _loc3_:String = this._laserPattern.laserType || "doublePlane";
         this._bulletLength = this._laserPattern.laserLength;
         if(_loc3_ == DOUBLE_PLANE)
         {
            this.doublePlaneShoot(this._resKey);
         }
         else if(_loc3_ == SINGLE_PLANE)
         {
            this.singlePlaneShoot(this._resKey);
         }
         else if(_loc3_ == PARTICLE)
         {
            this.particleShoot(this._resKey);
         }
      }
      
      public static function getPoolId(param1:LaserPattern, param2:String) : String
      {
         return "LaserBullet3D_" + param1.laserType + "_" + param2;
      }
      
      public function wakeUp() : void
      {
         this._active = true;
         if(this._particles)
         {
            if(this._lookAt)
            {
               this._particles.lookAt(this._lookAt);
            }
            this._particles.animator.time = 0;
            this._particles.animator.start();
         }
         if(Boolean(this._mesh) && Boolean(this._lookAt))
         {
            this._mesh.lookAt(TMP,Vector3D.Z_AXIS);
         }
      }
      
      public function sleep() : void
      {
         if(this._particles)
         {
            this._particles.animator.stop();
         }
         if(parent)
         {
            parent.removeChild(this);
         }
         this._active = false;
      }
      
      public function get bulletLength() : Number
      {
         return this._bulletLength;
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._particles)
         {
            this._particles.animator.stop();
            this._particles.animator.dispose();
            this._particles.dispose();
            this._particles = null;
         }
         if(this._particlesPromise)
         {
            this._particlesPromise.remove(this.particlesReady);
            this._particlesPromise = null;
         }
         if(this._mesh)
         {
            this._mesh.disposeWithAnimatorAndChildren();
            this._mesh = null;
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function orientTo(param1:Vector3D) : void
      {
         TMP.setTo(param1.x - x,param1.y - y,param1.z - z);
         if(this._mesh)
         {
            this._mesh.lookAt(TMP,Vector3D.Z_AXIS);
         }
         else if(this._particles)
         {
            this._particles.lookAt(TMP);
         }
         else
         {
            this._lookAt = TMP.clone();
         }
      }
      
      private function doublePlaneShoot(param1:String) : void
      {
         var _loc4_:Mesh = null;
         var _loc5_:Mesh = null;
         var _loc6_:Merge = null;
         if(_doublePlaneGeo == null || _doublePlaneGeo.subGeometries.length == 0)
         {
            _loc4_ = new Mesh(new PlaneGeometry(1,1,1,1,true,true));
            _loc5_ = new Mesh(new PlaneGeometry(1,1,1,1,true,true));
            _loc5_.rotationX = 90;
            _loc6_ = new Merge(false,true,false);
            _loc6_.apply(_loc4_,_loc5_);
            MeshHelper.applyPosition(_loc4_,-0.5,0,0);
            _loc4_.x = _loc4_.y = _loc4_.z = 0;
            _loc4_.rotationY = 90;
            MeshHelper.applyRotations(_loc4_);
            _doublePlaneGeo = _loc4_.geometry;
         }
         if(!ResourceManager.isLoaded(param1))
         {
            ResourceManager.loadAndCall(param1,this.doublePlaneShoot,arguments,100);
            return;
         }
         var _loc3_:MovieClip = ResourceManager.getMovieClip(param1,"mc");
         if(this._bulletLength == 0)
         {
            this._bulletLength = _loc3_.width;
         }
         this._mesh = Helper.movieclip2mesh(param1,_loc3_,_doublePlaneGeo);
         this._mesh.scaleX = _loc3_.height;
         this._mesh.scaleY = _loc3_.height;
         this._mesh.scaleZ = _loc3_.width;
         if(this._lookAt)
         {
            this._mesh.lookAt(this._lookAt);
         }
         addChild(this._mesh);
      }
      
      private function singlePlaneShoot(param1:String) : void
      {
         var _loc4_:Mesh = null;
         if(_singlePlaneGeo == null || _singlePlaneGeo.subGeometries.length == 0)
         {
            _loc4_ = new Mesh(new PlaneGeometry(1,1,1,1,true,true));
            _loc4_.rotationY = 90;
            _loc4_.rotationX -= 90;
            MeshHelper.applyRotations(_loc4_);
            _singlePlaneGeo = _loc4_.geometry;
         }
         if(!ResourceManager.isLoaded(param1))
         {
            ResourceManager.loadAndCall(param1,this.singlePlaneShoot,arguments,100);
            return;
         }
         var _loc3_:MovieClip = ResourceManager.getMovieClip(param1,"mc");
         if(this._bulletLength == 0)
         {
            this._bulletLength = _loc3_.width;
         }
         this._mesh = Helper.movieclip2mesh(param1,_loc3_,_singlePlaneGeo);
         this._mesh.scaleX = _loc3_.height * 2;
         this._mesh.scaleY = _loc3_.height * 2;
         this._mesh.scaleZ = _loc3_.width * 2;
         if(this._lookAt)
         {
            this._mesh.lookAt(this._lookAt);
         }
         addChild(this._mesh);
      }
      
      private function particleShoot(param1:String) : void
      {
         this._particlesPromise = World3D.instance.particleLoader.loadParticleByUrl(param1 + ".zip",World3D.LIFETIME_MAP);
         this._particlesPromise.addOnce(this.particlesReady);
      }
      
      private function particlesReady(param1:ParticleGroup) : void
      {
         this._particles = param1.clone() as ParticleGroup;
         if(this._active)
         {
            this._particles.animator.time = 0;
            this._particles.animator.start();
            if(this._lookAt)
            {
               this._particles.lookAt(this._lookAt);
            }
         }
         addChild(this._particles);
      }
      
      public function get poolId() : String
      {
         return getPoolId(this._laserPattern,this._resKey);
      }
      
      public function get pattern() : LaserPattern
      {
         return this._laserPattern;
      }
   }
}

