package away3d.loaders.misc
{
   import away3d.arcane;
   import away3d.events.AssetEvent;
   import away3d.events.LoaderEvent;
   import away3d.events.ParserEvent;
   import away3d.loaders.parsers.ImageParser;
   import away3d.loaders.parsers.ParserBase;
   import away3d.loaders.parsers.ParserDataFormat;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.getDefinitionByName;
   
   use namespace arcane;
   
   public class SingleFileLoader extends EventDispatcher
   {
      
      private static var _parsers:Vector.<Class> = Vector.<Class>([ImageParser]);
      
      protected var _parser:ParserBase;
      
      protected var _req:URLRequest;
      
      protected var _loadAsRawData:Boolean;
      
      protected var _data:*;
      
      private var _fileExtension:String;
      
      private var _fileName:String;
      
      private var _materialMode:uint;
      
      public function SingleFileLoader(param1:uint = 0)
      {
         super();
         this._materialMode = param1;
      }
      
      public static function enableParser(param1:Class) : void
      {
         if(_parsers.indexOf(param1) < 0)
         {
            _parsers.push(param1);
         }
      }
      
      public static function enableParsers(param1:Vector.<Class>) : void
      {
         var _loc2_:Class = null;
         for each(_loc2_ in param1)
         {
            enableParser(_loc2_);
         }
      }
      
      public function get url() : String
      {
         return this._req ? this._req.url : "";
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function get loadAsRawData() : Boolean
      {
         return this._loadAsRawData;
      }
      
      public function load(param1:URLRequest, param2:ParserBase = null, param3:Boolean = false) : void
      {
         var _loc4_:URLLoader = null;
         var _loc5_:String = null;
         this._loadAsRawData = param3;
         this._req = param1;
         this.decomposeFilename(this._req.url);
         if(this._loadAsRawData)
         {
            _loc5_ = URLLoaderDataFormat.BINARY;
         }
         else
         {
            if(param2)
            {
               this._parser = param2;
            }
            if(!this._parser)
            {
               this._parser = this.getParserFromSuffix();
            }
            if(this._parser)
            {
               switch(this._parser.dataFormat)
               {
                  case ParserDataFormat.BINARY:
                     _loc5_ = URLLoaderDataFormat.BINARY;
                     break;
                  case ParserDataFormat.PLAIN_TEXT:
                     _loc5_ = URLLoaderDataFormat.TEXT;
               }
            }
            else
            {
               _loc5_ = URLLoaderDataFormat.BINARY;
            }
         }
         _loc4_ = new URLLoader();
         _loc4_.dataFormat = _loc5_;
         _loc4_.addEventListener(Event.COMPLETE,this.handleUrlLoaderComplete);
         _loc4_.addEventListener(IOErrorEvent.IO_ERROR,this.handleUrlLoaderError);
         _loc4_.load(param1);
      }
      
      public function parseData(param1:*, param2:ParserBase = null, param3:URLRequest = null) : void
      {
         if(param1 is Class)
         {
            param1 = new param1();
         }
         if(param2)
         {
            this._parser = param2;
         }
         this._req = param3;
         this._data = param1;
         this.parse(param1);
      }
      
      public function get parser() : ParserBase
      {
         return this._parser;
      }
      
      public function get dependencies() : Vector.<ResourceDependency>
      {
         return this._parser ? this._parser.dependencies : new Vector.<ResourceDependency>();
      }
      
      protected function decomposeFilename(param1:String) : void
      {
         var _loc2_:String = param1.indexOf("?") > 0 ? param1.split("?")[0] : param1;
         var _loc3_:int = _loc2_.lastIndexOf(".");
         this._fileExtension = _loc2_.substr(_loc3_ + 1).toLowerCase();
         this._fileName = _loc2_.substr(0,_loc3_);
      }
      
      protected function getParserFromSuffix() : ParserBase
      {
         var _loc1_:uint = _parsers.length;
         var _loc2_:* = int(_loc1_ - 1);
         while(_loc2_ >= 0)
         {
            if(_parsers[_loc2_].supportsType(this._fileExtension))
            {
               return new _parsers[_loc2_]();
            }
            _loc2_--;
         }
         return null;
      }
      
      private function getParserFromData(param1:*) : ParserBase
      {
         var _loc2_:uint = _parsers.length;
         var _loc3_:* = int(_loc2_ - 1);
         while(_loc3_ >= 0)
         {
            if(_parsers[_loc3_].supportsData(param1))
            {
               return new _parsers[_loc3_]();
            }
            _loc3_--;
         }
         return null;
      }
      
      private function removeListeners(param1:URLLoader) : void
      {
         param1.removeEventListener(Event.COMPLETE,this.handleUrlLoaderComplete);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.handleUrlLoaderError);
      }
      
      private function handleUrlLoaderError(param1:IOErrorEvent) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.currentTarget);
         this.removeListeners(_loc2_);
         if(hasEventListener(LoaderEvent.LOAD_ERROR))
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,this._req.url,true,param1.text));
         }
      }
      
      private function handleUrlLoaderComplete(param1:Event) : void
      {
         var _loc2_:URLLoader = URLLoader(param1.currentTarget);
         this.removeListeners(_loc2_);
         this._data = _loc2_.data;
         if(this._loadAsRawData)
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE));
         }
         else
         {
            this.parse(this._data);
         }
      }
      
      protected function parse(param1:*) : void
      {
         var _loc2_:String = null;
         if(!this._parser)
         {
            this._parser = this.getParserFromData(param1);
         }
         if(this._parser)
         {
            this._parser.addEventListener(ParserEvent.READY_FOR_DEPENDENCIES,this.onReadyForDependencies);
            this._parser.addEventListener(ParserEvent.PARSE_ERROR,this.onParseError);
            this._parser.addEventListener(ParserEvent.PARSE_COMPLETE,this.onParseComplete);
            this._parser.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR,this.onTextureSizeError);
            this._parser.addEventListener(AssetEvent.ASSET_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.TEXTURE_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.CONTAINER_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.GEOMETRY_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.MATERIAL_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.MESH_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.ENTITY_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.SKELETON_COMPLETE,this.onAssetComplete);
            this._parser.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE,this.onAssetComplete);
            if(Boolean(this._req) && Boolean(this._req.url))
            {
               this._parser._fileName = this._req.url;
            }
            this._parser.materialMode = this._materialMode;
            this._parser.parseAsync(param1);
         }
         else
         {
            _loc2_ = "No parser defined. To enable all parsers for auto-detection, use Parsers.enableAllBundled()";
            if(Boolean(this._req) && Boolean(this._req.url))
            {
               _loc2_ += ", url: " + this._req.url;
            }
            if(!hasEventListener(LoaderEvent.LOAD_ERROR))
            {
               throw new Error(_loc2_);
            }
            this.dispatchEvent(new LoaderEvent(LoaderEvent.LOAD_ERROR,"",true,_loc2_));
         }
      }
      
      private function onParseError(param1:ParserEvent) : void
      {
         if(hasEventListener(ParserEvent.PARSE_ERROR))
         {
            dispatchEvent(param1.clone());
         }
      }
      
      private function onReadyForDependencies(param1:ParserEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function onAssetComplete(param1:AssetEvent) : void
      {
         this.dispatchEvent(param1.clone());
      }
      
      private function onTextureSizeError(param1:AssetEvent) : void
      {
         this.dispatchEvent(param1.clone());
      }
      
      protected function onParseComplete(param1:ParserEvent) : void
      {
         this.dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE,this.url));
         this._parser.removeEventListener(ParserEvent.READY_FOR_DEPENDENCIES,this.onReadyForDependencies);
         this._parser.removeEventListener(ParserEvent.PARSE_COMPLETE,this.onParseComplete);
         this._parser.removeEventListener(ParserEvent.PARSE_ERROR,this.onParseError);
         this._parser.removeEventListener(AssetEvent.TEXTURE_SIZE_ERROR,this.onTextureSizeError);
         this._parser.removeEventListener(AssetEvent.ASSET_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.ANIMATION_SET_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.ANIMATION_STATE_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.ANIMATION_NODE_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.STATE_TRANSITION_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.TEXTURE_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.CONTAINER_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.GEOMETRY_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.MATERIAL_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.MESH_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.ENTITY_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.SKELETON_COMPLETE,this.onAssetComplete);
         this._parser.removeEventListener(AssetEvent.SKELETON_POSE_COMPLETE,this.onAssetComplete);
      }
   }
}

