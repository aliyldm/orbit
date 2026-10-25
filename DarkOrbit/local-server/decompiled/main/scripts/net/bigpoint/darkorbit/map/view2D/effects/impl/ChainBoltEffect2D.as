package net.bigpoint.darkorbit.map.view2D.effects.impl
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.fireworks.Lightning;
   import net.bigpoint.darkorbit.fireworks.LightningFadeType;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   import net.bigpoint.darkorbit.map.view2D.DenseEffectPolicy2D;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectRange2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.ChainBoltPositionProvider;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class ChainBoltEffect2D extends AbstractEffect2D implements IFrameObserver
   {
      
      private static const DENSE_SIMPLIFICATION_ENABLED:Boolean = true;
      
      private static const UPDATE_INTERVAL:Number = 30;
      
      private static const BOLT_FILTER:GlowFilter = new GlowFilter();
      
      private var _tpf:Number = 0;
      
      private var _compact:Boolean = false;
      
      private var _built:Boolean = false;
      
      private var _disposed:Boolean = false;
      
      private var boltAnimaionTime:Number = 0.3;
      
      private var boltFadeTime:Number = 3;
      
      private var boltGraphicVector:Vector.<Lightning> = new Vector.<Lightning>();
      
      private var colorChainBolt:uint = 14544639;
      
      private var colorParticleBeam:uint = 16200448;
      
      private var colorShieldLink:uint = 5084598;
      
      private var colorHPLink:uint = 8183666;
      
      private var colorVoltageLink:uint = 10732;
      
      private var instantChainBuild:Boolean = false;
      
      private var _positionProvider:ChainBoltPositionProvider;
      
      private var _effect:AbstractBoltEffect;
      
      private var _map:MapView2D;
      
      public function ChainBoltEffect2D(param1:MapView2D, param2:AbstractBoltEffect)
      {
         this._effect = param2;
         this._map = param1;
         this._positionProvider = new ChainBoltPositionProvider(this._effect.chainArray,this._effect.attacker);
         switch(param2.id)
         {
            case EffectIDList.CHAIN_BOLT:
               BOLT_FILTER.color = this.colorChainBolt;
               break;
            case EffectIDList.PARTICLE_BEAM:
               BOLT_FILTER.color = this.colorParticleBeam;
               break;
            case EffectIDList.SHIELD_LINK:
            case EffectIDList.BOSS_ENERGY_BAY_LINK:
               BOLT_FILTER.color = this.colorShieldLink;
               break;
            case EffectIDList.HP_LINK:
               BOLT_FILTER.color = this.colorHPLink;
               break;
            case EffectIDList.VOLTAGE_LINK_EFFECT:
               BOLT_FILTER.color = this.colorVoltageLink;
         }
         BOLT_FILTER.strength = 3.5;
         BOLT_FILTER.quality = 1;
         BOLT_FILTER.blurX = BOLT_FILTER.blurY = 10;
         super(param1,param2);
      }
      
      private function get limitedLightning() : Boolean
      {
         return this._effect.id == EffectIDList.CHAIN_BOLT || this._effect.id == EffectIDList.VOLTAGE_LINK_EFFECT;
      }
      
      private function linkAllowed(param1:int) : Boolean
      {
         return !this.limitedLightning || EffectRange2D.link(param1 > 0 ? this._positionProvider.positions[param1 - 1] : this._positionProvider.attackerPosition,this._positionProvider.positions[param1],800);
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
         this._compact = DENSE_SIMPLIFICATION_ENABLED && DenseEffectPolicy2D.denseScene;
         if(this._compact)
         {
            visible = false;
         }
         else
         {
            this.buildVisuals();
         }
         ScreenManager.addObserver(this);
         if(this._effect.id == EffectIDList.CHAIN_BOLT || this._effect.id == EffectIDList.VOLTAGE_LINK_EFFECT)
         {
            TweenMax.delayedCall(0.8,this.fadeOutAndRemove);
            TweenMax.delayedCall(1,this.disposeView,[true]);
         }
      }
      
      private function fadeOutAndRemove() : void
      {
         var _loc2_:Lightning = null;
         if(this._disposed)
         {
            return;
         }
         TweenMax.killTweensOf(this.addAndFadeIn);
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
         TweenMax.delayedCall(0.3,this.disposeView);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Lightning = null;
         if(this._disposed)
         {
            return;
         }
         if(this._compact != (DENSE_SIMPLIFICATION_ENABLED && DenseEffectPolicy2D.denseScene))
         {
            this._compact = DENSE_SIMPLIFICATION_ENABLED && DenseEffectPolicy2D.denseScene;
            visible = !this._compact;
            if(!this._compact)
            {
               if(!this._built)
               {
                  this.buildVisuals();
               }
               else
               {
                  this.createBolt();
               }
            }
         }
         if(this._compact)
         {
            return;
         }
         this._tpf += param1;
         if(this._tpf > (this._compact ? 66 : UPDATE_INTERVAL))
         {
            this._tpf = 0;
            _loc2_ = int(this.boltGraphicVector.length);
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.boltGraphicVector[_loc3_];
               if((Boolean(_loc4_)) && _loc4_.isAdded)
               {
                  _loc4_.visible = this.linkAllowed(_loc3_);
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
         var _loc2_:Lightning = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._positionProvider.positions.length)
         {
            if(!this.linkAllowed(_loc1_))
            {
               this.boltGraphicVector.push(null);
            }
            else
            {
               _loc2_ = new Lightning(this.colorChainBolt,2);
               this.updateLightningPositions(_loc2_,_loc1_);
               this.configureBolt(_loc2_);
               this.boltGraphicVector.push(_loc2_);
            }
            _loc1_++;
         }
      }
      
      private function buildVisuals() : void
      {
         if(this._built || this._disposed)
         {
            return;
         }
         this._built = true;
         this.createBoltGraphics();
         this.createBolt();
      }
      
      private function configureBolt(param1:Lightning) : void
      {
         param1.compactHalo = false;
         param1.childrenMaxGenerations = 3;
         param1.childrenDetachedEnd = false;
         param1.childrenLifeSpanMin = 1;
         param1.childrenLifeSpanMax = 2;
         param1.childrenMaxCount = 3;
         param1.childrenMaxCountDecay = 0.5;
         param1.alphaFadeType = LightningFadeType.GENERATION;
         switch(this._effect.id)
         {
            case EffectIDList.SHIELD_LINK:
               param1.steps = 100;
               param1.childrenProbability = 0.8;
               param1.thickness = 3.5;
               param1.speed = 1;
               param1.amplitude = 0.05;
               break;
            case EffectIDList.HP_LINK:
               param1.steps = 50;
               param1.childrenProbability = 0.8;
               param1.thickness = 2;
               param1.speed = 2;
               param1.amplitude = 0.1;
               break;
            case EffectIDList.VOLTAGE_LINK_EFFECT:
               param1.steps = 50;
               param1.childrenProbability = 0.8;
               param1.thickness = 2;
               param1.speed = 2;
               param1.amplitude = 0.1;
               break;
            default:
               param1.steps = 30;
               param1.childrenProbability = 0.1;
               param1.thickness = 2.5;
               param1.speed = 2;
         }
         param1.filters = [BOLT_FILTER];
         if(this._compact)
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
      
      private function updateLightningPositions(param1:Lightning, param2:int) : void
      {
         param1.startX = param2 - 1 >= 0 ? this._positionProvider.positions[param2 - 1].x : this._positionProvider.attackerPosition.x;
         param1.startY = param2 - 1 >= 0 ? this._positionProvider.positions[param2 - 1].y : this._positionProvider.attackerPosition.y;
         param1.endX = this._positionProvider.positions[param2].x;
         param1.endY = this._positionProvider.positions[param2].y;
      }
      
      private function createBolt() : void
      {
         var _loc1_:int = int(this.boltGraphicVector.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            if(Boolean(this.boltGraphicVector[_loc2_]) && !this.boltGraphicVector[_loc2_].isAdded)
            {
               TweenMax.delayedCall(this.limitedLightning ? Math.min(_loc2_ * 0.08,0.3) : _loc2_ * 0.2,this.addAndFadeIn,[this.boltGraphicVector[_loc2_]]);
            }
            _loc2_++;
         }
      }
      
      private function addAndFadeIn(param1:Lightning) : void
      {
         if(this._disposed || this._compact)
         {
            return;
         }
         param1.isAdded = true;
         param1.alpha = 0;
         TweenMax.to(param1,0.5,{"alpha":1});
         addChild(param1);
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         TweenMax.killTweensOf(this.addAndFadeIn);
         TweenMax.killTweensOf(this.fadeOutAndRemove);
         TweenMax.killTweensOf(this.disposeView);
         var _loc2_:int = int(this.boltGraphicVector.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(Boolean(this.boltGraphicVector[_loc3_]) && Boolean(this.boltGraphicVector[_loc3_].parent))
            {
               this.boltGraphicVector[_loc3_].parent.removeChild(this.boltGraphicVector[_loc3_]);
            }
            _loc3_++;
         }
         this.boltGraphicVector.length = 0;
         ScreenManager.removeObserver(this);
         super.disposeView(param1);
      }
   }
}

