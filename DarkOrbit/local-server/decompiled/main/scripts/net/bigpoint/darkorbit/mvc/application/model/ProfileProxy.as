package net.bigpoint.darkorbit.mvc.application.model
{
   import flash.events.Event;
   import flash.net.URLLoader;
   import net.bigpoint.darkorbit.mvc.common.model.AbstractLoadProxy;
   import net.bigpoint.darkorbit.settings.Profiler;
   import net.bigpoint.darkorbit.settings.Settings;
   
   public class ProfileProxy extends AbstractLoadProxy
   {
      
      public static const NAME:String = "ProfileProxy";
      
      private var _profileXML:XML;
      
      private var _profiler:Profiler;
      
      public function ProfileProxy()
      {
         super(NAME);
      }
      
      override protected function handleLoaded(param1:Event) : void
      {
         super.handleLoaded(param1);
         var _loc2_:* = (param1.currentTarget as URLLoader).data;
         this.init(_loc2_);
         executeCallback();
         Settings.displayNotifications.changed.add(this.handleDisplayNotificationsSettingsChanged);
         Settings.allowAutoQuality.changed.add(this.handleDisplayNotificationsSettingsChanged);
      }
      
      private function handleDisplayNotificationsSettingsChanged() : void
      {
         if(Settings.displayNotifications.value || Settings.allowAutoQuality.value)
         {
            this.getProfiler().start();
         }
      }
      
      protected function init(param1:Object) : void
      {
         var _loc2_:XML = null;
         var _loc3_:int = 0;
         this._profileXML = new XML(param1);
         if(this._profileXML.qualityLowLimit != "")
         {
            Profiler.QUALITY_LOW_LIMIT = int(this._profileXML.qualityLowLimit);
         }
         if(this._profileXML.intervalLength != "")
         {
            Profiler.INTERVAL_LENGTH = int(this._profileXML.intervalLength);
         }
         if(XMLList(this._profileXML.notificationSteps).length() > 0)
         {
            Profiler.NOTIFICATION_STEPS = [];
            for each(_loc2_ in this._profileXML.notificationSteps.notificationStep)
            {
               if(_loc2_.@value > 0)
               {
                  Profiler.NOTIFICATION_STEPS.push(int(_loc2_.@value));
               }
            }
         }
         if(this._profileXML.autoQualityLowerBoundFPS != "")
         {
            Profiler.AUTO_QUALITY_LOWER_BOUND_FPS = int(this._profileXML.autoQualityLowerBoundFPS);
         }
         if(this._profileXML.autoQualityUpperBoundFPS != "")
         {
            Profiler.AUTO_QUALITY_UPPER_BOUND_FPS = int(this._profileXML.autoQualityUpperBoundFPS);
         }
         if(this._profileXML.autoQualityLowerBoundIntervalsTillChange != "")
         {
            Profiler.AUTO_QUALITY_LOWER_BOUND_INTERVALS_TILL_CHANGE = int(this._profileXML.autoQualityLowerBoundIntervalsTillChange);
         }
         if(this._profileXML.autoQualityUpperBoundIntervalsTillChange != "")
         {
            Profiler.AUTO_QUALITY_UPPER_BOUND_INTERVALS_TILL_CHANGE = int(this._profileXML.autoQualityUpperBoundIntervalsTillChange);
         }
      }
      
      public function setProfiler(param1:Profiler) : void
      {
         this._profiler = param1;
      }
      
      public function getProfiler() : Profiler
      {
         return this._profiler;
      }
   }
}

