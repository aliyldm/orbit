package away3d.textures
{
   import flash.display3D.Context3D;
   import flash.display3D.textures.CubeTexture;
   import flash.display3D.textures.TextureBase;
   import flash.utils.ByteArray;
   
   public class ATFCubeTexture extends CubeTextureBase
   {
      
      private var _atfData:ATFData;
      
      public function ATFCubeTexture(param1:ByteArray)
      {
         super();
         this.atfData = new ATFData(param1);
         if(this.atfData.type != ATFData.TYPE_CUBE)
         {
            throw new Error("ATF isn\'t cubetexture");
         }
         _format = this.atfData.format;
         _hasMipmaps = this._atfData.numTextures > 1;
      }
      
      public function get atfData() : ATFData
      {
         return this._atfData;
      }
      
      public function set atfData(param1:ATFData) : void
      {
         this._atfData = param1;
         invalidateContent();
         setSize(param1.width,param1.height);
      }
      
      override protected function uploadContent(param1:TextureBase) : void
      {
         CubeTexture(param1).uploadCompressedTextureFromByteArray(this._atfData.data,0,false);
      }
      
      override protected function createTexture(param1:Context3D) : TextureBase
      {
         return param1.createCubeTexture(this._atfData.width,this._atfData.format,false);
      }
   }
}

