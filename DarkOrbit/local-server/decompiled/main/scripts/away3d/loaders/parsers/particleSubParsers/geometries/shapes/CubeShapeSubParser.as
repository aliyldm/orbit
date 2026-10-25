package away3d.loaders.parsers.particleSubParsers.geometries.shapes
{
   import away3d.arcane;
   import away3d.core.base.Geometry;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.primitives.CubeGeometry;
   
   use namespace arcane;
   
   public class CubeShapeSubParser extends ShapeSubParserBase
   {
      
      private var _geometry:CubeGeometry;
      
      public function CubeShapeSubParser()
      {
         super();
         this._geometry = new CubeGeometry(10,10,10);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.CubeShapeSubParser;
      }
      
      override public function getGeometry() : Geometry
      {
         return this._geometry;
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(_isFirstParsing)
         {
            this._geometry.width = _data.width;
            this._geometry.height = _data.height;
            this._geometry.depth = _data.depth;
         }
         return super.proceedParsing();
      }
   }
}

