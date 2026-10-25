package away3d.events
{
   import away3d.arcane;
   import away3d.containers.ObjectContainer3D;
   import away3d.containers.View3D;
   import away3d.core.base.IRenderable;
   import away3d.core.math.Matrix3DUtils;
   import away3d.materials.MaterialBase;
   import flash.events.Event;
   import flash.geom.Point;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class MouseEvent3D extends Event
   {
      
      public static const MOUSE_OVER:String = "mouseOver3d";
      
      public static const MOUSE_OUT:String = "mouseOut3d";
      
      public static const MOUSE_UP:String = "mouseUp3d";
      
      public static const MOUSE_DOWN:String = "mouseDown3d";
      
      public static const MOUSE_MOVE:String = "mouseMove3d";
      
      public static const CLICK:String = "click3d";
      
      public static const DOUBLE_CLICK:String = "doubleClick3d";
      
      public static const MOUSE_WHEEL:String = "mouseWheel3d";
      
      arcane var _allowedToPropagate:Boolean = true;
      
      arcane var _parentEvent:MouseEvent3D;
      
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
      
      public var delta:int;
      
      public function MouseEvent3D(param1:String)
      {
         super(param1,true,true);
      }
      
      override public function get bubbles() : Boolean
      {
         var _loc1_:Boolean = super.bubbles && this._allowedToPropagate;
         this._allowedToPropagate = true;
         return _loc1_;
      }
      
      override public function stopPropagation() : void
      {
         super.stopPropagation();
         this._allowedToPropagate = false;
         if(this._parentEvent)
         {
            this._parentEvent.stopPropagation();
         }
      }
      
      override public function stopImmediatePropagation() : void
      {
         super.stopImmediatePropagation();
         this._allowedToPropagate = false;
         if(this._parentEvent)
         {
            this._parentEvent.stopImmediatePropagation();
         }
      }
      
      override public function clone() : Event
      {
         var _loc1_:MouseEvent3D = new MouseEvent3D(type);
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
         _loc1_.delta = this.delta;
         _loc1_.ctrlKey = this.ctrlKey;
         _loc1_.shiftKey = this.shiftKey;
         _loc1_._parentEvent = this;
         _loc1_._allowedToPropagate = this._allowedToPropagate;
         return _loc1_;
      }
      
      public function get scenePosition() : Vector3D
      {
         if(this.object is ObjectContainer3D)
         {
            return Matrix3DUtils.transformVector(ObjectContainer3D(this.object).sceneTransform,this.localPosition);
         }
         return this.localPosition;
      }
      
      public function getScenePosition(param1:Vector3D = null) : Vector3D
      {
         if(!param1)
         {
            param1 = new Vector3D();
         }
         if(this.object is ObjectContainer3D)
         {
            Matrix3DUtils.transformVector(ObjectContainer3D(this.object).sceneTransform,this.localPosition,param1);
         }
         else
         {
            param1.x = this.localPosition.x;
            param1.y = this.localPosition.y;
            param1.z = this.localPosition.z;
         }
         return param1;
      }
      
      public function get sceneNormal() : Vector3D
      {
         var _loc1_:Vector3D = null;
         if(this.object is ObjectContainer3D)
         {
            _loc1_ = Matrix3DUtils.deltaTransformVector(ObjectContainer3D(this.object).sceneTransform,this.localNormal);
            _loc1_.normalize();
            return _loc1_;
         }
         return this.localNormal;
      }
      
      public function getSceneNormal(param1:Vector3D = null) : Vector3D
      {
         if(!param1)
         {
            param1 = new Vector3D();
         }
         if(this.object is ObjectContainer3D)
         {
            Matrix3DUtils.deltaTransformVector(ObjectContainer3D(this.object).sceneTransform,this.localNormal,param1);
            param1.normalize();
         }
         else
         {
            param1.x = this.localNormal.x;
            param1.y = this.localNormal.y;
            param1.z = this.localNormal.z;
         }
         return param1;
      }
   }
}

