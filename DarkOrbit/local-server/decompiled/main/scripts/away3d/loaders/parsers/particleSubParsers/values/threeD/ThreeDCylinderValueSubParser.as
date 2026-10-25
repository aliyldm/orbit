package away3d.loaders.parsers.particleSubParsers.values.threeD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.threeD.ThreeDCylinderSetter;
   
   public class ThreeDCylinderValueSubParser extends ValueSubParserBase
   {
      
      public function ThreeDCylinderValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ThreeDCylinderValueSubParser;
      }
      
      override public function parseAsync(param1:*, param2:Number = 30) : void
      {
         super.parseAsync(param1,param2);
         _setter = new ThreeDCylinderSetter(_propName,_data.innerRadius,_data.outerRadius,_data.height,_data.centerX,_data.centerY,_data.centerZ,_data.dX,_data.dY,_data.dZ);
      }
   }
}

