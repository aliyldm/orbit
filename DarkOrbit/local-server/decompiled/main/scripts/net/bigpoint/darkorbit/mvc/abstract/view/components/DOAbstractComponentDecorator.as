package net.bigpoint.darkorbit.mvc.abstract.view.components
{
   import com.bigpoint.utils.ui.tooltip.TooltipControl;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   
   public class DOAbstractComponentDecorator extends Sprite
   {
      
      protected var _view:DisplayObjectContainer;
      
      protected var _swfFinisher:SWFFinisher;
      
      private var _debugRectContainer:Sprite;
      
      public function DOAbstractComponentDecorator(param1:DisplayObjectContainer, param2:SWFFinisher = null)
      {
         super();
         addChild(this._view = param1);
         this.decorate();
         if(param2)
         {
            this._swfFinisher = param2;
         }
      }
      
      public function decorate() : void
      {
         throw new Error("decorate method invoked in DOAbstractComponentDecorator");
      }
      
      public function updateLayout() : void
      {
         throw new Error("updateLayout method invoked in DOAbstractComponentDecorator");
      }
      
      public function get symbolLinkage() : String
      {
         throw new Error("symbolLinkage method invoked in DOAbstractComponentDecorator");
      }
      
      protected function getSpriteChild(param1:String, param2:Boolean = false) : Sprite
      {
         var _loc3_:Sprite = this._view.getChildByName(param1) as Sprite;
         if(!_loc3_ && !param2)
         {
            throw "sprite child hasn\'t been found: " + param1;
         }
         return this._view.getChildByName(param1) as Sprite;
      }
      
      protected function getTextFieldChild(param1:String, param2:Boolean = false) : TextField
      {
         var _loc3_:TextField = this._view.getChildByName(param1) as TextField;
         if(!_loc3_ && !param2)
         {
            throw "textfield child hasn\'t been found: " + param1;
         }
         return this._view.getChildByName(param1) as TextField;
      }
      
      override public function get x() : Number
      {
         return this._view.x;
      }
      
      override public function set x(param1:Number) : void
      {
         this._view.x = param1;
      }
      
      override public function get y() : Number
      {
         return this._view.y;
      }
      
      override public function set y(param1:Number) : void
      {
         this._view.y = param1;
      }
      
      override public function get width() : Number
      {
         return this._view.width;
      }
      
      override public function get height() : Number
      {
         return this._view.height;
      }
      
      override public function set scaleY(param1:Number) : void
      {
         this._view.scaleY = param1;
      }
      
      override public function get scaleY() : Number
      {
         return this._view.scaleX;
      }
      
      override public function set scaleX(param1:Number) : void
      {
         this._view.scaleX = param1;
      }
      
      override public function get scaleX() : Number
      {
         return this._view.scaleX;
      }
      
      override public function localToGlobal(param1:Point) : Point
      {
         return this.view.localToGlobal(param1);
      }
      
      override public function globalToLocal(param1:Point) : Point
      {
         return this.view.globalToLocal(param1);
      }
      
      public function addViewChild(param1:DisplayObject) : DisplayObject
      {
         if(param1)
         {
            this._view.addChild(param1);
         }
         return param1;
      }
      
      public function addChilViewdAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         return this._view.addChildAt(param1,param2);
      }
      
      public function removeViewChild(param1:DisplayObject) : DisplayObject
      {
         return this._view.removeChild(param1);
      }
      
      public function removeViewChildAt(param1:int) : DisplayObject
      {
         return this._view.removeChildAt(param1);
      }
      
      protected function clear(param1:DisplayObjectContainer) : void
      {
         while(param1.numChildren)
         {
            param1.removeChildAt(0);
         }
      }
      
      override public function set mouseEnabled(param1:Boolean) : void
      {
         this.view.mouseEnabled = param1;
         super.mouseEnabled = param1;
      }
      
      override public function set mouseChildren(param1:Boolean) : void
      {
         this.view.mouseChildren = param1;
         super.mouseChildren = param1;
      }
      
      public function drawDebugRect(param1:Rectangle = null) : void
      {
         if(!param1)
         {
            param1 = new Rectangle(this.x,this.y,this.width,this.height);
         }
         if(!this._debugRectContainer)
         {
            this._debugRectContainer = new Sprite();
            addChild(this._debugRectContainer);
         }
         this.clear(this._debugRectContainer);
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.lineStyle(1,16711680);
         _loc2_.graphics.drawRect(param1.x,param1.y,param1.width,param1.height);
         this._debugRectContainer.addChild(_loc2_);
      }
      
      public function setVisibility(param1:Boolean, param2:DisplayObject, param3:Number = 0.3) : void
      {
         if(param2)
         {
            TweenLite.killTweensOf(param2);
            if(param3 > 0)
            {
               TweenLite.to(param2,param3,{"autoAlpha":int(param1)});
            }
            else
            {
               param2.alpha = param1 ? 1 : 0;
               param2.visible = param1;
            }
         }
      }
      
      public function setVisibilities(param1:Vector.<DisplayObject>, param2:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc3_:* = int(param1.length);
         while(_loc3_--)
         {
            param1[_loc3_].visible = param2;
         }
      }
      
      public function setGreyness(param1:DisplayObject, param2:Number = 0, param3:Number = 1, param4:Number = 1, param5:Number = 0) : void
      {
         TweenMax.to(param1,param5,{
            "colorMatrixFilter":{
               "saturation":param2,
               "brightness":param3
            },
            "alpha":param4
         });
      }
      
      public function get viewNumChildren() : int
      {
         return this._view.numChildren;
      }
      
      protected function get tooltipManager() : TooltipControl
      {
         return TooltipControl.getInstance();
      }
      
      public function get view() : DisplayObjectContainer
      {
         return this._view;
      }
   }
}

