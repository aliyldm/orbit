package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.StartCapsuleCollectCommand;
   import net.bigpoint.darkorbit.map.model.Map;
   import net.bigpoint.darkorbit.map.model.effects.impl.CollectorBeamEffect;
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class StartCapsuleCollectHandler extends BaseHandler
   {
      
      public function StartCapsuleCollectHandler()
      {
         super();
      }
      
      public static function run(param1:StartCapsuleCollectCommand) : void
      {
         var _loc2_:Map = _main.screenManager.map;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Ship = _loc2_.getShipManager().getShip(param1.collectorId);
         if(_loc3_ == null)
         {
            return;
         }
         _loc2_.effects.addEffect(new CollectorBeamEffect(_loc3_,param1.timer,true));
      }
   }
}

