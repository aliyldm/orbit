package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityEffectActivationCommand;
   import net.bigpoint.darkorbit.com.module.HealBeamCommand;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.core.EntityTraitContainer;
   import net.bigpoint.darkorbit.map.model.traits.HealBeamSourceTrait;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class HealBeamHandler extends BaseHandler
   {
      
      public function HealBeamHandler()
      {
         super();
      }
      
      public static function run(param1:HealBeamCommand) : void
      {
         var _loc5_:HealBeamSourceTrait = null;
         var _loc6_:int = 0;
         var _loc2_:int = int.MAX_VALUE;
         var _loc3_:HealBeamSourceTrait = null;
         var _loc4_:EntityTraitContainer = ScreenManager.getInstance().map.getTraitsList(HealBeamSourceTrait);
         for each(_loc5_ in _loc4_.traits)
         {
            _loc6_ = Math.abs(_loc5_.owner.position.x - param1.sourcePositionX) + Math.abs(_loc5_.owner.position.y - param1.sourcePositionY);
            if(_loc6_ < _loc2_)
            {
               _loc2_ = _loc6_;
               _loc3_ = _loc5_;
            }
         }
         if(_loc3_ != null)
         {
            AbilityEffectActivationHandler.run(new AbilityEffectActivationCommand(InGameCatalog.SHIP_ABILITY_AEGIS_HEALING_BEAM,_loc3_.owner.id,false,new <int>[param1.targetId]));
         }
      }
   }
}

