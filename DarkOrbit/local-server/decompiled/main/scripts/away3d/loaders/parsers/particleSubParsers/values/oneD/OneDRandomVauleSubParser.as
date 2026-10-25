package away3d.loaders.parsers.particleSubParsers.values.oneD
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.oneD.OneDRandomSetter;
   
   public class OneDRandomVauleSubParser extends ValueSubParserBase
   {
      
      public function OneDRandomVauleSubParser(param1:String)
      {
         super(param1,VARIABLE_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.OneDRandomVauleSubParser;
      }
      
      override public function parseAsync(param1:*, param2:Number = 30) : void
      {
         super.parseAsync(param1,param2);
         _setter = new OneDRandomSetter(_propName,_data.min,_data.max);
      }
   }
}

