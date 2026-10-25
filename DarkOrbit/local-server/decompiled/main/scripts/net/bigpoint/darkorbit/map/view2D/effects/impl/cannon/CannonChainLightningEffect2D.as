package net.bigpoint.darkorbit.map.view2D.effects.impl.cannon
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.fireworks.Lightning;
   import net.bigpoint.darkorbit.fireworks.LightningFadeType;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   import net.bigpoint.darkorbit.map.view2D.DenseEffectPolicy2D;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectRange2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.ChainBoltPositionProvider;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class CannonChainLightningEffect2D extends AbstractEffect2D implements IFrameObserver
   {
      
      private static const DENSE_SIMPLIFICATION_ENABLED:Boolean = true;
      
      private static const BOLT_FILTER:GlowFilter = new GlowFilter();
      
      private static const UPDATE_INTERVAL:Number = 30;
      
      private var instantChainBuild:Boolean = false;
      
      private var _positionProvider:ChainBoltPositionProvider;
      
      private var _effect:AbstractBoltEffect;
      
      private var _map:MapView2D;
      
      private var boltAnimaionTime:Number = 0.3;
      
      private var boltFadeTime:Number = 0.8;
      
      private var boltGraphicVector:Vector.<Lightning> = new Vector.<Lightning>();
      
      private var _tpf:Number = 0;
      
      private var compact:Boolean;
      
      private var ended:Boolean;
      
      private var observing:Boolean;
      
      public function CannonChainLightningEffect2D(param1:MapView2D, param2:AbstractBoltEffect)
      {
         this._effect = param2;
         this._map = param1;
         this._positionProvider = new ChainBoltPositionProvider(this._effect.chainArray,this._effect.attacker);
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
            this.boltAnimaionTime = 0.3;
         }
         BOLT_FILTER.color = 13426669;
         BOLT_FILTER.strength = 3.5;
         BOLT_FILTER.quality = 1;
         BOLT_FILTER.blurX = BOLT_FILTER.blurY = 10;
         this.compact = DENSE_SIMPLIFICATION_ENABLED && DenseEffectPolicy2D.denseScene && !EffectRange2D.connectsHero(this._effect);
         if(this.compact)
         {
            visible = false;
            TweenMax.delayedCall(this.boltFadeTime,this.fadeOutAndRemove);
            return;
         }
         this.createBoltGraphics();
         ScreenManager.addObserver(this);
         this.observing = true;
         this.createBolt();
         TweenMax.delayedCall(this.boltFadeTime,this.fadeOutAndRemove);
      }
      
      private function fadeOutAndRemove() : void
      {
         var _loc2_:Lightning = null;
         if(this.ended)
         {
            return;
         }
         TweenMax.killTweensOf(this.addAndFadeIn);
         if(this.observing)
         {
            ScreenManager.removeObserver(this);
            this.observing = false;
         }
         var _loc1_:int = int(this.boltGraphicVector.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc1_)
         {
            _loc2_ = this.boltGraphicVector[_loc3_];
            if(_loc2_)
            {
               TweenMax.to(_loc2_,0.2,{
                  "alpha":0,
                  "onComplete":MovieClipUtils.removeDisplayObject,
                  "onCompleteParams":[_loc2_]
               });
            }
            _loc3_++;
         }
         TweenMax.delayedCall(0.2,this.disposeView);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Lightning = null;
         var _loc5_:PointLite = null;
         if(this.ended)
         {
            return;
         }
         if(this.compact != (DENSE_SIMPLIFICATION_ENABLED && DenseEffectPolicy2D.denseScene && !EffectRange2D.connectsHero(this._effect)))
         {
            this.compact = DENSE_SIMPLIFICATION_ENABLED && DenseEffectPolicy2D.denseScene && !EffectRange2D.connectsHero(this._effect);
            if(this.compact)
            {
               visible = false;
               if(this.observing)
               {
                  ScreenManager.removeObserver(this);
                  this.observing = false;
               }
               return;
            }
         }
         if(this.compact)
         {
            return;
         }
         this._tpf += param1;
         if(this._tpf > (this.compact ? 0 : UPDATE_INTERVAL))
         {
            this._tpf = 0;
            _loc2_ = int(this.boltGraphicVector.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.boltGraphicVector[_loc3_];
               if((Boolean(_loc4_)) && _loc4_.isAdded)
               {
                  _loc5_ = _loc3_ > 0 ? this._positionProvider.positions[_loc3_ - 1] : this._positionProvider.attackerPosition;
                  _loc4_.visible = EffectRange2D.link(_loc5_,this._positionProvider.positions[_loc3_],800);
                  if(_loc4_.visible)
                  {
                     this.updateLightningPositions(_loc4_,_loc3_);
                     _loc4_.update();
                  }
               }
               _loc3_++;
            }
         }
      }
      
      private function createBoltGraphics() : void
      {
         var _loc2_:PointLite = null;
         var _loc3_:Lightning = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._positionProvider.positions.length)
         {
            _loc2_ = _loc1_ > 0 ? this._positionProvider.positions[_loc1_ - 1] : this._positionProvider.attackerPosition;
            if(!EffectRange2D.link(_loc2_,this._positionProvider.positions[_loc1_],800))
            {
               this.boltGraphicVector.push(null);
            }
            else
            {
               _loc3_ = new Lightning(13886189,2);
               this.configure(_loc3_);
               this.updateLightningPositions(_loc3_,_loc1_);
               this.boltGraphicVector.push(_loc3_);
            }
            _loc1_++;
         }
      }
      
      private function configure(param1:Lightning) : void
      {
         param1.straightCompact = this.compact;
         param1.compactHalo = false;
         param1.childrenMaxGenerations = 3;
         param1.childrenDetachedEnd = false;
         param1.childrenLifeSpanMin = 1;
         param1.childrenLifeSpanMax = 2;
         param1.childrenMaxCount = 5;
         param1.childrenMaxCountDecay = 0.5;
         param1.alphaFadeType = LightningFadeType.GENERATION;
         param1.steps = 30;
         param1.childrenProbability = 0.1;
         param1.thickness = 2.5;
         param1.speed = 2;
         param1.filters = [BOLT_FILTER];
         if(this.compact)
         {
            param1.steps = 22;
            param1.childrenMaxCount = 2;
            param1.childrenProbability = 0.08;
            param1.thickness = 1.9;
            param1.filters = [];
            param1.compactHalo = true;
            param1.childrenMaxGenerations = 1;
            param1.childrenLifeSpanMin = 0.35;
            param1.childrenLifeSpanMax = 0.7;
         }
         param1.straightCompact = true;
         param1.compactHalo = true;
         param1.childrenMaxCount = 0;
         param1.childrenMaxGenerations = 0;
         param1.childrenProbability = 0;
         param1.steps = 12;
         param1.thickness = 1.2;
         param1.filters = [];
      }
      
      private function createBolt() : void
      {
         var _loc1_:int = int(this.boltGraphicVector.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.boltGraphicVector[_loc2_])
            {
               TweenMax.delayedCall(Math.min(_loc2_ * 0.08,0.3),this.addAndFadeIn,[this.boltGraphicVector[_loc2_]]);
            }
            _loc2_++;
         }
      }
      
      private function updateLightningPositions(param1:Lightning, param2:int) : void
      {
         var _loc3_:* = param2 - 1 >= 0 ? this._positionProvider.positions[param2 - 1].x : this._positionProvider.attackerPosition.x;
         var _loc4_:* = param2 - 1 >= 0 ? this._positionProvider.positions[param2 - 1].y : this._positionProvider.attackerPosition.y;
         var _loc5_:* = this._positionProvider.positions[param2].x;
         var _loc6_:* = this._positionProvider.positions[param2].y;
         param1.startX = _loc3_;
         param1.startY = _loc4_;
         param1.endX = _loc5_;
         param1.endY = _loc6_;
      }
      
      private function addAndFadeIn(param1:Lightning) : void
      {
         if(this.ended || !param1)
         {
            return;
         }
         param1.isAdded = true;
         param1.alpha = 0;
         TweenMax.to(param1,0.15,{"alpha":1});
         addChild(param1);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:Lightning = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.ended)
         {
            return;
         }
         this.ended = true;
         TweenMax.killTweensOf(this.fadeOutAndRemove);
         TweenMax.killTweensOf(this.disposeView);
         for each(_loc2_ in this.boltGraphicVector)
         {
            if(_loc2_)
            {
               TweenMax.killTweensOf(_loc2_);
               _loc2_.killAllChildren();
            }
         }
         TweenMax.killTweensOf(this.addAndFadeIn);
         _loc3_ = int(this.boltGraphicVector.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            if(Boolean(this.boltGraphicVector[_loc4_]) && Boolean(this.boltGraphicVector[_loc4_].parent))
            {
               this.boltGraphicVector[_loc4_].parent.removeChild(this.boltGraphicVector[_loc4_]);
            }
            _loc4_++;
         }
         this.boltGraphicVector.length = 0;
         if(this.observing)
         {
            ScreenManager.removeObserver(this);
         }
         this.observing = false;
         super.disposeView(param1);
      }
   }
}

