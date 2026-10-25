package net.bigpoint.darkorbit.map.view2D.display.ship.drones
{
   import flash.display.Bitmap;
   import flash.geom.ColorTransform;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.darkorbit.managers.ObjectPoolManager;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.drones.Drone;
   import net.bigpoint.darkorbit.map.model.ship.patterns.EngineSmokePattern;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.display.ship.ShipClip;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Drone2D extends ShipClip
   {
      
      private var _drone:Drone;
      
      private var _cacheKey:String;
      
      private var _raster:Bitmap;
      
      private var _released:Boolean = false;
      
      private var _budgetTrails:Boolean = true;
      
      private var _smokes:Vector.<Object> = new Vector.<Object>();
      
      private var _fumesEmmiterOn:Boolean = false;
      
      private var _smokeTpf:Number = 0;
      
      private var _ship:Ship;
      
      private var _engineSmokePattern:EngineSmokePattern;
      
      private var _ct:ColorTransform;
      
      private var _trailLength:Number;
      
      public function Drone2D(param1:Drone, param2:Ship, param3:Boolean = true)
      {
         super();
         this._budgetTrails = param3;
         this._drone = param1;
         this._ship = param2;
         DroneFrameCache2D.acquire();
         var _loc4_:XML = this._drone.uberAssetDescriptor.display2D[0];
         this._cacheKey = Settings.qualityShip.value + ":" + String(_loc4_.@srcKey) + ":" + String(_loc4_.@resKey) + ":" + String(_loc4_.@replacement);
         if(Settings.qualityShip.value == Settings.QUALITY_HIGH)
         {
            load(String(_loc4_.@srcKey) || "drones",String(_loc4_.@resKey));
         }
         else
         {
            load("replacementShips",String(_loc4_.@replacement));
         }
         var _loc5_:uint = uint(this._drone.uberAssetDescriptor.trail.@color);
         if(_loc5_)
         {
            this._trailLength = Number(this._drone.uberAssetDescriptor.trail.@length) || 1;
            this._ct = new ColorTransform();
            this._ct.color = _loc5_;
            Settings.qualityEngine.changed.add(this.updateSmoker);
            Settings.autoQualityReduction.changed.add(this.updateSmoker);
            this._engineSmokePattern = PatternManager.engineSmokePatterns[0] as EngineSmokePattern;
            this.updateSmoker();
         }
      }
      
      override protected function renderDirectionalFrame(param1:int) : void
      {
         var _loc2_:Object = null;
         _loc2_ = DroneFrameCache2D.frame(this._cacheKey,param1,clip);
         if(!_loc2_)
         {
            if(Boolean(this._raster) && Boolean(this._raster.parent))
            {
               removeChild(this._raster);
            }
            if(!clip.parent)
            {
               addChild(clip);
            }
            super.renderDirectionalFrame(param1);
            return;
         }
         if(clip.parent == this)
         {
            removeChild(clip);
         }
         if(!this._raster)
         {
            this._raster = new Bitmap();
         }
         this._raster.bitmapData = _loc2_.pixels;
         this._raster.x = _loc2_.x;
         this._raster.y = _loc2_.y;
         if(!this._raster.parent)
         {
            addChild(this._raster);
         }
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this._budgetTrails = false;
         this._fumesEmmiterOn = false;
         this.clearSmoke();
         if(this._raster)
         {
            this._raster.bitmapData = null;
            if(this._raster.parent)
            {
               removeChild(this._raster);
            }
            this._raster = null;
         }
         if(!this._released)
         {
            this._released = true;
            DroneFrameCache2D.release();
         }
         Settings.qualityEngine.changed.remove(this.updateSmoker);
         Settings.autoQualityReduction.changed.remove(this.updateSmoker);
         this._ship.position.changed.remove(this.emmitSmoke);
         super.disposeView(param1);
      }
      
      private function updateSmoker() : void
      {
         if(!this._budgetTrails || !this._engineSmokePattern || Settings.qualityEngine.value < Settings.QUALITY_GOOD || Settings.allowAutoQuality.value && Settings.autoQualityReduction.value >= Settings.AQ_NO_ENGINE_SMOKE_LIMIT)
         {
            this._fumesEmmiterOn = false;
         }
         else
         {
            this._fumesEmmiterOn = true;
         }
         if(this._fumesEmmiterOn)
         {
            this._ship.position.changed.add(this.emmitSmoke);
         }
         else
         {
            this._ship.position.changed.remove(this.emmitSmoke);
            this.clearSmoke();
         }
      }
      
      public function setTrailsAllowed(param1:Boolean) : void
      {
         if(this._budgetTrails == param1)
         {
            return;
         }
         this._budgetTrails = param1;
         this.updateSmoker();
      }
      
      private function clearSmoke() : void
      {
         while(this._smokes.length)
         {
            this.releaseSmoke(this._smokes[this._smokes.length - 1]);
         }
      }
      
      private function releaseSmoke(param1:Object) : void
      {
         if(param1.released)
         {
            return;
         }
         param1.released = true;
         clearTimeout(param1.timer);
         var _loc2_:int = this._smokes.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._smokes.splice(_loc2_,1);
         }
         var _loc3_:BitmapClip = param1.clip;
         _loc3_.stop();
         if(_loc3_.parent)
         {
            _loc3_.parent.removeChild(_loc3_);
         }
         ObjectPoolManager.addEngineSmokeClip(_loc3_);
      }
      
      private function emmitSmoke() : void
      {
         var _loc1_:BitmapClip = null;
         var _loc2_:Point = null;
         var _loc3_:Object = null;
         if(this._fumesEmmiterOn && this._ship.moveTrait.isMoving)
         {
            this._smokeTpf += 30;
            if(this._smokeTpf > 80)
            {
               this._smokeTpf = 0;
               if(this._ship.cloaked.value && !this._ship.isHeroShip())
               {
                  return;
               }
               _loc1_ = ObjectPoolManager.getEngineSmokeClip(this._engineSmokePattern.resKey);
               if(_loc1_ != null)
               {
                  _loc2_ = MapView2D.fxLayer.globalToLocal(this.localToGlobal(new Point(0,0)));
                  _loc1_.x = _loc2_.x;
                  _loc1_.y = _loc2_.y;
                  _loc1_.alpha = this._ship.cloaked.value ? 0.3 : 1;
                  _loc1_.transform.colorTransform = this._ct;
                  MapView2D.fxLayer.addChildAt(_loc1_,0);
                  _loc1_.frame = 1;
                  _loc1_.fps = 45 / this._trailLength;
                  _loc1_.removeAfterPlay = true;
                  _loc1_.playOnce();
                  _loc3_ = {
                     "clip":_loc1_,
                     "released":false,
                     "timer":0
                  };
                  this._smokes.push(_loc3_);
                  _loc3_.timer = setTimeout(this.releaseSmoke,1000 * _loc1_.framesLoaded / _loc1_.fps,_loc3_);
               }
               return;
            }
            return;
         }
      }
   }
}

