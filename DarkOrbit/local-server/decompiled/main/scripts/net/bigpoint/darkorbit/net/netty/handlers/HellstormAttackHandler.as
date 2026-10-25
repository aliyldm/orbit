package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.HellstormAttackCommand;
   import net.bigpoint.darkorbit.net.RocketLauncherAssembly;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class HellstormAttackHandler extends BaseHandler
   {
      
      public function HellstormAttackHandler()
      {
         super();
      }
      
      public static function run(param1:HellstormAttackCommand) : void
      {
         var _loc2_:String = "";
         if(!param1.hit)
         {
            _loc2_ = "M";
         }
         RocketLauncherAssembly.getInstance().assembleCommand(["0",ServerCommands.ROCKETLAUNCHER,ServerCommands.ROCKETLAUNCHER_ATTACK,param1.attackerId,param1.targetId,param1.currentLoad,RocketLauncherAssembly.getInstance().ammunitionTypeToRocketType[param1.rocketType.typeValue],_loc2_]);
      }
   }
}

