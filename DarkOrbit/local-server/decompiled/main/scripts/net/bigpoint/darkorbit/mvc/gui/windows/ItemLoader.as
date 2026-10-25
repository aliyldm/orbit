package net.bigpoint.darkorbit.mvc.gui.windows
{
   import flash.display.Bitmap;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   
   public class ItemLoader extends Loadable
   {
      
      private var _bitmap:Bitmap;
      
      public function ItemLoader(param1:String = null)
      {
         super();
         load(param1);
      }
      
      override protected function handleItemLoaded(param1:ImageFinisher = null) : void
      {
         _loadingSpinner.finished();
         this._bitmap = new Bitmap(param1.getBitmap().bitmapData);
         this.addChildAt(this._bitmap,0);
      }
      
      override protected function handleItemLoadError(param1:Object = null) : void
      {
         _loadingSpinner.finished();
      }
      
      public function dispose() : void
      {
         if(this._bitmap)
         {
            this.removeChild(this._bitmap);
            this._bitmap.bitmapData.dispose();
            this._bitmap = null;
         }
      }
   }
}

