package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleRotationalVelocityNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class ParticleRotationalVelocityState extends ParticleStateBase
   {
      
      private var _particleRotationalVelocityNode:ParticleRotationalVelocityNode;
      
      private var _rotationalVelocityData:Vector3D;
      
      private var _rotationalVelocity:Vector3D;
      
      public function ParticleRotationalVelocityState(param1:ParticleAnimator, param2:ParticleRotationalVelocityNode)
      {
         super(param1,param2);
         this._particleRotationalVelocityNode = param2;
         this._rotationalVelocity = this._particleRotationalVelocityNode._rotationalVelocity;
         this.updateRotationalVelocityData();
      }
      
      public function get rotationalVelocity() : Vector3D
      {
         return this._rotationalVelocity;
      }
      
      public function set rotationalVelocity(param1:Vector3D) : void
      {
         this._rotationalVelocity = param1;
         this.updateRotationalVelocityData();
      }
      
      public function getRotationalVelocities() : Vector.<Vector3D>
      {
         return _dynamicProperties;
      }
      
      public function setRotationalVelocities(param1:Vector.<Vector3D>) : void
      {
         _dynamicProperties = param1;
         _dynamicPropertiesDirty = new Dictionary(true);
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         param2 = param2;
         param5 = param5;
         if(this._particleRotationalVelocityNode.mode == ParticlePropertiesMode.LOCAL_DYNAMIC && !_dynamicPropertiesDirty[param3])
         {
            updateDynamicProperties(param3);
         }
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticleRotationalVelocityNode.ROTATIONALVELOCITY_INDEX);
         if(this._particleRotationalVelocityNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            param4.setVertexConst(_loc6_,this._rotationalVelocityData.x,this._rotationalVelocityData.y,this._rotationalVelocityData.z,this._rotationalVelocityData.w);
         }
         else
         {
            param3.activateVertexBuffer(_loc6_,this._particleRotationalVelocityNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_4);
         }
      }
      
      private function updateRotationalVelocityData() : void
      {
         var _loc1_:Vector3D = null;
         if(this._particleRotationalVelocityNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            if(this._rotationalVelocity.w <= 0)
            {
               throw new Error("the cycle duration must greater than zero");
            }
            _loc1_ = this._rotationalVelocity.clone();
            if(_loc1_.length <= 0)
            {
               _loc1_.z = 1;
            }
            else
            {
               _loc1_.normalize();
            }
            this._rotationalVelocityData = new Vector3D(_loc1_.x,_loc1_.y,_loc1_.z,Math.PI / _loc1_.w);
         }
      }
   }
}

