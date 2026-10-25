package away3d.loaders.parsers.particleSubParsers.geometries.shapes
{
   import away3d.core.base.Geometry;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.primitives.CylinderGeometry;
   
   public class CylinderShapeSubParser extends ShapeSubParserBase
   {
      
      private var _geometry:CylinderGeometry;
      
      public function CylinderShapeSubParser()
      {
         super();
         this._geometry = new CylinderGeometry(10,10,10);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.CylinderShapeSubParser;
      }
      
      override public function getGeometry() : Geometry
      {
         return this._geometry;
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(_isFirstParsing)
         {
            this._geometry = new CylinderGeometry(_data.topRadius,_data.bottomRadius,_data.height,_data.segmentsW,1,_data.topClosed,_data.bottomClosed);
         }
         return super.proceedParsing();
      }
   }
}

