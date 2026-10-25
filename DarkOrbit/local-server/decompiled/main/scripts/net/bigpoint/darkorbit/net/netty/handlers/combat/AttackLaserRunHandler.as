package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.com.module.AttackLaserRunCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.EffectIDList;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.LaserEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttackLaserRunHandler extends BaseHandler
   {
      
      protected static const AMMO_SAB50:int = 4;
      
      protected static const AMMO_RSB75:int = 6;
      
      protected static const SCATTER_LASER:int = 28;
      
      public function AttackLaserRunHandler()
      {
         super();
      }
      
      public static function run(param1:AttackLaserRunCommand) : void
      {
         var _loc5_:Boolean = false;
         var _loc10_:Boolean = false;
         var _loc2_:int = param1.attackerId;
         var _loc3_:int = param1.targetId;
         var _loc4_:int = param1.laserColor;
         _loc5_ = param1.isDiminishedBySkillShield;
         var _loc6_:Boolean = param1.skilledLaser;
         var _loc7_:int = param1.visualType;
         var _loc8_:AttackerTrait = map.getTraitById(_loc2_,AttackerTrait) as AttackerTrait;
         var _loc9_:MapEntity = map.getEntityById(_loc3_);
         if(Boolean(_loc8_) && Boolean(_loc9_))
         {
            _loc8_.target = _loc9_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
            map.effects.removeEffectFromMapObject(_loc2_,EffectIDList.SCATTER_LASER);
            fire(_loc8_.owner,_loc9_,_loc4_,_loc5_,_loc6_,_loc7_);
            _loc10_ = _loc4_ != AMMO_SAB50 && _loc4_ != AMMO_RSB75 && _loc4_ != SCATTER_LASER;
            if((_loc10_) && map.effects.getEffectForMapObject(_loc2_,EffectIDList.TECH_ENERGY_LEECH_EFFECT) != null)
            {
               fire(_loc9_,_loc8_.owner,7,false,false,_loc7_);
            }
         }
      }
      
      private static function fire(param1:MapEntity, param2:MapEntity, param3:int, param4:Boolean, param5:Boolean, param6:int = 0) : void
      {
         var _loc7_:LaserEffect = new LaserEffect();
         _loc7_.attacker = param1;
         _loc7_.target = param2;
         _loc7_.laserTypeID = param3;
         _loc7_.showShieldDamage = param4;
         _loc7_.skilledLaser = param5;
         _loc7_.shieldVisualType = param6;
         map.effects.playEffect(_loc7_);
      }
   }
}

