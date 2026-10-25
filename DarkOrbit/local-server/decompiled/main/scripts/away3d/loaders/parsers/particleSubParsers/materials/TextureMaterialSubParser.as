package away3d.loaders.parsers.particleSubParsers.materials
{
   import away3d.arcane;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.loaders.misc.ResourceDependency;
   import away3d.loaders.parsers.particleSubParsers.AllIdentifiers;
   import away3d.materials.MaterialBase;
   import away3d.materials.TextureMaterial;
   import away3d.textures.ATFTexture;
   import away3d.textures.Texture2DBase;
   import flash.net.URLRequest;
   
   use namespace arcane;
   
   public class TextureMaterialSubParser extends MaterialSubParserBase
   {
      
      private var _texture:TextureMaterial;
      
      private var _repeat:Boolean;
      
      private var _smooth:Boolean;
      
      private var _alphaBlending:Boolean;
      
      private var _alphaThreshold:Number = 0;
      
      public function TextureMaterialSubParser()
      {
         super();
      }
      
      public static function get identifier() : *
      {
         return AllIdentifiers.TextureMaterialSubParser;
      }
      
      override protected function proceedParsing() : Boolean
      {
         var _loc1_:URLRequest = null;
         if(_isFirstParsing)
         {
            this._repeat = _data.repeat;
            this._smooth = _data.smooth;
            this._alphaBlending = _data.alphaBlending;
            this._alphaThreshold = _data.alphaThreshold;
            if(!_data.url)
            {
               dieWithError("no texture url");
               return MORE_TO_PARSE;
            }
            _loc1_ = new URLRequest(_data.url);
            addDependency("default1",_loc1_);
         }
         return super.proceedParsing();
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
            if(_loc5_.assetType == AssetType.TEXTURE)
            {
               this._texture = new TextureMaterial(_loc5_ as Texture2DBase,this._smooth,this._repeat);
               this._texture.bothSides = _bothSide;
               this._texture.alphaBlending = this._alphaBlending;
               this._texture.blendMode = _blendMode;
               this._texture.alphaThreshold = this._alphaThreshold;
               this._texture.alphaPremultiplied = !(_loc5_ is ATFTexture);
               finalizeAsset(this._texture);
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
      
      override public function get material() : MaterialBase
      {
         return this._texture;
      }
   }
}

