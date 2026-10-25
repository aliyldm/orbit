package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleSpriteSheetNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import flash.geom.Vector3D;
   
   public class ParticleSpriteSheetNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _durationValue:ValueSubParserBase;
      
      private var _numColumns:int;
      
      private var _numRows:int;
      
      private var _total:int;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      public function ParticleSpriteSheetNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleSpriteSheetNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            this._numColumns = _data.numColumns;
            this._numRows = _data.numRows;
            this._total = _data.total;
            this._usesCycle = _data.usesCycle;
            this._usesPhase = _data.usesPhase;
            _loc1_ = _data.scale;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_FOURD_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._durationValue = new _loc4_(ParticleSpriteSheetNode.UV_VECTOR3D);
            addSubParser(this._durationValue);
            this._durationValue.parseAsync(_loc3_);
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.initProps();
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function initProps() : void
      {
         var _loc1_:Vector3D = null;
         if(this._total == 0)
         {
            this._total = int.MAX_VALUE;
         }
         if(this._durationValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _loc1_ = this._durationValue.setter.generateOneValue();
            _particleAnimationNode = new ParticleSpriteSheetNode(ParticlePropertiesMode.GLOBAL,this._usesCycle,this._usesPhase,this._numColumns,this._numRows,_loc1_.x,_loc1_.y,this._total);
         }
         else
         {
            _particleAnimationNode = new ParticleSpriteSheetNode(ParticlePropertiesMode.LOCAL_STATIC,this._usesCycle,this._usesPhase,this._numColumns,this._numRows,1,0,this._total);
            _setters.push(this._durationValue.setter);
         }
      }
   }
}

