package away3d.animators.data
{
   import away3d.animators.ParticleAnimator;
   import away3d.entities.Mesh;
   import flash.geom.Vector3D;
   
   public class ParticleInstanceProperty
   {
      
      private static const DEFAULT_ZERO:Vector3D = new Vector3D();
      
      private static const DEFAULT_ONE:Vector3D = new Vector3D(1,1,1);
      
      private var _position:Vector3D;
      
      private var _rotation:Vector3D;
      
      private var _scale:Vector3D;
      
      private var _playSpeed:Number;
      
      private var _timeOffset:Number;
      
      public function ParticleInstanceProperty(param1:Vector3D, param2:Vector3D, param3:Vector3D, param4:Number, param5:Number)
      {
         super();
         this._position = param1 ? param1 : DEFAULT_ZERO;
         this._rotation = param2 ? param2 : DEFAULT_ZERO;
         this._scale = param3 ? param3 : DEFAULT_ONE;
         this._timeOffset = param4;
         this._playSpeed = param5;
      }
      
      public function get timeOffset() : Number
      {
         return this._timeOffset;
      }
      
      public function apply(param1:Mesh) : void
      {
         param1.position = this._position.clone();
         param1.eulers = this._rotation.clone();
         param1.scaleX = this._scale.x;
         param1.scaleY = this._scale.y;
         param1.scaleZ = this._scale.z;
         ParticleAnimator(param1.animator).playbackSpeed = this._playSpeed;
      }
   }
}

