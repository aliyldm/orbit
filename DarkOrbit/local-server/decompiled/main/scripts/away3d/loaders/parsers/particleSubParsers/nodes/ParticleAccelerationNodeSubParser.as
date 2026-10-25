package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleAccelerationNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   
   public class ParticleAccelerationNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _acceleration:ValueSubParserBase;
      
      public function ParticleAccelerationNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleAccelerationNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.acceleration;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_THREED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._acceleration = new _loc4_(ParticleAccelerationNode.ACCELERATION_VECTOR3D);
            addSubParser(this._acceleration);
            this._acceleration.parseAsync(_loc3_);
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
         if(this._acceleration.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticleAccelerationNode(ParticlePropertiesMode.GLOBAL,this._acceleration.setter.generateOneValue());
         }
         else
         {
            _particleAnimationNode = new ParticleAccelerationNode(ParticlePropertiesMode.LOCAL_STATIC);
            _setters.push(this._acceleration.setter);
         }
      }
   }
}

