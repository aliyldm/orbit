package away3d.loaders.parsers.particleSubParsers.values.threeD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.threeD.ThreeDSphereSetter;
   
   public class ThreeDSphereValueSubParser extends ValueSubParserBase
   {
      
      public function ThreeDSphereValueSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ThreeDSphereValueSubParser;
      }
      
      override public function parseAsync(param1:*, param2:Number = 30) : void
      {
         super.parseAsync(param1,param2);
         _setter = new ThreeDSphereSetter(_propName,_data.innerRadius,_data.outerRadius,_data.centerX,_data.centerY,_data.centerZ);
      }
   }
}

