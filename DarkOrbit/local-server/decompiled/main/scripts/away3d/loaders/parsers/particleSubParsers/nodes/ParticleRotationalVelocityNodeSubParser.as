package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleRotationalVelocityNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.fourD.FourDCompositeWithThreeDValueSubParser;
   
   public class ParticleRotationalVelocityNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _rotationValue:FourDCompositeWithThreeDValueSubParser;
      
      public function ParticleRotationalVelocityNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleRotationalVelocityNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.rotation;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            this._rotationValue = new FourDCompositeWithThreeDValueSubParser(ParticleRotationalVelocityNode.ROTATIONALVELOCITY_VECTOR3D);
            addSubParser(this._rotationValue);
            this._rotationValue.parseAsync(_loc3_);
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
         if(this._rotationValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticleRotationalVelocityNode(ParticlePropertiesMode.GLOBAL,this._rotationValue.setter.generateOneValue());
         }
         else
         {
            _particleAnimationNode = new ParticleRotationalVelocityNode(ParticlePropertiesMode.LOCAL_STATIC);
            _setters.push(this._rotationValue.setter);
         }
      }
   }
}

