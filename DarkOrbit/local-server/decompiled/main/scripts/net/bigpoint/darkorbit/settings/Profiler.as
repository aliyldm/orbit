package net.bigpoint.darkorbit.settings
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.gui.elements.VideoElement;
   import net.bigpoint.darkorbit.gui.windows.specifics.VideoWindow;
   import net.bigpoint.darkorbit.interfaces.IFrameObserver;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   
   public class Profiler implements IFrameObserver
   {
      
      public static var QUALITY_LOW_LIMIT:int = 10;
      
      public static const DEFAULT_SMOKE_MS:int = 60;
      
      public static var AUTO_QUALITY_LOWER_BOUND_FPS:int = 10;
      
      public static var AUTO_QUALITY_LOWER_BOUND_INTERVALS_TILL_CHANGE:int = 1;
      
      public static var AUTO_QUALITY_UPPER_BOUND_FPS:int = 60;
      
      public static var AUTO_QUALITY_UPPER_BOUND_INTERVALS_TILL_CHANGE:int = 1;
      
      public static var INTERVAL_LENGTH:int = 20000;
      
      public static var NOTIFICATION_STEPS:Array = [3,4,6];
      
      private var main:Main;
      
      public var FPSCollection:Array = [];
      
      private var notificationOutputs:int = 0;
      
      private var lowFPSInARow:int = 0;
      
      private var fPSBelowAutoQualityBoundsInARow:int = 0;
      
      private var fPSAboveAutoQualityBoundsInARow:int = 0;
      
      public var isNotificationInQueue:Boolean = false;
      
      private var _tpf:Number = 0;
      
      private var _tpfFPS:Number = 0;
      
      private var _frameTicks:int;
      
      public function Profiler(param1:Main)
      {
         super();
         this.main = param1;
      }
      
      public function start() : void
      {
         this.addEventListeners();
         if(!ScreenManager.containsObserver(this))
         {
            ScreenManager.addObserver(this);
         }
      }
      
      public function stop() : void
      {
         this.removeEventListeners();
         ScreenManager.removeObserver(this);
      }
      
      private function addFPS(param1:int) : void
      {
         if(ScreenManager.containsObserver(this) && this.FPSCollection.length <= 100)
         {
            this.FPSCollection.push(param1);
         }
      }
      
      public function updateTimer(param1:Number) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Boolean = false;
         this._tpf += param1;
         ++this._frameTicks;
         this._tpfFPS += param1;
         if(this._tpfFPS > 999)
         {
            _loc2_ = this._frameTicks;
            this.addFPS(_loc2_);
            this._frameTicks = 0;
            this._tpfFPS = 0;
            this.calculateDynamicFPSActivation(_loc2_);
         }
         if(this._tpf > INTERVAL_LENGTH - 1)
         {
            if(this.FPSCollection.length == 0)
            {
               return;
            }
            _loc3_ = 0;
            for each(_loc4_ in this.FPSCollection)
            {
               _loc3_ += _loc4_;
            }
            _loc5_ = Math.round(_loc3_ / this.FPSCollection.length);
            _loc6_ = this.checkAndHandleNotification(_loc5_);
            if(Settings.allowAutoQuality.value)
            {
               this.checkAndHandleAutoQualityReduction(_loc5_);
            }
            else
            {
               this.fPSBelowAutoQualityBoundsInARow = 0;
               this.fPSAboveAutoQualityBoundsInARow = 0;
               Settings.autoQualityReduction.value = 0;
               if(!_loc6_)
               {
                  this.stop();
               }
            }
            this.FPSCollection = [];
            this._tpf = 0;
         }
      }
      
      private function calculateDynamicFPSActivation(param1:uint) : void
      {
         if(this.main.screenManager.map != null)
         {
         }
      }
      
      private function checkAndHandleAutoQualityReduction(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = Settings.getQualitySettingLevel();
         if(param1 < AUTO_QUALITY_LOWER_BOUND_FPS)
         {
            ++this.fPSBelowAutoQualityBoundsInARow;
            _loc2_ = AUTO_QUALITY_LOWER_BOUND_INTERVALS_TILL_CHANGE;
            if(this.fPSBelowAutoQualityBoundsInARow >= _loc2_ && _loc3_ > Settings.QUALITY_LOW)
            {
               if(Settings.autoQualityReduction.value < Settings.AQ_MAX_REDUCTION)
               {
                  Settings.autoQualityReduction.value += 1;
               }
            }
         }
         else
         {
            this.fPSBelowAutoQualityBoundsInARow = 0;
         }
         if(param1 > AUTO_QUALITY_UPPER_BOUND_FPS)
         {
            ++this.fPSAboveAutoQualityBoundsInARow;
            _loc2_ = AUTO_QUALITY_UPPER_BOUND_INTERVALS_TILL_CHANGE;
            if(this.fPSAboveAutoQualityBoundsInARow >= _loc2_)
            {
               if(Settings.autoQualityReduction.value > Settings.AQ_NONE)
               {
                  --Settings.autoQualityReduction.value;
               }
            }
         }
         else
         {
            this.fPSAboveAutoQualityBoundsInARow = 0;
         }
      }
      
      private function checkAndHandleNotification(param1:int) : Boolean
      {
         var _loc5_:int = 0;
         var _loc2_:int = int(NOTIFICATION_STEPS.length);
         if(this.notificationOutputs >= _loc2_ || Settings.displayNotifications.value == false)
         {
            return false;
         }
         var _loc3_:Boolean = true;
         if(this.isNotificationInQueue && _loc3_)
         {
            this.showNotification();
            return true;
         }
         var _loc4_:int = Settings.getQualitySettingLevel();
         if(param1 < QUALITY_LOW_LIMIT)
         {
            ++this.lowFPSInARow;
            _loc5_ = int(NOTIFICATION_STEPS[this.notificationOutputs]);
            if(this.lowFPSInARow >= _loc5_ && _loc4_ > Settings.QUALITY_LOW)
            {
               if(_loc3_)
               {
                  this.showNotification();
               }
               else
               {
                  this.lowFPSInARow = 0;
                  this.isNotificationInQueue = true;
               }
            }
         }
         else
         {
            this.lowFPSInARow = 0;
         }
         if(this.notificationOutputs >= _loc2_)
         {
            return false;
         }
         return true;
      }
      
      public function showNotification() : void
      {
         var _loc1_:Vector.<String> = null;
         if(!Settings.isPepperFlashPlayer)
         {
            _loc1_ = Vector.<String>(["notification_low_performance"]);
            this.main.getGuiManager().createVideoWindow(_loc1_,VideoWindow.NOTIFICATION_FPS,2,VideoElement.CLASS_HELPMOVIE,true,"nw");
         }
         else
         {
            _loc1_ = Vector.<String>(["notification_low_performance_pepper_flash_player"]);
            this.main.getGuiManager().createExtendedHelpVideoWindow(_loc1_,VideoWindow.NOTIFICATION_FPS,2,VideoElement.CLASS_HELPMOVIE,true,"nw");
         }
         this.lowFPSInARow = 0;
         ++this.notificationOutputs;
         this.isNotificationInQueue = false;
      }
      
      protected function addEventListeners() : void
      {
         if(this.main.stage)
         {
            this.main.stage.addEventListener(Event.ACTIVATE,this.handleActivateEvent);
            this.main.stage.addEventListener(Event.DEACTIVATE,this.handleDeactivateEvent);
         }
      }
      
      protected function removeEventListeners() : void
      {
         if(this.main.stage)
         {
            this.main.stage.removeEventListener(Event.ACTIVATE,this.handleActivateEvent);
            this.main.stage.removeEventListener(Event.DEACTIVATE,this.handleDeactivateEvent);
         }
      }
      
      protected function handleActivateEvent(param1:Event) : void
      {
         if(!ScreenManager.containsObserver(this))
         {
            ScreenManager.addObserver(this);
         }
      }
      
      protected function handleDeactivateEvent(param1:Event) : void
      {
         if(ScreenManager.containsObserver(this))
         {
            ScreenManager.removeObserver(this);
         }
      }
   }
}

