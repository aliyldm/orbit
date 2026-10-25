package away3d.loaders.parsers.particleSubParsers.geometries.shapes
{
   import away3d.arcane;
   import away3d.core.base.Geometry;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class ExternalShapeSubParser extends ShapeSubParserBase
   {
      
      private var _geometry:Geometry;
      
      public function ExternalShapeSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.ExternalShapeSubParser;
      }
      
      override public function getGeometry() : Geometry
      {
         return this._geometry;
      }
      
      override arcane function resolveDependency(param1:ResourceDependency) : void
      {
         var _loc4_:int = 0;
         var _loc5_:IAsset = null;
         var _loc2_:Vector.<IAsset> = param1.assets;
         var _loc3_:int = int(_loc2_.length);
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_[_loc4_];
            if(_loc5_.assetType == AssetType.GEOMETRY)
            {
               this._geometry = _loc5_ as Geometry;
               return;
            }
            _loc4_++;
         }
         dieWithError("resolveDependencyFailure");
      }
      
      override arcane function resolveDependencyFailure(param1:ResourceDependency) : void
      {
         dieWithError("resolveDependencyFailure");
      }
      
      override protected function proceedParsing() : Boolean
      {
         if(_isFirstParsing)
         {
            if(!_data.url)
            {
               dieWithError("no external geometry url");
               return MORE_TO_PARSE;
            }
            addDependency("default",new URLRequest(_data.url));
         }
         return super.proceedParsing();
      }
   }
}

