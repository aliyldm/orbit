package net.bigpoint.darkorbit.net.netty.handlers.capture
{
   import net.bigpoint.darkorbit.com.module.CTBScoreUpdateCommand;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.CTBScoreElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class CTBScoreUpdateHandler extends AbstractCTBHandler
   {
      
      public function CTBScoreUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:CTBScoreUpdateCommand) : void
      {
         var _loc2_:Array = [];
         _loc2_.push(param1.score_MMO);
         _loc2_.push(param1.score_EIC);
         _loc2_.push(param1.score_VRU);
         updateCTBScoreboard(_loc2_);
      }
      
      private static function updateCTBScoreboard(param1:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:CTBScoreElement = null;
         var _loc2_:SimpleWindow = guiManager ? guiManager.getWindow(GuiConstants.CTB_WINDOW) : null;
         if(_loc2_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < param1.length)
            {
               _loc4_ = CTBScoreElement(guiManager.getScoreElement(GuiConstants.CTB_WINDOW,SimpleContainer.CLASS_CTB,_loc3_ + 1));
               if(_loc4_ != null)
               {
                  _loc4_.updateScore(param1[_loc3_]);
               }
               _loc3_++;
            }
         }
      }
   }
}

