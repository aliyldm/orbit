package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleAccelerationNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleAccelerationState extends ParticleStateBase
   {
      
      private var _particleAccelerationNode:ParticleAccelerationNode;
      
      private var _acceleration:Vector3D;
      
      private var _halfAcceleration:Vector3D;
      
      public function ParticleAccelerationState(param1:ParticleAnimator, param2:ParticleAccelerationNode)
      {
         super(param1,param2);
         this._particleAccelerationNode = param2;
         this._acceleration = this._particleAccelerationNode._acceleration;
         this.updateAccelerationData();
      }
      
      public function get acceleration() : Vector3D
      {
         return this._acceleration;
      }
      
      public function set acceleration(param1:Vector3D) : void
      {
         this._acceleration.x = param1.x;
         this._acceleration.y = param1.y;
         this._acceleration.z = param1.z;
         this.updateAccelerationData();
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         param2 = param2;
         param5 = param5;
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticleAccelerationNode.ACCELERATION_INDEX);
         if(this._particleAccelerationNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
         {
            param3.activateVertexBuffer(_loc6_,this._particleAccelerationNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
         }
         else
         {
            param4.setVertexConst(_loc6_,this._halfAcceleration.x,this._halfAcceleration.y,this._halfAcceleration.z);
         }
      }
      
      private function updateAccelerationData() : void
      {
         if(this._particleAccelerationNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            this._halfAcceleration = new Vector3D(this._acceleration.x / 2,this._acceleration.y / 2,this._acceleration.z / 2);
         }
      }
   }
}

