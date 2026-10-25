package net.bigpoint.darkorbit.net.netty.handlers.spaceball
{
   import net.bigpoint.darkorbit.com.module.SpaceBallUpdateSpeedCommand;
   
   public class SpaceBallUpdateSpeedHandler extends AbstractSpaceballHandler
   {
      
      public function SpaceBallUpdateSpeedHandler()
      {
         super();
      }
      
      public static function run(param1:SpaceBallUpdateSpeedCommand) : void
      {
         var _loc2_:int = param1.factionId;
         var _loc3_:int = param1.speed;
         _main.getGuiManager().setSpaceballSpeed(_loc2_,_loc3_);
      }
   }
}

