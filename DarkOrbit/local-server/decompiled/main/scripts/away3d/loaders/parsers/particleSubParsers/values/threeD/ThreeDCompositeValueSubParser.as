package away3d.loaders.parsers.particleSubParsers.values.threeD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.threeD.ThreeDCompositeSetter;
   
   public class ThreeDCompositeValueSubParser extends ValueSubParserBase
   {
      
      private var _valueX:ValueSubParserBase;
      
      private var _valueY:ValueSubParserBase;
      
      private var _valueZ:ValueSubParserBase;
      
      private var _isometric:Boolean;
      
      public function ThreeDCompositeValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ThreeDCompositeValueSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            this._isometric = _data.isometric;
            _loc1_ = _data.x;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._valueX = new _loc4_(null);
            addSubParser(this._valueX);
            this._valueX.parseAsync(_loc3_);
            _loc1_ = _data.y;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._valueY = new _loc4_(null);
            addSubParser(this._valueY);
            this._valueY.parseAsync(_loc3_);
            _loc1_ = _data.z;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._valueZ = new _loc4_(null);
            addSubParser(this._valueZ);
            this._valueZ.parseAsync(_loc3_);
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
         if(this._valueX.valueType == CONST_VALUE && (this._isometric || this._valueY.valueType == CONST_VALUE && this._valueZ.valueType == CONST_VALUE))
         {
            _valueType = CONST_VALUE;
         }
         _setter = new ThreeDCompositeSetter(_propName,this._valueX.setter,this._valueY.setter,this._valueZ.setter,this._isometric);
      }
   }
}

