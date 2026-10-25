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
   
   public class ParticleUVNode extends ParticleNodeBase
   {
      
      arcane static const UV_INDEX:uint = 0;
      
      public static const GLOBAL:uint = 1;
      
      public static const U_AXIS:String = "x";
      
      public static const V_AXIS:String = "y";
      
      public static const LINEAR_EASE:int = 1;
      
      public static const SINE_EASE:int = 2;
      
      public static const UV_CYCLE:String = "UVCycle";
      
      public static const UV_SCALE:String = "UVSclae";
      
      arcane var _uvData:Vector3D;
      
      arcane var _cycle:Number;
      
      arcane var _scale:Number;
      
      arcane var _axis:String;
      
      arcane var _formula:int;
      
      public function ParticleUVNode(param1:uint, param2:Number = 1, param3:Number = 1, param4:String = "x", param5:int = 1)
      {
         super("ParticleUV",param1,2,ParticleAnimationSet.POST_PRIORITY + 1);
         _stateClass = ParticleUVState;
         this._cycle = param2;
         this._scale = param3;
         this._axis = param4;
         this._formula = param5;
      }
      
      override public function getAGALUVCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:Number = NaN;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:String = "";
         if(param2.needUVAnimation)
         {
            _loc4_ = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
            param2.setRegisterIndex(this,UV_INDEX,_loc4_.index);
            _loc5_ = this._axis == "x" ? 0 : (this._axis == "y" ? 1 : 2);
            _loc6_ = new ShaderRegisterElement(param2.uvTarget.regName,param2.uvTarget.index,_loc5_);
            _loc7_ = param2.getFreeVertexSingleTemp();
            if(this._scale != 1)
            {
               _loc3_ += "mul " + _loc6_ + "," + _loc6_ + "," + _loc4_ + ".y\n";
            }
            switch(this._formula)
            {
               case SINE_EASE:
                  _loc3_ += "mul " + _loc7_ + "," + param2.vertexTime + "," + _loc4_ + ".x\n";
                  _loc3_ += "sin " + _loc7_ + "," + _loc7_ + "\n";
                  break;
               case LINEAR_EASE:
               default:
                  _loc3_ += "mul " + _loc7_ + "," + param2.vertexTime + "," + _loc4_ + ".x\n";
            }
            _loc3_ += "add " + _loc6_ + "," + _loc6_ + "," + _loc7_ + "\n";
         }
         return _loc3_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleUVState
      {
         return param1.getAnimationState(this) as ParticleUVState;
      }
      
      override arcane function processAnimationSetting(param1:ParticleAnimationSet) : void
      {
         param1.hasUVNode = true;
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         if(!param1.hasOwnProperty(UV_CYCLE) || !(param1[UV_CYCLE] is Number))
         {
            throw new Error("there is no " + UV_CYCLE + " in param!");
         }
         var _loc2_:Number = Number(param1[UV_CYCLE]);
         var _loc3_:Number = 1;
         if(param1.hasOwnProperty(UV_SCALE) && param1[UV_SCALE] is Number)
         {
            _loc3_ = Number(param1[UV_SCALE]);
         }
         switch(this._formula)
         {
            case SINE_EASE:
               _oneData[0] = Math.PI * 2 / _loc2_;
               break;
            case LINEAR_EASE:
            default:
               _oneData[0] = 1 / _loc2_;
         }
         _oneData[1] = _loc3_;
      }
   }
}

