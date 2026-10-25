package away3d.loaders
{
   import away3d.*;
   import away3d.events.*;
   import away3d.loaders.misc.*;
   import away3d.loaders.parsers.*;
   import flash.events.*;
   import flash.net.*;
   
   use namespace arcane;
   
   public class AssetLoader extends EventDispatcher
   {
      
      private var _context:AssetLoaderContext;
      
      private var _token:AssetLoaderToken;
      
      private var _uri:String;
      
      private var _errorHandlers:Vector.<Function>;
      
      private var _parseErrorHandlers:Vector.<Function>;
      
      private var _stack:Vector.<ResourceDependency>;
      
      private var _baseDependency:ResourceDependency;
      
      private var _loadingDependency:ResourceDependency;
      
      private var _namespace:String;
      
      public function AssetLoader()
      {
         super();
         this._stack = new Vector.<ResourceDependency>();
         this._errorHandlers = new Vector.<Function>();
         this._parseErrorHandlers = new Vector.<Function>();
      }
      
      public static function enableParser(param1:Class) : void
      {
         SingleFileLoader.enableParser(param1);
      }
      
      public static function enableParsers(param1:Vector.<Class>) : void
      {
         SingleFileLoader.enableParsers(param1);
      }
      
      public function get baseDependency() : ResourceDependency
      {
         return this._baseDependency;
      }
      
      public function load(param1:URLRequest, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         if(!this._token)
         {
            this._token = new AssetLoaderToken(this);
            this._uri = param1.url = param1.url.replace(/\\/g,"/");
            this._context = param2;
            this._namespace = param3;
            this._baseDependency = new ResourceDependency("",param1,null,null);
            this.retrieveDependency(this._baseDependency,param4);
            return this._token;
         }
         return null;
      }
      
      public function loadData(param1:*, param2:String, param3:AssetLoaderContext = null, param4:String = null, param5:ParserBase = null) : AssetLoaderToken
      {
         if(!this._token)
         {
            this._token = new AssetLoaderToken(this);
            this._uri = param2;
            this._context = param3;
            this._namespace = param4;
            this._baseDependency = new ResourceDependency(param2,null,param1,null);
            this.retrieveDependency(this._baseDependency,param5);
            return this._token;
         }
         return null;
      }
      
      private function retrieveNext(param1:ParserBase = null) : void
      {
         var _loc2_:ResourceDependency = null;
         var _loc3_:ResourceDependency = null;
         if(this._loadingDependency.dependencies.length)
         {
            _loc2_ = this._loadingDependency.dependencies.pop();
            this._stack.push(this._loadingDependency);
            this.retrieveDependency(_loc2_);
         }
         else if(Boolean(this._loadingDependency.loader.parser) && this._loadingDependency.loader.parser.parsingPaused)
         {
            this._loadingDependency.loader.parser.resumeParsingAfterDependencies();
            this._stack.pop();
         }
         else if(this._stack.length)
         {
            _loc3_ = this._loadingDependency;
            this._loadingDependency = this._stack.pop();
            if(_loc3_.success)
            {
               _loc3_.resolve();
            }
            this.retrieveNext(param1);
         }
         else
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.RESOURCE_COMPLETE,this._uri));
         }
      }
      
      private function retrieveDependency(param1:ResourceDependency, param2:ParserBase = null) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:uint = 0;
         if(Boolean(this._context) && this._context.materialMode != 0)
         {
            _loc4_ = this._context.materialMode;
         }
         this._loadingDependency = param1;
         this._loadingDependency.loader = this._context ? this._context.createFileLoader(_loc4_) : new SingleFileLoader(_loc4_);
         this.addEventListeners(this._loadingDependency.loader);
         _loc3_ = this._loadingDependency.data;
         if(Boolean(this._context) && Boolean(this._loadingDependency.request) && this._context.hasDataForUrl(this._loadingDependency.request.url))
         {
            _loc3_ = this._context.getDataForUrl(this._loadingDependency.request.url);
         }
         if(_loc3_)
         {
            if(this._loadingDependency.retrieveAsRawData)
            {
               dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE,this._loadingDependency.request.url,true));
               this._loadingDependency.setData(_loc3_);
               this._loadingDependency.resolve();
               this.retrieveNext();
            }
            else
            {
               this._loadingDependency.loader.parseData(_loc3_,param2,this._loadingDependency.request);
            }
         }
         else
         {
            param1.request.url = this.resolveDependencyUrl(param1);
            this._loadingDependency.loader.load(param1.request,param2,this._loadingDependency.retrieveAsRawData);
         }
      }
      
      private function joinUrl(param1:String, param2:String) : String
      {
         if(param2.charAt(0) == "/")
         {
            param2 = param2.substr(1);
         }
         if(param1.length == 0)
         {
            return param2;
         }
         if(param1.charAt(param1.length - 1) == "/")
         {
            param1 = param1.substr(0,param1.length - 1);
         }
         return param1.concat("/",param2);
      }
      
      private function resolveDependencyUrl(param1:ResourceDependency) : String
      {
         var _loc2_:RegExp = null;
         var _loc3_:String = null;
         var _loc5_:String = null;
         var _loc4_:String = param1.request.url;
         if(Boolean(this._context) && this._context.hasMappingForUrl(_loc4_))
         {
            return this._context.getRemappedUrl(_loc4_);
         }
         if(_loc4_ == this._uri)
         {
            return _loc4_;
         }
         _loc2_ = new RegExp(/^[a-zA-Z]{3,4}:\/\//);
         if(_loc4_.charAt(0) == "/")
         {
            if(Boolean(this._context) && this._context.overrideAbsolutePaths)
            {
               return this.joinUrl(this._context.dependencyBaseUrl,_loc4_);
            }
            return _loc4_;
         }
         if(_loc2_.test(_loc4_))
         {
            if(Boolean(this._context) && this._context.overrideFullURLs)
            {
               _loc5_ = _loc4_.replace(_loc2_);
               return this.joinUrl(this._context.dependencyBaseUrl,_loc5_);
            }
         }
         if(Boolean(this._context) && Boolean(this._context.dependencyBaseUrl))
         {
            _loc3_ = this._context.dependencyBaseUrl;
            return this.joinUrl(_loc3_,_loc4_);
         }
         _loc3_ = this._uri.substring(0,this._uri.lastIndexOf("/") + 1);
         return this.joinUrl(_loc3_,_loc4_);
      }
      
      private function retrieveLoaderDependencies(param1:SingleFileLoader) : void
      {
         var _loc2_:int = 0;
         if(!this._loadingDependency)
         {
            return;
         }
         var _loc3_:int = int(param1.dependencies.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this._loadingDependency.dependencies[_loc2_] = param1.dependencies[_loc2_];
            _loc2_++;
         }
         param1.dependencies.length = 0;
         this._stack.push(this._loadingDependency);
         this.retrieveNext();
      }
      
      private function onRetrievalFailed(param1:LoaderEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Function = null;
         var _loc3_:Boolean = this._loadingDependency != this._baseDependency;
         var _loc4_:SingleFileLoader = SingleFileLoader(param1.target);
         this.removeEventListeners(_loc4_);
         param1 = new LoaderEvent(LoaderEvent.LOAD_ERROR,this._uri,_loc3_,param1.message);
         if(hasEventListener(LoaderEvent.LOAD_ERROR))
         {
            dispatchEvent(param1);
            _loc2_ = true;
         }
         else
         {
            _loc6_ = this._errorHandlers.length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = this._errorHandlers[_loc5_];
               _loc2_ ||= Boolean(_loc7_(param1));
               _loc5_++;
            }
         }
         if(_loc2_)
         {
            if(_loc3_ && !param1.isDefaultPrevented())
            {
               this._loadingDependency.resolveFailure();
               this.retrieveNext();
               return;
            }
            this.dispose();
            return;
         }
         throw new Error(param1.message);
      }
      
      private function onParserError(param1:ParserEvent) : void
      {
         var _loc2_:Boolean = false;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Function = null;
         var _loc3_:Boolean = this._loadingDependency != this._baseDependency;
         var _loc4_:SingleFileLoader = SingleFileLoader(param1.target);
         this.removeEventListeners(_loc4_);
         param1 = new ParserEvent(ParserEvent.PARSE_ERROR,param1.message);
         if(hasEventListener(ParserEvent.PARSE_ERROR))
         {
            dispatchEvent(param1);
            _loc2_ = true;
         }
         else
         {
            _loc6_ = this._parseErrorHandlers.length;
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc7_ = this._parseErrorHandlers[_loc5_];
               _loc2_ ||= Boolean(_loc7_(param1));
               _loc5_++;
            }
         }
         if(_loc2_)
         {
            this.dispose();
            return;
         }
         throw new Error(param1.message);
      }
      
      private function onAssetComplete(param1:AssetEvent) : void
      {
         if(param1.type == AssetEvent.ASSET_COMPLETE)
         {
            if(this._loadingDependency)
            {
               this._loadingDependency.assets.push(param1.asset);
            }
            param1.asset.resetAssetPath(param1.asset.name,this._namespace);
         }
         if(!this._loadingDependency.suppresAssetEvents)
         {
            dispatchEvent(param1.clone());
         }
      }
      
      private function onReadyForDependencies(param1:ParserEvent) : void
      {
         var _loc2_:SingleFileLoader = SingleFileLoader(param1.currentTarget);
         if(Boolean(this._context) && !this._context.includeDependencies)
         {
            _loc2_.parser.resumeParsingAfterDependencies();
         }
         else
         {
            this.retrieveLoaderDependencies(_loc2_);
         }
      }
      
      private function onRetrievalComplete(param1:LoaderEvent) : void
      {
         var _loc2_:SingleFileLoader = SingleFileLoader(param1.target);
         this._loadingDependency.setData(_loc2_.data);
         this._loadingDependency.success = true;
         dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE,param1.url));
         this.removeEventListeners(_loc2_);
         if(Boolean(_loc2_.dependencies.length) && (!this._context || this._context.includeDependencies))
         {
            this.retrieveLoaderDependencies(_loc2_);
         }
         else
         {
            this.retrieveNext();
         }
      }
      
      private function onTextureSizeError(param1:AssetEvent) : void
      {
         param1.asset.name = this._loadingDependency.resolveName(param1.asset);
         dispatchEvent(param1);
      }
      
      private function addEventListeners(param1:SingleFileLoader) : void
      {
         param1.addEventListener(LoaderEvent.DEPENDENCY_COMPLETE,this.onRetrievalComplete);
         param1.addEventListener(LoaderEvent.LOAD_ERROR,this.onRetrievalFailed);
         param1.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR,this.onTextureSizeError);
         param1.addEventListener(AssetEvent.ASSET_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.TEXTURE_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.CONTAINER_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.GEOMETRY_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.MATERIAL_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.MESH_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.ENTITY_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.SKELETON_COMPLETE,this.onAssetComplete);
         param1.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE,this.onAssetComplete);
         param1.addEventListener(ParserEvent.READY_FOR_DEPENDENCIES,this.onReadyForDependencies);
         param1.addEventListener(ParserEvent.PARSE_ERROR,this.onParserError);
      }
      
      private function removeEventListeners(param1:SingleFileLoader) : void
      {
         param1.removeEventListener(ParserEvent.READY_FOR_DEPENDENCIES,this.onReadyForDependencies);
         param1.removeEventListener(LoaderEvent.DEPENDENCY_COMPLETE,this.onRetrievalComplete);
         param1.removeEventListener(LoaderEvent.LOAD_ERROR,this.onRetrievalFailed);
         param1.removeEventListener(AssetEvent.TEXTURE_SIZE_ERROR,this.onTextureSizeError);
         param1.removeEventListener(AssetEvent.ASSET_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.ANIMATION_SET_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.ANIMATION_STATE_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.ANIMATION_NODE_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.STATE_TRANSITION_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.TEXTURE_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.CONTAINER_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.GEOMETRY_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.MATERIAL_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.MESH_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.ENTITY_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.SKELETON_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(AssetEvent.SKELETON_POSE_COMPLETE,this.onAssetComplete);
         param1.removeEventListener(ParserEvent.PARSE_ERROR,this.onParserError);
      }
      
      public function stop() : void
      {
         this.dispose();
      }
      
      private function dispose() : void
      {
         this._errorHandlers = null;
         this._parseErrorHandlers = null;
         this._context = null;
         this._token = null;
         this._stack = null;
         if(Boolean(this._loadingDependency) && Boolean(this._loadingDependency.loader))
         {
            this.removeEventListeners(this._loadingDependency.loader);
         }
         this._loadingDependency = null;
      }
      
      arcane function addParseErrorHandler(param1:Function) : void
      {
         if(this._parseErrorHandlers.indexOf(param1) < 0)
         {
            this._parseErrorHandlers.push(param1);
         }
      }
      
      arcane function addErrorHandler(param1:Function) : void
      {
         if(this._errorHandlers.indexOf(param1) < 0)
         {
            this._errorHandlers.push(param1);
         }
      }
   }
}

