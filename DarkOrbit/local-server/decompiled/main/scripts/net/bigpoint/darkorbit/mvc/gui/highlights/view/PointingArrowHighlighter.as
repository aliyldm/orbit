package net.bigpoint.darkorbit.mvc.gui.highlights.view
{
   import com.bigpoint.utils.PointLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   import net.bigpoint.darkorbit.managers.ScreenManager;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentDecorator;
   import net.bigpoint.darkorbit.mvc.gui.highlights.model.HighlightItemVO;
   
   public class PointingArrowHighlighter implements IHighLighter
   {
      
      public static const SYMBOL_LINKAGE:String = "pointingArrow";
      
      private static const TWEEN_Y:int = 30;
      
      private static const POINT:Point = new Point();
      
      private var _view:DisplayObjectContainer = new Sprite();
      
      private var _highliteVo:HighlightItemVO;
      
      private var _active:Boolean;
      
      public function PointingArrowHighlighter(param1:DisplayObject)
      {
         super();
         this._view.addChild(param1);
         this._view.mouseEnabled = false;
      }
      
      public function decorateUiElement(param1:Object, param2:HighlightItemVO) : void
      {
         this._highliteVo = param2;
         this._active = true;
         this.checkGlobalPosition(param1 as DOAbstractComponentDecorator);
         var _loc3_:DisplayObjectContainer = ScreenManager.getInstance().mainmenuLayer;
         _loc3_.addChild(this._view);
      }
      
      private function checkGlobalPosition(param1:DOAbstractComponentDecorator) : void
      {
         var _loc2_:PointLite = ScreenManager.getInstance().stageSize;
         var _loc3_:Point = param1.view.localToGlobal(POINT);
         if(_loc3_.y > _loc2_.y * 0.5)
         {
            this.topsideArrow(param1,_loc3_);
         }
         else
         {
            this.bottomsideArrow(param1,_loc3_);
         }
      }
      
      private function bottomsideArrow(param1:DOAbstractComponentDecorator, param2:Point) : void
      {
         this._view.y = param2.y + param1.height + TWEEN_Y;
         this._view.x = param2.x + param1.width * 0.5;
         this._view.rotation = 180;
         this.moveUpAndDown(this.vo.highlightDuration,param1);
      }
      
      private function topsideArrow(param1:DOAbstractComponentDecorator, param2:Point) : void
      {
         this._view.y = param2.y;
         this._view.x = param2.x + param1.width * 0.5;
         this._view.rotation = 0;
         this.moveUpAndDown(this.vo.highlightDuration,param1);
      }
      
      private function moveUpAndDown(param1:Number, param2:DOAbstractComponentDecorator) : void
      {
         if(this._active)
         {
            this._view.alpha = param2.alpha;
            this._view.visible = param2.visible;
            TweenMax.to(this._view,param1,{
               "y":this._view.y - TWEEN_Y,
               "yoyo":true,
               "repeat":1,
               "onComplete":this.checkGlobalPosition,
               "onCompleteParams":[param2]
            });
         }
         else if(this._view.parent)
         {
            this._view.parent.removeChild(this._view);
         }
      }
      
      public function remove() : void
      {
         this._active = false;
      }
      
      public function get vo() : HighlightItemVO
      {
         return this._highliteVo;
      }
      
      public function get expectedClass() : Class
      {
         return DOAbstractComponentDecorator;
      }
   }
}

