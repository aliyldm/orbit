package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.nodes.ParticleNodeBase;
   import away3d.animators.nodes.ParticleRotateToHeadingNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class ParticleRotateToHeadingState extends ParticleStateBase
   {
      
      private var _matrix:Matrix3D = new Matrix3D();
      
      public function ParticleRotateToHeadingState(param1:ParticleAnimator, param2:ParticleNodeBase)
      {
         super(param1,param2);
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         if(param4.hasBillboard)
         {
            this._matrix.copyFrom(param2.sceneTransform);
            this._matrix.append(param5.inverseSceneTransform);
            param4.setVertexConstFromMatrix(param4.getRegisterIndex(_animationNode,ParticleRotateToHeadingNode.MATRIX_INDEX),this._matrix);
         }
      }
   }
}

