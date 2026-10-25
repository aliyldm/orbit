package net.bigpoint.darkorbit.mvc.gui.highlights.view
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   
   public class YellowFlashHighlighter implements IHighLighter
   {
      
      protected var _running:Boolean;
      
      protected var _highliteVo:HighlightItemVO;
      
      public function YellowFlashHighlighter()
      {
         super();
      }
      
      public function decorateUiElement(param1:Object, param2:HighlightItemVO) : void
      {
         this._highliteVo = param2;
         this._running = true;
         this.doHighlite(param1 as DisplayObject,param2.highlightDuration);
         if(param2.displayTime > 0)
         {
            setTimeout(this.remove,param2.displayTime * 1000);
         }
      }
      
      protected function doHighlite(param1:DisplayObject, param2:Number) : void
      {
         if(this._running)
         {
            TweenMax.to(param1,param2,{
               "glowFilter":{
                  "color":16776960,
                  "blurX":30,
                  "blurY":30,
                  "strength":1,
                  "alpha":1,
                  "inner":true
               },
               "yoyo":true,
               "repeat":1,
               "onComplete":this.doHighlite,
               "onCompleteParams":[param1,param2]
            });
         }
      }
      
      public function remove() : void
      {
         this._running = false;
      }
      
      public function get vo() : HighlightItemVO
      {
         return this._highliteVo;
      }
      
      public function get expectedClass() : Class
      {
         return DisplayObject;
      }
   }
}

