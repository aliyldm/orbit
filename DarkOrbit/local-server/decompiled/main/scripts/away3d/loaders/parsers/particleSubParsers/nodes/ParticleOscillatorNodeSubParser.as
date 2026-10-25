package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleOscillatorNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.fourD.FourDCompositeWithThreeDValueSubParser;
   
   public class ParticleOscillatorNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _oscillatorValue:FourDCompositeWithThreeDValueSubParser;
      
      public function ParticleOscillatorNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleOscillatorNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.oscillator;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            this._oscillatorValue = new FourDCompositeWithThreeDValueSubParser(ParticleOscillatorNode.OSCILLATOR_VECTOR3D);
            addSubParser(this._oscillatorValue);
            this._oscillatorValue.parseAsync(_loc3_);
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
         if(this._oscillatorValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticleOscillatorNode(ParticlePropertiesMode.GLOBAL,this._oscillatorValue.setter.generateOneValue());
         }
         else
         {
            _particleAnimationNode = new ParticleOscillatorNode(ParticlePropertiesMode.LOCAL_STATIC);
            _setters.push(this._oscillatorValue.setter);
         }
      }
   }
}

