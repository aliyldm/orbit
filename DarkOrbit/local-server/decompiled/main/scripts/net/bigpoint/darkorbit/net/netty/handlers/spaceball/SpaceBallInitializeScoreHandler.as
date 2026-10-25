package net.bigpoint.darkorbit.net.netty.handlers.spaceball
{
   import net.bigpoint.darkorbit.com.module.SpaceBallInitializeScoreCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   
   public class SpaceBallInitializeScoreHandler extends AbstractSpaceballHandler
   {
      
      public function SpaceBallInitializeScoreHandler()
      {
         super();
      }
      
      public static function run(param1:SpaceBallInitializeScoreCommand) : void
      {
         var _loc2_:int = param1.ownerFactionId;
         var _loc3_:int = param1.speed;
         var _loc4_:int = param1.scoreEarth;
         var _loc5_:int = param1.scoreMars;
         var _loc6_:int = param1.scoreVenus;
         var _loc7_:Array = [_loc5_,_loc4_,_loc6_];
         var _loc8_:GuiManager = _main.getGuiManager();
         _loc8_.createSpaceballScoreboard(_loc7_);
         _loc8_.setSpaceballSpeed(_loc2_,_loc3_);
      }
   }
}

