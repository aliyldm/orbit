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
   
   public class ParticleAccelerationNode extends ParticleNodeBase
   {
      
      arcane static const ACCELERATION_INDEX:int = 0;
      
      public static const ACCELERATION_VECTOR3D:String = "AccelerationVector3D";
      
      arcane var _acceleration:Vector3D;
      
      public function ParticleAccelerationNode(param1:uint, param2:Vector3D = null)
      {
         super("ParticleAcceleration",param1,3);
         _stateClass = ParticleAccelerationState;
         this._acceleration = param2 || new Vector3D();
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc6_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,ACCELERATION_INDEX,_loc3_.index);
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         param2.addVertexTempUsages(_loc4_,1);
         var _loc5_:String = "mul " + _loc4_ + "," + param2.vertexTime + "," + _loc3_ + "\n";
         if(param2.needVelocity)
         {
            _loc6_ = param2.getFreeVertexVectorTemp();
            _loc5_ += "mul " + _loc6_ + "," + _loc4_ + "," + param2.vertexTwoConst + "\n";
            _loc5_ = _loc5_ + ("add " + param2.velocityTarget + ".xyz," + _loc6_ + ".xyz," + param2.velocityTarget + ".xyz\n");
         }
         param2.removeVertexTempUsage(_loc4_);
         _loc5_ += "mul " + _loc4_ + "," + _loc4_ + "," + param2.vertexTime + "\n";
         return _loc5_ + ("add " + param2.positionTarget + ".xyz," + _loc4_ + "," + param2.positionTarget + ".xyz\n");
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleAccelerationState
      {
         return param1.getAnimationState(this) as ParticleAccelerationState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[ACCELERATION_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + ACCELERATION_VECTOR3D + " in param!");
         }
         _oneData[0] = _loc2_.x / 2;
         _oneData[1] = _loc2_.y / 2;
         _oneData[2] = _loc2_.z / 2;
      }
   }
}

