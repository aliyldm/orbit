package net.bigpoint.darkorbit.mvc.gui.highlights.view
{
   import com.greensock.TweenMax;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   import net.bigpoint.darkorbit.utils.MovieClipUtils;
   
   public class RedDotHighlighter implements IHighLighter
   {
      
      private static const POINT:Point = new Point();
      
      private var _view:Sprite = new Sprite();
      
      private var _highliteVo:HighlightItemVO;
      
      private var _intervalPointer:uint;
      
      public function RedDotHighlighter()
      {
         super();
         this.drawDot();
      }
      
      private function drawDot() : void
      {
         var _loc1_:Graphics = this._view.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,16777215);
         _loc1_.beginFill(16711680);
         _loc1_.drawCircle(0,0,4);
         _loc1_.endFill();
      }
      
      public function decorateUiElement(param1:Object, param2:HighlightItemVO) : void
      {
         this._highliteVo = param2;
         this.checkGlobalPosition(param1 as DOAbstractComponentDecorator);
         var _loc3_:DisplayObjectContainer = ScreenManager.getInstance().mainmenuLayer;
         _loc3_.addChild(this._view);
         if(param2.displayTime > 0)
         {
            setTimeout(this.remove,param2.displayTime * 1000);
         }
         clearInterval(this._intervalPointer);
         this._intervalPointer = setInterval(this.checkGlobalPosition,1000,param1);
      }
      
      private function checkGlobalPosition(param1:DOAbstractComponentDecorator) : void
      {
         var _loc2_:Point = null;
         _loc2_ = param1.view.localToGlobal(POINT);
         this._view.y = _loc2_.y + param1.height * 0.25;
         this._view.x = _loc2_.x + param1.width * 0.75;
      }
      
      public function remove() : void
      {
         clearInterval(this._intervalPointer);
         TweenMax.to(this._view,0.3,{
            "alpha":0,
            "onComplete":MovieClipUtils.removeDisplayObject,
            "onCompleteParams":[this._view]
         });
      }
      
      public function get vo() : HighlightItemVO
      {
         return this._highliteVo;
      }
      
      public function get expectedClass() : Class
      {
         return Sprite;
      }
   }
}

