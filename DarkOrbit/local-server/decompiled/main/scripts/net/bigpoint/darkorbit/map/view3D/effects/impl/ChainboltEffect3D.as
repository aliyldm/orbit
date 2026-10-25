package net.bigpoint.darkorbit.map.view3D.effects.impl
{
   import com.bigpoint.utils.bindables.BindablePointLite;
   import com.greensock.TweenMax;
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonType;
   import net.bigpoint.darkorbit.map.common.EffectRangeTicker;
   import net.bigpoint.darkorbit.map.common.IDisposable;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonShotEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbstractBoltEffect;
   import net.bigpoint.darkorbit.map.view2D.effects.combat.ChainBoltPositionProvider;
   import net.bigpoint.darkorbit.map.view3D.DenseEffectPolicy3D;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.map.view3D.effects.EffectRange3D;
   
   public class ChainboltEffect3D implements IDisposable
   {
      
      private static const URL_HP_LINK:* = "pet-gear_hp_link_effect.zip";
      
      private static const URL_SHIELD_LINK:* = "berserker_shield_link_effect.zip";
      
      private static const URL_PARTICLE_BEAM_BOLT:* = "beam_particle_bolt.zip";
      
      private static const URL_BOLT:String = "beam_chain_bolt.zip";
      
      private static const URL_BOLT_CORNER:String = "chain_bolt_corners.zip";
      
      private static const URL_VOLTAGE_LINK:String = "ability_voltage-link.zip";
      
      private static const URL_CANNON_SHOT_ELECTRO:String = "cannon_shot_electro.zip";
      
      private static const URL_CANNON_SHOT_THERMAL:String = "cannon_shot_thermal.zip";
      
      private static const URL_CANNON_SHOT_CORROSIVE:String = "cannon_shot_corrosive.zip";
      
      private static const URL_CANNON_SKILL_ELECTRO:String = "cannon_skill_electro.zip";
      
      private static const URL_CANNON_HIT_ELECTRO:String = "cannon_hit_electro.zip";
      
      private var rangeToken:Object;
      
      private var _mapView:MapView3D;
      
      private var _effect:AbstractBoltEffect;
      
      private var _positionProvider:ChainBoltPositionProvider;
      
      private var _effects:Vector.<IDisposable> = new Vector.<IDisposable>();
      
      private var _disposed:Boolean = false;
      
      private var _rangeLinks:Array = [];
      
      public function ChainboltEffect3D(param1:MapView3D, param2:AbstractBoltEffect)
      {
         super();
         this._mapView = param1;
         this._effect = param2;
         this._positionProvider = new ChainBoltPositionProvider(this._effect.chainArray,this._effect.attacker);
         this.initEffectVisuals();
      }
      
      private function get limitedLightning() : Boolean
      {
         return this._effect.id == EffectIDList.CHAIN_BOLT || this._effect.id == EffectIDList.VOLTAGE_LINK_EFFECT || this._effect.id == EffectIDList.CANNON_SKILL_ELECTRO || this._effect is CannonShotEffect && CannonShotEffect(this._effect).cannonType == CannonType.ELECTRO;
      }
      
      private function releaseRangePart(param1:IDisposable) : void
      {
         var _loc2_:int = this._effects.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._effects.splice(_loc2_,1);
         }
         TweenMax.killTweensOf(param1.disposeView);
         param1.disposeView(true);
      }
      
      private function pollRange() : void
      {
         var _loc1_:Object = null;
         if(this._disposed)
         {
            return;
         }
         for each(_loc1_ in this._rangeLinks)
         {
            if(Boolean(_loc1_.active) && !EffectRange3D.link(_loc1_.from,_loc1_.to,800))
            {
               _loc1_.active = false;
               this.releaseRangePart(_loc1_.bolt);
               if(_loc1_.sparks)
               {
                  this.releaseRangePart(_loc1_.sparks);
               }
            }
         }
      }
      
      private function initEffectVisuals() : void
      {
         if(this.limitedLightning)
         {
            TweenMax.delayedCall(1,this.disposeView,[true]);
            this.rangeToken = EffectRangeTicker.add(this.pollRange,100);
         }
         var _loc1_:int = int(this._positionProvider.positions.length);
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_)
         {
            TweenMax.delayedCall(this.limitedLightning ? Math.min(_loc2_ * 0.08,0.3) : _loc2_ * 0.2,this.addBolt,[_loc2_]);
            _loc2_++;
         }
      }
      
      private function addBolt(param1:int) : void
      {
         var _loc4_:String = null;
         var _loc7_:CannonShotEffect = null;
         var _loc8_:StandaloneParticle3D = null;
         if(this._disposed)
         {
            return;
         }
         var _loc2_:BindablePointLite = param1 <= 0 ? this._effect.attacker.position : this._positionProvider.positions[param1 - 1];
         var _loc3_:BindablePointLite = this._positionProvider.positions[param1];
         if(this.limitedLightning && !EffectRange3D.link(_loc2_,_loc3_,800))
         {
            return;
         }
         switch(this._effect.id)
         {
            case EffectIDList.CHAIN_BOLT:
               _loc4_ = URL_BOLT;
               break;
            case EffectIDList.PARTICLE_BEAM:
               _loc4_ = URL_PARTICLE_BEAM_BOLT;
               break;
            case EffectIDList.SHIELD_LINK:
               _loc4_ = URL_SHIELD_LINK;
               break;
            case EffectIDList.HP_LINK:
               _loc4_ = URL_HP_LINK;
               break;
            case EffectIDList.VOLTAGE_LINK_EFFECT:
               _loc4_ = URL_VOLTAGE_LINK;
               break;
            case EffectIDList.CANNON_SKILL_ELECTRO:
               _loc4_ = URL_CANNON_SKILL_ELECTRO;
               break;
            case EffectIDList.CANNON_SHOT:
               _loc7_ = this._effect as CannonShotEffect;
               switch(_loc7_.cannonType)
               {
                  case CannonType.CORROSIVE:
                     _loc4_ = URL_CANNON_SHOT_CORROSIVE;
                     break;
                  case CannonType.THERMAL:
                     _loc4_ = URL_CANNON_SHOT_THERMAL;
                     break;
                  case CannonType.ELECTRO:
                     _loc4_ = URL_CANNON_SHOT_ELECTRO;
               }
         }
         var _loc5_:Boolean = DenseEffectPolicy3D.denseScene && (_loc4_ == URL_CANNON_SHOT_ELECTRO || _loc4_ == URL_CANNON_SKILL_ELECTRO || _loc4_ == URL_BOLT);
         var _loc6_:IDisposable = _loc5_ ? CompactCannonLinks3D.acquire(_loc2_,_loc3_,this._effect.id == EffectIDList.CANNON_SKILL_ELECTRO ? 0.7 : 0) : new BeamEffect3D(this._effect,_loc4_,_loc2_,_loc3_,0.1,true);
         this._effects.push(_loc6_);
         if(this._effect.id != EffectIDList.CANNON_SHOT)
         {
            if(this._effect.id == EffectIDList.CANNON_SKILL_ELECTRO)
            {
               if(!_loc5_)
               {
                  TweenMax.delayedCall(0.7,_loc6_.disposeView);
               }
               _loc8_ = new ElectroImpactParticle3D(this._effect,URL_CANNON_HIT_ELECTRO,_loc3_);
               this._effects.push(_loc8_);
            }
            else
            {
               _loc8_ = new StandaloneParticle3D(this._effect,URL_BOLT_CORNER,_loc3_,null,true);
               this._effects.push(_loc8_);
            }
         }
         if(this.limitedLightning)
         {
            this._rangeLinks.push({
               "from":_loc2_,
               "to":_loc3_,
               "bolt":_loc6_,
               "sparks":_loc8_,
               "active":true
            });
         }
         if(param1 == 0 && !this.limitedLightning)
         {
            switch(this._effect.id)
            {
               case EffectIDList.CHAIN_BOLT:
                  TweenMax.delayedCall(3,this.disposeView);
                  break;
               case EffectIDList.VOLTAGE_LINK_EFFECT:
                  TweenMax.delayedCall(1,this.disposeView);
                  break;
               case EffectIDList.CANNON_SHOT:
                  TweenMax.delayedCall(1.5,this.disposeView);
            }
         }
      }
      
      public function disposeView(param1:Boolean = false) : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         TweenMax.killTweensOf(this.addBolt);
         EffectRangeTicker.remove(this.rangeToken);
         this.rangeToken = null;
         this._rangeLinks.length = 0;
         TweenMax.killTweensOf(this);
         TweenMax.killTweensOf(this.disposeView);
         var _loc2_:int = int(this._effects.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            TweenMax.killTweensOf(this._effects[_loc3_].disposeView);
            this._effects[_loc3_].disposeView(param1);
            _loc3_++;
         }
         this._effects.length = 0;
      }
   }
}

