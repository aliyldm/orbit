package com.bigpoint.utils
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.utils.BitmapUtils;
   
   public class BitmapAtlas
   {
      
      private static const TEXTURE_ATLAS_PREFIX:String = "SubTexture";
      
      private var _atlas:Dictionary;
      
      public function BitmapAtlas(param1:Bitmap, param2:XML)
      {
         super();
         this.init(param1,param2);
      }
      
      private function init(param1:Bitmap, param2:XML) : void
      {
         var _loc3_:XML = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:BitmapData = null;
         this._atlas = new Dictionary();
         for each(_loc3_ in param2.child(TEXTURE_ATLAS_PREFIX))
         {
            _loc4_ = _loc3_.attribute("name");
            _loc5_ = int(_loc3_.attribute("width"));
            _loc6_ = int(_loc3_.attribute("height"));
            _loc7_ = new Rectangle(int(_loc3_.attribute("x")),int(_loc3_.attribute("y")),_loc5_,_loc6_);
            _loc8_ = new BitmapData(_loc5_,_loc6_);
            _loc8_.copyPixels(param1.bitmapData,_loc7_,new Point(0,0));
            this._atlas[_loc4_] = _loc8_;
         }
      }
      
      public function getBitmapDataByName(param1:String, param2:Boolean = false) : BitmapData
      {
         var _loc3_:BitmapData = this._atlas[param1] as BitmapData;
         if(_loc3_)
         {
            if(param2)
            {
               _loc3_ = BitmapUtils.cropBitmapData(_loc3_);
            }
         }
         return _loc3_;
      }
   }
}

