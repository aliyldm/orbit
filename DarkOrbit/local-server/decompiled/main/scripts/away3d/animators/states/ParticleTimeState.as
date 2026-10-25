package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.nodes.ParticleTimeNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   
   use namespace arcane;
   
   public class ParticleTimeState extends ParticleStateBase
   {
      
      private var _particleTimeNode:ParticleTimeNode;
      
      public function ParticleTimeState(param1:ParticleAnimator, param2:ParticleTimeNode)
      {
         super(param1,param2,true);
         this._particleTimeNode = param2;
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         param3.activateVertexBuffer(param4.getRegisterIndex(_animationNode,ParticleTimeNode.TIME_STREAM_INDEX),this._particleTimeNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_4);
         var _loc6_:Number = _time / 1000;
         param4.setVertexConst(param4.getRegisterIndex(_animationNode,ParticleTimeNode.TIME_CONSTANT_INDEX),_loc6_,_loc6_,_loc6_,_loc6_);
      }
      
      public function get particleTimeNode() : ParticleTimeNode
      {
         return this._particleTimeNode;
      }
   }
}

