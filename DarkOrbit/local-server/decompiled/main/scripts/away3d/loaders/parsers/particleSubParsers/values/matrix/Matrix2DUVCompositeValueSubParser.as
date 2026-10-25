package away3d.loaders.parsers.particleSubParsers.values.matrix
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.matrix.Matrix2DUVCompositeSetter;
   
   public class Matrix2DUVCompositeValueSubParser extends ValueSubParserBase
   {
      
      private var _numColumns:int;
      
      private var _numRows:int;
      
      private var _selectedValue:ValueSubParserBase;
      
      public function Matrix2DUVCompositeValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.Matrix2DUVCompositeValueSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         if(_isFirstParsing)
         {
            this._numColumns = _data.numColumns;
            this._numRows = _data.numRows;
            _loc1_ = _data.selectedValue;
            _loc2_ = _loc1_.id;
            _loc3_ = _loc1_.data;
            _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_ONED_VALUES);
            if(!_loc4_)
            {
               dieWithError("Unknown value");
            }
            this._selectedValue = new _loc4_(null);
            addSubParser(this._selectedValue);
            this._selectedValue.parseAsync(_loc3_);
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
         _setter = new Matrix2DUVCompositeSetter(_propName,this._numColumns,this._numRows,this._selectedValue.setter);
      }
   }
}

