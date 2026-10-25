package away3d.loaders.parsers.particleSubParsers.values.color
{
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.loaders.parsers.particleSubParsers.values.ValueSubParserBase;
   import away3d.loaders.parsers.particleSubParsers.values.setters.color.ConstColorSetter;
   import flash.geom.ColorTransform;
   
   public class ConstColorValueSubParser extends ValueSubParserBase
   {
      
      public function ConstColorValueSubParser(param1:String)
      {
         super(param1,CONST_VALUE);
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ConstColorValueSubParser;
      }
      
      override public function parseAsync(param1:*, param2:Number = 30) : void
      {
         super.parseAsync(param1,param2);
         _setter = new ConstColorSetter(_propName,this.extractColor(param1));
      }
      
      private function extractColor(param1:Object) : ColorTransform
      {
         var _loc2_:ColorTransform = new ColorTransform();
         if(param1.hasOwnProperty("mr"))
         {
            _loc2_.redMultiplier = param1.mr;
         }
         if(param1.hasOwnProperty("mg"))
         {
            _loc2_.greenMultiplier = param1.mg;
         }
         if(param1.hasOwnProperty("mb"))
         {
            _loc2_.blueMultiplier = param1.mb;
         }
         if(param1.hasOwnProperty("ma"))
         {
            _loc2_.alphaMultiplier = param1.ma;
         }
         if(param1.hasOwnProperty("or"))
         {
            _loc2_.redOffset = param1.or;
         }
         if(param1.hasOwnProperty("og"))
         {
            _loc2_.greenOffset = param1.og;
         }
         if(param1.hasOwnProperty("ob"))
         {
            _loc2_.blueOffset = param1.ob;
         }
         if(param1.hasOwnProperty("oa"))
         {
            _loc2_.alphaOffset = param1.oa;
         }
         return _loc2_;
      }
   }
}

