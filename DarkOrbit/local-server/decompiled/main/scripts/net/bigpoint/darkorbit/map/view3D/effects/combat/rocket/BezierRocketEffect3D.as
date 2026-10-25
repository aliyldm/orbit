package net.bigpoint.darkorbit.map.view3D.effects.combat.rocket
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.BezierRocketEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.model.traits.weapons.RocketLauncher;
   import net.bigpoint.darkorbit.map.view3D.MapView3D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   
   public class BezierRocketEffect3D
   {
      
      public function BezierRocketEffect3D(param1:MapView3D, param2:BezierRocketEffect)
      {
         var _loc5_:RocketPattern = null;
         var _loc6_:RocketSmokePattern = null;
         super();
         if(param2.attacker == null || param2.target == null)
         {
            return;
         }
         var _loc3_:RocketLauncher = AttackerTrait(param2.attacker.getFirstTrait(AttackerTrait)).rocketLauncher;
         var _loc4_:int = _loc3_.rocketClassId;
         if(_loc4_ != -1)
         {
            _loc5_ = PatternManager.getRocketPattern(_loc4_,param2.typeID) || PatternManager.getRocketPattern(0,1);
            if(_loc5_.getSoundID() != -1)
            {
               AudioManager.playSoundEffect(_loc5_.getSoundID(),false,false,param2.attacker.position.x,param2.attacker.position.y,true);
            }
            _loc6_ = PatternManager.rocketSmokePatterns[param2.rocketSmokeID];
            if(param2.scale == 1)
            {
               param1.gameWorld.addChild(new BezierRocket3D(param2.attacker.getFirstTrait(AttackerTrait) as AttackerTrait,param2.target.getFirstTrait(AttackTargetTrait) as AttackTargetTrait,param2.hit,_loc5_,_loc6_,param2.isHeatSeeking,false,param2.delay,true,param2.showPyro,param2.index,param2.scale,param2.shakeScreen));
            }
            else
            {
               param1.gameWorld.addChild(new TripleBezierRocket3D(param2.attacker.getFirstTrait(AttackerTrait) as AttackerTrait,param2.target.getFirstTrait(AttackTargetTrait) as AttackTargetTrait,param2.hit,_loc5_,_loc6_,param2.isHeatSeeking,false,param2.delay,true,param2.showPyro,param2.index,param2.scale,param2.shakeScreen));
            }
         }
      }
   }
}

