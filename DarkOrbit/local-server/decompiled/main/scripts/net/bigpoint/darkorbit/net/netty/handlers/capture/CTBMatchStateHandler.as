package net.bigpoint.darkorbit.net.netty.handlers.capture
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.CTBMatchStateCommand;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.CTBScoreElement;
   import net.bigpoint.darkorbit.gui.elements.CTBScoreGridElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.common.AssetNotifications;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class CTBMatchStateHandler extends AbstractCTBHandler
   {
      
      public function CTBMatchStateHandler()
      {
         super();
      }
      
      public static function run(param1:CTBMatchStateCommand) : void
      {
         var _loc2_:Boolean = param1.running;
         if(_loc2_)
         {
            createCTBScoreboard();
         }
         else
         {
            destroyCTBScoreboard();
         }
      }
      
      private static function createCTBScoreboard() : void
      {
         var _loc1_:SimpleWindow = null;
         var _loc2_:SimpleContainer = null;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc6_:CTBScoreElement = null;
         var _loc7_:Array = null;
         var _loc8_:CTBScoreGridElement = null;
         GameFacade.getInstance().sendNotification(AssetNotifications.PRELOAD_LIST,"ctb",AssetNotifications.TYPE_PRELOAD_LIST_TYPE_PATTERN_KEY);
         if(guiManager.getWindow(GuiConstants.CTB_WINDOW) == null)
         {
            _loc1_ = guiManager.createWindow(GuiConstants.CTB_WINDOW) as SimpleWindow;
            _loc2_ = new SimpleContainer(guiManager,SimpleContainer.CLASS_CTB);
            _loc3_ = 0;
            _loc4_ = 1;
            _loc2_.x = 12;
            _loc2_.y = 35;
            _loc5_ = 1;
            while(_loc5_ < 4)
            {
               _loc6_ = new CTBScoreElement(guiManager,_loc5_);
               _loc6_.setTitleYPosition(-4);
               _loc6_.setScoreYPosition(32);
               _loc6_.updateScore(0);
               if(_loc5_ == Hero.factionID.value)
               {
                  _loc6_.order = 0;
               }
               else
               {
                  _loc6_.order = _loc4_++;
               }
               _loc2_.addElement(_loc6_,SimpleContainer.NO_ALIGN);
               _loc5_++;
            }
            _loc7_ = _loc2_.getAllElements();
            _loc7_.sortOn("order",Array.NUMERIC);
            _loc5_ = 0;
            while(_loc5_ < _loc7_.length)
            {
               _loc6_ = _loc7_[_loc5_];
               _loc6_.x = _loc3_;
               _loc3_ += _loc6_.getBackground().width;
               _loc5_++;
            }
            _loc8_ = new CTBScoreGridElement();
            _loc8_.x = -2;
            _loc8_.y = -3;
            _loc2_.addElement(_loc8_,SimpleContainer.NO_ALIGN);
            _loc1_.addContainer(_loc2_);
         }
      }
      
      public static function destroyCTBScoreboard() : void
      {
         var _loc1_:SimpleWindow = guiManager ? guiManager.getWindow(GuiConstants.CTB_WINDOW) : null;
         if(_loc1_ != null)
         {
            guiManager.closeWindow(_loc1_);
         }
      }
   }
}

