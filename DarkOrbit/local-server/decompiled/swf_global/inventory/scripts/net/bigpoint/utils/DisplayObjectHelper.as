package net.bigpoint.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.utils.describeType;
   
   public class DisplayObjectHelper
   {
      
      public function DisplayObjectHelper()
      {
         super();
      }
      
      public static function removeDisplayObject(param1:DisplayObject) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         if(param1)
         {
            _loc2_ = param1.parent;
            if(_loc2_)
            {
               _loc2_.removeChild(param1);
            }
         }
      }
      
      public static function createAndAssignMask(param1:uint, param2:uint, param3:Sprite = null) : Sprite
      {
         var _loc4_:Sprite = new Sprite();
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.beginFill(65280,0.2);
         _loc5_.drawRect(0,0,param1,param2);
         _loc5_.endFill();
         if(param3)
         {
            param3.mask = _loc4_;
         }
         return _loc4_;
      }
      
      public static function kill(param1:*) : void
      {
         var _loc3_:int = 0;
         var _loc2_:XMLList = describeType(param1)..variable;
         while(_loc3_ < _loc2_.length())
         {
            try
            {
               param1[_loc2_[_loc3_].@name] = null;
            }
            catch(e:*)
            {
            }
            _loc3_++;
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
   }
}

