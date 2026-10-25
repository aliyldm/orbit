package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.nodes.ParticleBillboardNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.MathConsts;
   import away3d.core.math.Matrix3DUtils;
   import flash.geom.Matrix3D;
   import flash.geom.Orientation3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleBillboardState extends ParticleStateBase
   {
      
      private var _matrix:Matrix3D = new Matrix3D();
      
      private var _billboardAxis:Vector3D;
      
      public function ParticleBillboardState(param1:ParticleAnimator, param2:ParticleBillboardNode)
      {
         super(param1,param2);
         this.billboardAxis = param2._billboardAxis;
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         var _loc6_:Vector.<Vector3D> = null;
         var _loc7_:Vector3D = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Vector3D = null;
         if(this._billboardAxis)
         {
            _loc7_ = param2.sceneTransform.position;
            _loc8_ = param5.sceneTransform.position.subtract(_loc7_);
            _loc9_ = _loc8_.crossProduct(this._billboardAxis);
            _loc9_.normalize();
            _loc8_ = this._billboardAxis.crossProduct(_loc9_);
            _loc8_.normalize();
            this._matrix.copyFrom(param2.sceneTransform);
            _loc6_ = Matrix3DUtils.decompose(this._matrix,Orientation3D.AXIS_ANGLE);
            this._matrix.copyColumnFrom(0,_loc9_);
            this._matrix.copyColumnFrom(1,this._billboardAxis);
            this._matrix.copyColumnFrom(2,_loc8_);
            this._matrix.copyColumnFrom(3,_loc7_);
            this._matrix.appendRotation(-_loc6_[1].w * MathConsts.RADIANS_TO_DEGREES,_loc6_[1]);
         }
         else
         {
            this._matrix.copyFrom(param2.sceneTransform);
            this._matrix.append(param5.inverseSceneTransform);
            _loc6_ = Matrix3DUtils.decompose(this._matrix,Orientation3D.AXIS_ANGLE);
            this._matrix.identity();
            this._matrix.appendRotation(-_loc6_[1].w * MathConsts.RADIANS_TO_DEGREES,_loc6_[1]);
         }
         param4.setVertexConstFromMatrix(param4.getRegisterIndex(_animationNode,ParticleBillboardNode.MATRIX_INDEX),this._matrix);
      }
      
      public function get billboardAxis() : Vector3D
      {
         return this._billboardAxis;
      }
      
      public function set billboardAxis(param1:Vector3D) : void
      {
         this._billboardAxis = param1 ? param1.clone() : null;
         if(this._billboardAxis)
         {
            this._billboardAxis.normalize();
         }
      }
   }
}

