package com.bigpoint.filecollection
{
   import com.adobe.crypto.MD5;
   import com.bigpoint.filecollection.event.FileCollectionEvent;
   import com.bigpoint.filecollection.event.FileCollectionFileLoadEvent;
   import com.bigpoint.filecollection.event.FileCollectionFinishEvent;
   import com.bigpoint.filecollection.finish.DefaultFinisher;
   import com.bigpoint.filecollection.finish.FileCollectionFinisher;
   import com.bigpoint.filecollection.finish.ImageFinisher;
   import com.bigpoint.filecollection.finish.JSONFinisher;
   import com.bigpoint.filecollection.finish.SWFFinisher;
   import com.bigpoint.filecollection.finish.StringFinisher;
   import com.bigpoint.filecollection.finish.XMLFinisher;
   import com.bigpoint.filecollection.vo.FileVO;
   import com.bigpoint.filecollection.vo.LocationVO;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   
   public class FileCollection extends EventDispatcher
   {
      
      private var xmlLoader:URLLoader;
      
      private var xml:XML;
      
      private var locationList:Object;
      
      private var fileList:Object;
      
      private var queueSize:int;
      
      private var finisherClassList:Object;
      
      private var finisherList:Object;
      
      private var _basePath:String;
      
      private var _numOfFiles:int;
      
      private var _numOfFilesLoaded:int;
      
      private var _filePrefix:String = "";
      
      private var _linearLoadList:Array = new Array();
      
      private var useHash:Boolean = false;
      
      private var _resourceFileHash:String;
      
      private var _useFilesExtensions:Boolean;
      
      public function FileCollection(param1:String = "", param2:Boolean = false, param3:Boolean = false)
      {
         super();
         this.useHash = param2;
         this._useFilesExtensions = param3;
         this._basePath = param1;
         this.locationList = new Object();
         this.fileList = new Object();
         this.finisherList = new Object();
         this.finisherClassList = new Object();
         this.queueSize = 0;
         this._numOfFilesLoaded = 0;
         this._numOfFiles = 0;
         this.addDefaultFinisherClasses();
      }
      
      public function addFinisherClass(param1:String, param2:Class) : void
      {
         this.finisherClassList[param1] = param2;
      }
      
      public function loadResourceFile(param1:String) : void
      {
         this.xmlLoader = new URLLoader();
         this.xmlLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.xmlLoader.addEventListener(Event.COMPLETE,this.handleXMLLoad);
         this.xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleXMLSecurityError);
         this.xmlLoader.dataFormat = URLLoaderDataFormat.BINARY;
         var _loc2_:String = this._basePath + param1;
         this.xmlLoader.load(new URLRequest(_loc2_));
      }
      
      public function load(param1:String, param2:Function = null, param3:Function = null) : void
      {
         if(param1 == null)
         {
            if(param3 != null)
            {
               param3(param1);
            }
            return;
         }
         var _loc4_:FileVO = this.fileList[param1];
         if(_loc4_ == null)
         {
            if(param3 != null)
            {
               param3(param1);
            }
            return;
         }
         var _loc5_:FileCollectionFinisher = this.finisherList[param1];
         if(_loc5_ == null)
         {
            _loc5_ = new (this.finisherClassList[_loc4_.type] || DefaultFinisher)();
            this.finisherList[param1] = _loc5_;
            _loc5_.addEventListener(FileCollectionEvent.RESOURCE_CLEARED,this.handleResourceCleared);
            _loc5_.addEventListener(FileCollectionFinishEvent.FILE_FINISH,this.handleFileFinish);
            _loc5_.load(_loc4_,this._basePath,this.useHash);
            ++this.queueSize;
         }
         _loc5_.addCompleteCallback(param2);
         _loc5_.addErrorCallback(param3);
      }
      
      public function removeCallbacks(param1:String, param2:Function) : void
      {
         var _loc3_:FileCollectionFinisher = this.finisherList[param1];
         if(_loc3_)
         {
            _loc3_.removeCompleteCallback(param2);
            _loc3_.removeErrorCallback(param2);
         }
      }
      
      public function fileExists(param1:String) : Boolean
      {
         return this.fileList.hasOwnProperty(param1);
      }
      
      private function addDefaultFinisherClasses() : void
      {
         this.addFinisherClass("swf",SWFFinisher);
         this.addFinisherClass("xml",XMLFinisher);
         this.addFinisherClass("png",ImageFinisher);
         this.addFinisherClass("jpg",ImageFinisher);
         this.addFinisherClass("js",JSONFinisher);
         this.addFinisherClass("txt",StringFinisher);
      }
      
      private function extractLocationsFromXML() : void
      {
         var _loc1_:XML = null;
         for each(_loc1_ in this.xml.location)
         {
            this.locationList[_loc1_.@id] = new LocationVO(_loc1_.@id,this._filePrefix + _loc1_.@path);
         }
      }
      
      private function extractFilesFromXML() : void
      {
         var _loc1_:FileVO = null;
         var _loc2_:XML = null;
         var _loc3_:String = null;
         for each(_loc2_ in this.xml.file)
         {
            ++this._numOfFiles;
            _loc3_ = _loc2_.@id;
            if(this._useFilesExtensions)
            {
               _loc3_ += "." + _loc2_.@type;
            }
            _loc1_ = new FileVO(_loc3_,this.locationList[_loc2_.@location],_loc2_.@name,_loc2_.@type,_loc2_.@version,_loc2_);
            _loc1_.cdnHash = _loc2_.@hash;
            this.fileList[_loc3_] = _loc1_;
         }
      }
      
      private function handleXMLLoad(param1:Event) : void
      {
         var xmlParsedEvent:FileCollectionEvent = null;
         var contents:String = null;
         var event:Event = param1;
         try
         {
            xmlParsedEvent = new FileCollectionEvent(FileCollectionEvent.RESOURCE_XML_PARSED);
            contents = event.target.data;
            this._resourceFileHash = MD5.hash(contents);
            this.xml = new XML(contents);
            xmlParsedEvent.xml = this.xml;
            this.extractLocationsFromXML();
            this.extractFilesFromXML();
            dispatchEvent(xmlParsedEvent);
            this.xml = undefined;
         }
         catch(e:TypeError)
         {
            dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_FORMAT_ERROR));
            return;
         }
         this.xmlLoader.close();
         this.xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleIOError);
         this.xmlLoader.removeEventListener(Event.COMPLETE,this.handleXMLLoad);
         this.xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleXMLSecurityError);
         this.xmlLoader = null;
         dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_LOADED));
      }
      
      private function handleIOError(param1:IOErrorEvent) : void
      {
         dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_NOT_FOUND));
         throw new Error("resource file not found: " + param1.toString());
      }
      
      private function handleXMLSecurityError(param1:SecurityErrorEvent) : void
      {
         dispatchEvent(new FileCollectionEvent(FileCollectionEvent.RESOURCE_FILE_SECURITY_BREACH));
         throw new Error("resource file security breach! " + param1.toString());
      }
      
      private function handleFileFinish(param1:FileCollectionFinishEvent) : void
      {
         ++this._numOfFilesLoaded;
         dispatchEvent(new FileCollectionFileLoadEvent(FileCollectionFileLoadEvent.FILE_LOADED,param1.finisher.fileVO));
         if(--this.queueSize <= 0)
         {
            if(this._linearLoadList.length == 0)
            {
               dispatchEvent(new FileCollectionEvent(FileCollectionEvent.ALL_FILES_LOADED));
            }
         }
      }
      
      private function handleResourceCleared(param1:FileCollectionEvent) : void
      {
         var _loc2_:FileCollectionFinisher = param1.currentTarget as FileCollectionFinisher;
         _loc2_.removeEventListener(FileCollectionEvent.RESOURCE_CLEARED,this.handleResourceCleared);
         _loc2_.removeEventListener(FileCollectionFinishEvent.FILE_FINISH,this.handleFileFinish);
         this.finisherList[param1.text] = null;
         delete this.finisherList[param1.text];
      }
      
      public function isLoaded(param1:String) : Boolean
      {
         return Boolean(this.finisherList[param1]) && FileCollectionFinisher(this.finisherList[param1]).isFinished;
      }
      
      public function getFinisher(param1:String) : FileCollectionFinisher
      {
         return this.finisherList[param1];
      }
      
      public function get numOfFiles() : int
      {
         return this._numOfFiles;
      }
      
      public function get numOfFilesLoaded() : int
      {
         return this._numOfFilesLoaded;
      }
      
      public function get listOfFiles() : Object
      {
         return this.fileList;
      }
      
      public function cleanUpAllFinishers() : void
      {
         var _loc1_:FileCollectionFinisher = null;
         for each(_loc1_ in this.finisherList)
         {
            _loc1_.dispose();
            _loc1_.removeEventListener(FileCollectionEvent.RESOURCE_CLEARED,this.handleResourceCleared);
            _loc1_.removeEventListener(FileCollectionFinishEvent.FILE_FINISH,this.handleFileFinish);
         }
         this.finisherList = new Object();
      }
      
      public function get resourceFileHash() : String
      {
         return this._resourceFileHash;
      }
      
      public function addFile(param1:String, param2:String, param3:String = "", param4:String = "item") : void
      {
         var _loc5_:Array = param1.split("_");
         var _loc6_:String = _loc5_.pop();
         var _loc7_:String = _loc5_.pop();
         var _loc8_:String = _loc5_.join("_");
         var _loc9_:String = _loc5_.join("/") + "/";
         this.locationList[_loc8_] = new LocationVO(_loc8_,this._filePrefix + _loc9_);
         var _loc10_:String = _loc7_ + "_" + _loc6_;
         this.fileList[_loc10_] = new FileVO(_loc10_,this.locationList[_loc8_],_loc10_,param2,null,new XML());
         this.fileList[_loc10_].hash = param3;
      }
      
      public function getFileVO(param1:String) : FileVO
      {
         return this.listOfFiles[param1];
      }
      
      public function get basePath() : String
      {
         return this._basePath;
      }
   }
}

