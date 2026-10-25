package net.bigpoint.darkorbit.net.netty.handlers.combat
{
   import net.bigpoint.darkorbit.com.module.AttackMissedCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class AttackMissedHandler extends BaseHandler
   {
      
      public function AttackMissedHandler()
      {
         super();
      }
      
      public static function run(param1:AttackMissedCommand) : void
      {
         var _loc2_:int = param1.targetUserId;
         var _loc3_:String = AttackTypeMap.getAttackType(param1.attackType.attackTypeValue);
         var _loc4_:int = param1.skillColorId;
         _main.getConnectionManager().getCombatAssembly().assembleAttackMissed(_loc2_,_loc3_,_loc4_);
      }
   }
}

