package net.bigpoint.darkorbit.utils
{
   import away3d.textures.BitmapTexture;
   import away3d.tools.utils.TextureUtils;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BitmapUtils
   {
      
      private static const ROOT_POINT:Point = new Point();
      
      public function BitmapUtils()
      {
         super();
      }
      
      public static function isValidBitmapData(param1:BitmapData) : Boolean
      {
         var returnVal:Boolean = false;
         var bitmapData:BitmapData = param1;
         try
         {
            returnVal = Boolean(bitmapData) && bitmapData.width > 0 && bitmapData.height > 0;
         }
         catch(error:Error)
         {
            returnVal = false;
         }
         return returnVal;
      }
      
      public static function setBitmapDataAlpha(param1:BitmapData, param2:Number) : BitmapData
      {
         var _loc3_:Rectangle = new Rectangle(0,0,param1.width,param1.height);
         var _loc4_:ColorTransform = new ColorTransform();
         _loc4_.alphaMultiplier = param2;
         param1.colorTransform(_loc3_,_loc4_);
         return param1;
      }
      
      public static function scaleBitmapData(param1:BitmapData, param2:Number, param3:Number) : BitmapData
      {
         param2 = Math.abs(param2);
         param3 = Math.abs(param3);
         var _loc4_:int = int(int(param1.width * param2) || 1);
         var _loc5_:int = int(int(param1.height * param3) || 1);
         var _loc6_:Boolean = param1.transparent;
         var _loc7_:BitmapData = new BitmapData(_loc4_,_loc5_,_loc6_,0);
         var _loc8_:Matrix = new Matrix();
         _loc8_.scale(param2,param3);
         _loc7_.draw(param1,_loc8_);
         return _loc7_;
      }
      
      public static function cropBitmapData(param1:BitmapData) : BitmapData
      {
         var _loc2_:Rectangle = param1.getColorBoundsRect(4278190080,0,false);
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,true,0);
         _loc3_.copyPixels(param1,_loc2_,ROOT_POINT);
         return _loc3_;
      }
      
      public static function cropWidthBitmapData(param1:BitmapData) : BitmapData
      {
         var _loc2_:Rectangle = param1.getColorBoundsRect(4278190080,0,false);
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,param1.height,true,0);
         _loc3_.copyPixels(param1,_loc2_,ROOT_POINT);
         return _loc3_;
      }
      
      public static function drawToBitmapData(param1:DisplayObject) : BitmapData
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Matrix = null;
         if(Boolean(param1) && Boolean(param1.width > 0) && param1.height > 0)
         {
            _loc2_ = new BitmapData(param1.width,param1.height,true,0);
            _loc3_ = param1.getBounds(param1);
            _loc4_ = new Matrix(1,0,0,1,-_loc3_.x,-_loc3_.y);
            _loc2_.draw(param1,_loc4_);
            return _loc2_;
         }
         return null;
      }
      
      public static function drawToTexture(param1:DisplayObject) : BitmapTexture
      {
         var _loc2_:BitmapData = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Matrix = null;
         if(Boolean(param1) && Boolean(param1.width > 0) && param1.height > 0)
         {
            _loc2_ = new BitmapData(TextureUtils.getBestPowerOf2(param1.width),TextureUtils.getBestPowerOf2(param1.height),true,0);
            _loc3_ = param1.getBounds(param1);
            _loc4_ = new Matrix(1,0,0,1,-_loc3_.x,-_loc3_.y);
            _loc2_.draw(param1,_loc4_);
            return new BitmapTexture(_loc2_);
         }
         return null;
      }
   }
}

