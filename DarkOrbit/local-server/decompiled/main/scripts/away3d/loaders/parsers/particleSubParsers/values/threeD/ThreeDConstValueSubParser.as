package away3d.loaders.parsers.particleSubParsers.values.threeD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.threeD.ThreeDConstSetter;
   import flash.geom.Vector3D;
   
   public class ThreeDConstValueSubParser extends ValueSubParserBase
   {
      
      public function ThreeDConstValueSubParser(param1:String)
      {
         super(param1,CONST_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ThreeDConstValueSubParser;
      }
      
      override public function parseAsync(param1:*, param2:Number = 30) : void
      {
         super.parseAsync(param1,param2);
         _setter = new ThreeDConstSetter(_propName,new Vector3D(_data.x,_data.y,_data.z));
      }
   }
}

