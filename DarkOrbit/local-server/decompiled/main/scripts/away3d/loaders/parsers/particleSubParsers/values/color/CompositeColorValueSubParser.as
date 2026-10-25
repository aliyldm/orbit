package away3d.loaders.parsers.particleSubParsers.values.color
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.color.CompositeColorSetter;
   
   public class CompositeColorValueSubParser extends ValueSubParserBase
   {
      
      private var _redMultiplierValue:ValueSubParserBase;
      
      private var _greenMultiplierValue:ValueSubParserBase;
      
      private var _blueMultiplierValue:ValueSubParserBase;
      
      private var _alphaMultiplierValue:ValueSubParserBase;
      
      private var _redOffsetValue:ValueSubParserBase;
      
      private var _greenOffsetValue:ValueSubParserBase;
      
      private var _blueOffsetValue:ValueSubParserBase;
      
      private var _alphaOffsetValue:ValueSubParserBase;
      
      public var usesMultiplier:Boolean;
      
      public var usesOffset:Boolean;
      
      public function CompositeColorValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.CompositeColorValueSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Class = null;
         var _loc4_:Object = null;
         if(_isFirstParsing)
         {
            _loc4_ = _data.redMultiplierValue;
            if(_loc4_)
            {
               this.usesMultiplier = true;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._redMultiplierValue = new _loc3_(null);
               addSubParser(this._redMultiplierValue);
               this._redMultiplierValue.parseAsync(_loc2_);
               _loc4_ = _data.greenMultiplierValue;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._greenMultiplierValue = new _loc3_(null);
               addSubParser(this._greenMultiplierValue);
               this._greenMultiplierValue.parseAsync(_loc2_);
               _loc4_ = _data.blueMultiplierValue;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._blueMultiplierValue = new _loc3_(null);
               addSubParser(this._blueMultiplierValue);
               this._blueMultiplierValue.parseAsync(_loc2_);
               _loc4_ = _data.alphaMultiplierValue;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._alphaMultiplierValue = new _loc3_(null);
               addSubParser(this._alphaMultiplierValue);
               this._alphaMultiplierValue.parseAsync(_loc2_);
            }
            _loc4_ = _data.redOffsetValue;
            if(_loc4_)
            {
               this.usesOffset = true;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._redOffsetValue = new _loc3_(null);
               addSubParser(this._redOffsetValue);
               this._redOffsetValue.parseAsync(_loc2_);
               _loc4_ = _data.greenOffsetValue;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._greenOffsetValue = new _loc3_(null);
               addSubParser(this._greenOffsetValue);
               this._greenOffsetValue.parseAsync(_loc2_);
               _loc4_ = _data.blueOffsetValue;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._blueOffsetValue = new _loc3_(null);
               addSubParser(this._blueOffsetValue);
               this._blueOffsetValue.parseAsync(_loc2_);
               _loc4_ = _data.alphaOffsetValue;
               _loc1_ = _loc4_.id;
               _loc2_ = _loc4_.data;
               _loc3_ = MatchingTool.getMatchedClass(_loc1_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc3_)
               {
                  dieWithError("Unknown value");
               }
               this._alphaOffsetValue = new _loc3_(null);
               addSubParser(this._alphaOffsetValue);
               this._alphaOffsetValue.parseAsync(_loc2_);
            }
         }
         if(super.proceedParsing() == PARSING_DONE)
         {
            this.initSetter();
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      private function initSetter() : void
      {
         var _loc1_:SetterBase = null;
         var _loc2_:SetterBase = null;
         var _loc3_:SetterBase = null;
         var _loc4_:SetterBase = null;
         var _loc5_:SetterBase = null;
         var _loc6_:SetterBase = null;
         var _loc7_:SetterBase = null;
         var _loc8_:SetterBase = null;
         if(this.usesMultiplier)
         {
            _loc1_ = this._redMultiplierValue.setter;
            _loc2_ = this._greenMultiplierValue.setter;
            _loc3_ = this._blueMultiplierValue.setter;
            _loc4_ = this._alphaMultiplierValue.setter;
         }
         if(this.usesOffset)
         {
            _loc5_ = this._redOffsetValue.setter;
            _loc6_ = this._greenOffsetValue.setter;
            _loc7_ = this._blueOffsetValue.setter;
            _loc8_ = this._alphaOffsetValue.setter;
         }
         if((!this.usesMultiplier || this._redMultiplierValue.valueType == CONST_VALUE && this._greenMultiplierValue.valueType == CONST_VALUE && this._blueMultiplierValue.valueType == CONST_VALUE && this._alphaMultiplierValue.valueType == CONST_VALUE) && (!this.usesOffset || this._redOffsetValue.valueType == CONST_VALUE && this._greenOffsetValue.valueType == CONST_VALUE && this._blueOffsetValue.valueType == CONST_VALUE && this._alphaOffsetValue.valueType == CONST_VALUE))
         {
            _valueType = CONST_VALUE;
         }
         else
         {
            _valueType = VARIABLE_VALUE;
         }
         _setter = new CompositeColorSetter(_propName,_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,_loc8_);
      }
   }
}

