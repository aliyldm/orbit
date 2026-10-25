package net.bigpoint.darkorbit.gui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.filecollection.finish.ImageFinisher;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   
   public class BitmapFont extends Bitmap
   {
      
      private var source:BitmapData;
      
      private var rect:Rectangle;
      
      private var destinationPoint:Point;
      
      public function BitmapFont()
      {
         super();
         this.rect = new Rectangle();
         this.rect.width = 4;
         this.rect.height = 5;
         this.destinationPoint = new Point();
         this.init();
      }
      
      private function init() : void
      {
         this.source = ImageFinisher(ResourceManager.fileCollection.getFinisher("bitmapFont")).getBitmap().bitmapData;
      }
      
      public function setText(param1:String) : void
      {
         var _loc4_:* = 0;
         var _loc5_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = param1.split("");
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = int(_loc3_[_loc4_]);
            if(_loc5_ == 1)
            {
               _loc2_ += 2;
            }
            else
            {
               _loc2_ += 3;
            }
            if(_loc4_ < _loc3_.length - 1)
            {
               _loc2_ += 1;
            }
            _loc4_++;
         }
         this.bitmapData = new BitmapData(_loc2_,5,true,0);
         this.destinationPoint.x = _loc2_;
         var _loc6_:int = -1;
         _loc4_ = int(_loc3_.length - 1);
         while(_loc4_ > -1)
         {
            _loc5_ = int(_loc3_[_loc4_]);
            if(_loc6_ != -1 && _loc6_ == 1)
            {
               this.destinationPoint.x -= 3;
            }
            else
            {
               this.destinationPoint.x -= 4;
            }
            this.rect.x = _loc5_ * 4;
            bitmapData.copyPixels(this.source,this.rect,this.destinationPoint);
            _loc6_ = _loc5_;
            _loc4_--;
         }
      }
   }
}

