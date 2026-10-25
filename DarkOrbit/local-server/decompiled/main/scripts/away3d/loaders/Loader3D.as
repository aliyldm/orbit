package away3d.loaders
{
   import away3d.*;
   import away3d.cameras.*;
   import away3d.containers.*;
   import away3d.entities.*;
   import away3d.events.*;
   import away3d.library.*;
   import away3d.library.assets.*;
   import away3d.lights.*;
   import away3d.loaders.misc.*;
   import away3d.loaders.parsers.*;
   import away3d.primitives.*;
   import flash.events.*;
   import flash.net.*;
   
   use namespace arcane;
   
   public class Loader3D extends ObjectContainer3D
   {
      
      private var _loadingSessions:Vector.<AssetLoader>;
      
      private var _useAssetLib:Boolean;
      
      private var _assetLibId:String;
      
      private var _assets:Vector.<IAsset> = new Vector.<IAsset>();
      
      public function Loader3D(param1:Boolean = true, param2:String = null)
      {
         super();
         this._loadingSessions = new Vector.<AssetLoader>();
         this._useAssetLib = param1;
         this._assetLibId = param2;
      }
      
      public static function enableParser(param1:Class) : void
      {
         SingleFileLoader.enableParser(param1);
      }
      
      public static function enableParsers(param1:Vector.<Class>) : void
      {
         SingleFileLoader.enableParsers(param1);
      }
      
      public function load(param1:URLRequest, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         var _loc5_:AssetLoaderToken = null;
         var _loc6_:AssetLibraryBundle = null;
         var _loc7_:AssetLoader = null;
         if(this._useAssetLib)
         {
            _loc6_ = AssetLibraryBundle.getInstance(this._assetLibId);
            _loc5_ = _loc6_.load(param1,param2,param3,param4);
         }
         else
         {
            _loc7_ = new AssetLoader();
            this._loadingSessions.push(_loc7_);
            _loc5_ = _loc7_.load(param1,param2,param3,param4);
         }
         _loc5_.addEventListener(LoaderEvent.RESOURCE_COMPLETE,this.onResourceComplete);
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
         _loc5_._loader.addErrorHandler(this.onLoadError);
         return _loc5_;
      }
      
      public function loadData(param1:*, param2:AssetLoaderContext = null, param3:String = null, param4:ParserBase = null) : AssetLoaderToken
      {
         var _loc5_:AssetLoaderToken = null;
         var _loc6_:AssetLibraryBundle = null;
         var _loc7_:AssetLoader = null;
         if(this._useAssetLib)
         {
            _loc6_ = AssetLibraryBundle.getInstance(this._assetLibId);
            _loc5_ = _loc6_.loadData(param1,param2,param3,param4);
         }
         else
         {
            _loc7_ = new AssetLoader();
            this._loadingSessions.push(_loc7_);
            _loc5_ = _loc7_.loadData(param1,"",param2,param3,param4);
         }
         _loc5_.addEventListener(LoaderEvent.RESOURCE_COMPLETE,this.onResourceComplete);
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
         _loc5_._loader.addErrorHandler(this.onLoadError);
         return _loc5_;
      }
      
      public function stopLoad() : void
      {
         var _loc1_:int = 0;
         var _loc3_:AssetLibraryBundle = null;
         if(this._useAssetLib)
         {
            _loc3_ = AssetLibraryBundle.getInstance(this._assetLibId);
            _loc3_.stopAllLoadingSessions();
            this._loadingSessions = null;
            return;
         }
         var _loc2_:int = int(this._loadingSessions.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.removeListeners(this._loadingSessions[_loc1_]);
            this._loadingSessions[_loc1_].stop();
            this._loadingSessions[_loc1_] = null;
            _loc1_++;
         }
         this._loadingSessions = null;
      }
      
      private function removeListeners(param1:EventDispatcher) : void
      {
         param1.removeEventListener(LoaderEvent.RESOURCE_COMPLETE,this.onResourceComplete);
         param1.removeEventListener(LoaderEvent.LOAD_ERROR,this.onLoadError);
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
      }
      
      private function onAssetComplete(param1:AssetEvent) : void
      {
         var _loc2_:ObjectContainer3D = null;
         if(param1.type == AssetEvent.ASSET_COMPLETE)
         {
            this._assets.push(param1.asset);
            switch(param1.asset.assetType)
            {
               case AssetType.LIGHT:
                  _loc2_ = LightBase(param1.asset);
                  break;
               case AssetType.CONTAINER:
                  _loc2_ = ObjectContainer3D(param1.asset);
                  break;
               case AssetType.MESH:
                  _loc2_ = Mesh(param1.asset);
                  break;
               case AssetType.SKYBOX:
                  _loc2_ = SkyBox(param1.asset);
                  break;
               case AssetType.TEXTURE_PROJECTOR:
                  _loc2_ = TextureProjector(param1.asset);
                  break;
               case AssetType.CAMERA:
                  _loc2_ = Camera3D(param1.asset);
                  break;
               case AssetType.SEGMENT_SET:
                  _loc2_ = SegmentSet(param1.asset);
            }
            if(Boolean(_loc2_) && _loc2_.parent == null)
            {
               addChild(_loc2_);
            }
         }
         this.dispatchEvent(param1.clone());
      }
      
      private function onParseError(param1:ParserEvent) : Boolean
      {
         if(hasEventListener(ParserEvent.PARSE_ERROR))
         {
            dispatchEvent(param1);
            return true;
         }
         return false;
      }
      
      private function onLoadError(param1:LoaderEvent) : Boolean
      {
         if(hasEventListener(LoaderEvent.LOAD_ERROR))
         {
            dispatchEvent(param1);
            return true;
         }
         return false;
      }
      
      private function onResourceComplete(param1:Event) : void
      {
         this.removeListeners(EventDispatcher(param1.currentTarget));
         this.dispatchEvent(param1.clone());
      }
      
      public function get assets() : Vector.<IAsset>
      {
         return this._assets;
      }
   }
}

