package away3d.loaders.parsers.particleSubParsers.geometries.shapes
{
   import away3d.arcane;
   import away3d.core.base.Geometry;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.primitives.SphereGeometry;
   
   use namespace arcane;
   
   public class SphereShapeSubParser extends ShapeSubParserBase
   {
      
      private var _geometry:SphereGeometry;
      
      public function SphereShapeSubParser()
      {
         super();
         this._geometry = new SphereGeometry(10,8,8);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.SphereShapeSubParser;
      }
      
      override public function getGeometry() : Geometry
      {
         return this._geometry;
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(_isFirstParsing)
         {
            this._geometry.radius = _data.radius;
            this._geometry.segmentsW = _data.segmentsW;
            this._geometry.segmentsH = _data.segmentsH;
         }
         return super.proceedParsing();
      }
   }
}

