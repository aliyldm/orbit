package net.bigpoint.darkorbit.map.view3D.loaders
{
   import away3d.events.AssetEvent;
   import away3d.events.LoaderEvent;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.loaders.Loader3D;
   import away3d.loaders.misc.SingleFileLoader;
   import away3d.loaders.parsers.ParserBase;
   import away3d.textures.Texture2DBase;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import net.bigpoint.as3toolbox.filecollection.finish.DefaultFinisher;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   
   public class DOParticleFileLoader extends SingleFileLoader
   {
      
      private var _resourcesLifetime:uint;
      
      public function DOParticleFileLoader(param1:uint, param2:uint)
      {
         super(param2);
         this._resourcesLifetime = param1;
      }
      
      override public function load(param1:URLRequest, param2:ParserBase = null, param3:Boolean = false) : void
      {
         _loadAsRawData = param3;
         _req = param1;
         decomposeFilename(_req.url);
         if(!_loadAsRawData)
         {
            _parser = param2 || getParserFromSuffix();
         }
         if(param1.url.indexOf(".atf") != -1)
         {
            World3D.instance.textureLoader.loadTexture(param1.url,this._resourcesLifetime,World3D.instance.particlesFileCollection).addOnce(this.handleTextureReady);
         }
         else if(param1.url.indexOf(".awd") != -1)
         {
            World3D.instance.geometryLoader.loadGeometry(param1.url,this._resourcesLifetime,World3D.instance.particlesFileCollection).addOnce(this.handleGeometryReady);
         }
         else
         {
            World3D.instance.particlesFileCollection.load(param1.url,this.handleFileLoadComplete,this.handleFileLoadError);
         }
      }
      
      private function handleTextureReady(param1:Texture2DBase) : void
      {
         this.finalizeAsset(param1);
         dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE,this.url));
      }
      
      private function handleGeometryReady(param1:Loader3D) : void
      {
         var _loc2_:IAsset = null;
         for each(_loc2_ in param1.assets)
         {
            this.finalizeAsset(_loc2_);
         }
         dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE,this.url));
      }
      
      private function handleFileLoadComplete(param1:DefaultFinisher) : void
      {
         _data = ByteArray(param1.data);
         _data.position = 0;
         if(_loadAsRawData)
         {
            dispatchEvent(new LoaderEvent(LoaderEvent.DEPENDENCY_COMPLETE));
         }
         else
         {
            parse(_data);
         }
      }
      
      private function handleFileLoadError(... rest) : void
      {
      }
      
      protected function finalizeAsset(param1:IAsset, param2:String = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         if(param2 != null)
         {
            param1.name = param2;
         }
         switch(param1.assetType)
         {
            case AssetType.LIGHT_PICKER:
               _loc4_ = "lightPicker";
               _loc3_ = AssetEvent.LIGHTPICKER_COMPLETE;
               break;
            case AssetType.LIGHT:
               _loc4_ = "light";
               _loc3_ = AssetEvent.LIGHT_COMPLETE;
               break;
            case AssetType.ANIMATOR:
               _loc4_ = "animator";
               _loc3_ = AssetEvent.ANIMATOR_COMPLETE;
               break;
            case AssetType.ANIMATION_SET:
               _loc4_ = "animationSet";
               _loc3_ = AssetEvent.ANIMATION_SET_COMPLETE;
               break;
            case AssetType.ANIMATION_STATE:
               _loc4_ = "animationState";
               _loc3_ = AssetEvent.ANIMATION_STATE_COMPLETE;
               break;
            case AssetType.ANIMATION_NODE:
               _loc4_ = "animationNode";
               _loc3_ = AssetEvent.ANIMATION_NODE_COMPLETE;
               break;
            case AssetType.STATE_TRANSITION:
               _loc4_ = "stateTransition";
               _loc3_ = AssetEvent.STATE_TRANSITION_COMPLETE;
               break;
            case AssetType.TEXTURE:
               _loc4_ = "texture";
               _loc3_ = AssetEvent.TEXTURE_COMPLETE;
               break;
            case AssetType.TEXTURE_PROJECTOR:
               _loc4_ = "textureProjector";
               _loc3_ = AssetEvent.TEXTURE_PROJECTOR_COMPLETE;
               break;
            case AssetType.CONTAINER:
               _loc4_ = "container";
               _loc3_ = AssetEvent.CONTAINER_COMPLETE;
               break;
            case AssetType.GEOMETRY:
               _loc4_ = "geometry";
               _loc3_ = AssetEvent.GEOMETRY_COMPLETE;
               break;
            case AssetType.MATERIAL:
               _loc4_ = "material";
               _loc3_ = AssetEvent.MATERIAL_COMPLETE;
               break;
            case AssetType.MESH:
               _loc4_ = "mesh";
               _loc3_ = AssetEvent.MESH_COMPLETE;
               break;
            case AssetType.SKELETON:
               _loc4_ = "skeleton";
               _loc3_ = AssetEvent.SKELETON_COMPLETE;
               break;
            case AssetType.SKELETON_POSE:
               _loc4_ = "skelpose";
               _loc3_ = AssetEvent.SKELETON_POSE_COMPLETE;
               break;
            case AssetType.ENTITY:
               _loc4_ = "entity";
               _loc3_ = AssetEvent.ENTITY_COMPLETE;
               break;
            case AssetType.SKYBOX:
               _loc4_ = "skybox";
               _loc3_ = AssetEvent.SKYBOX_COMPLETE;
               break;
            case AssetType.CAMERA:
               _loc4_ = "camera";
               _loc3_ = AssetEvent.CAMERA_COMPLETE;
               break;
            case AssetType.SEGMENT_SET:
               _loc4_ = "segmentSet";
               _loc3_ = AssetEvent.SEGMENT_SET_COMPLETE;
               break;
            case AssetType.EFFECTS_METHOD:
               _loc4_ = "effectsMethod";
               _loc3_ = AssetEvent.EFFECTMETHOD_COMPLETE;
               break;
            case AssetType.SHADOW_MAP_METHOD:
               _loc4_ = "effectsMethod";
               _loc3_ = AssetEvent.SHADOWMAPMETHOD_COMPLETE;
               break;
            default:
               throw new Error("Unhandled asset type " + param1.assetType + ". Report as bug!");
         }
         if(!param1.name)
         {
            param1.name = _loc4_;
         }
         dispatchEvent(new AssetEvent(AssetEvent.ASSET_COMPLETE,param1));
         dispatchEvent(new AssetEvent(_loc3_,param1));
      }
   }
}

