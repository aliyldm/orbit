package net.bigpoint.darkorbit.net.netty.handlers.cannon
{
   import net.bigpoint.darkorbit.com.module.porting.cannon.CannonAttackCommand;
   import net.bigpoint.darkorbit.map.model.core.MapEntity;
   import net.bigpoint.darkorbit.map.model.effects.impl.cannon.CannonShotEffect;
   import net.bigpoint.darkorbit.map.model.traits.AttackTargetTrait;
   import net.bigpoint.darkorbit.map.model.traits.AttackerTrait;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CannonAttackHandler extends BaseHandler
   {
      
      public function CannonAttackHandler()
      {
         super();
      }
      
      public static function run(param1:CannonAttackCommand) : void
      {
         var _loc2_:int = param1.attackerId;
         var _loc3_:int = param1.attackedId;
         var _loc4_:AttackerTrait = map.getTraitById(_loc2_,AttackerTrait) as AttackerTrait;
         var _loc5_:MapEntity = map.getEntityById(_loc3_);
         if(Boolean(_loc4_) && Boolean(_loc5_))
         {
            _loc4_.target = _loc5_.getFirstTrait(AttackTargetTrait) as AttackTargetTrait;
         }
         var _loc6_:CannonShotEffect = new CannonShotEffect(map.getEntityById(_loc2_),_loc3_,param1.cannonType);
         map.effects.playEffect(_loc6_);
      }
   }
}

