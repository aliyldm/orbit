package com.craftymind.memoryTracker
{
   import flash.display.Stage;
   import flash.events.Event;
   import flash.net.LocalConnection;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.setTimeout;
   import mx.formatters.DateFormatter;
   
   public class MemoryTracker
   {
      
      private static var m_tracking:Dictionary = new Dictionary(true);
      
      private static var m_count:int = 0;
      
      private static var m_stage:Stage = null;
      
      private static var m_debug:TextField = null;
      
      private static var _env:Object = {};
      
      private static var _envStr:String = "";
      
      public function MemoryTracker()
      {
         super();
      }
      
      public static function set stage(param1:Stage) : void
      {
         MemoryTracker.m_stage = param1;
      }
      
      public static function set debugTextField(param1:TextField) : void
      {
         MemoryTracker.m_debug = param1;
      }
      
      public static function gcAndCheck() : void
      {
         if(MemoryTracker.m_stage == null)
         {
            MemoryTracker._log("Please set the Stage reference in MemoryTracker.stage before calling this");
            return;
         }
         MemoryTracker.m_count = 0;
         MemoryTracker.m_stage.addEventListener(Event.ENTER_FRAME,MemoryTracker._gc);
      }
      
      private static function _gc(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
         }
         catch(e:Error)
         {
         }
         _loc2_ = true;
         if(_loc2_)
         {
            (param1.target as Stage).removeEventListener(Event.ENTER_FRAME,MemoryTracker._gc);
            setTimeout(MemoryTracker._doLastGC,40);
         }
      }
      
      private static function _doLastGC() : void
      {
         var _loc4_:Object = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:DateFormatter = null;
         MemoryTracker._log("-------------------------------------------------");
         MemoryTracker._log("Remaining references in the MemoryTracker:");
         var _loc1_:int = 0;
         var _loc2_:Vector.<Object> = new Vector.<Object>();
         var _loc3_:Vector.<*> = new Vector.<*>();
         for(_loc4_ in MemoryTracker.m_tracking)
         {
            _loc1_++;
            _loc2_.push(MemoryTracker.m_tracking[_loc4_]);
            _loc3_.push(_loc4_);
         }
         _loc2_.sort(compareTrackingData);
         _loc5_ = new Vector.<String>();
         _loc6_ = new DateFormatter();
         _loc6_.formatString = "JJ:NN:SS.QQQ";
         _loc1_ = 0;
         while(_loc1_ < _loc2_.length)
         {
            _loc5_.push("[" + _loc6_.format(_loc2_[_loc1_].timestamp) + "] " + _loc2_[_loc1_].label);
            _loc1_++;
         }
         MemoryTracker._log(_loc5_.join("\n"));
         MemoryTracker._log("------------------------------------------------- total: " + _loc1_);
      }
      
      private static function compareTrackingData(param1:Object, param2:Object) : int
      {
         if(param1.timestamp.getTime() > param2.timestamp.getTime())
         {
            return 1;
         }
         if(param1.timestamp.getTime() < param2.timestamp.getTime())
         {
            return -1;
         }
         return 0;
      }
      
      private static function _log(param1:String) : void
      {
         if(MemoryTracker.m_debug != null)
         {
            MemoryTracker.m_debug.appendText(param1 + "\n");
         }
      }
      
      public static function setTrackEnv(param1:String, param2:String) : void
      {
         if(param2 !== null && param2.length > 0)
         {
            _env[param1] = param2;
         }
         else
         {
            _env[param1] = null;
            delete _env[param1];
         }
         _envStr = "";
         for(param1 in _env)
         {
            _envStr += "{" + param1 + ":" + _env[param1] + "} ";
         }
      }
   }
}

