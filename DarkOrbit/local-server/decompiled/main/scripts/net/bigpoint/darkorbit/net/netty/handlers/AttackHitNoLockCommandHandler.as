package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.AttackHitNoLockCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.DamageReceivedEffect;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.DamageEffect;
   import net.bigpoint.darkorbit.map.model.traits.HPTrait;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.net.netty.handlers.combat.AttackTypeMap;
   import net.bigpoint.darkorbit.settings.Settings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class AttackHitNoLockCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function AttackHitNoLockCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc15_:int = 0;
         var _loc18_:HPTrait = null;
         super.execute(param1);
         var _loc2_:AttackHitNoLockCommand = param1.getBody() as AttackHitNoLockCommand;
         var _loc3_:int = _loc2_.attackerId;
         var _loc4_:int = _loc2_.victimId;
         var _loc5_:String = AttackTypeMap.getAttackType(_loc2_.attackType.attackTypeValue);
         var _loc6_:int = _loc2_.victimHitpoints;
         var _loc7_:int = _loc2_.victimMaxHitpoints;
         var _loc8_:int = _loc2_.victimNanoHull;
         var _loc9_:int = _loc2_.victimMaxNanohull;
         var _loc10_:int = _loc2_.victimShield;
         var _loc11_:int = _loc2_.victimMaxShield;
         var _loc12_:int = _loc2_.damage;
         var _loc13_:Boolean = false;
         var _loc14_:Boolean = true;
         if(map == null)
         {
            return;
         }
         var _loc16_:MapEntity = map.getEntityById(_loc3_);
         var _loc17_:MapEntity = map.getEntityById(_loc4_);
         switch(_loc5_)
         {
            case AttackTypeMap.REPAIR:
               _loc15_ = 2;
               _loc13_ = true;
               _loc14_ = false;
               break;
            case AttackTypeMap.LASER:
            case AttackTypeMap.ROCKET:
            case AttackTypeMap.ECI:
            case AttackTypeMap.SINGULARITY:
            case AttackTypeMap.SHIELD_ABSORBER_ROCKET_CREDITS:
            case AttackTypeMap.SHIELD_ABSORBER_ROCKET_URIDIUM:
            default:
               _loc15_ = 0;
         }
         if(_loc17_)
         {
            map.effects.playEffect(new DamageEffect(_loc17_,_loc5_));
            _loc18_ = map.getTraitById(_loc4_,HPTrait) as HPTrait;
            if(_loc18_)
            {
               _loc18_.hp.value = _loc6_;
               _loc18_.maxHP.value = _loc7_;
               _loc18_.nanohullHP.value = _loc8_;
               _loc18_.nanohullMaxHP.value = _loc9_;
               _loc18_.shield.value = _loc10_;
               _loc18_.maxShield.value = _loc11_;
            }
            if(Settings.displayHitpointBubbles && _loc12_ != 0)
            {
               map.effects.addEffect(new DamageReceivedEffect(map.getEntityById(_loc4_),_loc12_,_loc15_,_loc13_,_loc14_));
            }
         }
      }
   }
}

