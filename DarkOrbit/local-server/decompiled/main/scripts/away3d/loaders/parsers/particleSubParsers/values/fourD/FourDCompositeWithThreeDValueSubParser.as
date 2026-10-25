package away3d.loaders.parsers.particleSubParsers.values.fourD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.fourD.FourDCompositeWithThreeDSetter;
   
   public class FourDCompositeWithThreeDValueSubParser extends ValueSubParserBase
   {
      
      private var _value3D:ValueSubParserBase;
      
      private var _valueW:ValueSubParserBase;
      
      public function FourDCompositeWithThreeDValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.FourDCompositeWithThreeDValueSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.x;
            if(_loc1_)
            {
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_THREED_VALUES);
               if(!_loc4_)
               {
                  dieWithError("Unknown value");
               }
               this._value3D = new _loc4_(null);
               addSubParser(this._value3D);
               this._value3D.parseAsync(_loc3_);
            }
            _loc1_ = _data.w;
            if(_loc1_)
            {
               _loc2_ = _loc1_.id;
               _loc3_ = _loc1_.data;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc4_)
               {
                  dieWithError("Unknown value");
               }
               this._valueW = new _loc4_(null);
               addSubParser(this._valueW);
               this._valueW.parseAsync(_loc3_);
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
         var _loc1_:SetterBase = this._value3D.setter;
         var _loc2_:SetterBase = this._valueW.setter;
         if(this._value3D.valueType == CONST_VALUE && this._valueW.valueType == CONST_VALUE)
         {
            _valueType = CONST_VALUE;
         }
         else
         {
            _valueType = VARIABLE_VALUE;
         }
         _setter = new FourDCompositeWithThreeDSetter(_propName,_loc1_,_loc2_);
      }
   }
}

