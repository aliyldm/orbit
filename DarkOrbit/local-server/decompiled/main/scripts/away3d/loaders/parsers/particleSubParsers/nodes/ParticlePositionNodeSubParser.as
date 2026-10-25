package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticlePositionNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   
   public class ParticlePositionNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _positionValue:ValueSubParserBase;
      
      public function ParticlePositionNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticlePositionNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.position;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_THREED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._positionValue = new _loc4_(ParticlePositionNode.POSITION_VECTOR3D);
            addSubParser(this._positionValue);
            this._positionValue.parseAsync(_loc3_);
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
         if(this._positionValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticlePositionNode(ParticlePropertiesMode.GLOBAL,this._positionValue.setter.generateOneValue());
         }
         else
         {
            _particleAnimationNode = new ParticlePositionNode(ParticlePropertiesMode.LOCAL_STATIC);
            _setters.push(this._positionValue.setter);
         }
      }
   }
}

