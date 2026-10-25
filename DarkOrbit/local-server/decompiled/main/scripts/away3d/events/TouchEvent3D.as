package away3d.events
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.containers.View3D;
   import away3d.core.base.IRenderable;
   import away3d.materials.MaterialBase;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class TouchEvent3D extends Event
   {
      
      public static const TOUCH_END:String = "touchEnd3d";
      
      public static const TOUCH_BEGIN:String = "touchBegin3d";
      
      public static const TOUCH_MOVE:String = "touchMove3d";
      
      public static const TOUCH_OUT:String = "touchOut3d";
      
      public static const TOUCH_OVER:String = "touchOver3d";
      
      arcane var _allowedToPropagate:Boolean = true;
      
      arcane var _parentEvent:TouchEvent3D;
      
      public var screenX:Number;
      
      public var screenY:Number;
      
      public var view:View3D;
      
      public var object:ObjectContainer3D;
      
      public var renderable:IRenderable;
      
      public var material:MaterialBase;
      
      public var uv:Point;
      
      public var index:uint;
      
      public var subGeometryIndex:uint;
      
      public var localPosition:Vector3D;
      
      public var localNormal:Vector3D;
      
      public var ctrlKey:Boolean;
      
      public var altKey:Boolean;
      
      public var shiftKey:Boolean;
      
      public var touchPointID:int;
      
      public function TouchEvent3D(param1:String)
      {
         super(param1,true,true);
      }
      
      override public function get bubbles() : Boolean
      {
         return super.bubbles && this._allowedToPropagate;
      }
      
      override public function stopPropagation() : void
      {
         super.stopPropagation();
         this._allowedToPropagate = false;
         if(this._parentEvent)
         {
            this._parentEvent._allowedToPropagate = false;
         }
      }
      
      override public function stopImmediatePropagation() : void
      {
         super.stopImmediatePropagation();
         this._allowedToPropagate = false;
         if(this._parentEvent)
         {
            this._parentEvent._allowedToPropagate = false;
         }
      }
      
      override public function clone() : Event
      {
         var _loc1_:TouchEvent3D = new TouchEvent3D(type);
         if(isDefaultPrevented())
         {
            _loc1_.preventDefault();
         }
         _loc1_.screenX = this.screenX;
         _loc1_.screenY = this.screenY;
         _loc1_.view = this.view;
         _loc1_.object = this.object;
         _loc1_.renderable = this.renderable;
         _loc1_.material = this.material;
         _loc1_.uv = this.uv;
         _loc1_.localPosition = this.localPosition;
         _loc1_.localNormal = this.localNormal;
         _loc1_.index = this.index;
         _loc1_.subGeometryIndex = this.subGeometryIndex;
         _loc1_.ctrlKey = this.ctrlKey;
         _loc1_.shiftKey = this.shiftKey;
         _loc1_._parentEvent = this;
         return _loc1_;
      }
      
      public function get scenePosition() : Vector3D
      {
         if(this.object is ObjectContainer3D)
         {
            return ObjectContainer3D(this.object).sceneTransform.transformVector(this.localPosition);
         }
         return this.localPosition;
      }
      
      public function get sceneNormal() : Vector3D
      {
         var _loc1_:Vector3D = null;
         if(this.object is ObjectContainer3D)
         {
            _loc1_ = ObjectContainer3D(this.object).sceneTransform.deltaTransformVector(this.localNormal);
            _loc1_.normalize();
            return _loc1_;
         }
         return this.localNormal;
      }
   }
}

