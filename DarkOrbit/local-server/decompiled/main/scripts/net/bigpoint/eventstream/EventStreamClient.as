package net.bigpoint.eventstream
{
   import com.adobe.serialization.json.JASON;
   import com.adobe.utils.StringUtil;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.system.System;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.utils.version.Version;
   import net.bigpoint.eventstream.vo.ESCRequestVo;
   
   public class EventStreamClient
   {
      
      public static var VERSION:Number = 91;
      
      private static var _instance:EventStreamClient = null;
      
      public const FLUSH_INTERVAL:uint = 10;
      
      public var debug:Boolean = true;
      
      private var _byteArray:ByteArray;
      
      private var _logFunction:Function;
      
      private var _startTime:Number = 0;
      
      private var _queue:Array = [];
      
      private var _context:Object = null;
      
      private var _stage:Stage = null;
      
      private var _frameCounter:Number = 0;
      
      private var _frameTime:Number = 0;
      
      private var _fpsMin:Number = Infinity;
      
      private var _fpsSum:Number = 0;
      
      private var _fpsCount:Number = 0;
      
      private var _totalMemMax:Number = 0;
      
      private var _totalMemSum:Number = 0;
      
      private var _totalMemCount:Number = 0;
      
      private var _usedMemDelta:Number = 0;
      
      private var _usedMemLast:Number = -1;
      
      private var _usedMemDeltaTime:Number = 0;
      
      private var _urlRequest:URLRequest = new URLRequest();
      
      private var _loader:URLLoader;
      
      private var _attempt:Number = 0;
      
      private var _contentType:String = "application/x-compressed-json";
      
      private var _autoEnterFrame:Boolean;
      
      private var _lastFlush:int;
      
      private var _statisticsTime:Number = 0;
      
      private var _counter:int = -1;
      
      public function EventStreamClient(param1:String, param2:Stage, param3:Boolean = true, param4:Function = null)
      {
         super();
         if(_instance == null)
         {
            _instance = this;
            this._autoEnterFrame = param3;
            this.setClientContext(param1);
            this.setStage(param2);
            this.setLogger(param4);
            this._byteArray = new ByteArray();
            this._urlRequest = new URLRequest();
            this._urlRequest.method = URLRequestMethod.POST;
            this._urlRequest.contentType = "application/x-compressed-json";
            this._startTime = getTimer();
            this._lastFlush = getTimer();
            Security.loadPolicyFile(this.baseURL + "crossdomain.xml");
            this._counter = getDefinitionByName(Base64.decode("Zmxhc2guc2FtcGxlci5nZXRTYW1wbGVDb3VudA=="))();
            return;
         }
         throw new Error("EventStreamClient() error: Respect the singleton!");
      }
      
      public static function track(param1:String, param2:Object = null, param3:Boolean = false) : void
      {
      }
      
      private function get baseURL() : String
      {
         return "https://eventstream-829-weblog-0" + (this._startTime % 8 + 1).toString() + ".bigpoint.net/";
      }
      
      public function enterFrame() : void
      {
         var _loc1_:Number = getTimer();
         if(_loc1_ - this._lastFlush > this.FLUSH_INTERVAL * 1000)
         {
            this._lastFlush = _loc1_;
            this.flush();
         }
         if(_loc1_ > this._frameTime + 1000)
         {
            this._frameTime += 1000;
            this._fpsMin = Math.min(this._fpsMin,this._frameCounter);
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
            this.doTrack("flash.metrics",{
               "fpsMin":this._fpsMin,
               "fpsAvg":Math.round(this._fpsSum / this._fpsCount),
               "totalMemMax":this._totalMemMax,
               "totalMemAvg":Math.round(this._totalMemSum / this._totalMemCount),
               "usedMemDelta":Math.round(this._usedMemDelta / ((_loc1_ - this._usedMemDeltaTime) / 1000)),
               "playTime":Math.round((_loc1_ - this._startTime) / 1000),
               "counter":this._counter
            });
            this._fpsMin = Infinity;
            this._fpsSum = 0;
            this._fpsCount = 0;
            this._totalMemMax = 0;
            this._totalMemSum = 0;
            this._totalMemCount = 0;
            this._usedMemDelta = 0;
            this._usedMemDeltaTime = _loc1_;
            if(_loc1_ - this._startTime < 60 * 1000)
            {
               this._statisticsTime += 5 * 1000;
            }
            else
            {
               this._statisticsTime += 30 * 1000;
            }
         }
      }
      
      private function doTrack(param1:String, param2:Object = null, param3:Boolean = false) : void
      {
         var _loc4_:Object = param2 || {};
         this.append(_loc4_,"event",param1);
         this.append(_loc4_,"time",new Date().getTime());
         this.append(_loc4_,"build",Version.BUILD);
         this.append(_loc4_,"map_id",ScreenManager.getInstance().map.mapID);
         this.append(_loc4_,"generator","as:" + VERSION);
         if(this.debug)
         {
            this.log("EventStreamClient: " + JASON.encode(_loc4_));
         }
         this._queue.push(_loc4_);
         if(param3)
         {
            this.flush();
         }
      }
      
      private function append(param1:Object, param2:String, param3:Object) : void
      {
         if(param2 in param1)
         {
            param1[param2] = param3 + " [" + param1[param2] + "]";
         }
         else
         {
            param1[param2] = param3;
         }
      }
      
      private function flush() : void
      {
         var request:ESCRequestVo = null;
         var url:String = null;
         try
         {
            if(this._loader != null)
            {
               return;
            }
            if(this._queue.length == 0)
            {
               return;
            }
            if(this._context == null)
            {
               if(this._queue.length > 1000)
               {
                  this._queue.length = 0;
               }
               return;
            }
            request = new ESCRequestVo(new Date().getTime(),this._context,this._queue);
            url = this.baseURL + "json.php";
            this._byteArray.clear();
            this._byteArray.writeUTFBytes(JASON.encode(request));
            this._byteArray.compress();
            this._urlRequest.method = URLRequestMethod.POST;
            this._urlRequest.contentType = this._contentType;
            this._urlRequest.data = this._byteArray;
            this._urlRequest.url = url;
            this._loader = new URLLoader();
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError,false,0,true);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError,false,0,true);
            this._loader.addEventListener(Event.COMPLETE,this.handleComplete,false,0,true);
            this.load();
            this._queue.length = 0;
         }
         catch(error:Error)
         {
            log("EventStreamClient.flushEvents: " + error);
         }
      }
      
      private function load() : void
      {
         if(Boolean(this._loader) && Boolean(this._urlRequest))
         {
            this._loader.load(this._urlRequest);
         }
      }
      
      private function handleComplete(param1:Event) : void
      {
         var response:Object = null;
         var event:Event = param1;
         try
         {
            response = JASON.decode(this._loader.data);
            if(!response.success)
            {
               this.log("EventStreamClient.flushEvents.NOSUCCESS: " + response.message);
            }
         }
         catch(error:Error)
         {
            log("EventStreamClient.flushEvents.COMPLETE: " + error);
         }
         this.removeListeners();
      }
      
      private function handleSecurityError(param1:SecurityErrorEvent) : void
      {
         this.removeListeners();
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         if(this._attempt == 0)
         {
            this.log("EventStreamClient.flushEvents.IO_ERROR: retrying");
            ++this._attempt;
            setTimeout(this.load,1000);
         }
         this.removeListeners();
      }
      
      private function removeListeners() : void
      {
         if(this._loader != null)
         {
            this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleSecurityError,false,0,true);
            this._loader.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError,false,0,true);
            this._loader.addEventListener(Event.COMPLETE,this.handleComplete,false,0,true);
            this._loader = null;
         }
      }
      
      private function log(param1:String) : void
      {
         if(this._logFunction != null)
         {
            this._logFunction(param1);
         }
      }
      
      private function setLogger(param1:Function) : void
      {
         this._logFunction = param1;
      }
      
      private function setClientContext(param1:String) : void
      {
         var rest:uint = 0;
         var i:int = 0;
         var contextStr:String = param1;
         try
         {
            contextStr = StringUtil.replace(contextStr,"-","+");
            contextStr = StringUtil.replace(contextStr,"_","/");
            rest = contextStr.length % 4;
            if(rest > 0)
            {
               i = 0;
               while(i < 4 - rest)
               {
                  contextStr += "=";
                  i++;
               }
            }
            contextStr = Base64.decode(contextStr);
            this._context = JASON.decode(contextStr);
         }
         catch(error:Error)
         {
            log("EventStreamClient.setClientContext: " + error);
         }
      }
      
      private function setStage(param1:Stage) : void
      {
         var caps:Object = null;
         var time:Number = NaN;
         var stageRef:Stage = param1;
         this._stage = stageRef;
         try
         {
            caps = {
               "vmVersion":System.vmVersion,
               "avHardwareDisable":Capabilities.avHardwareDisable,
               "cpuArchitecture":Capabilities["cpuArchitecture"],
               "hasAccessibility":Capabilities.hasAccessibility,
               "hasAudio":Capabilities.hasAudio,
               "hasAudioEncoder":Capabilities.hasAudioEncoder,
               "hasEmbeddedVideo":Capabilities.hasEmbeddedVideo,
               "hasIME":Capabilities.hasIME,
               "hasMP3":Capabilities.hasMP3,
               "hasPrinting":Capabilities.hasPrinting,
               "hasScreenBroadcast":Capabilities.hasScreenBroadcast,
               "hasScreenPlayback":Capabilities.hasScreenPlayback,
               "hasStreamingAudio":Capabilities.hasStreamingAudio,
               "hasStreamingVideo":Capabilities.hasStreamingVideo,
               "hasTLS":Capabilities.hasTLS,
               "hasVideoEncoder":Capabilities.hasVideoEncoder,
               "isDebugger":Capabilities.isDebugger,
               "isEmbeddedInAcrobat":Capabilities.isEmbeddedInAcrobat,
               "language":Capabilities.language,
               "localFileReadDisable":Capabilities.localFileReadDisable,
               "manufacturer":Capabilities.manufacturer,
               "maxLevelIDC":Capabilities.maxLevelIDC,
               "os":Capabilities.os,
               "pixelAspectRatio":Capabilities.pixelAspectRatio,
               "playerType":Capabilities.playerType,
               "screenColor":Capabilities.screenColor,
               "screenDPI":Capabilities.screenDPI,
               "screenResolutionX":Capabilities.screenResolutionX,
               "screenResolutionY":Capabilities.screenResolutionY,
               "supports32BitProcesses":Capabilities["supports32BitProcesses"],
               "supports64BitProcesses":Capabilities["supports64BitProcesses"],
               "touchscreenType":Capabilities["touchscreenType"],
               "version":Capabilities.version,
               "frameRate":this._stage.frameRate,
               "displayState":this._stage.displayState,
               "quality":this._stage.quality,
               "scaleMode":this._stage.scaleMode,
               "wmodeGPU":this._stage.wmodeGPU,
               "width":this._stage.width,
               "height":this._stage.height,
               "stageWidth":this._stage.stageWidth,
               "stageHeight":this._stage.stageHeight,
               "parameters":this._stage.loaderInfo.parameters,
               "hero":Hero.getHeroInfo()
            };
            this.doTrack("flash.capabilities",caps);
         }
         catch(error:Error)
         {
            log("EventStreamClient.setStage: systemInfo " + error);
         }
         try
         {
            time = getTimer();
            this._frameCounter = 0;
            this._frameTime = time;
            this._statisticsTime = time + 5 * 1000;
            this._usedMemDeltaTime = time;
            if(this._autoEnterFrame)
            {
               this._stage.addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
            }
         }
         catch(error:Error)
         {
            log("EventStreamClient.setStage: enterFrame " + error);
         }
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         this.enterFrame();
      }
   }
}

