package away3d.textures
{
   import away3d.materials.utils.MipmapGenerator;
   import away3d.tools.utils.TextureUtils;
   import flash.display.BitmapData;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DTextureFormat;
   import flash.display3D.textures.TextureBase;
   
   public class RenderTexture extends Texture2DBase
   {
      
      public function RenderTexture(param1:Number, param2:Number)
      {
         super();
         setSize(param1,param2);
      }
      
      public function set width(param1:int) : void
      {
         if(param1 == _width)
         {
            return;
         }
         if(!TextureUtils.isDimensionValid(param1))
         {
            throw new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048");
         }
         invalidateContent();
         setSize(param1,_height);
      }
      
      public function set height(param1:int) : void
      {
         if(param1 == _height)
         {
            return;
         }
         if(!TextureUtils.isDimensionValid(param1))
         {
            throw new Error("Invalid size: Width and height must be power of 2 and cannot exceed 2048");
         }
         invalidateContent();
         setSize(_width,param1);
      }
      
      override protected function uploadContent(param1:TextureBase) : void
      {
         var _loc2_:BitmapData = new BitmapData(width,height,false,16711680);
         MipmapGenerator.generateMipMaps(_loc2_,param1);
         _loc2_.dispose();
      }
      
      override protected function createTexture(param1:Context3D) : TextureBase
      {
         return param1.createTexture(width,height,Context3DTextureFormat.BGRA,true);
      }
   }
}

