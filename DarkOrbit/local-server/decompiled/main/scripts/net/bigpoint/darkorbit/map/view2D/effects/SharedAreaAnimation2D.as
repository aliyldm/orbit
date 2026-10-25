package net.bigpoint.darkorbit.map.view2D.effects
{
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;
   
   public final class SharedAreaAnimation2D
   {
      
      private static var entries:Dictionary = new Dictionary();
      
      private static var hosts:Dictionary = new Dictionary(true);
      
      private static var bytes:uint = 0;
      
      private static const MAX_BYTES:uint = 64 * 1024 * 1024;
      
      private static const MAX_EDGE:int = 384;
      
      public function SharedAreaAnimation2D()
      {
         super();
      }
      
      public static function attach(param1:Sprite, param2:MovieClip) : void
      {
         var _loc4_:Object = null;
         var _loc5_:Bitmap = null;
         var _loc6_:MovieClip = null;
         detach(param1);
         var _loc3_:Class = Object(param2).constructor as Class;
         _loc4_ = entries[_loc3_];
         if(!_loc4_)
         {
            _loc6_ = new _loc3_() as MovieClip;
            _loc6_.stop();
            _loc4_ = entries[_loc3_] = {
               "source":_loc6_,
               "frames":{}
            };
         }
         _loc5_ = new Bitmap(null,"auto",true);
         _loc5_.visible = false;
         param1.addChild(_loc5_);
         hosts[param1] = {
            "entry":_loc4_,
            "mc":param2,
            "bitmap":_loc5_
         };
         TimedEffectClip2D.stop(param2);
      }
      
      public static function detach(param1:Sprite) : void
      {
         var _loc2_:Object = hosts[param1];
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.bitmap.parent)
         {
            _loc2_.bitmap.parent.removeChild(_loc2_.bitmap);
         }
         _loc2_.bitmap.bitmapData = null;
         delete hosts[param1];
      }
      
      public static function tick() : void
      {
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc5_:MovieClip = null;
         var _loc6_:Object = null;
         var _loc7_:MovieClip = null;
         var _loc8_:int = 0;
         var _loc9_:Object = null;
         var _loc10_:Rectangle = null;
         var _loc11_:Number = NaN;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:BitmapData = null;
         var _loc15_:Bitmap = null;
         var _loc1_:int = getTimer();
         var _loc2_:int = 0;
         for(_loc3_ in hosts)
         {
            _loc4_ = hosts[_loc3_];
            _loc5_ = _loc4_.mc;
            _loc6_ = _loc4_.entry;
            _loc7_ = _loc6_.source;
            if(_loc4_.fallback !== true)
            {
               _loc8_ = 1 + int(_loc1_ / 50) * 3 % _loc7_.totalFrames;
               _loc9_ = _loc6_.frames[_loc8_];
               if(!_loc9_ && _loc2_ < 2 && getTimer() - _loc1_ < 3 && bytes < MAX_BYTES)
               {
                  _loc7_.gotoAndStop(_loc8_);
                  _loc10_ = _loc7_.getBounds(_loc7_);
                  _loc10_.inflate(3,3);
                  _loc11_ = Math.min(1,MAX_EDGE / Math.max(1,_loc10_.width,_loc10_.height));
                  _loc12_ = Math.max(1,Math.ceil(_loc10_.width * _loc11_));
                  _loc13_ = Math.max(1,Math.ceil(_loc10_.height * _loc11_));
                  if(bytes + _loc12_ * _loc13_ * 4 <= MAX_BYTES)
                  {
                     _loc14_ = new BitmapData(_loc12_,_loc13_,true,0);
                     _loc14_.draw(_loc7_,new Matrix(_loc11_,0,0,_loc11_,-_loc10_.x * _loc11_,-_loc10_.y * _loc11_),null,null,null,true);
                     _loc9_ = _loc6_.frames[_loc8_] = {
                        "pixels":_loc14_,
                        "x":_loc10_.x,
                        "y":_loc10_.y,
                        "scale":_loc11_
                     };
                     bytes += _loc12_ * _loc13_ * 4;
                     _loc2_++;
                  }
               }
               if(!_loc9_ && bytes >= MAX_BYTES - 4 * MAX_EDGE * MAX_EDGE)
               {
                  _loc4_.fallback = true;
                  _loc4_.bitmap.visible = false;
                  _loc5_.visible = true;
                  TimedEffectClip2D.play(_loc5_,_loc5_,true);
               }
               else if(_loc9_)
               {
                  _loc15_ = _loc4_.bitmap;
                  _loc15_.bitmapData = _loc9_.pixels;
                  _loc15_.x = _loc5_.x + _loc9_.x * _loc5_.scaleX;
                  _loc15_.y = _loc5_.y + _loc9_.y * _loc5_.scaleY;
                  _loc15_.scaleX = _loc5_.scaleX / _loc9_.scale;
                  _loc15_.scaleY = _loc5_.scaleY / _loc9_.scale;
                  _loc15_.alpha = _loc5_.alpha;
                  _loc15_.blendMode = _loc5_.blendMode;
                  _loc15_.visible = true;
                  _loc5_.visible = false;
               }
            }
         }
      }
      
      public static function clear() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for(_loc1_ in hosts)
         {
            detach(_loc1_ as Sprite);
         }
         for each(_loc2_ in entries)
         {
            for each(_loc3_ in _loc2_.frames)
            {
               _loc3_.pixels.dispose();
            }
         }
         entries = new Dictionary();
         hosts = new Dictionary(true);
         bytes = 0;
      }
   }
}

