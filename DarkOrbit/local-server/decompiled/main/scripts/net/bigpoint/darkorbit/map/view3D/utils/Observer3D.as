package net.bigpoint.darkorbit.map.view3D.utils
{
   import com.bigpoint.utils.bindables.BindableNumber;
   import com.greensock.TweenLite;
   import com.greensock.easing.Quad;
   import flash.geom.Vector3D;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   
   public class Observer3D
   {
      
      public static const start_cameraDistance:Number = 1740;
      
      public static const start_cameraPan:Number = 0;
      
      public static const start_cameraTilt:Number = 135;
      
      public static const start_cameraFov:Number = 30;
      
      public const maxTilt:Number = 179.9;
      
      public const minTilt:Number = 135;
      
      public const referenceDistance:Number = 1740;
      
      public const maxZoom:Number = 3;
      
      public const minZoom:Number = 1;
      
      public const animatedZoom:BindableNumber = new BindableNumber(start_cameraDistance);
      
      public const tilt:BindableNumber = new BindableNumber(start_cameraTilt);
      
      public const pan:BindableNumber = new BindableNumber(start_cameraPan);
      
      public const fov:BindableNumber = new BindableNumber(start_cameraFov,2,180);
      
      private const PI_DIV_180:Number = 0.017453292519943295;
      
      private var _lookAt:Vector3D = new Vector3D(0,0,0);
      
      private var _position:Vector3D = new Vector3D(0,0,0);
      
      private var _dirty:Boolean = true;
      
      private var _zoom:Number = 0;
      
      public var mapIs3D:Boolean = false;
      
      public var zoomMultiplier:Number = 1;
      
      public function Observer3D()
      {
         super();
         this.animatedZoom.changed.add(this.markDirty);
         this.tilt.changed.add(this.markDirty);
         this.pan.changed.add(this.markDirty);
         this._zoom = this.animatedZoom.value;
         this.reset();
      }
      
      public function reset() : void
      {
         this.pan.value = start_cameraPan;
         this.tilt.value = start_cameraTilt;
         this.immediateZoom = 1;
         this.lookAt(0,0,0);
      }
      
      public function lookAt(param1:Number, param2:Number, param3:Number) : void
      {
         this._lookAt.setTo(param1,param2,param3);
         this._dirty = true;
      }
      
      public function restoreDefaults(param1:Boolean = false, param2:Boolean = true) : void
      {
         this.killAnimation();
         this.pan.value %= 360;
         while(this.pan.value < 0)
         {
            this.pan.value += 360;
         }
         if(param2)
         {
            TweenLite.to(this.animatedZoom,param1 ? 0 : 1,{"value":1});
         }
         TweenLite.to(this.fov,param1 ? 0 : 1,{"value":start_cameraFov});
         TweenLite.to(this.pan,param1 ? 0 : 1,{"value":this.pan.value + ExtMath.getShortAngleDegrees(this.pan.value,start_cameraPan)});
         TweenLite.to(this.tilt,param1 ? 0 : 1,{"value":start_cameraTilt});
      }
      
      public function killAnimation() : void
      {
         TweenLite.killTweensOf(this.animatedZoom);
         TweenLite.killTweensOf(this.fov);
         TweenLite.killTweensOf(this.pan);
         TweenLite.killTweensOf(this.tilt);
      }
      
      public function zoomIn() : void
      {
         TweenLite.to(this.animatedZoom,1,{
            "value":1.5,
            "ease":Quad.easeOut
         });
         TweenLite.to(this.pan,1,{
            "value":this.pan.value + 10,
            "ease":Quad.easeOut
         });
      }
      
      private function markDirty() : void
      {
         this._dirty = true;
      }
      
      private function validate() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(this._dirty)
         {
            _loc1_ = this.tilt.value;
            if(this.mapIs3D && Settings3D.limitCameraAngle.value)
            {
               _loc3_ = 0;
               _loc4_ = 20;
               _loc5_ = (this.animatedZoom.value - 1) / (this.maxZoom - 1) * (_loc4_ - _loc3_);
               _loc1_ -= Math.max(_loc3_,Math.min(_loc5_,_loc4_));
               this._zoom = this.animatedZoom.value;
            }
            _loc2_ = this.zoomMultiplier * this.referenceDistance / this.animatedZoom.value;
            this._position.setTo(this._lookAt.x + _loc2_ * Math.sin(_loc1_ * this.PI_DIV_180) * Math.sin(this.pan.value * this.PI_DIV_180),this._lookAt.y - _loc2_ * Math.cos(_loc1_ * this.PI_DIV_180),this._lookAt.z - _loc2_ * Math.sin(_loc1_ * this.PI_DIV_180) * Math.cos(this.pan.value * this.PI_DIV_180));
            this._dirty = false;
         }
      }
      
      public function get position() : Vector3D
      {
         this.validate();
         return this._position;
      }
      
      public function get lookAtPosition() : Vector3D
      {
         return this._lookAt;
      }
      
      public function get zoom() : Number
      {
         return this._zoom;
      }
      
      public function set zoom(param1:Number) : void
      {
         if(Settings3D.limitCameraAngle.value)
         {
            param1 = Math.max(this.minZoom,Math.min(param1,this.maxZoom));
         }
         else
         {
            param1 = Math.max(0.1,param1);
         }
         this._zoom = param1;
         TweenLite.to(this.animatedZoom,0.3,{
            "value":this._zoom,
            "ease":Quad.easeOut
         });
      }
      
      public function set immediateZoom(param1:Number) : void
      {
         if(Settings3D.limitCameraAngle.value)
         {
            param1 = Math.max(this.minZoom,Math.min(param1,this.maxZoom));
         }
         else
         {
            param1 = Math.max(0.01,param1);
         }
         this._zoom = param1;
         this.animatedZoom.value = param1;
      }
      
      public function animateZoom(param1:Number, param2:Number) : void
      {
         this._zoom = param1;
         TweenLite.to(this.animatedZoom,param2,{
            "value":this._zoom,
            "ease":Quad.easeOut
         });
      }
   }
}

