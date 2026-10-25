package net.bigpoint.darkorbit.net.netty.handlers
{
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.com.module.PlayVisualEffectCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.Effect;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.MapObjectPersistantEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.LongRangeLaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.PlagueCureEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.ShieldEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.SolaceEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.AbsorbShieldAndHpEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.beam.ShieldBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonSkillElectroEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonSkillThermalEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AirstrikeEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.LaserEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.PyroEffect;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.pattern.EffectPattern;
   import net.bigpoint.darkorbit.pattern.ExplosionPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PlayVisualEffectCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function PlayVisualEffectCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PlayVisualEffectCommand = null;
         var _loc6_:MapEntity = null;
         var _loc9_:ExplosionPattern = null;
         var _loc10_:int = 0;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:EffectPattern = null;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         super.execute(param1);
         _loc2_ = param1.getBody() as PlayVisualEffectCommand;
         var _loc3_:int = _loc2_.activatorId;
         var _loc4_:MapEntity = map.getEntityById(_loc3_);
         var _loc5_:Vector.<MapEntity> = new Vector.<MapEntity>(0);
         var _loc7_:int = int(_loc2_.targetIds.length);
         var _loc8_:int = 0;
         while(_loc8_ < _loc7_)
         {
            _loc6_ = map.getEntityById(_loc2_.targetIds[_loc8_]);
            if(_loc6_)
            {
               _loc5_.push(_loc6_);
            }
            _loc8_++;
         }
         switch(_loc2_.visualEffect)
         {
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CPU_PLAGUE_CURE_WAS_USED:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  map.effects.addMapObjectEffectOnce(new PlagueCureEffect(_loc5_[_loc8_]));
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_PLAGUE_IMPACT:
               _loc7_ = int(_loc5_.length);
               _loc9_ = PatternManager.getPyroPattern(3,2);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  map.effects.addEffect(new PyroEffect(_loc5_[_loc8_].x,_loc5_[_loc8_].y,_loc5_[_loc8_].z,_loc9_));
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_LONG_RANGE_LASER_ATTACK_PLAGUE:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  map.effects.addEffectOnce(new LongRangeLaserEffect(_loc4_,_loc5_[_loc8_]));
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_NORMAL_LASER_ATTACK_PLAGUE:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  map.effects.addEffectOnce(new LaserEffect(_loc4_,_loc5_[_loc8_],2,true,true,0));
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_LEECH_ATTACK_PLAGUE:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  map.effects.addEffectOnce(new AbsorbShieldAndHpEffect(1000,_loc5_[_loc8_],_loc4_));
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_LEECH_ATTACK_SHIELD:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  map.effects.addEffectOnce(new ShieldBeamEffect(1000,_loc5_[_loc8_],_loc4_));
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_PET_FRIENDLY_SACRIFICE_EXPLOSION:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  map.effects.addEffect(new AirstrikeEffect(_loc4_,_loc5_[_loc8_],20,6,false,3,false));
                  _loc8_++;
               }
               map.removeEntity(_loc4_);
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_SHIELD_LEECH:
               _loc7_ = int(_loc2_.targetIds.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc10_ = _loc2_.targetIds[_loc8_];
                  _loc14_ = 4;
                  _loc15_ = 0;
                  while(_loc15_ < _loc14_)
                  {
                     setTimeout(this.playLeechBullet,_loc8_ * 100,_loc3_,_loc10_);
                     _loc15_++;
                  }
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CANNON_SKILL_ELECTRO:
               _loc11_ = [];
               _loc8_ = 0;
               while(_loc8_ < _loc2_.targetIds.length)
               {
                  _loc11_.push(_loc2_.targetIds[_loc8_]);
                  _loc8_++;
               }
               map.effects.addEffectOnce(new CannonSkillElectroEffect(_loc4_,_loc11_));
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CANNON_SKILL_THERMAL:
               map.effects.addEffectOnce(new CannonSkillThermalEffect(_loc4_));
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_SOLACE:
               _loc12_ = 2;
               if(!_loc4_)
               {
                  _loc12_ = 1;
               }
               map.effects.addEffectOnce(new SolaceEffect(_loc4_,_loc12_));
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CHSP_SHOT:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc10_ = _loc2_.targetIds[_loc8_];
                  this.playLeechBullet(_loc3_,_loc10_,41,false);
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CHSP_W_SHOT:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc10_ = _loc2_.targetIds[_loc8_];
                  this.playLeechBullet(_loc3_,_loc10_,42,false);
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CHSP_HIT:
               _loc13_ = PatternManager.effectPatterns[EffectIDList.CHSP_HIT];
               _loc13_.isChargeShotPlus = true;
               map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc4_,Effect.NOT_PERSISTANT,0,0,_loc13_));
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CHSP_W_HIT:
               _loc13_ = PatternManager.effectPatterns[EffectIDList.CHSP_W_HIT];
               _loc13_.isChargeShotPlus = true;
               map.effects.addMapObjectEffectOnce(new ShieldEffect(_loc4_,Effect.NOT_PERSISTANT,0,0,_loc13_));
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CHSP_OUT_BREAK:
               map.effects.addMapObjectEffectOnce(new MapObjectPersistantEffect(_loc4_,EffectIDList.CHSP_OUT_BREAK,Effect.NOT_PERSISTANT));
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_CHSP_W_OUT_BREAK:
               map.effects.addMapObjectEffectOnce(new MapObjectPersistantEffect(_loc4_,EffectIDList.CHSP_W_OUT_BREAK,Effect.NOT_PERSISTANT));
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_GRAVITATIONAL_ANCHOR_SHOT:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc10_ = _loc2_.targetIds[_loc8_];
                  this.playLeechBullet(_loc3_,_loc10_,46,false);
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_DA_SHOT_01:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc10_ = _loc2_.targetIds[_loc8_];
                  this.playLeechBullet(_loc3_,_loc10_,43,false);
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_DA_SHOT_02:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc10_ = _loc2_.targetIds[_loc8_];
                  this.playLeechBullet(_loc3_,_loc10_,44,false);
                  _loc8_++;
               }
               break;
            case PlayVisualEffectCommand.VISUALEFFECTTYPE_DA_SHOT_03:
               _loc7_ = int(_loc5_.length);
               _loc8_ = 0;
               while(_loc8_ < _loc7_)
               {
                  _loc10_ = _loc2_.targetIds[_loc8_];
                  this.playLeechBullet(_loc3_,_loc10_,45,false);
                  _loc8_++;
               }
         }
      }
      
      private function playLeechBullet(param1:int, param2:int, param3:int = 4, param4:Boolean = true, param5:Boolean = false) : void
      {
         var _loc6_:MapEntity = map.getEntityById(param1);
         var _loc7_:MapEntity = map.getEntityById(param2);
         if(Boolean(_loc6_) && Boolean(_loc7_))
         {
            map.effects.addEffect(new LaserEffect(_loc6_,_loc7_,param3,param4,param5,0,0));
         }
      }
   }
}

