package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleBezierCurveNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   
   public class ParticleBezierCurveNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _controlValue:ValueSubParserBase;
      
      private var _endValue:ValueSubParserBase;
      
      public function ParticleBezierCurveNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleBezierCurveNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.control;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_THREED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._controlValue = new _loc4_(ParticleBezierCurveNode.BEZIER_CONTROL_VECTOR3D);
            addSubParser(this._controlValue);
            this._controlValue.parseAsync(_loc3_);
            _loc1_ = _data.end;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_THREED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._endValue = new _loc4_(ParticleBezierCurveNode.BEZIER_END_VECTOR3D);
            addSubParser(this._endValue);
            this._endValue.parseAsync(_loc3_);
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
         if(this._controlValue.valueType == ValueSubParserBase.CONST_VALUE && this._endValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticleBezierCurveNode(ParticlePropertiesMode.GLOBAL,this._controlValue.setter.generateOneValue(),this._endValue.setter.generateOneValue());
         }
         else
         {
            _particleAnimationNode = new ParticleBezierCurveNode(ParticlePropertiesMode.LOCAL_STATIC);
            _setters.push(this._controlValue.setter);
            _setters.push(this._endValue.setter);
         }
      }
   }
}

