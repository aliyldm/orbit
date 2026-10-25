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
   
   public class ParticlePositionNode extends ParticleNodeBase
   {
      
      arcane static const POSITION_INDEX:uint = 0;
      
      public static const POSITION_VECTOR3D:String = "PositionVector3D";
      
      arcane var _position:Vector3D;
      
      public function ParticlePositionNode(param1:uint, param2:Vector3D = null)
      {
         super("ParticlePosition",param1,3);
         _stateClass = ParticlePositionState;
         this._position = param2 || new Vector3D();
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,POSITION_INDEX,_loc3_.index);
         return "add " + param2.positionTarget + ".xyz," + _loc3_ + ".xyz," + param2.positionTarget + ".xyz\n";
      }
      
      public function getAnimationState(param1:IAnimator) : ParticlePositionState
      {
         return param1.getAnimationState(this) as ParticlePositionState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[POSITION_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + POSITION_VECTOR3D + " in param!");
         }
         _oneData[0] = _loc2_.x;
         _oneData[1] = _loc2_.y;
         _oneData[2] = _loc2_.z;
      }
   }
}

