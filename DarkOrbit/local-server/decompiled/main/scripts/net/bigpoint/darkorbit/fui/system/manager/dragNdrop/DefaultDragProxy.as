package net.bigpoint.darkorbit.fui.system.manager.dragNdrop
{
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import net.bigpoint.darkorbit.fui.components.core.ICoreponent;
   
   public class DefaultDragProxy extends Sprite implements IDragProxy
   {
      
      protected var _dragStartCoreponent:ICoreponent;
      
      protected var _dragableContainer:Sprite;
      
      protected var _draggables:Vector.<DisplayObject>;
      
      protected var _visualDragables:Vector.<DisplayObject>;
      
      protected var _maxStackableItems:uint = 5;
      
      protected var onDropTweenFinishedCounter:uint;
      
      private var _dragZoneEventHandlingEnabled:Boolean = true;
      
      public function DefaultDragProxy()
      {
         super();
         this.init();
      }
      
      protected function init() : void
      {
         this.name = DragNDropManager.DRAGGER_PROXY_NAME;
         this.mouseChildren = false;
         this.mouseEnabled = false;
         this._dragableContainer = new Sprite();
         this._dragableContainer.filters = [new DropShadowFilter(4,45,0,0.7,2,2,1,3)];
         this.addChild(this._dragableContainer);
      }
      
      public function create() : void
      {
         var _loc1_:uint = 0;
         var _loc9_:DisplayObject = null;
         var _loc10_:BitmapData = null;
         var _loc11_:Bitmap = null;
         this.destroy();
         this._visualDragables = new Vector.<DisplayObject>();
         _loc1_ = this._draggables.length;
         _loc1_ = _loc1_ > this._maxStackableItems ? this._maxStackableItems : _loc1_;
         _loc1_--;
         var _loc2_:ColorTransform = new ColorTransform();
         _loc2_.alphaMultiplier = 1 - _loc1_ * 0.2;
         var _loc3_:Matrix = new Matrix();
         var _loc4_:int = 3;
         var _loc5_:int = 3;
         var _loc6_:uint = _loc1_ * _loc4_;
         var _loc7_:uint = _loc1_ * _loc5_;
         var _loc8_:* = int(_loc1_);
         while(_loc8_ >= 0)
         {
            _loc9_ = this._draggables[_loc8_] as DisplayObject;
            _loc10_ = new BitmapData(100,100,true,16777215);
            _loc3_ = new Matrix();
            _loc3_.translate(_loc6_,_loc7_);
            _loc10_.draw(_loc9_,_loc3_,_loc2_,null,null,true);
            _loc6_ -= _loc4_;
            _loc7_ -= _loc5_;
            _loc2_.alphaMultiplier += 0.2;
            _loc11_ = new Bitmap(_loc10_,PixelSnapping.ALWAYS);
            this._dragableContainer.addChild(_loc11_);
            this._visualDragables.push(_loc11_);
            _loc8_--;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         if(this._visualDragables)
         {
            _loc1_ = this._visualDragables.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = this._visualDragables[_loc2_];
               if(_loc3_)
               {
                  TweenLite.killTweensOf(_loc3_);
               }
               _loc2_++;
            }
         }
         this._visualDragables = null;
         while(this._dragableContainer.numChildren > 0)
         {
            _loc4_ = this._dragableContainer.getChildAt(0);
            if(_loc4_)
            {
               this._dragableContainer.removeChild(_loc4_);
            }
         }
      }
      
      public function onMouseMove() : void
      {
      }
      
      public function onDropFailed() : void
      {
         var _loc7_:DisplayObject = null;
         this.onDropTweenFinishedCounter = 0;
         var _loc1_:uint = this._visualDragables.length;
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 60;
         _loc2_ = this._dragStartCoreponent.globalPosition.x + (this._dragStartCoreponent.width >> 1);
         _loc3_ = this._dragStartCoreponent.globalPosition.y + (this._dragStartCoreponent.height >> 1);
         _loc2_ -= this._dragableContainer.x;
         _loc3_ -= this._dragableContainer.y;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc1_)
         {
            _loc7_ = this._visualDragables[_loc6_] as DisplayObject;
            _loc7_.cacheAsBitmap = true;
            _loc4_ = Math.PI * 2 * Math.random();
            TweenLite.to(_loc7_,0.3,{
               "x":_loc2_,
               "y":_loc3_,
               "alpha":0.1,
               "scaleX":0.5,
               "scaleY":0.5,
               "delay":_loc6_ * 0.03,
               "onComplete":this.onDropTweenFinished
            });
            _loc6_++;
         }
      }
      
      public function onDropSuccess() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc5_:DisplayObject = null;
         this.onDropTweenFinishedCounter = 0;
         var _loc1_:uint = this._visualDragables.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc1_)
         {
            _loc5_ = this._visualDragables[_loc4_] as DisplayObject;
            _loc5_.cacheAsBitmap = true;
            _loc2_ = _loc5_.x + 3;
            _loc3_ = _loc5_.y + 12;
            TweenLite.to(_loc5_,0.3,{
               "x":_loc2_,
               "y":_loc3_,
               "alpha":0.2,
               "scaleX":0.8,
               "scaleY":0.8,
               "onComplete":this.onDropTweenFinished
            });
            _loc4_++;
         }
      }
      
      public function set enableDragZoneEventHandling(param1:Boolean) : void
      {
         this._dragZoneEventHandlingEnabled = param1;
         if(!this._dragZoneEventHandlingEnabled)
         {
            this.dragZoneLeaveTween();
         }
      }
      
      public function onDragZoneEnter() : void
      {
         if(this._dragZoneEventHandlingEnabled)
         {
            this.dragZoneEnterTween();
         }
      }
      
      public function onDragZoneLeave() : void
      {
         if(this._dragZoneEventHandlingEnabled)
         {
            this.dragZoneLeaveTween();
         }
      }
      
      protected function onDropTweenFinished() : void
      {
         ++this.onDropTweenFinishedCounter;
         var _loc1_:uint = this._visualDragables.length;
         if(this.onDropTweenFinishedCounter >= _loc1_)
         {
            this.destroy();
            this.onDropTweenFinishedCounter = 0;
         }
      }
      
      protected function dragZoneEnterTween() : void
      {
         TweenMax.to(this,0.5,{
            "colorMatrixFilter":{
               "amount":1,
               "saturation":2,
               "brightness":1.6,
               "contrast":2
            },
            "glowFilter":{
               "color":16764006,
               "blurX":12,
               "blurY":12,
               "strength":2,
               "alpha":0.8
            },
            "repeat":-1,
            "yoyo":true
         });
      }
      
      protected function dragZoneLeaveTween() : void
      {
         TweenMax.to(this,0.2,{
            "colorMatrixFilter":{
               "amount":1,
               "saturation":1,
               "brightness":1,
               "contrast":1
            },
            "glowFilter":{
               "color":16764006,
               "blurX":0,
               "blurY":0,
               "strength":0,
               "alpha":0
            }
         });
      }
      
      public function set dragables(param1:Vector.<DisplayObject>) : void
      {
         this._draggables = param1;
      }
      
      public function set dragStartCoreponent(param1:ICoreponent) : void
      {
         this._dragStartCoreponent = param1;
      }
      
      override public function set x(param1:Number) : void
      {
         this._dragableContainer.x = param1;
      }
      
      override public function get x() : Number
      {
         return this._dragableContainer.x;
      }
      
      override public function set y(param1:Number) : void
      {
         this._dragableContainer.y = param1;
      }
      
      override public function get y() : Number
      {
         return this._dragableContainer.y;
      }
   }
}

