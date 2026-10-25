package away3d.textures
{
   import away3d.arcane;
   import away3d.materials.utils.MipmapGenerator;
   import away3d.tools.utils.TextureUtils;
   import flash.display.BitmapData;
   import flash.display3D.textures.Texture;
   import flash.display3D.textures.TextureBase;
   
   use namespace arcane;
   
   public class BitmapTexture extends Texture2DBase
   {
      
      private static var _mipMaps:Array = [];
      
      private static var _mipMapUses:Array = [];
      
      private var _bitmapData:BitmapData;
      
      private var _mipMapHolder:BitmapData;
      
      private var _generateMipmaps:Boolean;
      
      public function BitmapTexture(param1:BitmapData, param2:Boolean = true)
      {
         super();
         this.bitmapData = param1;
         this._generateMipmaps = param2;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         if(param1 == this._bitmapData)
         {
            return;
         }
         if(!TextureUtils.isBitmapDataValid(param1))
         {
            throw new Error("Invalid bitmapData: Width and height must be power of 2 and cannot exceed 2048");
         }
         invalidateContent();
         setSize(param1.width,param1.height);
         this._bitmapData = param1;
         if(this._generateMipmaps)
         {
            this.getMipMapHolder();
         }
      }
      
      override protected function uploadContent(param1:TextureBase) : void
      {
         if(this._generateMipmaps)
         {
            MipmapGenerator.generateMipMaps(this._bitmapData,param1,this._mipMapHolder,true);
         }
         else
         {
            Texture(param1).uploadFromBitmapData(this._bitmapData,0);
         }
      }
      
      private function getMipMapHolder() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = uint(this._bitmapData.width);
         _loc2_ = uint(this._bitmapData.height);
         if(this._mipMapHolder)
         {
            if(this._mipMapHolder.width == _loc1_ && this._bitmapData.height == _loc2_)
            {
               return;
            }
            this.freeMipMapHolder();
         }
         if(!_mipMaps[_loc1_])
         {
            _mipMaps[_loc1_] = [];
            _mipMapUses[_loc1_] = [];
         }
         if(!_mipMaps[_loc1_][_loc2_])
         {
            this._mipMapHolder = _mipMaps[_loc1_][_loc2_] = new BitmapData(_loc1_,_loc2_,true);
            _mipMapUses[_loc1_][_loc2_] = 1;
         }
         else
         {
            _mipMapUses[_loc1_][_loc2_] += 1;
            this._mipMapHolder = _mipMaps[_loc1_][_loc2_];
         }
      }
      
      private function freeMipMapHolder() : void
      {
         var _loc1_:uint = uint(this._mipMapHolder.width);
         var _loc2_:uint = uint(this._mipMapHolder.height);
         if(--_mipMapUses[_loc1_][_loc2_] == 0)
         {
            _mipMaps[_loc1_][_loc2_].dispose();
            _mipMaps[_loc1_][_loc2_] = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._mipMapHolder)
         {
            this.freeMipMapHolder();
         }
      }
   }
}

