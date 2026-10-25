package away3d.loaders.parsers.particleSubParsers.values
{
   import away3d.loaders.parsers.CompositeParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   
   public class ValueSubParserBase extends CompositeParserBase
   {
      
      public static const CONST_VALUE:int = 0;
      
      public static const VARIABLE_VALUE:int = 1;
      
      protected var _propName:String;
      
      protected var _valueType:int;
      
      protected var _setter:SetterBase;
      
      public function ValueSubParserBase(param1:String, param2:int)
      {
         this._propName = param1;
         this._valueType = param2;
         super();
      }
      
      public function get valueType() : int
      {
         return this._valueType;
      }
      
      public function get setter() : SetterBase
      {
         return this._setter;
      }
   }
}

