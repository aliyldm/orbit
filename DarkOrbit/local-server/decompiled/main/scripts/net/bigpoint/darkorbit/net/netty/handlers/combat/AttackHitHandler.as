package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.AttackHitCommand;
   import net.bigpoint.darkorbit.com.module.AttackTypeModule;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonHitEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.AbsorbationBeamEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.DamageEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.net.netty.handlers.BeaconHandler;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AttackHitHandler extends DOAbstractSimpleCommand
   {
      
      public function AttackHitHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc12_:int = 0;
         var _loc15_:HPTrait = null;
         var _loc16_:Boolean = false;
         super.execute(param1);
         var _loc2_:AttackHitCommand = param1.getBody() as AttackHitCommand;
         var _loc3_:int = _loc2_.attackerId;
         var _loc4_:int = _loc2_.victimId;
         var _loc5_:String = AttackTypeMap.getAttackType(_loc2_.attackType.attackTypeValue);
         var _loc6_:int = _loc2_.victimHitpoints;
         var _loc7_:int = _loc2_.victimNanoHull;
         var _loc8_:int = _loc2_.victimShield;
         var _loc9_:int = _loc2_.damage;
         var _loc10_:Boolean = false;
         var _loc11_:Boolean = true;
         if(map == null)
         {
            return;
         }
         var _loc13_:MapEntity = map.getEntityById(_loc3_);
         var _loc14_:MapEntity = map.getEntityById(_loc4_);
         switch(_loc5_)
         {
            case AttackTypeMap.REPAIR:
               _loc12_ = 2;
               _loc10_ = true;
               _loc11_ = false;
               break;
            case AttackTypeMap.LASER:
            case AttackTypeMap.ROCKET:
            case AttackTypeMap.ECI:
            case AttackTypeMap.SINGULARITY:
            case AttackTypeMap.SHIELD_ABSORBER_ROCKET_CREDITS:
            case AttackTypeMap.SHIELD_ABSORBER_ROCKET_URIDIUM:
            default:
               _loc12_ = 0;
         }
         if(Hero.userID == _loc4_)
         {
            _loc12_ = 1;
         }
         if(_loc14_)
         {
            map.effects.playEffect(new DamageEffect(_loc14_,_loc5_));
            _loc15_ = map.getTraitById(_loc4_,HPTrait) as HPTrait;
            if(_loc15_)
            {
               _loc15_.hp.value = _loc6_;
               _loc15_.nanohullHP.value = _loc7_;
               _loc15_.shield.value = _loc8_;
            }
            if(Settings.displayHitpointBubbles && _loc9_ != 0)
            {
               if(_loc5_ == AttackTypeMap.SHIELD_ABSORBER_ROCKET_CREDITS || _loc5_ == AttackTypeMap.SHIELD_ABSORBER_ROCKET_URIDIUM)
               {
                  if(_loc14_ is Ship)
                  {
                     _loc16_ = true;
                     if(_loc5_ == AttackTypeMap.SHIELD_ABSORBER_ROCKET_CREDITS)
                     {
                        _loc16_ = false;
                     }
                     else if(_loc5_ == AttackTypeMap.SHIELD_ABSORBER_ROCKET_URIDIUM)
                     {
                        _loc16_ = true;
                     }
                     map.effects.playEffect(new AbsorbationBeamEffect(_loc13_,_loc14_ as Ship,_loc16_));
                  }
               }
               if(_loc2_.attackType.attackTypeValue == AttackTypeModule.ATTACKTYPE_CANNON)
               {
                  map.effects.playEffect(new CannonHitEffect(_loc14_,_loc2_.cannonType));
               }
               map.effects.addEffect(new DamageReceivedEffect(map.getEntityById(_loc4_),_loc9_,_loc12_,_loc10_,_loc11_,_loc2_.strike));
            }
         }
         if(Hero.userID == _loc4_)
         {
            BeaconHandler.updateWarnings();
         }
      }
   }
}

