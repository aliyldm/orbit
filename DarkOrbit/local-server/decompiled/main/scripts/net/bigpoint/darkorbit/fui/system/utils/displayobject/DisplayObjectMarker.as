package net.bigpoint.darkorbit.fui.system.utils.displayobject
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   
   public class DisplayObjectMarker
   {
      
      public function DisplayObjectMarker()
      {
         super();
      }
      
      public static function mark(param1:Number, param2:DisplayObject, param3:Number = 0.5) : void
      {
         TweenMax.to(param2,param3,{"colorMatrixFilter":{
            "colorize":param1,
            "amount":1,
            "contrast":1.1,
            "brightness":1.1
         }});
      }
      
      public static function markRed(param1:Boolean, param2:DisplayObject, param3:Number = 0.5) : void
      {
         if(param1)
         {
            TweenMax.to(param2,param3,{"colorMatrixFilter":{
               "colorize":16711680,
               "amount":1,
               "contrast":1.1,
               "brightness":1.1
            }});
         }
         else
         {
            TweenMax.to(param2,param3,{"colorMatrixFilter":{
               "colorize":16711680,
               "amount":0,
               "contrast":1,
               "brightness":1
            }});
         }
      }
      
      public static function markGreen(param1:Boolean, param2:DisplayObject, param3:Number = 0.5) : void
      {
         if(param1)
         {
            TweenMax.to(param2,param3,{"colorMatrixFilter":{
               "colorize":65280,
               "amount":1,
               "contrast":1.1,
               "brightness":1.1
            }});
         }
         else
         {
            TweenMax.to(param2,param3,{"colorMatrixFilter":{
               "colorize":65280,
               "amount":0,
               "contrast":1,
               "brightness":1
            }});
         }
      }
      
      public static function markBlue(param1:Boolean, param2:DisplayObject, param3:Number = 0.5) : void
      {
         if(param1)
         {
            TweenMax.to(param2,param3,{"colorMatrixFilter":{
               "colorize":255,
               "amount":1,
               "contrast":1.1,
               "brightness":1.1
            }});
         }
         else
         {
            TweenMax.to(param2,param3,{"colorMatrixFilter":{
               "colorize":255,
               "amount":0,
               "contrast":1,
               "brightness":1
            }});
         }
      }
      
      public static function setContrast(param1:Boolean, param2:DisplayObject, param3:Number = 0.5) : void
      {
         TweenMax.to(param2,param3,{"colorMatrixFilter":{
            "colorize":16777215,
            "contrast":param1,
            "brightness":param1,
            "alpha":param1
         }});
      }
      
      public static function clearMark(param1:DisplayObject, param2:Number = 0.5) : void
      {
         TweenMax.to(param1,param2,{"colorMatrixFilter":{
            "colorize":16777215,
            "amount":0,
            "contrast":1,
            "brightness":1
         }});
      }
   }
}

