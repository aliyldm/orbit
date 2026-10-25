package net.bigpoint.darkorbit.net.netty.handlers.capture
{
   import net.bigpoint.darkorbit.com.module.CTBBeaconPositionCommand;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.CTBScoreElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class CTBBeaconPositionHandler extends AbstractCTBHandler
   {
      
      public function CTBBeaconPositionHandler()
      {
         super();
      }
      
      public static function run(param1:CTBBeaconPositionCommand) : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:CTBScoreElement = null;
         var _loc2_:int = param1.beaconId;
         var _loc3_:int = param1.mapId;
         var _loc4_:SimpleWindow = guiManager ? guiManager.getWindow(GuiConstants.CTB_WINDOW) : null;
         if(_loc4_ != null)
         {
            _loc5_ = _loc2_.toString().split("");
            _loc6_ = int(_loc5_[1]);
            _loc7_ = int(_loc5_[2]);
            _loc8_ = CTBScoreElement(guiManager.getScoreElement(GuiConstants.CTB_WINDOW,SimpleContainer.CLASS_CTB,_loc6_));
            if(_loc8_ != null)
            {
               _loc8_.updateBeacon(_loc2_,_loc7_,_loc3_);
            }
         }
      }
   }
}

