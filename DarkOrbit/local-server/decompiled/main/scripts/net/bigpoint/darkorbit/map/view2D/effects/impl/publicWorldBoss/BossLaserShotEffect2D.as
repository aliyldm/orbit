package net.bigpoint.darkorbit.map.view2D.effects.impl.publicWorldBoss
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.fireworks.Lightning;
   import net.bigpoint.darkorbit.fireworks.LightningFadeType;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.publicWorldBoss.BossLaserShotEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class BossLaserShotEffect2D extends AbstractEffect2D implements IFrameObserver
   {
      
      private static const UPDATE_INTERVAL:Number = 30;
      
      private static const BOLT_FILTER:GlowFilter = new GlowFilter();
      
      private static const LASER_RED:uint = 4294901760;
      
      private static const LASER_FADE:Number = 3;
      
      private var _tpf:Number = 0;
      
      private var boltAnimaionTime:Number = 0.3;
      
      private var boltGraphicVector:Vector.<Lightning> = new Vector.<Lightning>();
      
      private var instantChainBuild:Boolean = false;
      
      private var _effect:BossLaserShotEffect;
      
      private var _map:MapView2D;
      
      public function BossLaserShotEffect2D(param1:MapView2D, param2:BossLaserShotEffect)
      {
         this._effect = param2;
         this._map = param1;
         BOLT_FILTER.color = 16737894;
         BOLT_FILTER.strength = 1;
         BOLT_FILTER.quality = 1;
         BOLT_FILTER.blurX = BOLT_FILTER.blurY = 4;
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this._map.fxLayer.addChild(this);
         if(this.instantChainBuild)
         {
            this.boltAnimaionTime = 1e-7;
         }
         else
         {
            this.boltAnimaionTime = 0.03;
         }
         this.createBoltGraphics();
         ScreenManager.addObserver(this);
         this.createBolt();
         TweenMax.delayedCall(LASER_FADE,this.fadeOutAndRemove);
      }
      
      private function fadeOutAndRemove() : void
      {
         var _loc2_:Lightning = null;
         var _loc1_:int = int(this.boltGraphicVector.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.boltGraphicVector[_loc3_];
            TweenMax.to(_loc2_,0.2,{
               "alpha":0,
               "onComplete":MovieClipUtils.removeDisplayObject,
               "onCompleteParams":[_loc2_]
            });
            _loc3_++;
         }
         TweenMax.delayedCall(0.3,this.disposeView);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Lightning = null;
         this._tpf += param1;
         if(this._tpf > UPDATE_INTERVAL)
         {
            this._tpf = 0;
            _loc2_ = int(this.boltGraphicVector.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.boltGraphicVector[_loc3_];
               if(_loc4_.isAdded)
               {
                  this.updateLightningPositions(_loc4_);
                  _loc4_.update();
               }
               _loc3_++;
            }
         }
      }
      
      private function createBoltGraphics() : void
      {
         var _loc1_:Lightning = new Lightning(LASER_RED,1);
         this.updateLightningPositions(_loc1_);
         _loc1_.childrenDetachedEnd = false;
         _loc1_.childrenLifeSpanMin = 1;
         _loc1_.childrenLifeSpanMax = 2;
         _loc1_.childrenMaxCount = 3;
         _loc1_.childrenMaxCountDecay = 0.5;
         _loc1_.steps = 100;
         _loc1_.thickness = 3;
         _loc1_.speed = 1;
         _loc1_.amplitude = 0.05;
         _loc1_.thicknessDecay = 0.5;
         _loc1_.childrenMaxGenerations = 4;
         _loc1_.childrenProbability = 0.8;
         _loc1_.childrenAngleVariation = 45;
         _loc1_.childrenLengthDecay = 0.7;
         _loc1_.smoothPercentage = 90;
         _loc1_.alphaFadeType = LightningFadeType.TIP_TO_END;
         _loc1_.filters = [BOLT_FILTER];
         this.boltGraphicVector.push(_loc1_);
      }
      
      private function updateLightningPositions(param1:Lightning) : void
      {
         if(!this._effect.targetPosition)
         {
            return;
         }
         param1.startX = this._effect.source.position.x;
         param1.startY = this._effect.source.position.y;
         var _loc2_:PointLite = this.getPointAtDistance(this._effect.source.position,this._effect.targetPosition,this._effect.DISTANCE);
         param1.endX = _loc2_.x;
         param1.endY = _loc2_.y;
      }
      
      private function createBolt() : void
      {
         var _loc1_:int = int(this.boltGraphicVector.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TweenMax.delayedCall(_loc2_ * 0.02,this.addAndFadeIn,[this.boltGraphicVector[_loc2_]]);
            _loc2_++;
         }
      }
      
      private function addAndFadeIn(param1:Lightning) : void
      {
         param1.isAdded = true;
         param1.alpha = 0;
         TweenMax.to(param1,0,{"alpha":1});
         addChild(param1);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         TweenMax.killTweensOf(this.addAndFadeIn);
         var _loc2_:int = int(this.boltGraphicVector.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(this.boltGraphicVector[_loc3_].parent)
            {
               this.boltGraphicVector[_loc3_].parent.removeChild(this.boltGraphicVector[_loc3_]);
            }
            _loc3_++;
         }
         this.boltGraphicVector.length = 0;
         ScreenManager.removeObserver(this);
         super.disposeView(param1);
      }
      
      protected function getPointAtDistance(param1:PointLite, param2:PointLite, param3:Number) : PointLite
      {
         var _loc4_:Number = param2.x - param1.x;
         var _loc5_:Number = param2.y - param1.y;
         var _loc6_:Number = Math.atan2(_loc5_,_loc4_);
         var _loc7_:Number = Infinity;
         var _loc8_:Number = Infinity;
         if(Math.cos(_loc6_) < 0 && param1.x > 0)
         {
            _loc7_ = param1.x / Math.abs(Math.cos(_loc6_));
         }
         if(Math.sin(_loc6_) < 0 && param1.y > 0)
         {
            _loc8_ = param1.y / Math.abs(Math.sin(_loc6_));
         }
         var _loc9_:Number = Math.min(_loc7_,_loc8_,param3 * 0.9);
         return new PointLite(param1.x + Math.cos(_loc6_) * _loc9_,param1.y + Math.sin(_loc6_) * _loc9_);
      }
   }
}

