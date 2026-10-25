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
   
   public class ParticleOscillatorNode extends ParticleNodeBase
   {
      
      arcane static const OSCILLATOR_INDEX:uint = 0;
      
      public static const OSCILLATOR_VECTOR3D:String = "OscillatorVector3D";
      
      arcane var _oscillator:Vector3D;
      
      public function ParticleOscillatorNode(param1:uint, param2:Vector3D = null)
      {
         super("ParticleOscillator",param1,4);
         _stateClass = ParticleOscillatorState;
         this._oscillator = param2 || new Vector3D();
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,OSCILLATOR_INDEX,_loc3_.index);
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc5_:ShaderRegisterElement = new ShaderRegisterElement(_loc4_.regName,_loc4_.index,0);
         var _loc6_:ShaderRegisterElement = new ShaderRegisterElement(_loc4_.regName,_loc4_.index,1);
         var _loc7_:ShaderRegisterElement = new ShaderRegisterElement(_loc4_.regName,_loc4_.index,2);
         param2.addVertexTempUsages(_loc4_,1);
         var _loc8_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc9_:ShaderRegisterElement = new ShaderRegisterElement(_loc8_.regName,_loc8_.index);
         param2.removeVertexTempUsage(_loc4_);
         var _loc10_:String = "";
         _loc10_ = _loc10_ + ("mul " + _loc5_ + "," + param2.vertexTime + "," + _loc3_ + ".w\n");
         _loc10_ = _loc10_ + ("sin " + _loc6_ + "," + _loc5_ + "\n");
         _loc10_ = _loc10_ + ("mul " + _loc9_ + ".xyz," + _loc6_ + "," + _loc3_ + ".xyz\n");
         _loc10_ = _loc10_ + ("add " + param2.positionTarget + ".xyz," + _loc9_ + ".xyz," + param2.positionTarget + ".xyz\n");
         if(param2.needVelocity)
         {
            _loc10_ += "cos " + _loc7_ + "," + _loc5_ + "\n";
            _loc10_ = _loc10_ + ("mul " + _loc9_ + ".xyz," + _loc7_ + "," + _loc3_ + ".xyz\n");
            _loc10_ = _loc10_ + ("add " + param2.velocityTarget + ".xyz," + _loc9_ + ".xyz," + param2.velocityTarget + ".xyz\n");
         }
         return _loc10_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleOscillatorState
      {
         return param1.getAnimationState(this) as ParticleOscillatorState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[OSCILLATOR_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + OSCILLATOR_VECTOR3D + " in param!");
         }
         _oneData[0] = _loc2_.x;
         _oneData[1] = _loc2_.y;
         _oneData[2] = _loc2_.z;
         if(_loc2_.w <= 0)
         {
            throw new Error("the cycle duration must greater than zero");
         }
         _oneData[3] = Math.PI * 2 / _loc2_.w;
      }
   }
}

