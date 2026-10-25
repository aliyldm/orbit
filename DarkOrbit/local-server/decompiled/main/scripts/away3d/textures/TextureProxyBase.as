package away3d.textures
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.errors.AbstractMethodError;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.library.assets.NamedAssetBase;
   import flash.display3D.Context3D;
   import flash.display3D.textures.TextureBase;
   
   use namespace arcane;
   
   public class TextureProxyBase extends NamedAssetBase implements IAsset
   {
      
      protected var _format:String = "bgra";
      
      protected var _hasMipmaps:Boolean = true;
      
      protected var _textures:Vector.<TextureBase>;
      
      protected var _dirty:Vector.<Context3D>;
      
      protected var _width:int;
      
      protected var _height:int;
      
      public function TextureProxyBase()
      {
         super();
         this._textures = new Vector.<TextureBase>(8);
         this._dirty = new Vector.<Context3D>(8);
      }
      
      public function get hasMipMaps() : Boolean
      {
         return this._hasMipmaps;
      }
      
      public function get format() : String
      {
         return this._format;
      }
      
      public function get assetType() : String
      {
         return AssetType.TEXTURE;
      }
      
      public function get width() : int
      {
         return this._width;
      }
      
      public function get height() : int
      {
         return this._height;
      }
      
      public function getTextureForStage3D(param1:Stage3DProxy) : TextureBase
      {
         var _loc2_:int = param1._stage3DIndex;
         var _loc3_:TextureBase = this._textures[_loc2_];
         var _loc4_:Context3D = param1._context3D;
         if(!_loc3_ || this._dirty[_loc2_] != _loc4_)
         {
            this._textures[_loc2_] = _loc3_ = this.createTexture(_loc4_);
            this._dirty[_loc2_] = _loc4_;
            this.uploadContent(_loc3_);
         }
         return _loc3_;
      }
      
      protected function uploadContent(param1:TextureBase) : void
      {
         throw new AbstractMethodError();
      }
      
      protected function setSize(param1:int, param2:int) : void
      {
         if(this._width != param1 || this._height != param2)
         {
            this.invalidateSize();
         }
         this._width = param1;
         this._height = param2;
      }
      
      public function invalidateContent() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            this._dirty[_loc1_] = null;
            _loc1_++;
         }
      }
      
      protected function invalidateSize() : void
      {
         var _loc1_:TextureBase = null;
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            _loc1_ = this._textures[_loc2_];
            if(_loc1_)
            {
               _loc1_.dispose();
               this._textures[_loc2_] = null;
               this._dirty[_loc2_] = null;
            }
            _loc2_++;
         }
      }
      
      protected function createTexture(param1:Context3D) : TextureBase
      {
         throw new AbstractMethodError();
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 8)
         {
            if(this._textures[_loc1_])
            {
               this._textures[_loc1_].dispose();
            }
            _loc1_++;
         }
      }
   }
}

