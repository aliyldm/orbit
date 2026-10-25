package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.com.module.AbilityEffectActivationCommand;
   import net.bigpoint.darkorbit.com.module.MarkTargetCommand;
   import net.bigpoint.darkorbit.net.AbilityEffectActivationAssembly;
   import net.bigpoint.darkorbit.net.ServerCommands;
   import net.bigpoint.darkorbit.net.UserInterfaceAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class MarkTargetHandler extends BaseHandler
   {
      
      public function MarkTargetHandler()
      {
         super();
      }
      
      public static function run(param1:MarkTargetCommand) : void
      {
         UserInterfaceAssembly.getInstance().assembleCommand(["0",ServerCommands.USER_INTERFACE,ServerCommands.MINIMAP,ServerCommands.SHOW_MARKER,param1.userId,param1.positionX,param1.positionY,1,"_red"]);
         var _loc2_:Vector.<int> = new Vector.<int>();
         _loc2_.push(param1.targetId);
         AbilityEffectActivationAssembly.getInstance().assembleEffectActivation(new AbilityEffectActivationCommand(InGameCatalog.SHIP_ABILITY_SPEARHEAD_MARK_TARGET,param1.userId,false,_loc2_));
      }
   }
}

