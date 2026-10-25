package net.bigpoint.darkorbit.map.view2D.display.ship
{
   import com.bigpoint.utils.PointLite;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   import flash.utils.setTimeout;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ObjectPoolManager;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.ship.patterns.EnginePositionPattern;
   import net.bigpoint.darkorbit.map.model.ship.patterns.EngineSmokePattern;
   import net.bigpoint.darkorbit.map.model.ship.patterns.ShipPattern;
   import net.bigpoint.darkorbit.map.model.traits.UberDisplayTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.pattern.AudibleResourcePattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class Engines2D extends Sprite implements IFrameObserver, IDisposable
   {
      
      private static const COLOR_TRANSFORM:ColorTransform = new ColorTransform();
      
      private const DEGTORAD:Number = 0.017453292519943295;
      
      private const RADTODEG:Number = 57.29577951308232;
      
      private var _engineFrame:int = 16;
      
      private var _engineClips:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _ship:Ship;
      
      private var _fumesEmmiterOn:Boolean = false;
      
      private var _tpf:Number = 0;
      
      private var _smokeTpf:Number = 0;
      
      private var _fuselage:ShipClip;
      
      private var _trailColorTransform:ColorTransform;
      
      private var _presentationEnabled:Boolean = true;
      
      private var _observing:Boolean = true;
      
      public function Engines2D(param1:Ship, param2:ShipClip)
      {
         super();
         this._ship = param1;
         this._fuselage = param2;
         this._fuselage.changed.add(this.update);
         ScreenManager.addObserver(this);
         Settings.qualityEngine.changed.add(this.updateSmoker);
         Settings.autoQualityReduction.changed.add(this.updateSmoker);
         this.updateSmoker();
         this.initTrailColor();
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         this._fuselage.changed.remove(this.update);
         if(this._observing)
         {
            ScreenManager.removeObserver(this);
         }
         this._observing = false;
         Settings.qualityEngine.changed.remove(this.updateSmoker);
         Settings.autoQualityReduction.changed.remove(this.updateSmoker);
         AudioManager.removeUniqueChannelById(this.enginePattern.getSoundID(),true);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(!this._presentationEnabled)
         {
            return;
         }
         this._tpf += param1;
         if(this._tpf > 50)
         {
            this._tpf = 0;
            if(Boolean(this._engineClips) && this._engineClips.length > 0)
            {
               _loc2_ = this._engineClips[0].framesLoaded;
               if(this._ship.moveTrait.isMoving)
               {
                  if(this._engineFrame > -1)
                  {
                     --this._engineFrame;
                  }
               }
               else if(this._engineFrame < _loc2_ + 1)
               {
                  ++this._engineFrame;
               }
               for each(_loc3_ in this._engineClips)
               {
                  _loc3_.gotoAndStop(this._engineFrame);
               }
            }
            if(this._ship.isHeroShip())
            {
               this.updateSound();
            }
         }
         if(this._fumesEmmiterOn && this._engineFrame < 10 && this._ship.moveTrait.isMoving)
         {
            this._smokeTpf += param1;
            if(this._smokeTpf > 80)
            {
               this.emmitSmoke();
               this._smokeTpf = 0;
            }
         }
      }
      
      private function updateSound() : void
      {
         if(this.enginePattern.getSoundID() == -1)
         {
            return;
         }
         if(this._ship.moveTrait.isMoving)
         {
            AudioManager.playSoundEffect(this.enginePattern.getSoundID(),true,true,-1,-1,true,true);
         }
         else
         {
            AudioManager.removeUniqueChannelById(this.enginePattern.getSoundID(),true);
         }
      }
      
      private function update() : void
      {
         var _loc3_:Vector.<Vector.<PointLite>> = null;
         var _loc4_:int = 0;
         var _loc5_:MovieClip = null;
         var _loc6_:PointLite = null;
         var _loc1_:MovieClip = this._fuselage.clip;
         if(_loc1_ == null)
         {
            this.createEngines(0);
            return;
         }
         var _loc2_:EnginePositionPattern = PatternManager.getEnginePositionPattern(this.shipPattern.getEnginePositionClassID());
         if(_loc1_.framesLoaded == 1)
         {
            _loc4_ = this._fuselage.clipRotation;
            this.initSimpleEnginePositions(_loc1_);
            _loc3_ = this.shipPattern.simpleShipEnginePositions;
         }
         else if(_loc2_ != null)
         {
            _loc4_ = _loc1_.currentFrame - 1;
            if(Settings.qualityEngine.value >= Settings.QUALITY_MEDIUM || _loc2_.lowEnginePositions == null)
            {
               _loc3_ = _loc2_.enginePositions;
            }
            else
            {
               _loc3_ = _loc2_.lowEnginePositions;
            }
         }
         if(_loc3_ == null)
         {
            _loc3_ = new Vector.<Vector.<PointLite>>();
         }
         if(this._engineClips.length != _loc3_.length)
         {
            this.createEngines(_loc3_.length);
         }
         var _loc7_:int = 0;
         while(_loc7_ < this._engineClips.length)
         {
            _loc5_ = this._engineClips[_loc7_];
            _loc4_ %= _loc3_[_loc7_].length;
            _loc6_ = _loc3_[_loc7_][_loc4_];
            _loc5_.x = _loc6_.x;
            _loc5_.y = _loc6_.y;
            _loc5_.rotation = this._ship.rotation.degrees;
            _loc7_++;
         }
      }
      
      private function initSimpleEnginePositions(param1:MovieClip) : void
      {
         var _loc2_:* = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:PointLite = null;
         var _loc7_:Vector.<PointLite> = null;
         var _loc8_:int = 0;
         if(this.shipPattern.simpleShipEnginePositions == null)
         {
            this.shipPattern.simpleShipEnginePositions = new Vector.<Vector.<PointLite>>();
            _loc2_ = int(param1.numChildren - 1);
            while(_loc2_ >= 0)
            {
               _loc3_ = param1.getChildAt(_loc2_);
               if(_loc3_.name.search("engine") != -1)
               {
                  _loc4_ = Math.sqrt(_loc3_.x * _loc3_.x + _loc3_.y * _loc3_.y);
                  _loc5_ = Math.round(Math.atan2(_loc3_.y,_loc3_.x) * this.RADTODEG);
                  _loc7_ = new Vector.<PointLite>(360,true);
                  _loc8_ = 0;
                  while(_loc8_ < 360)
                  {
                     _loc6_ = new PointLite(int(_loc4_ * Math.cos((_loc8_ + _loc5_) * this.DEGTORAD)),int(_loc4_ * Math.sin((_loc8_ + _loc5_) * this.DEGTORAD)));
                     _loc7_[_loc8_] = _loc6_;
                     _loc8_++;
                  }
                  this.shipPattern.simpleShipEnginePositions.push(_loc7_);
               }
               _loc2_--;
            }
         }
         _loc2_ = int(param1.numChildren - 1);
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_.name.search("engine") != -1)
            {
               param1.removeChild(_loc3_);
            }
            _loc2_--;
         }
      }
      
      private function createEngines(param1:int) : void
      {
         var _loc3_:SWFFinisher = null;
         var _loc4_:MovieClip = null;
         var _loc5_:int = 0;
         while(this._engineClips.length)
         {
            removeChild(this._engineClips.pop());
         }
         var _loc2_:String = this.shipPattern.getEnginePositionClassID();
         if(_loc2_)
         {
            _loc3_ = null;
            if(this.enginePattern.getResKey() != "")
            {
               _loc3_ = SWFFinisher(ResourceManager.fileCollection.getFinisher(this.enginePattern.getResKey()));
            }
            _loc5_ = 0;
            while(_loc5_ < param1)
            {
               if(_loc3_ != null)
               {
                  _loc4_ = MovieClip(_loc3_.getEmbeddedMovieClip("mc"));
               }
               else
               {
                  _loc4_ = new MovieClip();
               }
               this._engineClips.push(_loc4_);
               addChild(_loc4_);
               _loc5_++;
            }
         }
      }
      
      private function get shipPattern() : ShipPattern
      {
         return this._ship.shipPattern;
      }
      
      private function get enginePattern() : AudibleResourcePattern
      {
         return PatternManager.enginePatterns[this.shipPattern.getEngineTypeID()];
      }
      
      private function updateSmoker() : void
      {
         if(!this._presentationEnabled || Settings.qualityEngine.value < Settings.QUALITY_GOOD || Settings.allowAutoQuality.value && Settings.autoQualityReduction.value >= Settings.AQ_NO_ENGINE_SMOKE_LIMIT)
         {
            this._fumesEmmiterOn = false;
         }
         else
         {
            this._fumesEmmiterOn = true;
         }
      }
      
      public function setPresentationEnabled(param1:Boolean) : void
      {
         if(this._presentationEnabled == param1)
         {
            return;
         }
         this._presentationEnabled = param1;
         visible = param1;
         if(param1)
         {
            if(!this._observing)
            {
               ScreenManager.addObserver(this);
               this._observing = true;
            }
            this.update();
            this.updateSmoker();
         }
         else
         {
            if(this._observing)
            {
               ScreenManager.removeObserver(this);
               this._observing = false;
            }
            this._fumesEmmiterOn = false;
            this._smokeTpf = 0;
         }
      }
      
      private function initTrailColor() : void
      {
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc1_:UberDisplayTrait = this._ship.getFirstTrait(UberDisplayTrait) as UberDisplayTrait;
         if(Boolean(_loc1_) && Boolean(_loc1_.descriptor) && Boolean(_loc1_.descriptor.display2D))
         {
            _loc2_ = _loc1_.descriptor.display2D[0];
            _loc3_ = String(_loc2_.@engineTrailColor2D);
            if(Boolean(_loc3_) && _loc3_ != "")
            {
               _loc4_ = uint(_loc3_);
               this._trailColorTransform = new ColorTransform();
               this._trailColorTransform.color = _loc4_;
            }
         }
      }
      
      private function emmitSmoke() : void
      {
         var _loc1_:BitmapClip = null;
         var _loc3_:MovieClip = null;
         if(this._ship.cloaked.value && !this._ship.isHeroShip())
         {
            return;
         }
         var _loc2_:EngineSmokePattern = PatternManager.engineSmokePatterns[this.shipPattern.getEngineSmokeID()];
         for each(_loc3_ in this._engineClips)
         {
            _loc1_ = ObjectPoolManager.getEngineSmokeClip(_loc2_.resKey);
            if(_loc1_ != null)
            {
               _loc1_.x = this._ship.position.x + _loc3_.x;
               _loc1_.y = this._ship.position.y + _loc3_.y;
               _loc1_.alpha = this._ship.cloaked.value ? 0.3 : 1;
               _loc1_.transform.colorTransform = this._trailColorTransform != null ? this._trailColorTransform : COLOR_TRANSFORM;
               MapView2D.fxLayer.addChildAt(_loc1_,0);
               _loc1_.frame = 1;
               _loc1_.fps = 45;
               _loc1_.removeAfterPlay = true;
               _loc1_.playOnce();
               setTimeout(ObjectPoolManager.addEngineSmokeClip,1000 * _loc1_.framesLoaded / _loc1_.fps,_loc1_);
            }
         }
      }
      
      public function get engineClips() : Vector.<MovieClip>
      {
         return this._engineClips;
      }
   }
}

