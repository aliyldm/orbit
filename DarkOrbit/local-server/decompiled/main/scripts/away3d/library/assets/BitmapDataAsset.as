package away3d.library.assets
{
   import flash.display.BitmapData;
   
   public class BitmapDataAsset extends NamedAssetBase implements IAsset
   {
      
      private var _bitmapData:BitmapData;
      
      public function BitmapDataAsset(param1:BitmapData = null)
      {
         super();
         this._bitmapData = param1;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this._bitmapData;
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         this._bitmapData = param1;
      }
      
      public function get assetType() : String
      {
         return AssetType.TEXTURE;
      }
      
      public function dispose() : void
      {
         this._bitmapData.dispose();
      }
   }
}

