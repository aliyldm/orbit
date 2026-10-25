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
   
   public class ParticleVelocityNode extends ParticleNodeBase
   {
      
      arcane static const VELOCITY_INDEX:int = 0;
      
      public static const VELOCITY_VECTOR3D:String = "VelocityVector3D";
      
      arcane var _velocity:Vector3D;
      
      public function ParticleVelocityNode(param1:uint, param2:Vector3D = null)
      {
         super("ParticleVelocity",param1,3);
         _stateClass = ParticleVelocityState;
         this._velocity = param2 || new Vector3D();
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,VELOCITY_INDEX,_loc3_.index);
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc5_:String = "";
         _loc5_ = _loc5_ + ("mul " + _loc4_ + "," + param2.vertexTime + "," + _loc3_ + "\n");
         _loc5_ = _loc5_ + ("add " + param2.positionTarget + ".xyz," + _loc4_ + "," + param2.positionTarget + ".xyz\n");
         if(param2.needVelocity)
         {
            _loc5_ += "add " + param2.velocityTarget + ".xyz," + _loc3_ + ".xyz," + param2.velocityTarget + ".xyz\n";
         }
         return _loc5_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleVelocityState
      {
         return param1.getAnimationState(this) as ParticleVelocityState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[VELOCITY_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + VELOCITY_VECTOR3D + " in param!");
         }
         _oneData[0] = _loc2_.x;
         _oneData[1] = _loc2_.y;
         _oneData[2] = _loc2_.z;
      }
   }
}

