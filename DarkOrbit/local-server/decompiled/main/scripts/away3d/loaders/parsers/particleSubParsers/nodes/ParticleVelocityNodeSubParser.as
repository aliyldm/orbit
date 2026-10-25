package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleVelocityNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   
   public class ParticleVelocityNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _velocityValue:ValueSubParserBase;
      
      public function ParticleVelocityNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleVelocityNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.velocity;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_THREED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._velocityValue = new _loc4_(ParticleVelocityNode.VELOCITY_VECTOR3D);
            addSubParser(this._velocityValue);
            this._velocityValue.parseAsync(_loc3_);
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
         if(this._velocityValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticleVelocityNode(ParticlePropertiesMode.GLOBAL,this._velocityValue.setter.generateOneValue());
         }
         else
         {
            _particleAnimationNode = new ParticleVelocityNode(ParticlePropertiesMode.LOCAL_STATIC);
            _setters.push(this._velocityValue.setter);
         }
      }
   }
}

