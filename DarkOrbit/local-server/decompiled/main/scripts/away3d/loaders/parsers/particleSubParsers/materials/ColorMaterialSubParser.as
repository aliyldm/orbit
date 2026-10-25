package away3d.loaders.parsers.particleSubParsers.materials
{
   import away3d.arcane;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.materials.ColorMaterial;
   import away3d.materials.MaterialBase;
   
   use namespace arcane;
   
   public class ColorMaterialSubParser extends MaterialSubParserBase
   {
      
      private var _colorMaterial:ColorMaterial = new ColorMaterial();
      
      public function ColorMaterialSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ColorMaterialSubParser;
      }
      
      override public function parseAsync(param1:*, param2:Number = 30) : void
      {
         super.parseAsync(param1,param2);
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(super.proceedParsing() == PARSING_DONE)
         {
            this._colorMaterial.color = _data.color;
            this._colorMaterial.alpha = _data.alpha;
            this._colorMaterial.bothSides = _bothSide;
            this._colorMaterial.blendMode = _blendMode;
            this._colorMaterial.alphaPremultiplied = false;
            return PARSING_DONE;
         }
         return MORE_TO_PARSE;
      }
      
      override public function get material() : MaterialBase
      {
         return this._colorMaterial;
      }
   }
}

