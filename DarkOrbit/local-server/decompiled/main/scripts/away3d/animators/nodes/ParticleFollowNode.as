package away3d.animators.nodes
{
   import away3d.*;
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   import away3d.materials.compilation.*;
   import away3d.materials.passes.*;
   
   use namespace arcane;
   
   public class ParticleFollowNode extends ParticleNodeBase
   {
      
      arcane static const FOLLOW_POSITION_INDEX:uint = 0;
      
      arcane static const FOLLOW_ROTATION_INDEX:uint = 1;
      
      arcane var _usesPosition:Boolean;
      
      arcane var _usesRotation:Boolean;
      
      arcane var _smooth:Boolean;
      
      public function ParticleFollowNode(param1:Boolean = true, param2:Boolean = true, param3:Boolean = false)
      {
         _stateClass = ParticleFollowState;
         this._usesPosition = param1;
         this._usesRotation = param2;
         this._smooth = param3;
         super("ParticleFollow",ParticlePropertiesMode.LOCAL_DYNAMIC,this._usesPosition && this._usesRotation ? 6 : 3,ParticleAnimationSet.POST_PRIORITY);
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         var _loc8_:ShaderRegisterElement = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:String = "";
         if(this._usesRotation)
         {
            _loc4_ = param2.getFreeVertexAttribute();
            param2.setRegisterIndex(this,FOLLOW_ROTATION_INDEX,_loc4_.index);
            _loc5_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc5_,1);
            _loc6_ = param2.getFreeVertexVectorTemp();
            param2.addVertexTempUsages(_loc6_,1);
            _loc7_ = param2.getFreeVertexVectorTemp();
            if(param2.hasBillboard)
            {
               param2.addVertexTempUsages(_loc7_,1);
               _loc8_ = param2.getFreeVertexVectorTemp();
            }
            param2.removeVertexTempUsage(_loc5_);
            param2.removeVertexTempUsage(_loc6_);
            if(param2.hasBillboard)
            {
               param2.removeVertexTempUsage(_loc7_);
            }
            _loc9_ = int(param2.rotationRegisters.length);
            _loc3_ += "mov " + _loc5_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc5_ + ".x," + param2.vertexOneConst + "\n";
            _loc3_ += "mov " + _loc7_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "sin " + _loc7_ + ".y," + _loc4_ + ".x\n";
            _loc3_ += "cos " + _loc7_ + ".z," + _loc4_ + ".x\n";
            _loc3_ += "mov " + _loc6_ + ".x," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc6_ + ".y," + _loc7_ + ".z\n";
            _loc3_ += "neg " + _loc6_ + ".z," + _loc7_ + ".y\n";
            if(param2.hasBillboard)
            {
               _loc3_ += "m33 " + _loc8_ + ".xyz," + param2.positionTarget + ".xyz," + _loc5_ + "\n";
            }
            else
            {
               _loc3_ += "m33 " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc5_ + "\n";
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  _loc3_ += "m33 " + param2.rotationRegisters[_loc10_] + ".xyz," + param2.rotationRegisters[_loc10_] + "," + _loc5_ + "\n";
                  _loc10_++;
               }
            }
            _loc3_ += "mov " + _loc5_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "cos " + _loc5_ + ".x," + _loc4_ + ".y\n";
            _loc3_ += "sin " + _loc5_ + ".z," + _loc4_ + ".y\n";
            _loc3_ += "mov " + _loc6_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc6_ + ".y," + param2.vertexOneConst + "\n";
            _loc3_ += "mov " + _loc7_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "neg " + _loc7_ + ".x," + _loc5_ + ".z\n";
            _loc3_ += "mov " + _loc7_ + ".z," + _loc5_ + ".x\n";
            if(param2.hasBillboard)
            {
               _loc3_ += "m33 " + _loc8_ + ".xyz," + _loc8_ + ".xyz," + _loc5_ + "\n";
            }
            else
            {
               _loc3_ += "m33 " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc5_ + "\n";
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  _loc3_ += "m33 " + param2.rotationRegisters[_loc10_] + ".xyz," + param2.rotationRegisters[_loc10_] + "," + _loc5_ + "\n";
                  _loc10_++;
               }
            }
            _loc3_ += "mov " + _loc6_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "sin " + _loc6_ + ".x," + _loc4_ + ".z\n";
            _loc3_ += "cos " + _loc6_ + ".y," + _loc4_ + ".z\n";
            _loc3_ += "mov " + _loc5_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc5_ + ".x," + _loc6_ + ".y\n";
            _loc3_ += "neg " + _loc5_ + ".y," + _loc6_ + ".x\n";
            _loc3_ += "mov " + _loc7_ + "," + param2.vertexZeroConst + "\n";
            _loc3_ += "mov " + _loc7_ + ".z," + param2.vertexOneConst + "\n";
            if(param2.hasBillboard)
            {
               _loc3_ += "m33 " + _loc8_ + ".xyz," + _loc8_ + ".xyz," + _loc5_ + "\n";
               _loc3_ += "sub " + _loc8_ + ".xyz," + _loc8_ + ".xyz," + param2.positionTarget + ".xyz\n";
               _loc3_ += "add " + param2.scaleAndRotateTarget + ".xyz," + _loc8_ + ".xyz," + param2.scaleAndRotateTarget + ".xyz\n";
            }
            else
            {
               _loc3_ += "m33 " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc5_ + "\n";
               _loc10_ = 0;
               while(_loc10_ < _loc9_)
               {
                  _loc3_ += "m33 " + param2.rotationRegisters[_loc10_] + ".xyz," + param2.rotationRegisters[_loc10_] + "," + _loc5_ + "\n";
                  _loc10_++;
               }
            }
         }
         if(this._usesPosition)
         {
            _loc11_ = param2.getFreeVertexAttribute();
            param2.setRegisterIndex(this,FOLLOW_POSITION_INDEX,_loc11_.index);
            _loc3_ += "add " + param2.scaleAndRotateTarget + ".xyz," + _loc11_ + "," + param2.scaleAndRotateTarget + ".xyz\n";
         }
         return _loc3_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleFollowState
      {
         return param1.getAnimationState(this) as ParticleFollowState;
      }
   }
}

