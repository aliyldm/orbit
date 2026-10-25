package com.bigpoint.filecollection.finish
{
   import com.adobe.crypto.MD5;
   import com.bigpoint.filecollection.event.FileCollectionEvent;
   import com.bigpoint.filecollection.event.FileCollectionFinishEvent;
   import com.bigpoint.filecollection.vo.FileVO;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class FileCollectionFinisher extends EventDispatcher
   {
      
      public static const maxTries:int = 5;
      
      private static const FILES_TO_CHECK:Array = ["replacementCollectables","box0","box1","box2","ore_palladium","oreBlue","oreRed","oreYellow"];
      
      private static const _reported:Object = {};
      
      protected var _data:*;
      
      private var _callbackComplete:Vector.<Function> = new Vector.<Function>();
      
      private var _callbackError:Vector.<Function> = new Vector.<Function>();
      
      private var _executingCallbacks:Boolean = false;
      
      private var _disposeAfterCallbacks:Boolean = false;
      
      private var fileLoader:URLLoader;
      
      private var _url:String;
      
      private var _reloadTimeout:uint;
      
      private var _fileVO:FileVO;
      
      private var _isFinished:Boolean = false;
      
      public function FileCollectionFinisher()
      {
         super();
      }
      
      public static function getFileHash(param1:ByteArray) : String
      {
         var _loc2_:String = MD5.hashBytes(param1 as ByteArray);
         return _loc2_.substr(0,_loc2_.length - 2) + "00";
      }
      
      public function get fileVO() : FileVO
      {
         return this._fileVO;
      }
      
      public function get isFinished() : Boolean
      {
         return this._isFinished;
      }
      
      public function dispose() : void
      {
         var _loc1_:FileCollectionEvent = null;
         clearTimeout(this._reloadTimeout);
         this.disposeFileLoader();
         if(this._executingCallbacks)
         {
            this._disposeAfterCallbacks = true;
         }
         else
         {
            this._disposeAfterCallbacks = false;
            this._data = null;
            this.disposeFinisher();
            _loc1_ = new FileCollectionEvent(FileCollectionEvent.RESOURCE_CLEARED);
            _loc1_.text = this.fileVO.id;
            dispatchEvent(_loc1_);
         }
      }
      
      public function addCompleteCallback(param1:Function) : void
      {
         if(param1 != null)
         {
            this._callbackComplete.push(param1);
            if(this.isFinished)
            {
               this._executingCallbacks = true;
               setTimeout(this.executeCompleteCallbacks,1);
            }
         }
      }
      
      public function removeCompleteCallback(param1:Function) : void
      {
         var _loc2_:int = this._callbackComplete.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._callbackComplete.splice(_loc2_,1);
         }
      }
      
      public function addErrorCallback(param1:Function) : void
      {
         if(param1 != null)
         {
            this._callbackError.push(param1);
         }
      }
      
      public function removeErrorCallback(param1:Function) : void
      {
         var _loc2_:int = this._callbackError.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this._callbackError.splice(_loc2_,1);
         }
      }
      
      public function load(param1:FileVO, param2:String, param3:Boolean) : void
      {
         this._fileVO = param1;
         this._url = param2 + this._fileVO.getFileName(param3);
         this.fileLoader = new URLLoader();
         this.fileLoader.dataFormat = URLLoaderDataFormat.BINARY;
         this.fileLoader.addEventListener(Event.COMPLETE,this.handleFileLoad);
         this.fileLoader.addEventListener(IOErrorEvent.IO_ERROR,this.handleFileLoadError);
         this.fileLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
         this.internalLoad();
      }
      
      protected function start() : void
      {
         this.finish();
      }
      
      final protected function finish() : void
      {
         this._isFinished = true;
         dispatchEvent(new FileCollectionFinishEvent(FileCollectionFinishEvent.FILE_FINISH,this));
         this.executeCompleteCallbacks();
      }
      
      protected function disposeFinisher() : void
      {
      }
      
      private function executeCompleteCallbacks() : void
      {
         this._executingCallbacks = true;
         this._callbackError.length = 0;
         while(this._callbackComplete.length > 0)
         {
            this._callbackComplete.pop()(this);
         }
         this._executingCallbacks = false;
         if(this._disposeAfterCallbacks)
         {
            this.dispose();
         }
      }
      
      private function executeErrorCallbacks() : void
      {
         this._executingCallbacks = true;
         this._callbackComplete.length = 0;
         while(this._callbackError.length > 0)
         {
            this._callbackError.pop()(this._fileVO.id);
         }
         this._executingCallbacks = false;
         if(this._disposeAfterCallbacks)
         {
            this.dispose();
         }
      }
      
      private function internalLoad() : void
      {
         ++this._fileVO.numTries;
         this.fileLoader.load(new URLRequest(this._url));
      }
      
      private function disposeFileLoader() : void
      {
         if(this.fileLoader)
         {
            this.fileLoader.removeEventListener(Event.COMPLETE,this.handleFileLoad);
            this.fileLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.handleFileLoadError);
            this.fileLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityErrorHandler);
            this.fileLoader.close();
            this.fileLoader = null;
         }
      }
      
      private function handleFileLoad(param1:Event) : void
      {
         this.fileVO.size = this.fileLoader.bytesTotal;
         this._data = this.fileLoader.data;
         this.check();
         this.disposeFileLoader();
         this.start();
      }
      
      private function handleFileLoadError(param1:IOErrorEvent) : void
      {
         if(maxTries > 0 && this._fileVO.numTries >= maxTries)
         {
            this.disposeFileLoader();
            this.executeErrorCallbacks();
         }
         else
         {
            this._reloadTimeout = setTimeout(this.internalLoad,5000);
         }
      }
      
      private function securityErrorHandler(param1:SecurityErrorEvent) : void
      {
         this.disposeFileLoader();
         this.executeErrorCallbacks();
      }
      
      private function check() : void
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         if(this.fileLoader.data is ByteArray && FILES_TO_CHECK.indexOf(this.fileVO.id) >= 0)
         {
            _loc1_ = getFileHash(this.fileLoader.data);
            if(this._fileVO.cdnHash != _loc1_ && !_reported[this._fileVO.id])
            {
               _reported[this._fileVO.id] = true;
               _loc2_ = {
                  "id":this._fileVO.id,
                  "fn":this._fileVO.name,
                  "fs":this._fileVO.size,
                  "he":this._fileVO.cdnHash,
                  "h":_loc1_
               };
            }
         }
      }
   }
}

