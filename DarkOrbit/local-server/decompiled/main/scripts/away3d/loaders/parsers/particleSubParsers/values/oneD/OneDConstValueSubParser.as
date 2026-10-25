package away3d.loaders.parsers.particleSubParsers.values.oneD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.oneD.OneDConstSetter;
   
   public class OneDConstValueSubParser extends ValueSubParserBase
   {
      
      public function OneDConstValueSubParser(param1:String)
      {
         super(param1,CONST_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.OneDConstValueSubParser;
      }
      
      override public function parseAsync(param1:*, param2:Number = 30) : void
      {
         super.parseAsync(param1,param2);
         _setter = new OneDConstSetter(_propName,_data.value);
      }
   }
}

