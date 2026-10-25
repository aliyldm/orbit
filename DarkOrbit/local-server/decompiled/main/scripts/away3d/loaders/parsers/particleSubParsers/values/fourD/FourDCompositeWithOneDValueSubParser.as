package away3d.loaders.parsers.particleSubParsers.values.fourD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.fourD.FourDCompositeWithOneDSetter;
   
   public class FourDCompositeWithOneDValueSubParser extends ValueSubParserBase
   {
      
      private var _valueX:ValueSubParserBase;
      
      private var _valueY:ValueSubParserBase;
      
      private var _valueZ:ValueSubParserBase;
      
      private var _valueW:ValueSubParserBase;
      
      public function FourDCompositeWithOneDValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.FourDCompositeWithOneDValueSubParser;
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
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
               if(!_loc4_)
               {
                  dieWithError("Unknown value");
               }
               this._valueX = new _loc4_(null);
               addSubParser(this._valueX);
               this._valueX.parseAsync(_loc3_);
            }
            _loc1_ = _data.y;
            if(_loc1_)
            {
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
            }
            _loc1_ = _data.z;
            if(_loc1_)
            {
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
         var _loc1_:SetterBase = this._valueX ? this._valueX.setter : null;
         var _loc2_:SetterBase = this._valueY ? this._valueY.setter : null;
         var _loc3_:SetterBase = this._valueZ ? this._valueZ.setter : null;
         var _loc4_:SetterBase = this._valueW ? this._valueW.setter : null;
         if((!this._valueX || this._valueX.valueType == CONST_VALUE) && (!this._valueY || this._valueY.valueType == CONST_VALUE) && (!this._valueZ || this._valueZ.valueType == CONST_VALUE) && (!this._valueW || this._valueW.valueType == CONST_VALUE))
         {
            _valueType = CONST_VALUE;
         }
         else
         {
            _valueType = VARIABLE_VALUE;
         }
         _setter = new FourDCompositeWithOneDSetter(_propName,_loc1_,_loc2_,_loc3_,_loc4_);
      }
   }
}

