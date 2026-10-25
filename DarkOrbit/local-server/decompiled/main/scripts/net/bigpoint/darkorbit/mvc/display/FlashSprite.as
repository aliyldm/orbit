package net.bigpoint.darkorbit.mvc.display
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class FlashSprite extends Sprite implements IDisplayObject
   {
      
      public function FlashSprite()
      {
         super();
      }
      
      public function addUntypedChild(param1:Object) : void
      {
         if(this.isCorrectDisplayObject(param1))
         {
            addChild(param1 as DisplayObject);
         }
      }
      
      public function removeUntypedChild(param1:Object, param2:Boolean = true) : Object
      {
         if(param1 is DisplayObject)
         {
            return removeChild(param1 as DisplayObject);
         }
         return null;
      }
      
      public function removeUntypedChildAt(param1:int, param2:Boolean = true) : Object
      {
         return removeChildAt(param1);
      }
      
      public function removeFromParent(param1:Boolean = true) : void
      {
         var _loc2_:Boolean = false;
         if(this.isCorrectDisplayObject(this.untypedParent))
         {
            _loc2_ = Boolean(this.untypedParent.contains(this));
            if(_loc2_)
            {
               this.untypedParent.removeUntypedChild(this);
            }
         }
      }
      
      public function containsUntypedChild(param1:Object) : Boolean
      {
         return false;
      }
      
      public function dispatchUntypedEvent(param1:Object) : Boolean
      {
         if(this.isCorrectEvent(param1))
         {
            dispatchEvent(param1 as Event);
         }
         return true;
      }
      
      public function isCorrectDisplayObject(param1:Object) : Boolean
      {
         return param1 is DisplayObject;
      }
      
      public function isCorrectEvent(param1:Object) : Boolean
      {
         return param1 is Event;
      }
      
      public function addUntypedEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeUntypedEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         removeEventListener(param1,param2,param3);
      }
      
      public function get untypedParent() : Object
      {
         return parent;
      }
      
      public function getUntypedBounds(param1:Object, param2:Rectangle = null) : Rectangle
      {
         if(this.isCorrectDisplayObject(param1))
         {
            return getBounds(param1 as DisplayObject);
         }
         return null;
      }
      
      public function get rotationUntyped() : Number
      {
         return rotation;
      }
      
      public function set rotationUntyped(param1:Number) : void
      {
         rotation = param1;
      }
      
      public function disposeAll(param1:Object = null) : void
      {
         var _loc2_:DisplayObjectContainer = null;
         if(param1 == null)
         {
            param1 = this;
         }
         if(this.isCorrectDisplayObject(param1))
         {
            _loc2_ = param1 as DisplayObjectContainer;
            if(_loc2_)
            {
               while(_loc2_.numChildren)
               {
                  _loc2_.removeChildAt(0);
               }
            }
            this.removeFromParent();
         }
      }
      
      public function get transformationMatrix() : Matrix
      {
         return transform.matrix;
      }
      
      public function get untypedRoot() : Object
      {
         return root;
      }
      
      public function untypedLocalToGlobal(param1:Point) : Point
      {
         return localToGlobal(param1);
      }
      
      public function get untypedStage() : Object
      {
         return stage;
      }
      
      public function untypedGlobalToLocal(param1:Point) : Point
      {
         return globalToLocal(param1);
      }
   }
}

