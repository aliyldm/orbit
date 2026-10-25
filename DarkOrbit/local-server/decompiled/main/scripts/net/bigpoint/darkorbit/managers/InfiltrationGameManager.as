package net.bigpoint.darkorbit.managers
{
   import com.bigpoint.utils.TimeFormatter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.container.SimpleContainer;
   import net.bigpoint.darkorbit.gui.elements.InfoField;
   import net.bigpoint.darkorbit.gui.elements.SimpleElement;
   import net.bigpoint.darkorbit.gui.windows.simpleWindow.SimpleWindow;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.mvc.gui.GuiConstants;
   
   public class InfiltrationGameManager implements IFrameObserver
   {
      
      private var main:Main;
      
      private var localSecsElapsed:int;
      
      private var ifgTimeInSecs:int;
      
      private var ifgMsSinceLastUpdate:Number = 0;
      
      public function InfiltrationGameManager(param1:Main)
      {
         super();
         this.main = param1;
      }
      
      private function createInfiltrationGameWindow() : SimpleWindow
      {
         var _loc6_:SimpleElement = null;
         var _loc1_:int = 0;
         var _loc2_:SimpleWindow = this.main.getGuiManager().createWindow(GuiConstants.INFILTRATION_GAME_WINDOW) as SimpleWindow;
         var _loc3_:SimpleContainer = _loc2_.getContainer(SimpleContainer.CLASS_INFILTRATION_GAME);
         var _loc4_:Array = _loc3_.getAllElements();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length)
         {
            _loc6_ = _loc4_[_loc5_];
            if(_loc6_ != null)
            {
               _loc6_.x = _loc1_;
            }
            _loc1_ += 60;
            _loc5_++;
         }
         return _loc2_;
      }
      
      public function updateInfiltrationGameWindow(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:SimpleWindow = this.main.getGuiManager().getWindow(GuiConstants.INFILTRATION_GAME_WINDOW);
         if(_loc4_ == null)
         {
            _loc4_ = this.createInfiltrationGameWindow();
         }
         var _loc5_:SimpleContainer = _loc4_.getContainer(SimpleContainer.CLASS_INFILTRATION_GAME);
         var _loc6_:InfoField = _loc5_.getElement(SimpleElement.TYPE_INFILTRATION_GAME_TIMER) as InfoField;
         _loc6_.setLabel(TimeFormatter.formatTime(param1));
         var _loc7_:String = BPLocale.getItem("ttip_infiltrationGameTimer").replace(/%TIME%/,TimeFormatter.formatTime(param1));
         _loc6_.updateTooltip(_loc7_);
         this.ifgTimeInSecs = param1;
         this.localSecsElapsed = 0;
         if(!ScreenManager.containsObserver(this))
         {
            ScreenManager.addObserver(this);
         }
         var _loc8_:InfoField = _loc5_.getElement(SimpleElement.TYPE_INFILTRATION_GAME_AMOUNTS) as InfoField;
         _loc8_.setLabel(BPLocale.getItem("prefix_ifg_amounts").replace(/%COUNT%/,param2 + "/" + param3));
         _loc8_.setText(BPLocale.getItem("prefix_ifg_amounts").replace(/%COUNT%/,param2 + "/" + param3));
         _loc8_.getChildAt(0).y = 5;
         var _loc9_:TextFormat = new TextFormat();
         _loc9_.align = TextFormatAlign.CENTER;
         var _loc10_:TextField = _loc8_.getChildAt(1) as TextField;
         _loc10_.setTextFormat(_loc9_);
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:SimpleWindow = null;
         var _loc4_:SimpleContainer = null;
         var _loc5_:InfoField = null;
         var _loc6_:String = null;
         this.ifgMsSinceLastUpdate += param1;
         if(this.ifgMsSinceLastUpdate > 999)
         {
            _loc2_ = this.ifgTimeInSecs - this.localSecsElapsed++;
            if(_loc2_ < 0)
            {
               _loc2_ = 0;
            }
            _loc3_ = this.main.getGuiManager().getWindow(GuiConstants.INFILTRATION_GAME_WINDOW);
            if(_loc3_ == null)
            {
               _loc3_ = this.createInfiltrationGameWindow();
            }
            _loc4_ = _loc3_.getContainer(SimpleContainer.CLASS_INFILTRATION_GAME);
            _loc5_ = _loc4_.getElement(SimpleElement.TYPE_INFILTRATION_GAME_TIMER) as InfoField;
            _loc5_.setLabel(TimeFormatter.formatTime(_loc2_));
            _loc6_ = BPLocale.getItem("ttip_infiltrationGameTimer").replace(/%TIME%/,TimeFormatter.formatTime(_loc2_));
            _loc5_.updateTooltip(_loc6_);
            if(_loc2_ == 0)
            {
               this.stopInfiltrationGameTimer();
            }
            this.ifgMsSinceLastUpdate -= 1000;
         }
      }
      
      private function stopInfiltrationGameTimer() : void
      {
         ScreenManager.removeObserver(this);
      }
      
      public function getMain() : Main
      {
         return this.main;
      }
      
      public function cleanUp() : void
      {
         this.stopInfiltrationGameTimer();
      }
   }
}

