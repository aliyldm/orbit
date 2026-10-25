package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleVelocityNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class ParticleVelocityState extends ParticleStateBase
   {
      
      private var _particleVelocityNode:ParticleVelocityNode;
      
      private var _velocity:Vector3D;
      
      public function ParticleVelocityState(param1:ParticleAnimator, param2:ParticleVelocityNode)
      {
         super(param1,param2);
         this._particleVelocityNode = param2;
         this._velocity = this._particleVelocityNode._velocity;
      }
      
      public function get velocity() : Vector3D
      {
         return this._velocity;
      }
      
      public function set velocity(param1:Vector3D) : void
      {
         this._velocity = param1;
      }
      
      public function getVelocities() : Vector.<Vector3D>
      {
         return _dynamicProperties;
      }
      
      public function setVelocities(param1:Vector.<Vector3D>) : void
      {
         _dynamicProperties = param1;
         _dynamicPropertiesDirty = new Dictionary(true);
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         if(this._particleVelocityNode.mode == ParticlePropertiesMode.LOCAL_DYNAMIC && !_dynamicPropertiesDirty[param3])
         {
            updateDynamicProperties(param3);
         }
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticleVelocityNode.VELOCITY_INDEX);
         if(this._particleVelocityNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            param4.setVertexConst(_loc6_,this._velocity.x,this._velocity.y,this._velocity.z);
         }
         else
         {
            param3.activateVertexBuffer(_loc6_,this._particleVelocityNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
         }
      }
   }
}

