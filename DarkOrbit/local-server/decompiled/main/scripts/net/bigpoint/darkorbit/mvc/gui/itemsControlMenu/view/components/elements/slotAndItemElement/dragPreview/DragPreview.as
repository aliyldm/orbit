package net.bigpoint.darkorbit.mvc.gui.itemsControlMenu.view.components.elements.slotAndItemElement.dragPreview
{
   import com.bigpoint.utils.drag.IDragablePreview;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Back;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import net.bigpoint.as3toolbox.filecollection.finish.SWFFinisher;
   import net.bigpoint.darkorbit.mvc.abstract.view.components.DOAbstractComponentInstance;
   
   public class DragPreview extends DOAbstractComponentInstance implements IDragablePreview
   {
      
      private static const LINKAGE:String = "slotAndItemDragPreview";
      
      private static const DRAG_STATE:String = "dragState";
      
      private static const VALID_DROP_STATE:String = "validDropState";
      
      private static const INVALID_DROP_STATE:String = "invalidDropState";
      
      private var _itemShanpshot:Bitmap;
      
      public var dragState:Sprite;
      
      public var validDropState:Sprite;
      
      public var invalidDropState:Sprite;
      
      public function DragPreview(param1:SWFFinisher, param2:Bitmap)
      {
         this._itemShanpshot = param2;
         super(param1,this.symbolLinkage);
         mouseChildren = false;
         setVisibility(false,this.validDropState,0);
         setVisibility(false,this.invalidDropState,0);
         setVisibility(false,this.dragState,0);
         setVisibility(true,this.dragState,1);
      }
      
      override public function decorate() : void
      {
         addViewChild(this._itemShanpshot);
         addViewChild(this.validDropState = getSpriteChild(VALID_DROP_STATE));
         addViewChild(this.invalidDropState = getSpriteChild(INVALID_DROP_STATE));
         addViewChild(this.dragState = getSpriteChild(DRAG_STATE));
         this._itemShanpshot.x = -this._itemShanpshot.width / 2;
         this._itemShanpshot.y = -this._itemShanpshot.height / 2;
      }
      
      public function dropAccept(param1:Function) : void
      {
         mouseEnabled = false;
         setVisibility(false,this.dragState,0.2);
         this.validDropState.alpha = 1;
         this.validDropState.visible = true;
         TweenMax.to(this.validDropState,0.5,{
            "scaleX":1.4,
            "scaleY":1.4,
            "autoAlpha":0,
            "onUpdate":this.onUpdate,
            "onComplete":param1
         });
      }
      
      private function onUpdate() : void
      {
         var _loc1_:Number = this._itemShanpshot.width - this.validDropState.width >> 1;
         var _loc2_:Number = this._itemShanpshot.height - this.validDropState.height >> 1;
         this.validDropState.x = this._itemShanpshot.x + _loc1_;
         this.validDropState.y = this._itemShanpshot.y + _loc2_;
      }
      
      public function dropNotAccept(param1:Function, param2:Point = null) : void
      {
         if(param2)
         {
            TweenMax.to(this,0.5,{
               "x":param2.x + this.dropOffset.x,
               "y":param2.y + this.dropOffset.y,
               "autoAlpha":0,
               "onComplete":param1
            });
         }
         else
         {
            mouseEnabled = false;
            setVisibility(true,this.invalidDropState,0.2);
            setVisibility(false,this.dragState,0.2);
            TweenLite.to(this,1,{
               "delay":0.2,
               "y":this.y + 30,
               "autoAlpha":0,
               "onComplete":param1,
               "ease":Back.easeOut
            });
         }
      }
      
      public function dispose() : void
      {
         TweenLite.killDelayedCallsTo(this);
         TweenLite.killTweensOf(this);
         TweenLite.killDelayedCallsTo(this.validDropState);
         TweenLite.killTweensOf(this.validDropState);
      }
      
      public function get asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      override public function get symbolLinkage() : String
      {
         return LINKAGE;
      }
      
      public function get itemShanpshot() : Bitmap
      {
         return this._itemShanpshot;
      }
      
      public function get snapToDropTarget() : Boolean
      {
         return true;
      }
      
      public function get dropOffset() : Point
      {
         return new Point(this._itemShanpshot.width / 2,this._itemShanpshot.height / 2);
      }
   }
}

