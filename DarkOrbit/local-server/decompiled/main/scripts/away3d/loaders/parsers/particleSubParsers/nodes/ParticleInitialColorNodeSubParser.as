package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleInitialColorNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.color.CompositeColorValueSubParser;
   
   public class ParticleInitialColorNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _colorValue:CompositeColorValueSubParser;
      
      public function ParticleInitialColorNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleInitialColorNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.color;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            this._colorValue = new CompositeColorValueSubParser(ParticleInitialColorNode.COLOR_INITIAL_COLORTRANSFORM);
            addSubParser(this._colorValue);
            this._colorValue.parseAsync(_loc3_);
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
         if(this._colorValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticleInitialColorNode(ParticlePropertiesMode.GLOBAL,this._colorValue.usesMultiplier,this._colorValue.usesOffset,this._colorValue.setter.generateOneValue());
         }
         else
         {
            _particleAnimationNode = new ParticleInitialColorNode(ParticlePropertiesMode.LOCAL_STATIC,this._colorValue.usesMultiplier,this._colorValue.usesOffset);
            _setters.push(this._colorValue.setter);
         }
      }
   }
}

