package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticlePositionNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   import flash.utils.Dictionary;
   
   use namespace arcane;
   
   public class ParticlePositionState extends ParticleStateBase
   {
      
      private var _particlePositionNode:ParticlePositionNode;
      
      private var _position:Vector3D;
      
      public function ParticlePositionState(param1:ParticleAnimator, param2:ParticlePositionNode)
      {
         super(param1,param2);
         this._particlePositionNode = param2;
         this._position = this._particlePositionNode._position;
      }
      
      public function get position() : Vector3D
      {
         return this._position;
      }
      
      public function set position(param1:Vector3D) : void
      {
         this._position = param1;
      }
      
      public function getPositions() : Vector.<Vector3D>
      {
         return _dynamicProperties;
      }
      
      public function setPositions(param1:Vector.<Vector3D>) : void
      {
         _dynamicProperties = param1;
         _dynamicPropertiesDirty = new Dictionary(true);
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         if(this._particlePositionNode.mode == ParticlePropertiesMode.LOCAL_DYNAMIC && !_dynamicPropertiesDirty[param3])
         {
            updateDynamicProperties(param3);
         }
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticlePositionNode.POSITION_INDEX);
         if(this._particlePositionNode.mode == ParticlePropertiesMode.GLOBAL)
         {
            param4.setVertexConst(_loc6_,this._position.x,this._position.y,this._position.z);
         }
         else
         {
            param3.activateVertexBuffer(_loc6_,this._particlePositionNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
         }
      }
   }
}

