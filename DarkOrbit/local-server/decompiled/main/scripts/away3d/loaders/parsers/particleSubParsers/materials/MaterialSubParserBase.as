package away3d.loaders.parsers.particleSubParsers.materials
{
   import away3d.arcane;
   import away3d.errors.AbstractMethodError;
   import away3d.loaders.parsers.CompositeParserBase;
   import away3d.materials.MaterialBase;
   
   use namespace arcane;
   
   public class MaterialSubParserBase extends CompositeParserBase
   {
      
      protected var _bothSide:Boolean;
      
      protected var _blendMode:String = "normal";
      
      public function MaterialSubParserBase()
      {
         super();
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(_isFirstParsing)
         {
            this._bothSide = _data.bothSide;
            if(_data.blendMode)
            {
               this._blendMode = _data.blendMode;
            }
         }
         return super.proceedParsing();
      }
      
      public function get material() : MaterialBase
      {
         throw new AbstractMethodError();
      }
   }
}

