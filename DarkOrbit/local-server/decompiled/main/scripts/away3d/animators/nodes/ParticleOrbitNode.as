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
   
   public class ParticleOrbitNode extends ParticleNodeBase
   {
      
      arcane static const ORBIT_INDEX:uint = 0;
      
      arcane static const EULERS_INDEX:uint = 1;
      
      public static const ORBIT_VECTOR3D:String = "OrbitVector3D";
      
      arcane var _usesEulers:Boolean;
      
      arcane var _usesCycle:Boolean;
      
      arcane var _usesPhase:Boolean;
      
      arcane var _radius:Number;
      
      arcane var _cycleDuration:Number;
      
      arcane var _cyclePhase:Number;
      
      arcane var _eulers:Vector3D;
      
      public function ParticleOrbitNode(param1:uint, param2:Boolean = true, param3:Boolean = false, param4:Boolean = false, param5:Number = 100, param6:Number = 1, param7:Number = 0, param8:Vector3D = null)
      {
         var _loc9_:int = 3;
         if(param4)
         {
            _loc9_++;
         }
         super("ParticleOrbit",param1,_loc9_);
         _stateClass = ParticleOrbitState;
         this._usesEulers = param2;
         this._usesCycle = param3;
         this._usesPhase = param4;
         this._radius = param5;
         this._cycleDuration = param6;
         this._cyclePhase = param7;
         this._eulers = param8 || new Vector3D();
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,ORBIT_INDEX,_loc3_.index);
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexConstant();
         param2.setRegisterIndex(this,EULERS_INDEX,_loc4_.index);
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         param2.getFreeVertexConstant();
         var _loc5_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         param2.addVertexTempUsages(_loc5_,1);
         var _loc6_:ShaderRegisterElement = new ShaderRegisterElement(_loc5_.regName,_loc5_.index);
         var _loc7_:ShaderRegisterElement = param2.getFreeVertexVectorTemp();
         var _loc8_:ShaderRegisterElement = new ShaderRegisterElement(_loc7_.regName,_loc7_.index,0);
         var _loc9_:ShaderRegisterElement = new ShaderRegisterElement(_loc7_.regName,_loc7_.index,1);
         var _loc10_:ShaderRegisterElement = new ShaderRegisterElement(_loc7_.regName,_loc7_.index,2);
         param2.removeVertexTempUsage(_loc5_);
         var _loc11_:String = "";
         if(this._usesCycle)
         {
            _loc11_ += "mul " + _loc10_ + "," + param2.vertexTime + "," + _loc3_ + ".y\n";
            if(this._usesPhase)
            {
               _loc11_ += "add " + _loc10_ + "," + _loc10_ + "," + _loc3_ + ".w\n";
            }
         }
         else
         {
            _loc11_ += "mul " + _loc10_ + "," + param2.vertexLife + "," + _loc3_ + ".y\n";
         }
         _loc11_ += "cos " + _loc8_ + "," + _loc10_ + "\n";
         _loc11_ = _loc11_ + ("sin " + _loc9_ + "," + _loc10_ + "\n");
         _loc11_ = _loc11_ + ("mul " + _loc6_ + ".x," + _loc8_ + "," + _loc3_ + ".x\n");
         _loc11_ = _loc11_ + ("mul " + _loc6_ + ".y," + _loc9_ + "," + _loc3_ + ".x\n");
         _loc11_ = _loc11_ + ("mov " + _loc6_ + ".wz" + param2.vertexZeroConst + "\n");
         if(this._usesEulers)
         {
            _loc11_ += "m44 " + _loc6_ + "," + _loc6_ + "," + _loc4_ + "\n";
         }
         _loc11_ += "add " + param2.positionTarget + ".xyz," + _loc6_ + ".xyz," + param2.positionTarget + ".xyz\n";
         if(param2.needVelocity)
         {
            _loc11_ += "neg " + _loc6_ + ".x," + _loc9_ + "\n";
            _loc11_ = _loc11_ + ("mov " + _loc6_ + ".y," + _loc8_ + "\n");
            _loc11_ = _loc11_ + ("mov " + _loc6_ + ".zw," + param2.vertexZeroConst + "\n");
            if(this._usesEulers)
            {
               _loc11_ += "m44 " + _loc6_ + "," + _loc6_ + "," + _loc4_ + "\n";
            }
            _loc11_ += "mul " + _loc6_ + "," + _loc6_ + "," + _loc3_ + ".z\n";
            _loc11_ = _loc11_ + ("div " + _loc6_ + "," + _loc6_ + "," + _loc3_ + ".y\n");
            if(!this._usesCycle)
            {
               _loc11_ += "div " + _loc6_ + "," + _loc6_ + "," + param2.vertexLife + "\n";
            }
            _loc11_ += "add " + param2.velocityTarget + ".xyz," + param2.velocityTarget + ".xyz," + _loc6_ + ".xyz\n";
         }
         return _loc11_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleOrbitState
      {
         return param1.getAnimationState(this) as ParticleOrbitState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[ORBIT_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + ORBIT_VECTOR3D + " in param!");
         }
         _oneData[0] = _loc2_.x;
         if(this._usesCycle && _loc2_.y <= 0)
         {
            throw new Error("the cycle duration must be greater than zero");
         }
         _oneData[1] = Math.PI * 2 / (!this._usesCycle ? 1 : _loc2_.y);
         _oneData[2] = _loc2_.x * Math.PI * 2;
         if(this._usesPhase)
         {
            _oneData[3] = _loc2_.z * Math.PI / 180;
         }
      }
   }
}

