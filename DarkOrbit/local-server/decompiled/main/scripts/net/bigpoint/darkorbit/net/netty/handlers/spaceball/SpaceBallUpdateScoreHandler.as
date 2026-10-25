package net.bigpoint.darkorbit.net.netty.handlers.spaceball
{
   import net.bigpoint.darkorbit.com.module.SpaceBallUpdateScoreCommand;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.map.model.env.Portal;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class SpaceBallUpdateScoreHandler extends AbstractSpaceballHandler
   {
      
      public function SpaceBallUpdateScoreHandler()
      {
         super();
      }
      
      public static function run(param1:SpaceBallUpdateScoreCommand) : void
      {
         var _loc2_:int = param1.factionId;
         var _loc3_:int = param1.gateId;
         var _loc4_:int = param1.score;
         var _loc5_:GuiManager = _main.getGuiManager();
         _loc5_.updateScoreboard(GuiConstants.SPACEBALL_WINDOW,SimpleContainer.CLASS_SPACEBALL,_loc2_,_loc4_);
         var _loc6_:Portal = ScreenManager.getInstance().map.getEntityById(_loc3_) as Portal;
         if(_loc6_)
         {
            _loc6_.jump(2);
         }
      }
   }
}

