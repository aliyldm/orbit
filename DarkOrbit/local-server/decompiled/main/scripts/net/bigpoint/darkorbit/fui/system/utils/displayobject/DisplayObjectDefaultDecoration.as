package net.bigpoint.darkorbit.fui.system.utils.displayobject
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import net.bigpoint.darkorbit.managers.ResourceManager;
   import net.bigpoint.darkorbit.mvc.traininggrounds.view.TraininggroundsResultsConstants;
   
   public class DisplayObjectDefaultDecoration
   {
      
      public static const FILTER_DROP_SHADOW:DropShadowFilter = new DropShadowFilter(7,90,0,0.75,4,7,2,BitmapFilterQuality.HIGH);
      
      public static const FILTER_GLOW_LIGHT_BLUE:Array = [new GlowFilter(4520959,0.75,5,5,2)];
      
      public static const FILTER_GLOW_ORANGE:Array = [new GlowFilter(16740864,0.75,12,12,2,1)];
      
      public function DisplayObjectDefaultDecoration()
      {
         super();
      }
      
      public static function setShadow(param1:DisplayObject) : void
      {
         param1.filters = param1.filters.concat([FILTER_DROP_SHADOW]);
      }
      
      public static function addLightBlueGlow(param1:DisplayObject) : void
      {
         param1.filters = param1.filters.concat(FILTER_GLOW_LIGHT_BLUE);
      }
      
      public static function addOrangeGlowShadow(param1:DisplayObject) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         param1.filters = param1.filters.concat(FILTER_GLOW_ORANGE);
         if(param1 is DisplayObjectContainer)
         {
            _loc2_ = new Sprite();
            _loc3_ = new Sprite();
            _loc3_.addChild(_loc2_);
            _loc2_.graphics.clear();
            _loc2_.graphics.beginBitmapFill(ResourceManager.getBitmapData(TraininggroundsResultsConstants.RESULT_LIB,"white_yellow_gradient"));
            _loc2_.graphics.drawRect(0,0,param1.width,param1.height);
            _loc2_.graphics.endFill();
            (param1 as DisplayObjectContainer).addChild(_loc3_);
            _loc3_.mask = (param1 as DisplayObjectContainer).getChildAt(0);
         }
      }
   }
}

