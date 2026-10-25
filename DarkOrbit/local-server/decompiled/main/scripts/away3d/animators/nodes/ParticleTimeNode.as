package away3d.animators.nodes
{
   import away3d.*;
   import away3d.animators.*;
   import away3d.animators.data.*;
   import away3d.animators.states.*;
   import away3d.materials.compilation.*;
   import away3d.materials.passes.*;
   
   use namespace arcane;
   
   public class ParticleTimeNode extends ParticleNodeBase
   {
      
      arcane static const TIME_STREAM_INDEX:uint = 0;
      
      arcane static const TIME_CONSTANT_INDEX:uint = 1;
      
      arcane var _usesDuration:Boolean;
      
      arcane var _usesDelay:Boolean;
      
      arcane var _usesLooping:Boolean;
      
      public function ParticleTimeNode(param1:Boolean = false, param2:Boolean = false, param3:Boolean = false)
      {
         _stateClass = ParticleTimeState;
         this._usesDuration = param1;
         this._usesLooping = param2;
         this._usesDelay = param3;
         super("ParticleTime",ParticlePropertiesMode.LOCAL_STATIC,4,0);
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc7_:ShaderRegisterElement = null;
         var _loc8_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:ShaderRegisterElement = param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,TIME_STREAM_INDEX,_loc3_.index);
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexConstant();
         param2.setRegisterIndex(this,TIME_CONSTANT_INDEX,_loc4_.index);
         var _loc5_:String = "";
         _loc5_ = _loc5_ + ("sub " + param2.vertexTime + "," + _loc4_ + "," + _loc3_ + ".x\n");
         var _loc6_:ShaderRegisterElement = param2.getFreeVertexSingleTemp();
         _loc5_ += "sge " + _loc6_ + "," + param2.vertexTime + "," + param2.vertexZeroConst + "\n";
         _loc5_ = _loc5_ + ("mul " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc6_ + "\n");
         if(this._usesDuration)
         {
            if(this._usesLooping)
            {
               _loc7_ = param2.getFreeVertexSingleTemp();
               if(this._usesDelay)
               {
                  _loc5_ += "div " + _loc7_ + "," + param2.vertexTime + "," + _loc3_ + ".z\n";
                  _loc5_ = _loc5_ + ("frc " + _loc7_ + "," + _loc7_ + "\n");
                  _loc5_ = _loc5_ + ("mul " + param2.vertexTime + "," + _loc7_ + "," + _loc3_ + ".z\n");
                  _loc5_ = _loc5_ + ("slt " + _loc7_ + "," + param2.vertexTime + "," + _loc3_ + ".y\n");
                  _loc5_ = _loc5_ + ("mul " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc7_ + "\n");
               }
               else
               {
                  _loc5_ += "mul " + _loc7_ + "," + param2.vertexTime + "," + _loc3_ + ".w\n";
                  _loc5_ = _loc5_ + ("frc " + _loc7_ + "," + _loc7_ + "\n");
                  _loc5_ = _loc5_ + ("mul " + param2.vertexTime + "," + _loc7_ + "," + _loc3_ + ".y\n");
               }
            }
            else
            {
               _loc8_ = param2.getFreeVertexSingleTemp();
               _loc5_ += "sge " + _loc8_ + "," + _loc3_ + ".y," + param2.vertexTime + "\n";
               _loc5_ = _loc5_ + ("mul " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc8_ + "\n");
            }
         }
         return _loc5_ + ("mul " + param2.vertexLife + "," + param2.vertexTime + "," + _loc3_ + ".w\n");
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleTimeState
      {
         return param1.getAnimationState(this) as ParticleTimeState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         _oneData[0] = param1.startTime;
         _oneData[1] = param1.duration;
         _oneData[2] = param1.delay + param1.duration;
         _oneData[3] = 1 / param1.duration;
      }
   }
}

