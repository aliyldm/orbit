package away3d.loaders.parsers
{
   import away3d.arcane;
   import away3d.events.AssetEvent;
   import away3d.events.ParserEvent;
   import away3d.library.assets.IAsset;
   import away3d.loaders.misc.ResourceDependency;
   
   use namespace arcane;
   
   public class AWDParser extends ParserBase
   {
      
      private var _parser:ParserBase;
      
      public function AWDParser()
      {
         super(ParserDataFormat.BINARY);
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         return param1.toLowerCase() == "awd";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         return AWD1Parser.supportsData(param1) || AWD2Parser.supportsData(param1);
      }
      
      override public function get dependencies() : Vector.<ResourceDependency>
      {
         return this._parser ? this._parser.dependencies : super.dependencies;
      }
      
      override public function get parsingComplete() : Boolean
      {
         return this._parser ? this._parser.parsingComplete : false;
      }
      
      override public function get parsingPaused() : Boolean
      {
         return this._parser ? this._parser.parsingPaused : false;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         if(this._parser)
         {
            this._parser.resolveDependency(param1);
         }
      }
      
      override arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
         if(this._parser)
         {
            this._parser.resolveDependencyFailure(param1);
         }
      }
      
      override arcane function resolveDependencyName(param1:ResourceDependency, param2:IAsset) : String
      {
         if(this._parser)
         {
            return this._parser.resolveDependencyName(param1,param2);
         }
         return param2.name;
      }
      
      override arcane function resumeParsingAfterDependencies() : void
      {
         if(this._parser)
         {
            this._parser.resumeParsingAfterDependencies();
         }
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(!this._parser)
         {
            if(AWD99Parser.supportsData(_data))
            {
               this._parser = new AWD99Parser();
            }
            else if(AWD2Parser.supportsData(_data))
            {
               this._parser = new AWD2Parser();
            }
            else
            {
               this._parser = new AWD1Parser();
            }
            this._parser.materialMode = materialMode;
            this._parser.addEventListener(ParserEvent.PARSE_COMPLETE,this.onParseComplete);
            this._parser.addEventListener(ParserEvent.READY_FOR_DEPENDENCIES,this.onReadyForDependencies);
            this._parser.addEventListener(ParserEvent.PARSE_ERROR,this.onParseError);
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
            this._parser.parseAsync(_data);
         }
         return MORE_TO_PARSE;
      }
      
      private function onParseError(param1:ParserEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function onReadyForDependencies(param1:ParserEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function onAssetComplete(param1:AssetEvent) : void
      {
         dispatchEvent(param1.clone());
      }
      
      private function onParseComplete(param1:ParserEvent) : void
      {
         this._parser.removeEventListener(ParserEvent.READY_FOR_DEPENDENCIES,this.onReadyForDependencies);
         this._parser.removeEventListener(ParserEvent.PARSE_COMPLETE,this.onParseComplete);
         this._parser.removeEventListener(ParserEvent.PARSE_ERROR,this.onParseError);
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
         finishParsing();
      }
   }
}

