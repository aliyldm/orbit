package away3d.loaders.parsers.particleSubParsers.values.matrix
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.SetterBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.matrix.Matrix3DCompositeSetter;
   
   public class Matrix3DCompositeValueSubParser extends ValueSubParserBase
   {
      
      private var _transforms:Vector.<ValueSubParserBase> = new Vector.<ValueSubParserBase>();
      
      public function Matrix3DCompositeValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.Matrix3DCompositeValueSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Class = null;
         var _loc5_:Object = null;
         var _loc6_:Array = null;
         var _loc7_:Object = null;
         var _loc8_:ValueSubParserBase = null;
         if(_isFirstParsing)
         {
            _loc6_ = _data.transforms;
            for each(_loc7_ in _loc6_)
            {
               _loc5_ = _loc7_.data;
               _loc3_ = _loc5_.data;
               _loc2_ = _loc5_.id;
               _loc4_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_THREED_VALUES);
               if(!_loc4_)
               {
                  dieWithError("Unknown value parser");
               }
               _loc8_ = new _loc4_(_loc7_.type);
               addSubParser(_loc8_);
               _loc8_.parseAsync(_loc3_);
               this._transforms.push(_loc8_);
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
         var _loc2_:int = 0;
         var _loc1_:Vector.<SetterBase> = new Vector.<SetterBase>();
         while(_loc2_ < this._transforms.length)
         {
            _loc1_.push(this._transforms[_loc2_].setter);
            _loc2_++;
         }
         _setter = new Matrix3DCompositeSetter(_propName,_loc1_);
      }
   }
}

