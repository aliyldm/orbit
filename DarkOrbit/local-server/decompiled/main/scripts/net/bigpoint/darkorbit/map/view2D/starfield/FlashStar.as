package net.bigpoint.darkorbit.map.view2D.starfield
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class FlashStar extends Bitmap implements IStar
   {
      
      private var _speed:Number;
      
      private var _starBitmpData:BitmapData;
      
      public function FlashStar()
      {
         super(this._starBitmpData = new BitmapData(1,1,false,0));
      }
      
      public function dispose() : void
      {
         this._starBitmpData.dispose();
      }
      
      public function get speed() : Number
      {
         return this._speed;
      }
      
      public function set speed(param1:Number) : void
      {
         this._speed = param1;
      }
      
      public function set color(param1:uint) : void
      {
         this._starBitmpData.floodFill(0,0,param1);
      }
   }
}

