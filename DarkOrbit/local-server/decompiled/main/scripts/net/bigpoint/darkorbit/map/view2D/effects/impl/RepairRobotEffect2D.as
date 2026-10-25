package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import flash.display.Sprite;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.impl.RepairRobotEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractMapObjectEffect2D;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.display.impl.flash.DOFlashMovieClip;
   import net.bigpoint.darkorbit.mvc.display.utils.DOBitmapAtlasResource;
   import net.bigpoint.darkorbit.mvc.display.utils.DOTexturesProxy;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RepairRobotPattern;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class RepairRobotEffect2D extends AbstractMapObjectEffect2D implements IDisposable, IFrameObserver
   {
      
      private var _robotClips:Vector.<RobotClipBehavior>;
      
      private var _robotPattern:RepairRobotPattern;
      
      private var _sparksPattern:RepairRobotPattern;
      
      private var _robotRes:DOBitmapAtlasResource;
      
      private var _sparksRes:DOBitmapAtlasResource;
      
      private var _repairEffect:RepairRobotEffect;
      
      private var _nextRobotAngleRadians:Number = 0;
      
      public function RepairRobotEffect2D(param1:MapView2D, param2:RepairRobotEffect)
      {
         super(param1,param2);
         this._repairEffect = param2;
         this._repairEffect.repairBotId.changed.add(this.reloadView);
         this._repairEffect.repairSkillLevel.changed.add(this.reloadView);
         this.reloadView();
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         this.internalCleanup();
         super.disposeView(param1);
      }
      
      private function internalCleanup() : void
      {
         AudioManager.removeUniqueChannelById(InGameCatalog.SOUND_ID_REPAIR_START,false);
         AudioManager.removeUniqueChannelById(InGameCatalog.SOUND_ID_REPAIR_BOT,false);
         ScreenManager.removeObserver(this);
         if(this._robotClips != null)
         {
            while(this._robotClips.length > 0)
            {
               RobotClipBehavior(this._robotClips.pop()).dispose();
            }
            this._robotClips = null;
         }
         if(this._sparksRes)
         {
            this._sparksRes.ready.remove(this.initializeRobotsAndSparks);
         }
         if(this._robotRes)
         {
            this._robotRes.ready.remove(this.handleRobotResReady);
         }
      }
      
      private function get repairEffect() : RepairRobotEffect
      {
         return this._repairEffect;
      }
      
      private function reloadView() : void
      {
         this._robotPattern = PatternManager.getRepairRobotPattern(this.repairEffect.repairBotId.value);
         if(this._robotPattern == null)
         {
            this._robotPattern = PatternManager.getRepairRobotPattern("_default");
         }
         this._sparksPattern = PatternManager.getRepairSparksPattern(this.repairEffect.repairSkillLevel.value);
         if(this._sparksPattern == null)
         {
            this._sparksPattern = PatternManager.getRepairSparksPattern(0);
         }
         if(this._robotPattern)
         {
            this._robotRes = this.assetsProxy.getTextureResourceWithPrefix(this._robotPattern.resKey);
            this._robotRes.ready.addOnce(this.handleRobotResReady);
         }
      }
      
      private function get assetsProxy() : DOTexturesProxy
      {
         return GameFacade.getInstance().retrieveProxy(DOTexturesProxy.NAME) as DOTexturesProxy;
      }
      
      private function handleRobotResReady() : void
      {
         this._sparksRes = this.assetsProxy.getTextureResourceWithPrefix(this._sparksPattern.resKey);
         this._sparksRes.ready.addOnce(this.initializeRobotsAndSparks);
      }
      
      private function initializeRobotsAndSparks() : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc5_:DOFlashMovieClip = null;
         var _loc6_:DOFlashMovieClip = null;
         this.internalCleanup();
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_REPAIR_START);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_REPAIR_BOT,true,true,this.repairEffect.source.position.x,this.repairEffect.source.position.y,true,true);
         ScreenManager.addObserver(this);
         var _loc1_:Boolean = Settings.qualityShip.value >= Settings.QUALITY_GOOD;
         this._robotClips = new Vector.<RobotClipBehavior>();
         var _loc4_:* = this._robotPattern.robotsNum;
         while(_loc4_ > 0)
         {
            _loc2_ = new Sprite();
            _loc5_ = new DOFlashMovieClip(this._robotRes,"",30);
            _loc5_.x = this._robotPattern.offsetX;
            _loc5_.y = this._robotPattern.offsetY;
            _loc2_.addChild(_loc5_);
            if(_loc1_)
            {
               if(this._sparksPattern)
               {
                  _loc3_ = new Sprite();
                  _loc6_ = new DOFlashMovieClip(this._sparksRes,"",30);
                  _loc6_.x = this._sparksPattern.offsetX;
                  _loc6_.y = this._sparksPattern.offsetY;
                  _loc6_.currentFrame = int(_loc6_.numFrames * Math.random());
                  _loc3_.addChild(_loc6_);
                  addChild(_loc3_);
               }
            }
            else
            {
               _loc5_.stop();
            }
            addChild(_loc2_);
            this._robotClips.push(new RobotClipBehavior(_loc2_,_loc3_));
            _loc4_--;
         }
         this.updateTimer(1);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:RobotClipBehavior = null;
         for each(_loc2_ in this._robotClips)
         {
            _loc2_.nextMoveTimer += param1;
            _loc2_.ownerRotationRadians = Ship(this.repairEffect.source).rotation.radians;
            if(_loc2_.nextMoveTimer > 0)
            {
               _loc2_.nextMoveTimer = this.randomBetween(-2000,-3000);
               _loc2_.moveTo(this.randomBetween(1,1.2) * Ship(this.repairEffect.source).hitArea.clickRadius,this.nextRobotAngleRadians());
            }
            _loc2_.update(param1);
         }
      }
      
      private function nextRobotAngleRadians() : Number
      {
         this._nextRobotAngleRadians += this.randomBetween(0.2,1) * Math.PI;
         return this._nextRobotAngleRadians;
      }
      
      private function randomBetween(param1:Number, param2:Number) : Number
      {
         return param1 + Math.random() * (param2 - param1);
      }
   }
}

import com.greensock.easing.Linear;
import flash.display.Sprite;
import flash.geom.Point;

class RobotClipBehavior
{
   
   private var _view:Sprite;
   
   private var _sparks:Sprite;
   
   private var _ownerRotationRadians:Number = 0;
   
   public var nextMoveTimer:Number = 0;
   
   public var robotRadius:Number = 0;
   
   public var robotRelativeRotationRadians:Number = 0;
   
   public var sparksRadius:Number = 0;
   
   public var sparksRelativeRotationRadians:Number = 0;
   
   private var _robotDesiredPosition:Point;
   
   private var _sparksDesiredPosition:Point;
   
   public function RobotClipBehavior(param1:Sprite, param2:Sprite)
   {
      super();
      this._view = param1;
      this._sparks = param2;
   }
   
   public function dispose() : void
   {
      this._view.parent.removeChild(this._view);
      this._view = null;
      if(this._sparks != null)
      {
         this._sparks.parent.removeChild(this._sparks);
         this._sparks = null;
      }
   }
   
   public function moveTo(param1:Number, param2:Number) : void
   {
      this.robotRadius = param1;
      this.robotRelativeRotationRadians = param2;
      this.sparksRadius = this.randomBetween(0.3,0.6) * param1;
      this.sparksRelativeRotationRadians = param2 + this.randomBetween(-0.1,0.1);
      this.updateDesiredPositions();
   }
   
   public function set ownerRotationRadians(param1:Number) : void
   {
      if(this._ownerRotationRadians != param1)
      {
         this._ownerRotationRadians = param1;
         this.updateDesiredPositions();
      }
   }
   
   public function update(param1:Number) : void
   {
      this.tweenObject(this._view,this._robotDesiredPosition,param1);
      this._view.scaleX = Math.abs(this._view.scaleX) * (this._view.x > 0 ? -1 : 1);
      if(this._sparks != null)
      {
         this.tweenObject(this._sparks,this._sparksDesiredPosition,param1);
      }
   }
   
   private function tweenObject(param1:Sprite, param2:Point, param3:Number) : void
   {
      var _loc4_:Number = Math.min(param3 / 1000,0.2);
      param1.x = Linear.easeNone(_loc4_,param1.x,param2.x - param1.x,0.2);
      param1.y = Linear.easeNone(_loc4_,param1.y,param2.y - param1.y,0.2);
   }
   
   private function updateDesiredPositions() : void
   {
      this._robotDesiredPosition = Point.polar(this.robotRadius,this._ownerRotationRadians + this.robotRelativeRotationRadians);
      this._sparksDesiredPosition = Point.polar(this.sparksRadius,this._ownerRotationRadians + this.sparksRelativeRotationRadians);
   }
   
   private function randomBetween(param1:Number, param2:Number) : Number
   {
      return param1 + Math.random() * (param2 - param1);
   }
}
