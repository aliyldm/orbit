package net.bigpoint.darkorbit.map.view2D.effects.combat.laser
{
   import net.bigpoint.darkorbit.map.model.effects.impl.combat.LaserEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.map.view2D.MapView2D;
   import net.bigpoint.darkorbit.pattern.LaserPattern;
   import net.bigpoint.darkorbit.pattern.LaserSalvoPattern;
   import net.bigpoint.darkorbit.pattern.PatternManager;
   
   public class LaserEffect2D
   {
      
      public function LaserEffect2D(param1:MapView2D, param2:LaserEffect)
      {
         var _loc3_:int = 0;
         var _loc4_:LaserSalvoPattern = null;
         var _loc5_:int = 0;
         var _loc6_:LaserPattern = null;
         super();
         if(Boolean(param2.attacker) && Boolean(param2.target))
         {
            _loc3_ = param2.laserClass != -1 ? param2.laserClass : AttackerTrait(param2.attacker.getFirstTrait(AttackerTrait)).laser.laserClassID;
            if(_loc3_ != -1)
            {
               _loc4_ = PatternManager.getLaserPattern(_loc3_,param2.laserTypeID);
               if(_loc4_)
               {
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.laserPatternsUsed.length)
                  {
                     _loc6_ = _loc4_.laserPatternsUsed[_loc5_];
                     param1.projectileLayer.addChild(new LaserSalvo2D(param2.attacker,param2.target,_loc6_,param2.showShieldDamage,param2.skilledLaser,param1,param2.laserTypeID,_loc5_ > 0));
                     _loc5_++;
                  }
               }
            }
         }
      }
   }
}

