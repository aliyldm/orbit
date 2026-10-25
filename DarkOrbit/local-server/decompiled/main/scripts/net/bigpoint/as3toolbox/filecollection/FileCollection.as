package net.bigpoint.as3toolbox.filecollection
{
   import com.adobe.crypto.MD5;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionEvent;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionFileLoadEvent;
   import net.bigpoint.as3toolbox.filecollection.event.FileCollectionFinishEvent;
   import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.FileCollectionFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.JSONFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.StringFinisher;
   import net.bigpoint.as3toolbox.filecollection.finish.XMLFinisher;
   import net.bigpoint.as3toolbox.filecollection.vo.FileVO;
   import net.bigpoint.as3toolbox.filecollection.vo.LocationVO;
   
   public class FileCollection extends EventDispatcher
   {
      
      private static const logging:Boolean = false;
      
      private var xmlLoader:URLLoader;
      
      private var xml:XML;
      
      private var locationList:Object;
      
      private var fileList:Object;
      
      private var queueSize:int;
      
      private var finisherClassList:Object;
      
      private var finisherList:Object;
      
      private var m_sBasePath:String;
      
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
         this.m_sBasePath = param1;
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
         this.xmlLoader.load(new URLRequest(this.m_sBasePath + param1));
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
            _loc5_.load(_loc4_,this.m_sBasePath,this.useHash);
            ++this.queueSize;
         }
         _loc5_.addCompleteCallback(param2);
         _loc5_.addErrorCallback(param3);
      }
      
      public function clearResource(param1:String) : void
      {
         this.finisherList[param1] = null;
         delete this.finisherList[param1];
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
            if(logging)
            {
            }
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
            if(logging)
            {
            }
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
      
      public function loadAll(param1:String = "", param2:Function = null) : void
      {
         var totalCount:int = 0;
         var filesLoaded:int = 0;
         var key:* = undefined;
         var vo:FileVO = null;
         var fileExtension:String = param1;
         var onFileLoaded:Function = param2;
         totalCount = 0;
         filesLoaded = 0;
         for(key in this.fileList)
         {
            if(fileExtension)
            {
               vo = this.fileList[key];
               if(vo.type != fileExtension)
               {
                  continue;
               }
            }
            totalCount++;
            this.load(key,function checkLoadComplete(param1:FileCollectionFinisher):void
            {
               ++filesLoaded;
               if(onFileLoaded != null)
               {
                  onFileLoaded(param1);
               }
               if(totalCount == filesLoaded)
               {
                  dispatchEvent(new FileCollectionEvent(FileCollectionEvent.LOAD_ALL_COMPLETED));
               }
            });
         }
      }
   }
}

