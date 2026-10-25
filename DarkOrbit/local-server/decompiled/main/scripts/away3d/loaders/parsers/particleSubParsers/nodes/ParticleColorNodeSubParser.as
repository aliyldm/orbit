package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleColorNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.color.CompositeColorValueSubParser;
   import away3d.loaders.parsers.particleSubParsers.values.oneD.OneDConstValueSubParser;
   
   public class ParticleColorNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _startColorValue:CompositeColorValueSubParser;
      
      private var _endColorValue:CompositeColorValueSubParser;
      
      private var _cycleDurationValue:OneDConstValueSubParser;
      
      private var _cyclePhaseValue:OneDConstValueSubParser;
      
      private var _usesCycle:Boolean;
      
      private var _usesPhase:Boolean;
      
      public function ParticleColorNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleColorNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(_isFirstParsing)
         {
            this._usesCycle = _data.usesCycle;
            this._usesPhase = _data.usesPhase;
            this._usesCycle = _data.usesCycle;
            if(this._usesCycle)
            {
               _loc1_ = _data.cycleDuration;
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               this._cycleDurationValue = new OneDConstValueSubParser(null);
               addSubParser(this._cycleDurationValue);
               this._cycleDurationValue.parseAsync(_loc3_);
            }
            this._usesPhase = _data.usesPhase;
            if(this._usesPhase)
            {
               _loc1_ = _data.cyclePhase;
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               this._cyclePhaseValue = new OneDConstValueSubParser(null);
               addSubParser(this._cyclePhaseValue);
               this._cyclePhaseValue.parseAsync(_loc3_);
            }
            _loc1_ = _data.startColor;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            this._startColorValue = new CompositeColorValueSubParser(ParticleColorNode.COLOR_START_COLORTRANSFORM);
            addSubParser(this._startColorValue);
            this._startColorValue.parseAsync(_loc3_);
            _loc1_ = _data.endColor;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            this._endColorValue = new CompositeColorValueSubParser(ParticleColorNode.COLOR_END_COLORTRANSFORM);
            addSubParser(this._endColorValue);
            this._endColorValue.parseAsync(_loc3_);
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
         var _loc1_:Number = 1;
         var _loc2_:Number = 0;
         if(this._usesCycle)
         {
            _loc1_ = this._cycleDurationValue.setter.generateOneValue();
            if(this._usesPhase)
            {
               _loc2_ = this._cyclePhaseValue.setter.generateOneValue();
            }
         }
         if(this._startColorValue.valueType == ValueSubParserBase.CONST_VALUE && this._endColorValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            _particleAnimationNode = new ParticleColorNode(ParticlePropertiesMode.GLOBAL,this._startColorValue.usesMultiplier,this._startColorValue.usesOffset,this._usesCycle,this._usesPhase,this._startColorValue.setter.generateOneValue(),this._endColorValue.setter.generateOneValue(),_loc1_,_loc2_);
         }
         else
         {
            _particleAnimationNode = new ParticleColorNode(ParticlePropertiesMode.LOCAL_STATIC,this._startColorValue.usesMultiplier,this._startColorValue.usesOffset,this._usesCycle,this._usesPhase,null,null,_loc1_,_loc2_);
            _setters.push(this._startColorValue.setter);
            _setters.push(this._endColorValue.setter);
         }
      }
   }
}

