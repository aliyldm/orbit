package net.bigpoint.darkorbit.map.view2D.effects.combat.rocket
{
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.RocketEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   import net.bigpoint.darkorbit.pattern.RocketPattern;
   import net.bigpoint.darkorbit.pattern.RocketSmokePattern;
   
   public class RocketEffect2D
   {
      
      public function RocketEffect2D(param1:MapView2D, param2:RocketEffect)
      {
         var _loc3_:AttackerTrait = null;
         var _loc4_:int = 0;
         var _loc5_:RocketPattern = null;
         var _loc6_:RocketSmokePattern = null;
         super();
         if(param2.attacker != null && param2.target != null)
         {
            _loc3_ = param2.attacker.getFirstTrait(AttackerTrait) as AttackerTrait;
            _loc4_ = _loc3_.rocketLauncher ? _loc3_.rocketLauncher.rocketClassId : -1;
            if(_loc4_ != -1)
            {
               _loc5_ = PatternManager.getRocketPattern(_loc4_,param2.typeID) || PatternManager.getRocketPattern(0,1);
               if(_loc5_)
               {
                  if(_loc5_.getSoundID() != -1)
                  {
                     AudioManager.playSoundEffect(_loc5_.getSoundID(),false,false,param2.attacker.position.x,param2.attacker.position.y,true);
                  }
                  _loc6_ = PatternManager.rocketSmokePatterns[param2.rocketSmokeID];
                  param1.projectileLayer.addChild(new Rocket2D(param2.attacker.getFirstTrait(AttackerTrait) as AttackerTrait,param2.target.getFirstTrait(AttackTargetTrait) as AttackTargetTrait,param2.hit,_loc5_,_loc6_,param2.isHeatSeeking));
               }
            }
         }
      }
   }
}

