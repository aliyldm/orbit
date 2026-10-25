package away3d.library
{
   import away3d.arcane;
   import away3d.events.AssetEvent;
   import away3d.events.LoaderEvent;
   import away3d.events.ParserEvent;
   import away3d.library.assets.IAsset;
   import away3d.library.assets.NamedAssetBase;
   import away3d.library.naming.ConflictPrecedence;
   import away3d.library.naming.ConflictStrategy;
   import away3d.library.naming.ConflictStrategyBase;
   import away3d.library.utils.AssetLibraryIterator;
   import away3d.library.utils.IDUtil;
   import away3d.loaders.AssetLoader;
   import away3d.loaders.misc.AssetLoaderContext;
   import away3d.loaders.misc.AssetLoaderToken;
   import away3d.loaders.misc.SingleFileLoader;
   import away3d.loaders.parsers.ParserBase;
   import flash.events.EventDispatcher;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class AssetLibraryBundle extends EventDispatcher
   {
      
      private var _loadingSessions:Vector.<AssetLoader>;
      
      private var _strategy:ConflictStrategyBase;
      
      private var _strategyPreference:String;
      
      private var _assets:Vector.<IAsset>;
      
      private var _assetDictionary:Object;
      
      private var _assetDictDirty:Boolean;
      
      public function AssetLibraryBundle(param1:AssetLibraryBundleSingletonEnforcer)
      {
         super();
         param1 = param1;
         this._assets = new Vector.<IAsset>();
         this._assetDictionary = {};
         this._loadingSessions = new Vector.<AssetLoader>();
         this.conflictStrategy = ConflictStrategy.IGNORE.create();
         this.conflictPrecedence = ConflictPrecedence.FAVOR_NEW;
      }
      
      public static function getInstance(param1:String = "default") : AssetLibraryBundle
      {
         if(!param1)
         {
            param1 = "default";
         }
         if(!AssetLibrary._instances.hasOwnProperty(param1))
         {
            AssetLibrary._instances[param1] = new AssetLibraryBundle(new AssetLibraryBundleSingletonEnforcer());
         }
         return AssetLibrary._instances[param1];
      }
      
      public function enableParser(param1:Class) : void
      {
         SingleFileLoader.enableParser(param1);
      }
      
      public function enableParsers(param1:Vector.<Class>) : void
      {
         SingleFileLoader.enableParsers(param1);
      }
      
      public function get conflictStrategy() : ConflictStrategyBase
      {
         return this._strategy;
      }
      
      public function set conflictStrategy(param1:ConflictStrategyBase) : void
      {
         if(!param1)
         {
            throw new Error("namingStrategy must not be null. To ignore naming, use AssetLibrary.IGNORE");
         }
         this._strategy = param1.create();
      }
      
      public function get conflictPrecedence() : String
      {
         return this._strategyPreference;
      }
      
      public function set conflictPrecedence(param1:String) : void
      {
         this._strategyPreference = param1;
      }
      
      public function createIterator(param1:String = null, param2:String = null, param3:Function = null) : AssetLibraryIterator
      {
         return new AssetLibraryIterator(this._assets,param1,param2,param3);
      }
      
      public function load(param1:URLRequest, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         return this.loadResource(param1,param2,param3,param4);
      }
      
      public function loadData(param1:*, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         return this.parseResource(param1,param2,param3,param4);
      }
      
      public function getAsset(param1:String, param2:String = null) : IAsset
      {
         if(this._assetDictDirty)
         {
            this.rehashAssetDict();
         }
         param2 ||= NamedAssetBase.DEFAULT_NAMESPACE;
         if(!this._assetDictionary.hasOwnProperty(param2))
         {
            return null;
         }
         return this._assetDictionary[param2][param1];
      }
      
      public function addAsset(param1:IAsset) : void
      {
         var _loc2_:String = null;
         var _loc3_:IAsset = null;
         if(this._assets.indexOf(param1) >= 0)
         {
            return;
         }
         _loc3_ = this.getAsset(param1.name,param1.assetNamespace);
         _loc2_ = param1.assetNamespace || NamedAssetBase.DEFAULT_NAMESPACE;
         if(_loc3_ != null)
         {
            this._strategy.resolveConflict(param1,_loc3_,this._assetDictionary[_loc2_],this._strategyPreference);
         }
         param1.id = IDUtil.createUID();
         this._assets.push(param1);
         if(!this._assetDictionary.hasOwnProperty(_loc2_))
         {
            this._assetDictionary[_loc2_] = {};
         }
         this._assetDictionary[_loc2_][param1.name] = param1;
         param1.addEventListener(AssetEvent.ASSET_RENAME,this.onAssetRename);
         param1.addEventListener(AssetEvent.ASSET_CONFLICT_RESOLVED,this.onAssetConflictResolved);
      }
      
      public function removeAsset(param1:IAsset, param2:Boolean = true) : void
      {
         var _loc3_:int = 0;
         this.removeAssetFromDict(param1);
         param1.removeEventListener(AssetEvent.ASSET_RENAME,this.onAssetRename);
         param1.removeEventListener(AssetEvent.ASSET_CONFLICT_RESOLVED,this.onAssetConflictResolved);
         _loc3_ = this._assets.indexOf(param1);
         if(_loc3_ >= 0)
         {
            this._assets.splice(_loc3_,1);
         }
         if(param2)
         {
            param1.dispose();
         }
      }
      
      public function removeAssetByName(param1:String, param2:String = null, param3:Boolean = true) : IAsset
      {
         var _loc4_:IAsset = this.getAsset(param1,param2);
         if(_loc4_)
         {
            this.removeAsset(_loc4_,param3);
         }
         return _loc4_;
      }
      
      public function removeAllAssets(param1:Boolean = true) : void
      {
         var _loc2_:IAsset = null;
         if(param1)
         {
            for each(_loc2_ in this._assets)
            {
               _loc2_.dispose();
            }
         }
         this._assets.length = 0;
         this.rehashAssetDict();
      }
      
      public function removeNamespaceAssets(param1:String = null, param2:Boolean = true) : void
      {
         var _loc4_:IAsset = null;
         var _loc5_:Vector.<IAsset> = null;
         var _loc3_:uint = 0;
         _loc5_ = this._assets.concat();
         this._assets.length = 0;
         param1 ||= NamedAssetBase.DEFAULT_NAMESPACE;
         for each(_loc4_ in _loc5_)
         {
            if(_loc4_.assetNamespace == param1)
            {
               if(param2)
               {
                  _loc4_.dispose();
               }
               this.removeAssetFromDict(_loc4_,false);
            }
            else
            {
               var _loc8_:uint;
               this._assets[_loc8_ = _loc3_++] = _loc4_;
            }
         }
         if(this._assetDictionary.hasOwnProperty(param1))
         {
            delete this._assetDictionary[param1];
         }
      }
      
      private function removeAssetFromDict(param1:IAsset, param2:Boolean = true) : void
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         if(this._assetDictDirty)
         {
            this.rehashAssetDict();
         }
         if(this._assetDictionary.hasOwnProperty(param1.assetNamespace))
         {
            if(this._assetDictionary[param1.assetNamespace].hasOwnProperty(param1.name))
            {
               delete this._assetDictionary[param1.assetNamespace][param1.name];
            }
            if(param2)
            {
               _loc4_ = true;
               var _loc5_:int = 0;
               var _loc6_:* = this._assetDictionary[param1.assetNamespace];
               for(_loc3_ in _loc6_)
               {
                  _loc4_ = false;
               }
               if(_loc4_)
               {
                  delete this._assetDictionary[param1.assetNamespace];
               }
            }
         }
      }
      
      private function loadResource(param1:URLRequest, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         var _loc5_:AssetLoader = new AssetLoader();
         if(!this._loadingSessions)
         {
            this._loadingSessions = new Vector.<AssetLoader>();
         }
         this._loadingSessions.push(_loc5_);
         _loc5_.addEventListener(LoaderEvent.RESOURCE_COMPLETE,this.onResourceRetrieved);
         _loc5_.addEventListener(LoaderEvent.DEPENDENCY_COMPLETE,this.onDependencyRetrieved);
         _loc5_.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR,this.onTextureSizeError);
         _loc5_.addEventListener(AssetEvent.ASSET_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.TEXTURE_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.CONTAINER_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.GEOMETRY_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.MATERIAL_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.MESH_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ENTITY_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.SKELETON_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE,this.onAssetComplete);
         _loc5_.addErrorHandler(this.onDependencyRetrievingError);
         _loc5_.addParseErrorHandler(this.onDependencyRetrievingParseError);
         return _loc5_.load(param1,param2,param3,param4);
      }
      
      public function stopAllLoadingSessions() : void
      {
         var _loc1_:int = 0;
         if(!this._loadingSessions)
         {
            this._loadingSessions = new Vector.<AssetLoader>();
         }
         var _loc2_:int = int(this._loadingSessions.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.killLoadingSession(this._loadingSessions[_loc1_]);
            _loc1_++;
         }
         this._loadingSessions = null;
      }
      
      private function parseResource(param1:*, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         var _loc5_:AssetLoader = new AssetLoader();
         if(!this._loadingSessions)
         {
            this._loadingSessions = new Vector.<AssetLoader>();
         }
         this._loadingSessions.push(_loc5_);
         _loc5_.addEventListener(LoaderEvent.RESOURCE_COMPLETE,this.onResourceRetrieved);
         _loc5_.addEventListener(LoaderEvent.DEPENDENCY_COMPLETE,this.onDependencyRetrieved);
         _loc5_.addEventListener(AssetEvent.TEXTURE_SIZE_ERROR,this.onTextureSizeError);
         _loc5_.addEventListener(AssetEvent.ASSET_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ANIMATION_SET_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ANIMATION_STATE_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ANIMATION_NODE_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.STATE_TRANSITION_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.TEXTURE_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.CONTAINER_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.GEOMETRY_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.MATERIAL_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.MESH_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.ENTITY_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.SKELETON_COMPLETE,this.onAssetComplete);
         _loc5_.addEventListener(AssetEvent.SKELETON_POSE_COMPLETE,this.onAssetComplete);
         _loc5_.addErrorHandler(this.onDependencyRetrievingError);
         _loc5_.addParseErrorHandler(this.onDependencyRetrievingParseError);
         return _loc5_.loadData(param1,"",param2,param3,param4);
      }
      
      private function rehashAssetDict() : void
      {
         var _loc1_:IAsset = null;
         this._assetDictionary = {};
         this._assets.fixed = true;
         for each(_loc1_ in this._assets)
         {
            if(!this._assetDictionary.hasOwnProperty(_loc1_.assetNamespace))
            {
               this._assetDictionary[_loc1_.assetNamespace] = {};
            }
            this._assetDictionary[_loc1_.assetNamespace][_loc1_.name] = _loc1_;
         }
         this._assets.fixed = false;
         this._assetDictDirty = false;
      }
      
      private function onDependencyRetrieved(param1:LoaderEvent) : void
      {
         if(hasEventListener(LoaderEvent.DEPENDENCY_COMPLETE))
         {
            dispatchEvent(param1);
         }
      }
      
      private function onDependencyRetrievingError(param1:LoaderEvent) : Boolean
      {
         if(hasEventListener(LoaderEvent.LOAD_ERROR))
         {
            dispatchEvent(param1);
            return true;
         }
         return false;
      }
      
      private function onDependencyRetrievingParseError(param1:ParserEvent) : Boolean
      {
         if(hasEventListener(ParserEvent.PARSE_ERROR))
         {
            dispatchEvent(param1);
            return true;
         }
         return false;
      }
      
      private function onAssetComplete(param1:AssetEvent) : void
      {
         if(param1.type == AssetEvent.ASSET_COMPLETE)
         {
            this.addAsset(param1.asset);
         }
         dispatchEvent(param1.clone());
      }
      
      private function onTextureSizeError(param1:AssetEvent) : void
      {
         this.dispatchEvent(param1.clone());
      }
      
      private function onResourceRetrieved(param1:LoaderEvent) : void
      {
         var _loc2_:AssetLoader = AssetLoader(param1.target);
         this.killLoadingSession(_loc2_);
         var _loc3_:int = this._loadingSessions.indexOf(_loc2_);
         this._loadingSessions.splice(_loc3_,1);
         dispatchEvent(param1.clone());
      }
      
      private function killLoadingSession(param1:AssetLoader) : void
      {
         param1.removeEventListener(LoaderEvent.LOAD_ERROR,this.onDependencyRetrievingError);
         param1.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,this.onResourceRetrieved);
         param1.removeEventListener(LoaderEvent.DEPENDENCY_COMPLETE,this.onDependencyRetrieved);
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
         param1.stop();
      }
      
      private function onAssetRename(param1:AssetEvent) : void
      {
         var _loc4_:Object = null;
         var _loc2_:IAsset = IAsset(param1.currentTarget);
         var _loc3_:IAsset = this.getAsset(_loc2_.assetNamespace,_loc2_.name);
         if(_loc3_ != null)
         {
            this._strategy.resolveConflict(_loc2_,_loc3_,this._assetDictionary[_loc2_.assetNamespace],this._strategyPreference);
         }
         else
         {
            _loc4_ = this._assetDictionary[param1.asset.assetNamespace];
            if(_loc4_ == null)
            {
               return;
            }
            _loc4_[param1.assetPrevName] = null;
            _loc4_[param1.asset.name] = param1.asset;
         }
      }
      
      private function onAssetConflictResolved(param1:AssetEvent) : void
      {
         dispatchEvent(param1.clone());
      }
   }
}

class AssetLibraryBundleSingletonEnforcer
{
   
   public function AssetLibraryBundleSingletonEnforcer()
   {
      super();
   }
}
