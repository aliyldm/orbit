package away3d.loaders.parsers.particleSubParsers.geometries.shapes
{
   import away3d.arcane;
   import away3d.core.base.Geometry;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.primitives.PlaneGeometry;
   
   use namespace arcane;
   
   public class PlaneShapeSubParser extends ShapeSubParserBase
   {
      
      private var _geometry:PlaneGeometry;
      
      public function PlaneShapeSubParser()
      {
         super();
         this._geometry = new PlaneGeometry(10,10,1,1,false);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.PlaneShapeSubParser;
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
         }
         return super.proceedParsing();
      }
   }
}

