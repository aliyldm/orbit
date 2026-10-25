package away3d.animators.states
{
   import away3d.animators.ParticleAnimator;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.animators.data.AnimationSubGeometry;
   import away3d.animators.data.ParticlePropertiesMode;
   import away3d.animators.nodes.ParticleBezierCurveNode;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ParticleBezierCurveState extends ParticleStateBase
   {
      
      private var _particleBezierCurveNode:ParticleBezierCurveNode;
      
      private var _controlPoint:Vector3D;
      
      private var _endPoint:Vector3D;
      
      public function ParticleBezierCurveState(param1:ParticleAnimator, param2:ParticleBezierCurveNode)
      {
         super(param1,param2);
         this._particleBezierCurveNode = param2;
         this._controlPoint = this._particleBezierCurveNode._controlPoint;
         this._endPoint = this._particleBezierCurveNode._endPoint;
      }
      
      public function get controlPoint() : Vector3D
      {
         return this._controlPoint;
      }
      
      public function set controlPoint(param1:Vector3D) : void
      {
         this._controlPoint = param1;
      }
      
      public function get endPoint() : Vector3D
      {
         return this._endPoint;
      }
      
      public function set endPoint(param1:Vector3D) : void
      {
         this._endPoint = param1;
      }
      
      override public function setRenderState(param1:Stage3DProxy, param2:IRenderable, param3:AnimationSubGeometry, param4:AnimationRegisterCache, param5:Camera3D) : void
      {
         param2 = param2;
         param5 = param5;
         var _loc6_:int = param4.getRegisterIndex(_animationNode,ParticleBezierCurveNode.BEZIER_CONTROL_INDEX);
         var _loc7_:int = param4.getRegisterIndex(_animationNode,ParticleBezierCurveNode.BEZIER_END_INDEX);
         if(this._particleBezierCurveNode.mode == ParticlePropertiesMode.LOCAL_STATIC)
         {
            param3.activateVertexBuffer(_loc6_,this._particleBezierCurveNode.dataOffset,param1,Context3DVertexBufferFormat.FLOAT_3);
            param3.activateVertexBuffer(_loc7_,this._particleBezierCurveNode.dataOffset + 3,param1,Context3DVertexBufferFormat.FLOAT_3);
         }
         else
         {
            param4.setVertexConst(_loc6_,this._controlPoint.x,this._controlPoint.y,this._controlPoint.z);
            param4.setVertexConst(_loc7_,this._endPoint.x,this._endPoint.y,this._endPoint.z);
         }
      }
   }
}

