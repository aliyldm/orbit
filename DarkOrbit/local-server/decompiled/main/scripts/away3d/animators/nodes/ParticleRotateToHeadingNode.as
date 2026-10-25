package away3d.animators.nodes
{
   import away3d.*;
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   import away3d.materials.compilation.*;
   import away3d.materials.passes.*;
   
   use namespace arcane;
   
   public class ParticleRotateToHeadingNode extends ParticleNodeBase
   {
      
      arcane static const MATRIX_INDEX:int = 0;
      
      public function ParticleRotateToHeadingNode()
      {
         super("ParticleRotateToHeading",ParticlePropertiesMode.GLOBAL,0,3);
         _stateClass = ParticleRotateToHeadingState;
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc5_:int = 0;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         var _loc8_:ShaderRegisterElement = null;
         var _loc9_:ShaderRegisterElement = null;
         var _loc10_:ShaderRegisterElement = null;
         var _loc11_:ShaderRegisterElement = null;
         var _loc12_:ShaderRegisterElement = null;
         var _loc13_:ShaderRegisterElement = null;
         var _loc14_:ShaderRegisterElement = null;
         var _loc15_:ShaderRegisterElement = null;
         var _loc16_:ShaderRegisterElement = null;
         var _loc17_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:String = "";
         var _loc4_:int = int(param2.rotationRegisters.length);
         if(param2.hasBillboard)
         {
            _loc6_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc6_,1);
            _loc7_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc7_,1);
            _loc8_ = param2.getFreeVertexVectorTemp();
            _loc9_ = param2.getFreeVertexConstant();
            param2.setRegisterIndex(this,MATRIX_INDEX,_loc9_.index);
            param2.getFreeVertexConstant();
            param2.getFreeVertexConstant();
            param2.getFreeVertexConstant();
            param2.removeVertexTempUsage(_loc6_);
            param2.removeVertexTempUsage(_loc7_);
            _loc3_ += "m33 " + _loc6_ + ".xyz," + param2.velocityTarget + ".xyz," + _loc9_ + "\n";
            _loc3_ += "mov " + _loc8_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc8_ + ".xy," + _loc6_ + ".xy\n";
            _loc3_ += "nrm " + _loc8_ + ".xyz," + _loc8_ + ".xyz\n";
            _loc3_ += "mov " + _loc7_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc7_ + ".x," + _loc8_ + ".y\n";
            _loc3_ += "mov " + _loc7_ + ".y," + _loc8_ + ".x\n";
            _loc3_ += "mov " + _loc6_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc6_ + ".x," + _loc8_ + ".x\n";
            _loc3_ += "neg " + _loc6_ + ".y," + _loc8_ + ".y\n";
            _loc3_ += "mov " + _loc8_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc8_ + ".z," + param2.vertexOneConst + "\n";
            _loc3_ += "m33 " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc6_ + "\n";
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ += "m33 " + param2.rotationRegisters[_loc5_] + ".xyz," + param2.rotationRegisters[_loc5_] + "," + _loc6_ + "\n";
               _loc5_++;
            }
         }
         else
         {
            _loc10_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc10_,1);
            _loc11_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc11_,1);
            _loc12_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc12_,1);
            _loc13_ = param2.getFreeVertexVectorTemp();
            _loc14_ = new ShaderRegisterElement(_loc12_.regName,_loc12_.index,3);
            _loc15_ = new ShaderRegisterElement(_loc13_.regName,_loc13_.index,3);
            _loc16_ = new ShaderRegisterElement(_loc10_.regName,_loc10_.index,3);
            _loc17_ = _loc15_;
            param2.removeVertexTempUsage(_loc10_);
            param2.removeVertexTempUsage(_loc11_);
            param2.removeVertexTempUsage(_loc12_);
            _loc3_ += "mov " + _loc11_ + ".x," + param2.vertexOneConst + "\n";
            _loc3_ += "mov " + _loc11_ + ".yz," + param2.vertexZeroConst + "\n";
            _loc3_ += "nrm " + _loc10_ + ".xyz," + param2.velocityTarget + ".xyz\n";
            _loc3_ += "dp3 " + _loc16_ + "," + _loc10_ + ".xyz," + _loc11_ + ".xyz\n";
            _loc3_ += "crs " + _loc10_ + ".xyz," + _loc11_ + ".xyz," + _loc10_ + ".xyz\n";
            _loc3_ += "nrm " + _loc10_ + ".xyz," + _loc10_ + ".xyz\n";
            _loc3_ += "dp3 " + _loc12_ + ".x," + _loc10_ + ".xyz," + _loc10_ + ".xyz\n";
            _loc3_ += "sge " + _loc12_ + ".x," + param2.vertexZeroConst + "," + _loc12_ + ".x\n";
            _loc3_ += "add " + _loc10_ + ".z," + _loc12_ + ".x," + _loc10_ + ".z\n";
            _loc3_ += "add " + _loc17_ + "," + _loc16_ + "," + param2.vertexOneConst + "\n";
            _loc3_ += "div " + _loc17_ + "," + _loc17_ + "," + param2.vertexTwoConst + "\n";
            _loc3_ += "sqt " + _loc14_ + "," + _loc17_ + "\n";
            _loc3_ += "sub " + _loc17_ + "," + param2.vertexOneConst + "," + _loc16_ + "\n";
            _loc3_ += "div " + _loc17_ + "," + _loc17_ + "," + param2.vertexTwoConst + "\n";
            _loc3_ += "sqt " + _loc15_ + "," + _loc17_ + "\n";
            _loc3_ += "mul " + _loc12_ + ".xyz," + _loc15_ + "," + _loc10_ + ".xyz\n";
            _loc3_ += "mul " + _loc13_ + ".xyz," + _loc15_ + "," + _loc10_ + ".xyz\n";
            _loc3_ += "neg " + _loc13_ + ".xyz," + _loc13_ + ".xyz\n";
            _loc3_ += "crs " + _loc10_ + ".xyz," + _loc12_ + ".xyz," + param2.scaleAndRotateTarget + ".xyz\n";
            _loc3_ += "mul " + _loc11_ + ".xyz," + _loc14_ + "," + param2.scaleAndRotateTarget + ".xyz\n";
            _loc3_ += "add " + _loc10_ + ".xyz," + _loc10_ + ".xyz," + _loc11_ + ".xyz\n";
            _loc3_ += "dp3 " + _loc11_ + ".w," + _loc12_ + ".xyz," + param2.scaleAndRotateTarget + ".xyz\n";
            _loc3_ += "neg " + _loc10_ + ".w," + _loc11_ + ".w\n";
            _loc3_ += "crs " + _loc12_ + ".xyz," + _loc10_ + ".xyz," + _loc13_ + ".xyz\n";
            _loc3_ += "mul " + _loc11_ + ".xyzw," + _loc10_ + ".xyzw," + _loc14_ + "\n";
            _loc3_ += "add " + _loc12_ + ".xyz," + _loc12_ + ".xyz," + _loc11_ + ".xyz\n";
            _loc3_ += "mul " + _loc11_ + ".xyz," + _loc10_ + ".w," + _loc13_ + ".xyz\n";
            _loc3_ += "add " + param2.scaleAndRotateTarget + ".xyz," + _loc12_ + ".xyz," + _loc11_ + ".xyz\n";
            _loc5_ = 0;
            while(_loc5_ < _loc4_)
            {
               _loc3_ += "mov " + _loc11_ + ".x," + param2.vertexOneConst + "\n";
               _loc3_ += "mov " + _loc11_ + ".yz," + param2.vertexZeroConst + "\n";
               _loc3_ += "nrm " + _loc10_ + ".xyz," + param2.velocityTarget + ".xyz\n";
               _loc3_ += "dp3 " + _loc16_ + "," + _loc10_ + ".xyz," + _loc11_ + ".xyz\n";
               _loc3_ += "crs " + _loc10_ + ".xyz," + _loc11_ + ".xyz," + _loc10_ + ".xyz\n";
               _loc3_ += "nrm " + _loc10_ + ".xyz," + _loc10_ + ".xyz\n";
               _loc3_ += "dp3 " + _loc12_ + ".x," + _loc10_ + ".xyz," + _loc10_ + ".xyz\n";
               _loc3_ += "sge " + _loc12_ + ".x," + param2.vertexZeroConst + "," + _loc12_ + ".x\n";
               _loc3_ += "add " + _loc10_ + ".z," + _loc12_ + ".x," + _loc10_ + ".z\n";
               _loc3_ += "add " + _loc17_ + "," + _loc16_ + "," + param2.vertexOneConst + "\n";
               _loc3_ += "div " + _loc17_ + "," + _loc17_ + "," + param2.vertexTwoConst + "\n";
               _loc3_ += "sqt " + _loc14_ + "," + _loc17_ + "\n";
               _loc3_ += "sub " + _loc17_ + "," + param2.vertexOneConst + "," + _loc16_ + "\n";
               _loc3_ += "div " + _loc17_ + "," + _loc17_ + "," + param2.vertexTwoConst + "\n";
               _loc3_ += "sqt " + _loc15_ + "," + _loc17_ + "\n";
               _loc3_ += "mul " + _loc12_ + ".xyz," + _loc15_ + "," + _loc10_ + ".xyz\n";
               _loc3_ += "mul " + _loc13_ + ".xyz," + _loc15_ + "," + _loc10_ + ".xyz\n";
               _loc3_ += "neg " + _loc13_ + ".xyz," + _loc13_ + ".xyz\n";
               _loc3_ += "crs " + _loc10_ + ".xyz," + _loc12_ + ".xyz," + param2.rotationRegisters[_loc5_] + ".xyz\n";
               _loc3_ += "mul " + _loc11_ + ".xyz," + _loc14_ + "," + param2.rotationRegisters[_loc5_] + ".xyz\n";
               _loc3_ += "add " + _loc10_ + ".xyz," + _loc10_ + ".xyz," + _loc11_ + ".xyz\n";
               _loc3_ += "dp3 " + _loc11_ + ".w," + _loc12_ + ".xyz," + param2.rotationRegisters[_loc5_] + ".xyz\n";
               _loc3_ += "neg " + _loc10_ + ".w," + _loc11_ + ".w\n";
               _loc3_ += "crs " + _loc12_ + ".xyz," + _loc10_ + ".xyz," + _loc13_ + ".xyz\n";
               _loc3_ += "mul " + _loc11_ + ".xyzw," + _loc10_ + ".xyzw," + _loc14_ + "\n";
               _loc3_ += "add " + _loc12_ + ".xyz," + _loc12_ + ".xyz," + _loc11_ + ".xyz\n";
               _loc3_ += "mul " + _loc11_ + ".xyz," + _loc10_ + ".w," + _loc13_ + ".xyz\n";
               _loc3_ += "add " + param2.rotationRegisters[_loc5_] + ".xyz," + _loc12_ + ".xyz," + _loc11_ + ".xyz\n";
               _loc5_++;
            }
         }
         return _loc3_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleRotateToHeadingState
      {
         return param1.getAnimationState(this) as ParticleRotateToHeadingState;
      }
      
      override arcane function processAnimationSetting(param1:ParticleAnimationSet) : void
      {
         param1.needVelocity = true;
      }
   }
}

