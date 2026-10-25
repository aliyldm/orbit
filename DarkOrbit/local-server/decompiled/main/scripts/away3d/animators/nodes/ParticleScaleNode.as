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
   
   public class ParticleScaleNode extends ParticleNodeBase
   {
      
      arcane static const SCALE_INDEX:uint = 0;
      
      public static const SCALE_VECTOR3D:String = "ScaleVector3D";
      
      arcane var _usesCycle:Boolean;
      
      arcane var _usesPhase:Boolean;
      
      arcane var _minScale:Number;
      
      arcane var _maxScale:Number;
      
      arcane var _cycleDuration:Number;
      
      arcane var _cyclePhase:Number;
      
      public function ParticleScaleNode(param1:uint, param2:Boolean, param3:Boolean, param4:Number = 1, param5:Number = 1, param6:Number = 1, param7:Number = 0)
      {
         var _loc8_:int = 2;
         if(param2)
         {
            _loc8_++;
         }
         if(param3)
         {
            _loc8_++;
         }
         super("ParticleScale",param1,_loc8_,3);
         _stateClass = ParticleScaleState;
         this._usesCycle = param2;
         this._usesPhase = param3;
         this._minScale = param4;
         this._maxScale = param5;
         this._cycleDuration = param6;
         this._cyclePhase = param7;
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         param1 = param1;
         var _loc3_:String = "";
         var _loc4_:ShaderRegisterElement = param2.getFreeVertexSingleTemp();
         var _loc5_:ShaderRegisterElement = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
         param2.setRegisterIndex(this,SCALE_INDEX,_loc5_.index);
         if(this._usesCycle)
         {
            _loc3_ += "mul " + _loc4_ + "," + param2.vertexTime + "," + _loc5_ + ".z\n";
            if(this._usesPhase)
            {
               _loc3_ += "add " + _loc4_ + "," + _loc4_ + "," + _loc5_ + ".w\n";
            }
            _loc3_ += "sin " + _loc4_ + "," + _loc4_ + "\n";
         }
         _loc3_ += "mul " + _loc4_ + "," + _loc5_ + ".y," + (this._usesCycle ? _loc4_ : param2.vertexLife) + "\n";
         _loc3_ += "add " + _loc4_ + "," + _loc5_ + ".x," + _loc4_ + "\n";
         return _loc3_ + ("mul " + param2.scaleAndRotateTarget + ".xyz," + param2.scaleAndRotateTarget + ".xyz," + _loc4_ + "\n");
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleScaleState
      {
         return param1.getAnimationState(this) as ParticleScaleState;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc2_:Vector3D = param1[SCALE_VECTOR3D];
         if(!_loc2_)
         {
            throw new Error("there is no " + SCALE_VECTOR3D + " in param!");
         }
         if(this._usesCycle)
         {
            _oneData[0] = (_loc2_.x + _loc2_.y) / 2;
            _oneData[1] = Math.abs(_loc2_.x - _loc2_.y) / 2;
            if(_loc2_.z <= 0)
            {
               throw new Error("the cycle duration must be greater than zero");
            }
            _oneData[2] = Math.PI * 2 / _loc2_.z;
            if(this._usesPhase)
            {
               _oneData[3] = _loc2_.w * Math.PI / 180;
            }
         }
         else
         {
            _oneData[0] = _loc2_.x;
            _oneData[1] = _loc2_.y - _loc2_.x;
         }
      }
   }
}

