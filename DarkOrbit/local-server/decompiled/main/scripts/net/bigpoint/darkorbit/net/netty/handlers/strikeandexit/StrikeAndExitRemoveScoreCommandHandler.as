package net.bigpoint.darkorbit.net.netty.handlers.strikeandexit
{
   import net.bigpoint.darkorbit.map.model.ship.Ship;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class StrikeAndExitRemoveScoreCommandHandler extends DOAbstractSimpleCommand
   {
      
      public function StrikeAndExitRemoveScoreCommandHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Ship = null;
         super.execute(param1);
         if(map != null)
         {
            _loc2_ = map.hero;
            if(_loc2_)
            {
               _loc2_.info.saeScore.value = 0;
            }
         }
         this.tryClose();
      }
      
      private function tryClose() : Boolean
      {
         var _loc1_:IWindow = guiManager.getWindow(GuiConstants.STRIKE_AND_EXIT_INFO);
         if(Boolean(_loc1_) && _loc1_.maximized)
         {
            _loc1_.minimize();
            return true;
         }
         return false;
      }
   }
}

