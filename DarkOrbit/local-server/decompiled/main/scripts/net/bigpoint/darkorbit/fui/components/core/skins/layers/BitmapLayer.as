package net.bigpoint.darkorbit.fui.components.core.skins.layers
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   
   public class BitmapLayer extends Bitmap implements ISkinLayer
   {
      
      public function BitmapLayer(param1:BitmapData = null)
      {
         super(param1);
      }
      
      public function clone() : DisplayObject
      {
         var _loc1_:BitmapLayer = new BitmapLayer(bitmapData.clone());
         _loc1_.scaleX = this.scaleX;
         _loc1_.scaleY = this.scaleY;
         _loc1_.smoothing = this.smoothing;
         _loc1_.x = this.x;
         _loc1_.y = this.y;
         return _loc1_;
      }
      
      public function dispose() : void
      {
         if(this.bitmapData)
         {
            this.bitmapData.dispose();
            this.bitmapData = null;
         }
      }
   }
}

