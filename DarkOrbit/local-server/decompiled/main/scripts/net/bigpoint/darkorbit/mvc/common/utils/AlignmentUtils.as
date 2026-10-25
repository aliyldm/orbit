package net.bigpoint.darkorbit.mvc.common.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class AlignmentUtils
   {
      
      public static const LEFT:uint = 1;
      
      public static const RIGHT:uint = 2;
      
      public static const CENTER_HORIZONTAL:uint = 8;
      
      public static const TOP:uint = 16;
      
      public static const BOTTOM:uint = 32;
      
      public static const CENTER_VERTICAL:uint = 64;
      
      public function AlignmentUtils()
      {
         super();
      }
      
      public static function align(param1:DisplayObject, param2:uint, param3:Number = 0, param4:Number = 0) : void
      {
         var _loc5_:DisplayObjectContainer = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         if(param1)
         {
            _loc5_ = param1.parent;
            if(_loc5_)
            {
               _loc6_ = uint(param2 & 0x0F);
               switch(_loc6_)
               {
                  default:
                  case LEFT:
                     param1.x = param3;
                     break;
                  case RIGHT:
                     param1.x = _loc5_.width - param1.width - param3;
                     break;
                  case CENTER_HORIZONTAL:
                     param1.x = (_loc5_.width - param1.width >> 1) + param3;
               }
               _loc7_ = uint(param2 & 0xF0);
               switch(_loc7_)
               {
                  default:
                  case TOP:
                     param1.y = param4;
                     break;
                  case BOTTOM:
                     param1.y = _loc5_.height - param1.height - param4;
                     break;
                  case CENTER_VERTICAL:
                     param1.y = (_loc5_.height - param1.height >> 1) + param4;
               }
            }
         }
      }
   }
}

