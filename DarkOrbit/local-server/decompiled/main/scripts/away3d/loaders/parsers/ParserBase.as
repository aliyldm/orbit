package away3d.loaders.parsers
{
   import away3d.arcane;
   import away3d.errors.AbstractMethodError;
   import away3d.events.AssetEvent;
   import away3d.events.ParserEvent;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.utils.ParserUtil;
   import away3d.tools.utils.TextureUtils;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   use namespace arcane;
   
   public class ParserBase extends EventDispatcher
   {
      
      protected static const PARSING_DONE:Boolean = true;
      
      protected static const MORE_TO_PARSE:Boolean = false;
      
      arcane var _fileName:String;
      
      protected var _dataFormat:String;
      
      protected var _data:*;
      
      protected var _frameLimit:Number;
      
      protected var _lastFrameTime:Number;
      
      private var _dependencies:Vector.<ResourceDependency>;
      
      private var _parsingPaused:Boolean;
      
      private var _parsingComplete:Boolean;
      
      private var _parsingFailure:Boolean;
      
      private var _timer:Timer;
      
      private var _materialMode:uint;
      
      public function ParserBase(param1:String)
      {
         super();
         this._materialMode = 0;
         this._dataFormat = param1;
         this._dependencies = new Vector.<ResourceDependency>();
      }
      
      protected function getTextData() : String
      {
         return ParserUtil.toString(this._data);
      }
      
      protected function getByteData() : ByteArray
      {
         return ParserUtil.toByteArray(this._data);
      }
      
      public function isBitmapDataValid(param1:BitmapData) : Boolean
      {
         var _loc2_:Boolean = TextureUtils.isBitmapDataValid(param1);
         if(_loc2_)
         {
         }
         return _loc2_;
      }
      
      public function set parsingFailure(param1:Boolean) : void
      {
         this._parsingFailure = param1;
      }
      
      public function get parsingFailure() : Boolean
      {
         return this._parsingFailure;
      }
      
      public function get parsingPaused() : Boolean
      {
         return this._parsingPaused;
      }
      
      public function get parsingComplete() : Boolean
      {
         return this._parsingComplete;
      }
      
      public function set materialMode(param1:uint) : void
      {
         this._materialMode = param1;
      }
      
      public function get materialMode() : uint
      {
         return this._materialMode;
      }
      
      public function get dataFormat() : String
      {
         return this._dataFormat;
      }
      
      public function parseAsync(param1:*, param2:Number = 30) : void
      {
         this._data = param1;
         this.startParsing(param2);
      }
      
      public function get dependencies() : Vector.<ResourceDependency>
      {
         return this._dependencies;
      }
      
      arcane function resolveDependency(param1:ResourceDependency) : void
      {
         throw new AbstractMethodError();
      }
      
      arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
         throw new AbstractMethodError();
      }
      
      arcane function resolveDependencyName(param1:ResourceDependency, param2:IAsset) : String
      {
         return param2.name;
      }
      
      arcane function resumeParsingAfterDependencies() : void
      {
         this._parsingPaused = false;
         if(this._timer)
         {
            this._timer.start();
         }
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
      
      protected function proceedParsing() : Boolean
      {
         throw new AbstractMethodError();
      }
      
      protected function dieWithError(param1:String = "Unknown parsing error") : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onInterval);
            this._timer.stop();
            this._timer = null;
         }
         dispatchEvent(new ParserEvent(ParserEvent.PARSE_ERROR,param1));
      }
      
      protected function addDependency(param1:String, param2:URLRequest, param3:Boolean = false, param4:* = null, param5:Boolean = false) : void
      {
         this._dependencies.push(new ResourceDependency(param1,param2,param4,this,param3,param5));
      }
      
      protected function pauseAndRetrieveDependencies() : void
      {
         if(this._timer)
         {
            this._timer.stop();
         }
         this._parsingPaused = true;
         dispatchEvent(new ParserEvent(ParserEvent.READY_FOR_DEPENDENCIES));
      }
      
      protected function hasTime() : Boolean
      {
         return getTimer() - this._lastFrameTime < this._frameLimit;
      }
      
      protected function onInterval(param1:TimerEvent = null) : void
      {
         this._lastFrameTime = getTimer();
         if(this.proceedParsing() && !this._parsingFailure)
         {
            this.finishParsing();
         }
      }
      
      protected function startParsing(param1:Number) : void
      {
         this._frameLimit = param1;
         this._timer = new Timer(this._frameLimit,0);
         this._timer.addEventListener(TimerEvent.TIMER,this.onInterval);
         this._timer.start();
      }
      
      protected function finishParsing() : void
      {
         if(this._timer)
         {
            this._timer.removeEventListener(TimerEvent.TIMER,this.onInterval);
            this._timer.stop();
         }
         this._timer = null;
         this._parsingComplete = true;
         dispatchEvent(new ParserEvent(ParserEvent.PARSE_COMPLETE));
      }
   }
}

