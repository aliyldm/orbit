package away3d.animators.nodes
{
   import away3d.*;
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   import away3d.materials.compilation.*;
   import away3d.materials.passes.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class ParticleBezierCurveNode extends ParticleNodeBase
   {
      
      arcane static const BEZIER_CONTROL_INDEX:int = 0;
      
      arcane static const BEZIER_END_INDEX:int = 1;
      
      public static const BEZIER_CONTROL_VECTOR3D:String = "BezierControlVector3D";
      
      public static const BEZIER_END_VECTOR3D:String = "BezierEndVector3D";
      
      arcane var _controlPoint:Vector3D;
      
      arcane var _endPoint:Vector3D;
      
      public function ParticleBezierCurveNode(param1:uint, param2:Vector3D = null, param3:Vector3D = null)
      {
         super("ParticleBezierCurve",param1,6);
         _stateClass = ParticleBezierCurveState;
         this._controlPoint = param2 || new Vector3D();
         this._endPoint = param3 || new Vector3D();
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,BEZIER_CONTROL_INDEX,_loc3_.index);
         var _loc4_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,BEZIER_END_INDEX,_loc4_.index);
         var _loc5_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc6_:ShaderRegisterElement = new ShaderRegisterElement(_loc5_.regName,_loc5_.index,0);
         var _loc7_:ShaderRegisterElement = new ShaderRegisterElement(_loc5_.regName,_loc5_.index,1);
         var _loc8_:ShaderRegisterElement = new ShaderRegisterElement(_loc5_.regName,_loc5_.index,2);
         param2.addVertexTempUsages(_loc5_,1);
         var _loc9_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc10_:ShaderRegisterElement = new ShaderRegisterElement(_loc9_.regName,_loc9_.index);
         param2.removeVertexTempUsage(_loc5_);
         var _loc11_:String = "";
         _loc11_ = _loc11_ + ("sub " + _loc6_ + "," + param2.vertexOneConst + "," + param2.vertexLife + "\n");
         _loc11_ = _loc11_ + ("mul " + _loc7_ + "," + param2.vertexLife + "," + param2.vertexLife + "\n");
         _loc11_ = _loc11_ + ("mul " + _loc8_ + "," + param2.vertexLife + "," + _loc6_ + "\n");
         _loc11_ = _loc11_ + ("mul " + _loc8_ + "," + _loc8_ + "," + param2.vertexTwoConst + "\n");
         _loc11_ = _loc11_ + ("mul " + _loc10_ + ".xyz," + _loc8_ + "," + _loc3_ + "\n");
         _loc11_ = _loc11_ + ("add " + param2.positionTarget + ".xyz," + _loc10_ + ".xyz," + param2.positionTarget + ".xyz\n");
         _loc11_ = _loc11_ + ("mul " + _loc10_ + ".xyz," + _loc7_ + "," + _loc4_ + "\n");
         _loc11_ = _loc11_ + ("add " + param2.positionTarget + ".xyz," + _loc10_ + ".xyz," + param2.positionTarget + ".xyz\n");
         if(param2.needVelocity)
         {
            _loc11_ += "mul " + _loc7_ + "," + param2.vertexLife + "," + param2.vertexTwoConst + "\n";
            _loc11_ = _loc11_ + ("sub " + _loc8_ + "," + param2.vertexOneConst + "," + _loc7_ + "\n");
            _loc11_ = _loc11_ + ("mul " + _loc8_ + "," + param2.vertexTwoConst + "," + _loc8_ + "\n");
            _loc11_ = _loc11_ + ("mul " + _loc10_ + ".xyz," + _loc3_ + "," + _loc8_ + "\n");
            _loc11_ = _loc11_ + ("add " + param2.velocityTarget + ".xyz," + _loc10_ + ".xyz," + param2.velocityTarget + ".xyz\n");
            _loc11_ = _loc11_ + ("mul " + _loc10_ + ".xyz," + _loc4_ + "," + _loc7_ + "\n");
            _loc11_ = _loc11_ + ("add " + param2.velocityTarget + ".xyz," + _loc10_ + ".xyz," + param2.velocityTarget + ".xyz\n");
         }
         return _loc11_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleBezierCurveState
      {
         return param1.getAnimationState(this) as ParticleBezierCurveState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[BEZIER_CONTROL_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + BEZIER_CONTROL_VECTOR3D + " in param!");
         }
         var _loc3_:Vector3D = param1[BEZIER_END_VECTOR3D];
         if(!_loc3_)
         {
            throw new Error("there is no " + BEZIER_END_VECTOR3D + " in param!");
         }
         _oneData[0] = _loc2_.x;
         _oneData[1] = _loc2_.y;
         _oneData[2] = _loc2_.z;
         _oneData[3] = _loc3_.x;
         _oneData[4] = _loc3_.y;
         _oneData[5] = _loc3_.z;
      }
   }
}

