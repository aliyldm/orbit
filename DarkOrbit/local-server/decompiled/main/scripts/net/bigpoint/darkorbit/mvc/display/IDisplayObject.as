package net.bigpoint.darkorbit.mvc.display
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public interface IDisplayObject
   {
      
      function addUntypedChild(param1:Object) : void;
      
      function containsUntypedChild(param1:Object) : Boolean;
      
      function isCorrectDisplayObject(param1:Object) : Boolean;
      
      function removeUntypedChildAt(param1:int, param2:Boolean = true) : Object;
      
      function removeUntypedChild(param1:Object, param2:Boolean = true) : Object;
      
      function removeFromParent(param1:Boolean = true) : void;
      
      function get untypedParent() : Object;
      
      function addUntypedEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void;
      
      function removeUntypedEventListener(param1:String, param2:Function, param3:Boolean = false) : void;
      
      function dispatchUntypedEvent(param1:Object) : Boolean;
      
      function hasEventListener(param1:String) : Boolean;
      
      function untypedLocalToGlobal(param1:Point) : Point;
      
      function untypedGlobalToLocal(param1:Point) : Point;
      
      function get untypedRoot() : Object;
      
      function get untypedStage() : Object;
      
      function get rotationUntyped() : Number;
      
      function set rotationUntyped(param1:Number) : void;
      
      function disposeAll(param1:Object = null) : void;
      
      function getUntypedBounds(param1:Object, param2:Rectangle = null) : Rectangle;
      
      function get transformationMatrix() : Matrix;
      
      function set mouseEnabled(param1:Boolean) : void;
      
      function set mouseChildren(param1:Boolean) : void;
      
      function set buttonMode(param1:Boolean) : void;
      
      function get numChildren() : int;
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
      
      function get alpha() : Number;
      
      function set alpha(param1:Number) : void;
      
      function get scaleX() : Number;
      
      function set scaleX(param1:Number) : void;
      
      function get scaleY() : Number;
      
      function set scaleY(param1:Number) : void;
      
      function get width() : Number;
      
      function set width(param1:Number) : void;
      
      function get height() : Number;
      
      function set height(param1:Number) : void;
      
      function get mouseX() : Number;
      
      function get mouseY() : Number;
      
      function get visible() : Boolean;
      
      function set visible(param1:Boolean) : void;
      
      function set useHandCursor(param1:Boolean) : void;
      
      function set doubleClickEnabled(param1:Boolean) : void;
   }
}

