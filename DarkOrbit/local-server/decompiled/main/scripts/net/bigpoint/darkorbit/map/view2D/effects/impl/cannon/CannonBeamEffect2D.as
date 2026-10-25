package net.bigpoint.darkorbit.map.view2D.effects.impl.cannon
{
   import com.bigpoint.utils.PointLite;
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenMax;
   import flash.display.MovieClip;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonType;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonShotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.map.view2D.effects.AbstractEffect2D;
   import net.bigpoint.darkorbit.map.view2D.effects.CompactEffectGeometry2D;
   import net.bigpoint.darkorbit.map.view2D.effects.EffectRange2D;
   import net.bigpoint.darkorbit.map.view2D.effects.NativeEffectClipPool2D;
   import net.bigpoint.darkorbit.map.view2D.effects.TimedEffectClip2D;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.ChainBoltPositionProvider;
   import net.bigpoint.darkorbit.utils.math.FastMath;
   
   public class CannonBeamEffect2D extends AbstractEffect2D
   {
      
      private static const RADTODEG:Number = FastMath.RADTODEG;
      
      private static const DENOMINATOR_X:Number = 250;
      
      private var _effect:AbstractBoltEffect;
      
      private var _map:MapView2D;
      
      private var _positionProvider:ChainBoltPositionProvider;
      
      private var _clips:Vector.<MovieClip> = new Vector.<MovieClip>();
      
      private var _disposed:Boolean = false;
      
      private var _pendingBeams:int = 0;
      
      public function CannonBeamEffect2D(param1:MapView2D, param2:AbstractBoltEffect)
      {
         this._effect = param2;
         this._map = param1;
         this._positionProvider = new ChainBoltPositionProvider(this._effect.chainArray,this._effect.attacker);
         super(param1,param2);
      }
      
      override protected function initEffectVisuals() : void
      {
         this._map.fxLayer.addChild(this);
         TweenMax.delayedCall(1,this.disposeView);
         var _loc1_:int = int(this._positionProvider.positions.length);
         this._pendingBeams = _loc1_;
         if(_loc1_ == 0)
         {
            this.disposeView();
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TweenMax.delayedCall(Math.min(_loc2_ * 0.08,0.3),this.addBeam,[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addBeam(param1:int) : void
      {
         var from:BindablePointLite = null;
         var to:BindablePointLite = null;
         var resKey:String = null;
         var i:int = param1;
         if(this._disposed)
         {
            return;
         }
         from = i <= 0 ? this._effect.attacker.position : this._positionProvider.positions[i - 1];
         to = this._positionProvider.positions[i];
         if(!EffectRange2D.link(from,to))
         {
            this.finishPendingBeam();
            return;
         }
         resKey = this.getResKey(i);
         ResourceManager.fileCollection.load(resKey,function(param1:SWFFinisher):void
         {
            var mc:MovieClip = null;
            var finisher:SWFFinisher = param1;
            if(_disposed)
            {
               return;
            }
            if(!finisher || !EffectRange2D.link(from,to))
            {
               finishPendingBeam();
               return;
            }
            mc = NativeEffectClipPool2D.acquire(finisher,resKey);
            if(!mc)
            {
               finishPendingBeam();
               return;
            }
            _clips.push(mc);
            addChild(mc);
            TimedEffectClip2D.play(mc,mc,false,function():void
            {
               finishBeam(mc);
            });
            updateBeam(mc,from,to);
            CompactEffectGeometry2D.beam(mc);
         },function(param1:String):void
         {
            if(!_disposed)
            {
               finishPendingBeam();
            }
         });
      }
      
      private function finishBeam(param1:MovieClip) : void
      {
         if(this._disposed)
         {
            return;
         }
         var _loc2_:int = this._clips.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this._clips.splice(_loc2_,1);
         TimedEffectClip2D.stop(param1);
         NativeEffectClipPool2D.release(param1);
         this.finishPendingBeam();
      }
      
      private function finishPendingBeam() : void
      {
         if(this._disposed)
         {
            return;
         }
         --this._pendingBeams;
         if(this._pendingBeams <= 0)
         {
            this.disposeView();
         }
      }
      
      private function getResKey(param1:int) : String
      {
         var _loc2_:CannonShotEffect = null;
         switch(this._effect.id)
         {
            case EffectIDList.CANNON_SKILL_ELECTRO:
               return "cannon_skill_electro";
            case EffectIDList.CANNON_SHOT:
               if(param1 > 0)
               {
                  return "cannon_skill_electro";
               }
               _loc2_ = this._effect as CannonShotEffect;
               switch(_loc2_.cannonType)
               {
                  case CannonType.CORROSIVE:
                     return "cannon_shot_corrosive";
                  case CannonType.THERMAL:
                     return "cannon_shot_thermal";
                  case CannonType.ELECTRO:
               }
               return "cannon_shot_electro";
               break;
            default:
               return "cannon_shot_electro";
         }
      }
      
      private function getOffset() : Object
      {
         var _loc1_:CannonShotEffect = this._effect as CannonShotEffect;
         if(!_loc1_)
         {
            return null;
         }
         switch(_loc1_.cannonType)
         {
            case CannonType.CORROSIVE:
               return CannonCentroidConst.CANNON_SHOT_CORROSIVE;
            case CannonType.THERMAL:
               return CannonCentroidConst.CANNON_SHOT_THERMAL;
            case CannonType.ELECTRO:
         }
         return CannonCentroidConst.CANNON_SHOT_ELECTRO;
      }
      
      private function updateBeam(param1:MovieClip, param2:PointLite, param3:PointLite) : void
      {
         var _loc4_:Number = NaN;
         if(!param1 || !param2 || !param3)
         {
            return;
         }
         param1.x = param2.x;
         param1.y = param2.y;
         _loc4_ = param3.x - param2.x;
         var _loc5_:Number = param3.y - param2.y;
         var _loc6_:Number = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
         param1.scaleX = _loc6_ / DENOMINATOR_X;
         param1.rotation = Math.atan2(_loc5_,_loc4_) * RADTODEG;
      }
      
      override public function disposeView(param1:Boolean = false) : void
      {
         var _loc2_:MovieClip = null;
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         TweenMax.killTweensOf(this.addBeam);
         TweenMax.killTweensOf(this.disposeView);
         TweenMax.killTweensOf(this);
         for each(_loc2_ in this._clips)
         {
            TweenMax.killTweensOf(_loc2_);
            TimedEffectClip2D.stop(_loc2_);
            _loc2_.stop();
            if(_loc2_)
            {
               _loc2_.addFrameScript(_loc2_.totalFrames - 1,null);
               if(_loc2_.parent)
               {
                  _loc2_.parent.removeChild(_loc2_);
               }
               NativeEffectClipPool2D.release(_loc2_);
               _loc2_ = null;
            }
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         this._clips.length = 0;
         super.disposeView(param1);
      }
   }
}

