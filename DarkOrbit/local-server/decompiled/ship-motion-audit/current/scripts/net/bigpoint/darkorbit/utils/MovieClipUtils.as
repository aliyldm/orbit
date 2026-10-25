package net.bigpoint.darkorbit.utils
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import net.bigpoint.as3toolbox.bitmapclip.BitmapClip;
   
   public class MovieClipUtils
   {
      
      public static const TYPE_SHIP:int = 1;
      
      public function MovieClipUtils()
      {
         super();
      }
      
      public static function duplicateDisplayObject(param1:DisplayObject, param2:Boolean = false) : DisplayObject
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         var _loc3_:Class = Class(Object(param1).constructor);
         _loc4_ = new _loc3_();
         _loc4_.transform = param1.transform;
         _loc4_.filters = param1.filters;
         _loc4_.cacheAsBitmap = param1.cacheAsBitmap;
         _loc4_.opaqueBackground = param1.opaqueBackground;
         if(param1.scale9Grid)
         {
            _loc5_ = param1.scale9Grid;
            _loc4_.scale9Grid = _loc5_;
         }
         if(param2 && Boolean(param1.parent))
         {
            param1.parent.addChild(_loc4_);
         }
         return _loc4_;
      }
      
      public static function movieClipMaxHeight(param1:MovieClip, param2:int = 0) : int
      {
         var _loc5_:int = 0;
         var _loc3_:int = -1;
         var _loc4_:int = param1.currentFrame;
         if(param2 == MovieClipUtils.TYPE_SHIP)
         {
            param1.gotoAndStop(1);
            _loc3_ = param1.height;
            param1.gotoAndStop(9);
            _loc3_ = Math.max(_loc3_,param1.height);
         }
         else
         {
            _loc5_ = 1;
            while(_loc5_ <= param1.framesLoaded)
            {
               param1.gotoAndStop(_loc5_);
               _loc3_ = Math.max(_loc3_,param1.height);
               _loc5_++;
            }
         }
         param1.gotoAndStop(_loc4_);
         return _loc3_;
      }
      
      public static function cleanupDisplayObjectContainer(param1:DisplayObjectContainer) : void
      {
         while(param1.numChildren > 0)
         {
            param1.removeChildAt(0);
         }
      }
      
      public static function movieClipMaxWidth(param1:MovieClip, param2:int = 0) : int
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = param1.currentFrame;
         if(param2 == MovieClipUtils.TYPE_SHIP)
         {
            param1.gotoAndStop(1);
            _loc3_ = param1.width;
            param1.gotoAndStop(9);
            _loc3_ = Math.max(_loc3_,param1.width);
         }
         else
         {
            _loc5_ = 1;
            while(_loc5_ <= param1.framesLoaded)
            {
               param1.gotoAndStop(_loc5_);
               _loc3_ = Math.max(_loc3_,param1.width);
               _loc5_++;
            }
         }
         param1.gotoAndStop(_loc4_);
         return _loc3_;
      }
      
      public static function playAllBitmapClipsInLayer(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         if(param1.stage)
         {
            _loc2_ = param1.numChildren;
            _loc4_ = 0;
            while(_loc4_ < _loc2_)
            {
               _loc3_ = param1.getChildAt(_loc4_);
               if(_loc3_ is BitmapClip)
               {
                  (_loc3_ as BitmapClip).play();
               }
               _loc4_++;
            }
         }
      }
      
      public static function scale(param1:DisplayObject, param2:Number) : void
      {
         param1.scaleX = param2;
         param1.scaleY = param2;
      }
      
      public static function removeDisplayObject(param1:DisplayObject) : void
      {
         if(param1)
         {
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
         }
      }
      
      public static function stopAllMovieClipsInsideDisplayObjectContainer(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = param1.numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1.getChildAt(_loc4_);
            if(_loc3_ is DisplayObjectContainer)
            {
               stopAllMovieClipsInsideDisplayObjectContainer(_loc3_ as DisplayObjectContainer);
               if(_loc3_ is MovieClip)
               {
                  (_loc3_ as MovieClip).gotoAndStop(1);
               }
            }
            _loc4_++;
         }
      }
      
      public static function playAllMovieClipsInsideDisplayObjectContainer(param1:DisplayObjectContainer) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:int = param1.numChildren;
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            _loc3_ = param1.getChildAt(_loc4_);
            if(_loc3_ is DisplayObjectContainer)
            {
               playAllMovieClipsInsideDisplayObjectContainer(_loc3_ as DisplayObjectContainer);
               if(_loc3_ is MovieClip)
               {
                  (_loc3_ as MovieClip).play();
               }
            }
            _loc4_++;
         }
      }
      
      public static function drawBounds(param1:DisplayObject, param2:uint = 16711935, param3:uint = 65280) : void
      {
         var _loc4_:Graphics = null;
         if(param1 is Shape)
         {
            _loc4_ = Shape(param1).graphics;
         }
         else
         {
            if(!(param1 is Sprite))
            {
               return;
            }
            _loc4_ = (param1 as Sprite).graphics;
         }
         _loc4_.clear();
         _loc4_.lineStyle(2,param2);
         var _loc5_:Rectangle = param1.getBounds(param1);
         _loc4_.drawRect(_loc5_.x,_loc5_.y,_loc5_.width,_loc5_.height);
         _loc4_.lineStyle(2,param3);
         _loc4_.drawCircle(0,0,4);
      }
      
      public static function playAnimation(param1:DisplayObject, param2:int = 30, param3:Boolean = false, param4:int = 1, param5:Boolean = true) : void
      {
         var _loc6_:int = 0;
         if(param1 is MovieClip)
         {
            _loc6_ = MovieClip(param1).framesLoaded;
            MovieClip(param1).gotoAndStop(param4);
         }
         else if(param1 is BitmapClip)
         {
            _loc6_ = BitmapClip(param1).framesLoaded;
            BitmapClip(param1).gotoAndStop(param4);
         }
         var _loc7_:Number = _loc6_ / param2;
         if(param3)
         {
            TweenLite.to(param1,_loc7_,{
               "ease":Linear.easeNone,
               "frame":_loc6_,
               "onComplete":playAnimation,
               "onCompleteParams":[param1,param2,param3]
            });
         }
         else if(param5)
         {
            TweenLite.to(param1,_loc7_,{
               "ease":Linear.easeNone,
               "frame":_loc6_,
               "onComplete":onRemoveDisplayObject,
               "onCompleteParams":[param1]
            });
         }
         else
         {
            TweenLite.to(param1,_loc7_,{
               "ease":Linear.easeNone,
               "frame":_loc6_
            });
         }
      }
      
      public static function stopAnimation(param1:DisplayObject) : void
      {
         TweenLite.killTweensOf(param1);
      }
      
      public static function fadeInClip(param1:Number, param2:DisplayObject) : void
      {
         TweenLite.to(param2,param1,{
            "ease":Linear.easeNone,
            "alpha":1
         });
      }
      
      public static function fadeOutClip(param1:Number, param2:DisplayObject) : void
      {
         TweenLite.to(param2,param1,{
            "ease":Linear.easeNone,
            "alpha":0,
            "onComplete":onRemoveDisplayObject,
            "onCompleteParams":[param2]
         });
      }
      
      public static function onRemoveDisplayObject(param1:DisplayObject) : void
      {
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         TweenLite.killTweensOf(param1);
      }
      
      public static function isMouseOver(param1:DisplayObject) : Boolean
      {
         return param1.mouseX > param1.x - param1.width * 0.5 && param1.mouseX < param1.x + param1.width * 0.5 && param1.mouseY > param1.y - param1.height * 0.5 && param1.mouseY < param1.y + param1.height * 0.5;
      }
   }
}

