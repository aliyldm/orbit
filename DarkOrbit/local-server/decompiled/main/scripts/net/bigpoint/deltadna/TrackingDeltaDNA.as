package net.bigpoint.deltadna
{
   import flash.display.Stage;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.system.Capabilities;
   import flash.system.System;
   import flash.utils.getTimer;
   
   public class TrackingDeltaDNA
   {
      
      private static const APIKEY_DEV:String = "36354895740097111828373609615749";
      
      private static const APIKEY_LIVE:String = "36354906083689211744887718815749";
      
      private static const COLLECT_URL:String = "https://collect16086drkrb.deltadna.net";
      
      private static const ENGAGE_URL:String = "";
      
      private static const PLATFORM_ANDROID:String = "ANDROID";
      
      private static const PLATFORM_IOS:String = "IOS";
      
      private static const PLATFORM_WEB:String = "WEB";
      
      private static const DEVICE_HANDHELD:String = "HANDHELD";
      
      private static const DEVICE_MOBILE_PHONE:String = "MOBILE_PHONE";
      
      private static const DEVICE_TABLET:String = "TABLET";
      
      private static const DEVICE_PC:String = "PC";
      
      private static const TABLET_THRESHOLD:Number = 7;
      
      public static var _instance:TrackingDeltaDNA = null;
      
      private var apikey:String;
      
      private var apisecret:String;
      
      private var url:String;
      
      private var userid:Number;
      
      private var instanceId:int;
      
      private var sessionid:String;
      
      private var platform:String;
      
      private var _startTime:Number = 0;
      
      private var _frameCounter:Number = 0;
      
      private var _frameTime:Number = 0;
      
      private var _fpsMin:Number = Infinity;
      
      private var _fpsMax:Number = -1;
      
      private var _fpsSum:Number = 0;
      
      private var _fpsCount:Number = 0;
      
      private var _totalMemMax:Number = 0;
      
      private var _totalMemSum:Number = 0;
      
      private var _totalMemCount:Number = 0;
      
      private var _usedMemDelta:Number = 0;
      
      private var _usedMemLast:Number = -1;
      
      private var _usedMemDeltaTime:Number = 0;
      
      private var _statisticsTime:Number = 0;
      
      public function TrackingDeltaDNA(param1:Boolean, param2:Number, param3:int, param4:String, param5:String)
      {
         super();
         if(_instance == null)
         {
            _instance = this;
            this.apikey = param1 ? APIKEY_LIVE : APIKEY_DEV;
            this.userid = param2;
            this.instanceId = param3;
            this.platform = param5;
            this.url = COLLECT_URL + "/collect/api/" + this.apikey;
            this.sessionid = param4;
            return;
         }
         throw new Error("TrackingDeltaDNA() error: Respect the singleton!");
      }
      
      public function track(param1:String, param2:Object) : void
      {
         var data:Object;
         var hdr:URLRequestHeader;
         var request:URLRequest;
         var loader:URLLoader;
         var event:String = param1;
         var params:Object = param2;
         var eventParams:Object = params || {};
         eventParams["platform"] = this.platform;
         eventParams["projectID"] = this.instanceId;
         data = {
            "eventName":event,
            "userID":this.userid.toString(),
            "sessionID":this.sessionid,
            "eventParams":eventParams
         };
         hdr = new URLRequestHeader("Content-type","application/json");
         request = new URLRequest(this.url);
         loader = new URLLoader();
         request.requestHeaders.push(hdr);
         request.data = JSON.stringify(data);
         request.method = "POST";
         loader.dataFormat = URLLoaderDataFormat.TEXT;
         loader.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
         });
         loader.addEventListener("error",function(param1:ErrorEvent):void
         {
         });
         loader.addEventListener("ioError",function(param1:IOErrorEvent):void
         {
         });
         loader.load(request);
      }
      
      public function TrackClientDevice() : void
      {
         var _loc1_:Object = {
            "manufacturer":Capabilities.manufacturer,
            "operatingSystemVersion":Capabilities.os,
            "isDebugger":Capabilities.isDebugger,
            "clientLanguage":Capabilities.language,
            "screenResolutionX":Capabilities.screenResolutionX.toString(),
            "screenResolutionY":Capabilities.screenResolutionY.toString(),
            "cpuArchitecture":Capabilities["cpuArchitecture"],
            "supports32BitProcesses":Capabilities["supports32BitProcesses"],
            "supports64BitProcesses":Capabilities["supports64BitProcesses"]
         };
         this.track("clientDevice",_loc1_);
      }
      
      public function setStage(param1:Stage) : void
      {
         param1.addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         this.enterFrame();
      }
      
      public function enterFrame() : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc1_:Number = getTimer();
         if(_loc1_ > this._frameTime + 1000)
         {
            this._frameTime += 1000;
            this._fpsMin = Math.min(this._fpsMin,this._frameCounter);
            this._fpsMax = Math.max(this._fpsMax,this._frameCounter);
            this._fpsSum += this._frameCounter;
            ++this._fpsCount;
            this._frameCounter = 0;
         }
         ++this._frameCounter;
         var _loc2_:Number = System.totalMemory;
         this._totalMemMax = Math.max(this._totalMemMax,_loc2_);
         this._totalMemSum += _loc2_;
         ++this._totalMemCount;
         var _loc3_:Number = _loc2_ - System.freeMemory;
         if(this._usedMemLast == -1)
         {
            this._usedMemLast = _loc3_;
         }
         this._usedMemDelta += Math.abs(this._usedMemLast - _loc3_);
         this._usedMemLast = _loc3_;
         if(_loc1_ > this._statisticsTime)
         {
            _loc4_ = {
               "minFps":this._fpsMin,
               "maxFps":this._fpsMax,
               "avgFps":Math.round(this._fpsSum / this._fpsCount),
               "totalMemorySize":this._totalMemMax,
               "dynamicMemorySize":Math.round(this._totalMemSum / this._totalMemCount),
               "staticMemorySize":Math.round(this._usedMemDelta / ((_loc1_ - this._usedMemDeltaTime + 1) / 1000)),
               "playTime":Math.round((_loc1_ - this._startTime) / 1000)
            };
            this.track("performanceMetrics",_loc4_);
            this._fpsMin = Infinity;
            this._fpsMax = -1;
            this._fpsSum = 0;
            this._fpsCount = 0;
            this._totalMemMax = 0;
            this._totalMemSum = 0;
            this._totalMemCount = 0;
            this._usedMemDelta = 0;
            this._usedMemDeltaTime = _loc1_;
            _loc5_ = _loc1_ - this._startTime < 60 * 1000 ? 60 : 600;
            this._statisticsTime += _loc5_ * 1000;
         }
      }
   }
}

