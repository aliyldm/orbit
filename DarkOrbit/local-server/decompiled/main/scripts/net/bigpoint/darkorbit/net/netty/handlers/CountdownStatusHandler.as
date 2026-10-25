package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.CountdownStatusCommand;
   import net.bigpoint.darkorbit.com.module.CountdownStatusTypeModule;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.countdownStatus.view.CountdownStatusWindowView;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class CountdownStatusHandler extends BaseHandler
   {
      
      public function CountdownStatusHandler()
      {
         super();
      }
      
      public static function run(param1:CountdownStatusCommand) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:SimpleWindow = null;
         var _loc4_:CountdownStatusWindowView = null;
         if(param1.type.type == CountdownStatusTypeModule.STATUSTYPE_HALLOWEEN_2012)
         {
            if(param1.currentAmount > 0)
            {
               _loc2_ = false;
               _loc3_ = _main.getGuiManager().getWindow(GuiConstants.CURCUBITOR_COUNTDOWN_STATUS_WINDOW);
               if(_loc3_ == null)
               {
                  _loc3_ = _main.getGuiManager().createWindow(GuiConstants.CURCUBITOR_COUNTDOWN_STATUS_WINDOW) as SimpleWindow;
               }
               else if(!_loc3_.maximized)
               {
                  _loc2_ = true;
               }
               _loc4_ = FlexWindowManager.getInstance().getWindowByType(FlexWindowManager.COUNTDOWN_STATUS) as CountdownStatusWindowView;
               if(_loc4_ == null)
               {
                  _loc4_ = FlexWindowManager.getInstance().createDownGradedWindow(FlexWindowManager.COUNTDOWN_STATUS,_loc3_) as CountdownStatusWindowView;
               }
               _loc4_.countDownLabel.text = BPLocale.getItem("label_countdownHalloweenNpcs").replace("%AMOUNT%",param1.currentAmount).replace("%TOTAL%",param1.maxAmount);
               if(!_loc2_)
               {
                  _main.guiManager.maximizeWindow(GuiConstants.CURCUBITOR_COUNTDOWN_STATUS_WINDOW);
               }
            }
            else
            {
               FlexWindowManager.getInstance().destroyWindow(FlexWindowManager.COUNTDOWN_STATUS);
            }
         }
      }
   }
}

