package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.com.module.CombatStateCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CombatStateHandler extends BaseHandler
   {
      
      public function CombatStateHandler()
      {
         super();
      }
      
      public static function run(param1:CombatStateCommand) : void
      {
         var _loc2_:uint = uint(param1.combatState);
         _main.getConnectionManager().getCombatAssembly().assembleCombatState(_loc2_);
      }
   }
}

