package away3d.loaders.parsers
{
   import away3d.arcane;
   import away3d.core.base.ParticleGeometry;
   import away3d.loaders.parsers.particleSubParsers.AllSubParsers;
   import away3d.loaders.parsers.particleSubParsers.geometries.GeometrySubParserBase;
   import away3d.loaders.parsers.particleSubParsers.utils.MatchingTool;
   
   use namespace arcane;
   
   public class ParticleGeometryParser extends CompositeParserBase
   {
      
      private var _assembler:GeometrySubParserBase;
      
      public function ParticleGeometryParser()
      {
         super();
      }
      
      public static function supportsType(param1:String) : Boolean
      {
         param1 = param1.toLowerCase();
         return param1 == "pag";
      }
      
      public static function supportsData(param1:*) : Boolean
      {
         return false;
      }
      
      public function get particleGeometry() : ParticleGeometry
      {
         return this._assembler.particleGeometry;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:Class = null;
         if(_isFirstParsing)
         {
            _loc1_ = _data.assembler.data;
            _loc2_ = _data.assembler.id;
            _loc3_ = MatchingTool.getMatchedClass(_loc2_,AllSubParsers.ALL_GEOMETRIES);
            if(!_loc3_)
            {
               dieWithError("Unknown geometry assembler");
            }
            this._assembler = new _loc3_();
            addSubParser(this._assembler);
            this._assembler.parseAsync(_loc1_);
         }
         return super.proceedParsing();
      }
   }
}

