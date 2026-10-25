package away3d.textures
{
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.textures.TextureBase;
   
   public class Texture2DBase extends TextureProxyBase
   {
      
      public function Texture2DBase()
      {
         super();
      }
      
      override protected function createTexture(param1:Context3D) : TextureBase
      {
         return param1.createTexture(_width,_height,Context3DTextureFormat.BGRA,false);
      }
   }
}

