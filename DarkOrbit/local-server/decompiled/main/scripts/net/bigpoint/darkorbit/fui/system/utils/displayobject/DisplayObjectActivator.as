package net.bigpoint.darkorbit.fui.system.utils.displayobject
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.filters.ColorMatrixFilter;
   
   public class DisplayObjectActivator
   {
      
      public static var greymatrix:Array = [0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0.5,0.5,0.5,0,0,0,0,0,0.65,0];
      
      public static var COLOR_MATRIX_GREY:ColorMatrixFilter = new ColorMatrixFilter(greymatrix);
      
      public static var TWEENMAX_COLORMATRIX_COLORED:Object = {"colorMatrixFilter":{
         "amount":1,
         "saturation":1,
         "brightness":1,
         "contrast":1
      }};
      
      public static var TWEENMAX_COLORMATRIX_COLORLESS:Object = {"colorMatrixFilter":{
         "amount":1,
         "saturation":0,
         "brightness":0.85,
         "contrast":0.9
      }};
      
      public static var TWEENMAX_COLORMATRIX_BLACKANDWHITE:Object = {"colorMatrixFilter":{
         "amount":1,
         "saturation":0,
         "brightness":0,
         "contrast":0.6
      }};
      
      public function DisplayObjectActivator()
      {
         super();
      }
      
      public static function setActivation(param1:Boolean, param2:InteractiveObject, param3:Number = 0.4, param4:Boolean = true, param5:Object = null) : void
      {
         var _loc6_:DisplayObjectContainer = null;
         _loc6_ = param2 as DisplayObjectContainer;
         if((Boolean(_loc6_)) && param4)
         {
            param2.mouseEnabled = param1;
            _loc6_.mouseChildren = param1;
         }
         if(param1)
         {
            if(param5 == null)
            {
               param5 = TWEENMAX_COLORMATRIX_COLORED;
            }
            TweenMax.to(param2,param3,param5);
         }
         else
         {
            if(param5 == null)
            {
               param5 = TWEENMAX_COLORMATRIX_BLACKANDWHITE;
            }
            TweenMax.to(param2,param3,param5);
         }
      }
   }
}

