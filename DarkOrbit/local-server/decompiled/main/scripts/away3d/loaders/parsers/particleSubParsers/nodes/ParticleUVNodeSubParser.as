package away3d.loaders.parsers.particleSubParsers.nodes
{
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleUVNode;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   
   public class ParticleUVNodeSubParser extends ParticleNodeSubParserBase
   {
      
      private var _cycleValue:ValueSubParserBase;
      
      private var _scaleValue:ValueSubParserBase;
      
      private var _axis:String;
      
      private var _formula:int;
      
      public function ParticleUVNodeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ParticleUVNodeSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.cycle;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._cycleValue = new _loc4_(ParticleUVNode.UV_CYCLE);
            addSubParser(this._cycleValue);
            this._cycleValue.parseAsync(_loc3_);
            _loc1_ = _data.scale;
            if(_loc1_)
            {
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc4_)
               {
                  dieWithError("Unknown value");
               }
               this._scaleValue = new _loc4_(ParticleUVNode.UV_SCALE);
               addSubParser(this._scaleValue);
               this._scaleValue.parseAsync(_loc3_);
            }
            this._axis = _data.axis;
            this._formula = _data.formula;
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
         if(this._cycleValue.valueType == ValueSubParserBase.CONST_VALUE)
         {
            if(!this._scaleValue)
            {
               _particleAnimationNode = new ParticleUVNode(ParticlePropertiesMode.GLOBAL,this._cycleValue.setter.generateOneValue(),1,this._axis,this._formula);
            }
            else if(this._scaleValue.valueType == ValueSubParserBase.CONST_VALUE)
            {
               _particleAnimationNode = new ParticleUVNode(ParticlePropertiesMode.GLOBAL,this._cycleValue.setter.generateOneValue(),this._scaleValue.setter.generateOneValue(),this._axis,this._formula);
            }
            else
            {
               _particleAnimationNode = new ParticleUVNode(ParticlePropertiesMode.LOCAL_STATIC,this._cycleValue.setter.generateOneValue(),2,this._axis,this._formula);
               _setters.push(this._cycleValue.setter);
               _setters.push(this._scaleValue.setter);
            }
         }
         else
         {
            _setters.push(this._cycleValue.setter);
            if(!this._scaleValue)
            {
               _particleAnimationNode = new ParticleUVNode(ParticlePropertiesMode.LOCAL_STATIC,this._cycleValue.setter.generateOneValue(),1,this._axis,this._formula);
            }
            else if(this._scaleValue.valueType == ValueSubParserBase.CONST_VALUE)
            {
               _particleAnimationNode = new ParticleUVNode(ParticlePropertiesMode.LOCAL_STATIC,this._cycleValue.setter.generateOneValue(),this._scaleValue.setter.generateOneValue(),this._axis,this._formula);
            }
            else
            {
               _particleAnimationNode = new ParticleUVNode(ParticlePropertiesMode.LOCAL_STATIC,this._cycleValue.setter.generateOneValue(),2,this._axis,this._formula);
               _setters.push(this._scaleValue.setter);
            }
         }
      }
   }
}

