package net.bigpoint.darkorbit.map.view3D.display3D.uber
{
   import away3d.entities.ParticleGroup;
   import away3d.events.ParticleGroupEvent;
   import com.greensock.easing.Quad;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.common.IRenderable;
   import net.bigpoint.darkorbit.map.common.IUpdatable;
   import net.bigpoint.darkorbit.map.view3D.display3D.*;
   import net.bigpoint.darkorbit.map.view3D.utils.ParticleLeasePool3D;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Promise;
   import org.osflash.signals.Signal;
   
   public class Particle3D implements IUpdatable, IRenderable, IDisposable
   {
      
      private static const LIGHT_EVENT_NAME:String = "light";
      
      private static const UP:Vector3D = new Vector3D(0,-1,0);
      
      public const ready:ISignal = new Signal();
      
      public const completed:ISignal = new Signal();
      
      public var scale:Number = 1;
      
      public var scaleFactor:Number = 1;
      
      private const _vec:Vector.<Number> = new Vector.<Number>(3,true);
      
      private const _lookAt:Vector3D = new Vector3D();
      
      private var _eventLookUp:Dictionary = new Dictionary();
      
      private var _promise:Promise;
      
      private var _isBillboard:Boolean = false;
      
      private var _scalingDown:Boolean = false;
      
      private var _scaleTimer:Number = 0;
      
      private var _interpolateScale:Boolean = true;
      
      private var _path:String;
      
      private var _internalScale:Number = 1;
      
      private var _useEffectsPool:Boolean = false;
      
      private var _timestamp:int;
      
      private var _maxDelay:int = 0;
      
      private var _autoDisposeDelayMs:int;
      
      private var _autoDisposeTimer:uint;
      
      private var _readyTimer:uint;
      
      private var _disposed:Boolean = false;
      
      protected var _aniSpeed:Number = 1;
      
      private var _view:ParticleGroup;
      
      public function Particle3D(param1:String, param2:Boolean = false, param3:Number = 0, param4:Boolean = true, param5:Number = 0)
      {
         super();
         this._path = param1;
         this._useEffectsPool = param2;
         this._maxDelay = param3 * 1000;
         this._autoDisposeDelayMs = param5 * 1000;
         this._timestamp = getTimer();
         if(param1)
         {
            this.addEvent("end",this.handleEndEvent);
            this._promise = World3D.instance.particleLoader.loadParticleByUrl(param1,World3D.LIFETIME_MAP,param4);
            this._promise.addOnce(this.particlesReady);
         }
      }
      
      protected function handleEndEvent() : void
      {
         this.disposeView();
      }
      
      public function get view() : ParticleGroup
      {
         return this._view;
      }
      
      public function updateObj(param1:Number) : void
      {
         if(this._view == null)
         {
            return;
         }
         var _loc2_:Number = Number.NaN;
         if(this._scalingDown)
         {
            _loc2_ = 0;
         }
         else if(this._view.customParamters.scalable !== 0)
         {
            _loc2_ = this.scale;
            if(Number(this._view.customParamters.maxScale))
            {
               _loc2_ = Math.min(_loc2_,Number(this._view.customParamters.maxScale));
               _loc2_ *= this.scaleFactor;
            }
         }
         if(this._internalScale != _loc2_ && !isNaN(_loc2_))
         {
            this._internalScale = _loc2_;
            this._scaleTimer = 0;
         }
         this._scaleTimer += param1;
         this.applyScale(this._interpolateScale ? Quad.easeInOut(Math.min(this._scaleTimer,0.5),this._view.scaleX,this._internalScale - this._view.scaleX,0.5) : this._internalScale);
         if(this._scaleTimer > 0.5 && this._scalingDown)
         {
            this.cleanUpView();
         }
         else
         {
            this._view.animator.time += param1 * 1000 * this._view.animator.playbackSpeed * this._aniSpeed;
         }
      }
      
      protected function applyScale(param1:Number) : void
      {
         this._view.scaleX = this._view.scaleY = this._view.scaleZ = param1;
      }
      
      public function preRender() : void
      {
         var _loc1_:Vector3D = null;
         if(Boolean(this._view) && this._isBillboard)
         {
            _loc1_ = World3D.instance.mapView.camera.position;
            this.lookAt(_loc1_.x,_loc1_.y,_loc1_.z);
         }
      }
      
      public function postRender() : void
      {
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._disposed)
         {
            return;
         }
         if(Boolean(!param1) && Boolean(this._view) && this._view.customParamters.dispose == "scaleDown")
         {
            this._scalingDown = true;
         }
         else
         {
            this.cleanUpView();
         }
      }
      
      public function addEvent(param1:String, param2:Function) : void
      {
         this._eventLookUp[param1] = param2;
      }
      
      protected function initAndPlay() : void
      {
         if(this._view.customParamters.billboard === 1)
         {
            this._isBillboard = true;
         }
         this._view.animator.time = 0;
         this._view.animator.addEventListener(ParticleGroupEvent.OCCUR,this.handleOccur);
         this.updateObj(0);
         if(this._autoDisposeDelayMs > 0)
         {
            this._autoDisposeTimer = setTimeout(this.handleAutoDispose,this._autoDisposeDelayMs);
         }
         if(!this._disposed)
         {
            this._readyTimer = setTimeout(this.dispatchReady,1);
         }
      }
      
      private function dispatchReady() : void
      {
         this._readyTimer = 0;
         if(!this._disposed && Boolean(this._view))
         {
            this.ready.dispatch();
         }
      }
      
      protected function cleanUpView() : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         if(this._readyTimer)
         {
            clearTimeout(this._readyTimer);
            this._readyTimer = 0;
         }
         if(this._autoDisposeTimer)
         {
            clearTimeout(this._autoDisposeTimer);
            this._autoDisposeTimer = 0;
         }
         if(this._promise)
         {
            this._promise.remove(this.particlesReady);
            this._promise = null;
         }
         if(this._view)
         {
            if(this._view.parent)
            {
               this._view.parent.removeChild(this._view);
            }
            this._view.animator.removeEventListener(ParticleGroupEvent.OCCUR,this.handleOccur);
            if(this._useEffectsPool)
            {
               ParticleLeasePool3D.release(this._view);
            }
            else
            {
               this._view.dispose();
            }
            this._view = null;
         }
         this.completed.dispatch();
      }
      
      private function handleAutoDispose() : void
      {
         this._autoDisposeTimer = 0;
         if(this._view)
         {
            this.disposeView();
         }
      }
      
      private function particlesReady(param1:ParticleGroup) : void
      {
         if(this._disposed)
         {
            return;
         }
         if(!param1)
         {
            this.cleanUpView();
            return;
         }
         if(Boolean(this._maxDelay) && getTimer() - this._timestamp > this._maxDelay)
         {
            this.cleanUpView();
            return;
         }
         if(this._useEffectsPool)
         {
            this._view = ParticleLeasePool3D.acquire(param1);
         }
         if(this._view == null)
         {
            this._view = param1.clone() as ParticleGroup;
         }
         this.resetPooledView(this._view);
         this.initAndPlay();
      }
      
      private function resetPooledView(param1:ParticleGroup) : void
      {
         this._isBillboard = false;
         this._scalingDown = false;
         this._internalScale = 1;
         this._scaleTimer = 0;
         if(param1 == null)
         {
            return;
         }
         param1.visible = true;
         param1.x = param1.y = param1.z = 0;
         param1.rotationX = param1.rotationY = param1.rotationZ = 0;
         param1.scaleX = param1.scaleY = param1.scaleZ = 1;
      }
      
      protected function lookAt(param1:Number, param2:Number, param3:Number) : void
      {
         if(this._view.parent)
         {
            this._vec[0] = param1;
            this._vec[1] = param2;
            this._vec[2] = param3;
            this._view.parent.inverseSceneTransform.transformVectors(this._vec,this._vec);
            this._lookAt.setTo(this._vec[0],this._vec[1],this._vec[2]);
            this._view.lookAt(this._lookAt,UP);
            this._view.rotationX += 90;
         }
      }
      
      private function addEffectLight(param1:String) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc2_:Object = this._view.customParamters[param1];
         if(_loc2_)
         {
            _loc3_ = Number(Number(_loc2_.radius) || 100);
            _loc4_ = Number(Number(_loc2_.duration) || 0.5);
            _loc5_ = Number(Number(_loc2_.fading) || 0.3);
            _loc6_ = 16777215;
            if(_loc2_.color)
            {
               _loc6_ = uint("0x" + _loc2_.color.substr(1));
            }
            World3D.instance.lights.activateEffectLight(this._view.x,this._view.y,this._view.z,_loc6_,_loc3_,0,20,_loc4_,_loc5_);
         }
      }
      
      private function handleOccur(param1:ParticleGroupEvent) : void
      {
         var _loc3_:Function = null;
         var _loc2_:String = param1.eventProperty.customName;
         if(_loc2_.toLowerCase().indexOf(LIGHT_EVENT_NAME) == 0)
         {
            this.addEffectLight(_loc2_);
         }
         else
         {
            _loc3_ = this._eventLookUp[_loc2_];
            if(_loc3_ != null)
            {
               _loc3_();
            }
         }
      }
      
      public function set interpolateScale(param1:Boolean) : void
      {
         this._interpolateScale = param1;
      }
   }
}

