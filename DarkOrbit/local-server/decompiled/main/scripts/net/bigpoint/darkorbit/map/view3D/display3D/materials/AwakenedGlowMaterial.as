package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.textures.BitmapTexture;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.geom.ColorTransform;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.methods.UberMaterialMethod;
   
   public class AwakenedGlowMaterial extends EntityXRayMaterial
   {
      
      public static const offsetBitmapData:BitmapData = new BitmapData(128,128,false,0);
      
      public static const colorBitmapData:BitmapData = new BitmapData(128,128,false,0);
      
      colorBitmapData.perlinNoise(32,32,8,Math.random() * 1000,true,false,BitmapDataChannel.BLUE | BitmapDataChannel.RED);
      colorBitmapData.colorTransform(colorBitmapData.rect,new ColorTransform(0.3,0.6,0,1));
      offsetBitmapData.perlinNoise(32,32,8,Math.random() * 1000,true,false,7,true);
      
      private var _uberMethod:UberMaterialMethod;
      
      public function AwakenedGlowMaterial()
      {
         super();
         this._uberMethod = new UberMaterialMethod(new BitmapTexture(colorBitmapData,true),new BitmapTexture(offsetBitmapData,true));
         addMethod(this._uberMethod);
      }
      
      public function get uber() : UberMaterialMethod
      {
         return this._uberMethod;
      }
   }
}

