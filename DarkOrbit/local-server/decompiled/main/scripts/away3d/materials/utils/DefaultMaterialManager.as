package away3d.materials.utils
{
   import away3d.core.base.IMaterialOwner;
   import away3d.materials.TextureMaterial;
   import away3d.textures.BitmapTexture;
   import flash.display.BitmapData;
   
   public class DefaultMaterialManager
   {
      
      private static var _defaultTextureBitmapData:BitmapData;
      
      private static var _defaultMaterial:TextureMaterial;
      
      private static var _defaultTexture:BitmapTexture;
      
      public function DefaultMaterialManager()
      {
         super();
      }
      
      public static function getDefaultMaterial(param1:IMaterialOwner = null) : TextureMaterial
      {
         if(!_defaultTexture)
         {
            createDefaultTexture();
         }
         if(!_defaultMaterial)
         {
            createDefaultMaterial();
         }
         return _defaultMaterial;
      }
      
      public static function getDefaultTexture(param1:IMaterialOwner = null) : BitmapTexture
      {
         if(!_defaultTexture)
         {
            createDefaultTexture();
         }
         return _defaultTexture;
      }
      
      private static function createDefaultTexture() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _defaultTextureBitmapData = new BitmapData(8,8,false,0);
         _loc1_ = 0;
         while(_loc1_ < 8)
         {
            _loc2_ = 0;
            while(_loc2_ < 8)
            {
               if(_loc2_ & 1 ^ _loc1_ & 1)
               {
                  _defaultTextureBitmapData.setPixel(_loc1_,_loc2_,16777215);
               }
               _loc2_++;
            }
            _loc1_++;
         }
         _defaultTexture = new BitmapTexture(_defaultTextureBitmapData);
         _defaultTexture.name = "defaultTexture";
      }
      
      private static function createDefaultMaterial() : void
      {
         _defaultMaterial = new TextureMaterial(_defaultTexture);
         _defaultMaterial.mipmap = false;
         _defaultMaterial.smooth = false;
         _defaultMaterial.name = "defaultMaterial";
      }
   }
}

