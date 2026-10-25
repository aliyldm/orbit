package net.bigpoint.darkorbit.net.netty.handlers.invasion
{
   import net.bigpoint.darkorbit.com.module.InvasionEventInitCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.ScoreElement;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class InvasionEventInitHandler extends BaseHandler
   {
      
      public function InvasionEventInitHandler()
      {
         super();
      }
      
      public static function run(param1:InvasionEventInitCommand) : void
      {
         var _loc2_:int = param1.waveCount;
         var _loc3_:int = param1.score_EIC;
         var _loc4_:int = param1.score_MMO;
         var _loc5_:int = param1.score_VRU;
         var _loc6_:Array = [_loc4_,_loc3_,_loc5_];
         var _loc7_:GuiManager = _main.getGuiManager();
         if(!_loc7_.isInvasionScoreboardCreated())
         {
            _loc7_.createInvasionScoreboard(_loc6_);
            _loc7_.setInvasionWave(_loc2_);
         }
         else
         {
            _loc7_.updateScoreboard(GuiConstants.INVASION_WINDOW,SimpleContainer.CLASS_INVASION,ScoreElement.COMPANY_TYPE_MMO,_loc4_);
            _loc7_.updateScoreboard(GuiConstants.INVASION_WINDOW,SimpleContainer.CLASS_INVASION,ScoreElement.COMPANY_TYPE_EIC,_loc3_);
            _loc7_.updateScoreboard(GuiConstants.INVASION_WINDOW,SimpleContainer.CLASS_INVASION,ScoreElement.COMPANY_TYPE_VRU,_loc5_);
            _loc7_.setInvasionWave(_loc2_);
         }
      }
   }
}

