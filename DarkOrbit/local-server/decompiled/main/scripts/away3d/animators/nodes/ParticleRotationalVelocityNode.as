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
   
   public class ParticleRotationalVelocityNode extends ParticleNodeBase
   {
      
      arcane static const ROTATIONALVELOCITY_INDEX:uint = 0;
      
      public static const ROTATIONALVELOCITY_VECTOR3D:String = "RotationalVelocityVector3D";
      
      arcane var _rotationalVelocity:Vector3D;
      
      public function ParticleRotationalVelocityNode(param1:uint, param2:Vector3D = null)
      {
         _stateClass = ParticleRotationalVelocityState;
         super("ParticleRotationalVelocity",param1,4);
         this._rotationalVelocity = param2 || new Vector3D();
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,ROTATIONALVELOCITY_INDEX,_loc3_.index);
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         param2.addVertexTempUsages(_loc4_,1);
         var _loc5_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         param2.addVertexTempUsages(_loc5_,1);
         var _loc6_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         param2.addVertexTempUsages(_loc6_,1);
         var _loc7_:ShaderRegisterElement = new ShaderRegisterElement(_loc6_.regName,_loc6_.index);
         var _loc8_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         _loc8_ = new ShaderRegisterElement(_loc8_.regName,_loc8_.index);
         var _loc9_:ShaderRegisterElement = new ShaderRegisterElement(_loc7_.regName,_loc7_.index,3);
         var _loc10_:ShaderRegisterElement = new ShaderRegisterElement(_loc8_.regName,_loc8_.index,3);
         param2.removeVertexTempUsage(_loc4_);
         param2.removeVertexTempUsage(_loc5_);
         param2.removeVertexTempUsage(_loc6_);
         var _loc11_:String = "";
         _loc11_ = _loc11_ + ("mov " + _loc4_ + ".xyz," + _loc3_ + ".xyz\n");
         _loc11_ = _loc11_ + ("mov " + _loc4_ + ".w," + param2.vertexZeroConst + "\n");
         _loc11_ = _loc11_ + ("mul " + _loc9_ + "," + param2.vertexTime + "," + _loc3_ + ".w\n");
         _loc11_ = _loc11_ + ("sin " + _loc10_ + "," + _loc9_ + "\n");
         _loc11_ = _loc11_ + ("cos " + _loc9_ + "," + _loc9_ + "\n");
         _loc11_ = _loc11_ + ("mul " + _loc7_ + ".xyz," + _loc10_ + "," + _loc4_ + ".xyz\n");
         _loc11_ = _loc11_ + ("mul " + _loc8_ + ".xyz," + _loc10_ + "," + _loc4_ + ".xyz\n");
         _loc11_ = _loc11_ + ("neg " + _loc8_ + ".xyz," + _loc8_ + ".xyz\n");
         _loc11_ = _loc11_ + ("crs " + _loc4_ + ".xyz," + _loc7_ + ".xyz," + param2.scaleAndRotateTarget + ".xyz\n");
         _loc11_ = _loc11_ + ("mul " + _loc5_ + ".xyz," + _loc9_ + "," + param2.scaleAndRotateTarget + ".xyz\n");
         _loc11_ = _loc11_ + ("add " + _loc4_ + ".xyz," + _loc4_ + ".xyz," + _loc5_ + ".xyz\n");
         _loc11_ = _loc11_ + ("dp3 " + _loc5_ + ".w," + _loc7_ + ".xyz," + param2.scaleAndRotateTarget + ".xyz\n");
         _loc11_ = _loc11_ + ("neg " + _loc4_ + ".w," + _loc5_ + ".w\n");
         _loc11_ = _loc11_ + ("crs " + _loc7_ + ".xyz," + _loc4_ + ".xyz," + _loc8_ + ".xyz\n");
         _loc11_ = _loc11_ + ("mul " + _loc5_ + ".xyzw," + _loc4_ + ".xyzw," + _loc9_ + "\n");
         _loc11_ = _loc11_ + ("add " + _loc7_ + ".xyz," + _loc7_ + ".xyz," + _loc5_ + ".xyz\n");
         _loc11_ = _loc11_ + ("mul " + _loc5_ + ".xyz," + _loc4_ + ".w," + _loc8_ + ".xyz\n");
         _loc11_ = _loc11_ + ("add " + param2.scaleAndRotateTarget + ".xyz," + _loc7_ + ".xyz," + _loc5_ + ".xyz\n");
         var _loc12_:int = int(param2.rotationRegisters.length);
         var _loc13_:int = 0;
         while(_loc13_ < _loc12_)
         {
            _loc11_ += "mov " + _loc4_ + ".xyz," + _loc3_ + ".xyz\n";
            _loc11_ = _loc11_ + ("mov " + _loc4_ + ".w," + param2.vertexZeroConst + "\n");
            _loc11_ = _loc11_ + ("mul " + _loc9_ + "," + param2.vertexTime + "," + _loc3_ + ".w\n");
            _loc11_ = _loc11_ + ("sin " + _loc10_ + "," + _loc9_ + "\n");
            _loc11_ = _loc11_ + ("cos " + _loc9_ + "," + _loc9_ + "\n");
            _loc11_ = _loc11_ + ("mul " + _loc7_ + ".xyz," + _loc10_ + "," + _loc4_ + ".xyz\n");
            _loc11_ = _loc11_ + ("mul " + _loc8_ + ".xyz," + _loc10_ + "," + _loc4_ + ".xyz\n");
            _loc11_ = _loc11_ + ("neg " + _loc8_ + ".xyz," + _loc8_ + ".xyz\n");
            _loc11_ = _loc11_ + ("crs " + _loc4_ + ".xyz," + _loc7_ + ".xyz," + param2.rotationRegisters[_loc13_] + ".xyz\n");
            _loc11_ = _loc11_ + ("mul " + _loc5_ + ".xyz," + _loc9_ + "," + param2.rotationRegisters[_loc13_] + "\n");
            _loc11_ = _loc11_ + ("add " + _loc4_ + ".xyz," + _loc4_ + ".xyz," + _loc5_ + ".xyz\n");
            _loc11_ = _loc11_ + ("dp3 " + _loc5_ + ".w," + _loc7_ + ".xyz," + param2.rotationRegisters[_loc13_] + "\n");
            _loc11_ = _loc11_ + ("neg " + _loc4_ + ".w," + _loc5_ + ".w\n");
            _loc11_ = _loc11_ + ("crs " + _loc7_ + ".xyz," + _loc4_ + ".xyz," + _loc8_ + ".xyz\n");
            _loc11_ = _loc11_ + ("mul " + _loc5_ + ".xyzw," + _loc4_ + ".xyzw," + _loc9_ + "\n");
            _loc11_ = _loc11_ + ("add " + _loc7_ + ".xyz," + _loc7_ + ".xyz," + _loc5_ + ".xyz\n");
            _loc11_ = _loc11_ + ("mul " + _loc5_ + ".xyz," + _loc4_ + ".w," + _loc8_ + ".xyz\n");
            _loc11_ = _loc11_ + ("add " + param2.rotationRegisters[_loc13_] + "," + _loc7_ + ".xyz," + _loc5_ + ".xyz\n");
            _loc13_++;
         }
         return _loc11_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleRotationalVelocityState
      {
         return param1.getAnimationState(this) as ParticleRotationalVelocityState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[ROTATIONALVELOCITY_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + ROTATIONALVELOCITY_VECTOR3D + " in param!");
         }
         if(_loc2_.length <= 0)
         {
            _loc2_.z = 1;
         }
         else
         {
            _loc2_.normalize();
         }
         _oneData[0] = _loc2_.x;
         _oneData[1] = _loc2_.y;
         _oneData[2] = _loc2_.z;
         if(_loc2_.w <= 0)
         {
            throw new Error("the cycle duration must greater than zero");
         }
         _oneData[3] = Math.PI / _loc2_.w;
      }
   }
}

