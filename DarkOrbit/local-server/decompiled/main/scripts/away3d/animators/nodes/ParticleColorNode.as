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
   
   public class ParticleColorNode extends ParticleNodeBase
   {
      
      arcane static const START_MULTIPLIER_INDEX:uint = 0;
      
      arcane static const DELTA_MULTIPLIER_INDEX:uint = 1;
      
      arcane static const START_OFFSET_INDEX:uint = 2;
      
      arcane static const DELTA_OFFSET_INDEX:uint = 3;
      
      arcane static const CYCLE_INDEX:uint = 4;
      
      public static const COLOR_START_COLORTRANSFORM:String = "ColorStartColorTransform";
      
      public static const COLOR_END_COLORTRANSFORM:String = "ColorEndColorTransform";
      
      arcane var _usesMultiplier:Boolean;
      
      arcane var _usesOffset:Boolean;
      
      arcane var _usesCycle:Boolean;
      
      arcane var _usesPhase:Boolean;
      
      arcane var _startColor:ColorTransform;
      
      arcane var _endColor:ColorTransform;
      
      arcane var _cycleDuration:Number;
      
      arcane var _cyclePhase:Number;
      
      public function ParticleColorNode(param1:uint, param2:Boolean = true, param3:Boolean = true, param4:Boolean = false, param5:Boolean = false, param6:ColorTransform = null, param7:ColorTransform = null, param8:Number = 1, param9:Number = 0)
      {
         _stateClass = ParticleColorState;
         this._usesMultiplier = param2;
         this._usesOffset = param3;
         this._usesCycle = param4;
         this._usesPhase = param5;
         this._startColor = param6 || new ColorTransform();
         this._endColor = param7 || new ColorTransform();
         this._cycleDuration = param8;
         this._cyclePhase = param9;
         super("ParticleColor",param1,this._usesMultiplier && this._usesOffset ? 16 : 8,ParticleAnimationSet.COLOR_PRIORITY);
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         var _loc8_:ShaderRegisterElement = null;
         var _loc9_:ShaderRegisterElement = null;
         var _loc10_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:String = "";
         if(param2.needFragmentAnimation)
         {
            _loc4_ = param2.getFreeVertexVectorTemp();
            if(this._usesCycle)
            {
               _loc5_ = param2.getFreeVertexConstant();
               param2.setRegisterIndex(this,CYCLE_INDEX,_loc5_.index);
               param2.addVertexTempUsages(_loc4_,1);
               _loc6_ = param2.getFreeVertexSingleTemp();
               param2.removeVertexTempUsage(_loc4_);
               _loc3_ += "mul " + _loc6_ + "," + param2.vertexTime + "," + _loc5_ + ".x\n";
               if(this._usesPhase)
               {
                  _loc3_ += "add " + _loc6_ + "," + _loc6_ + "," + _loc5_ + ".y\n";
               }
               _loc3_ += "sin " + _loc6_ + "," + _loc6_ + "\n";
            }
            if(this._usesMultiplier)
            {
               _loc7_ = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
               _loc8_ = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
               param2.setRegisterIndex(this,START_MULTIPLIER_INDEX,_loc7_.index);
               param2.setRegisterIndex(this,DELTA_MULTIPLIER_INDEX,_loc8_.index);
               _loc3_ += "mul " + _loc4_ + "," + _loc8_ + "," + (this._usesCycle ? _loc6_ : param2.vertexLife) + "\n";
               _loc3_ += "add " + _loc4_ + "," + _loc4_ + "," + _loc7_ + "\n";
               _loc3_ += "mul " + param2.colorMulTarget + "," + _loc4_ + "," + param2.colorMulTarget + "\n";
            }
            if(this._usesOffset)
            {
               _loc9_ = _mode == ParticlePropertiesMode.LOCAL_STATIC ? param2.getFreeVertexAttribute() : param2.getFreeVertexConstant();
               _loc10_ = _mode == ParticlePropertiesMode.LOCAL_STATIC ? param2.getFreeVertexAttribute() : param2.getFreeVertexConstant();
               param2.setRegisterIndex(this,START_OFFSET_INDEX,_loc9_.index);
               param2.setRegisterIndex(this,DELTA_OFFSET_INDEX,_loc10_.index);
               _loc3_ += "mul " + _loc4_ + "," + _loc10_ + "," + (this._usesCycle ? _loc6_ : param2.vertexLife) + "\n";
               _loc3_ += "add " + _loc4_ + "," + _loc4_ + "," + _loc9_ + "\n";
               _loc3_ += "add " + param2.colorAddTarget + "," + _loc4_ + "," + param2.colorAddTarget + "\n";
            }
         }
         return _loc3_;
      }
      
      public function getAnimationState(param1:IAnimator) : ParticleColorState
      {
         return param1.getAnimationState(this) as ParticleColorState;
      }
      
      override arcane function processAnimationSetting(param1:ParticleAnimationSet) : void
      {
         if(this._usesMultiplier)
         {
            param1.hasColorMulNode = true;
         }
         if(this._usesOffset)
         {
            param1.hasColorAddNode = true;
         }
      }
      
      override arcane function generatePropertyOfOneParticle(param1:ParticleProperties) : void
      {
         var _loc4_:uint = 0;
         var _loc2_:ColorTransform = param1[COLOR_START_COLORTRANSFORM];
         if(!_loc2_)
         {
            throw new Error("there is no " + COLOR_START_COLORTRANSFORM + " in param!");
         }
         var _loc3_:ColorTransform = param1[COLOR_END_COLORTRANSFORM];
         if(!_loc3_)
         {
            throw new Error("there is no " + COLOR_END_COLORTRANSFORM + " in param!");
         }
         if(!this._usesCycle)
         {
            if(this._usesMultiplier)
            {
               var _loc5_:uint;
               _oneData[_loc5_ = _loc4_++] = _loc2_.redMultiplier;
               var _loc6_:uint;
               _oneData[_loc6_ = _loc4_++] = _loc2_.greenMultiplier;
               var _loc7_:uint;
               _oneData[_loc7_ = _loc4_++] = _loc2_.blueMultiplier;
               var _loc8_:uint;
               _oneData[_loc8_ = _loc4_++] = _loc2_.alphaMultiplier;
               var _loc9_:uint;
               _oneData[_loc9_ = _loc4_++] = _loc3_.redMultiplier - _loc2_.redMultiplier;
               var _loc10_:uint;
               _oneData[_loc10_ = _loc4_++] = _loc3_.greenMultiplier - _loc2_.greenMultiplier;
               var _loc11_:uint;
               _oneData[_loc11_ = _loc4_++] = _loc3_.blueMultiplier - _loc2_.blueMultiplier;
               var _loc12_:uint;
               _oneData[_loc12_ = _loc4_++] = _loc3_.alphaMultiplier - _loc2_.alphaMultiplier;
            }
            if(this._usesOffset)
            {
               _oneData[_loc5_ = _loc4_++] = _loc2_.redOffset / 255;
               _oneData[_loc6_ = _loc4_++] = _loc2_.greenOffset / 255;
               _oneData[_loc7_ = _loc4_++] = _loc2_.blueOffset / 255;
               _oneData[_loc8_ = _loc4_++] = _loc2_.alphaOffset / 255;
               _oneData[_loc9_ = _loc4_++] = (_loc3_.redOffset - _loc2_.redOffset) / 255;
               _oneData[_loc10_ = _loc4_++] = (_loc3_.greenOffset - _loc2_.greenOffset) / 255;
               _oneData[_loc11_ = _loc4_++] = (_loc3_.blueOffset - _loc2_.blueOffset) / 255;
               _oneData[_loc12_ = _loc4_++] = (_loc3_.alphaOffset - _loc2_.alphaOffset) / 255;
            }
         }
         else
         {
            if(this._usesMultiplier)
            {
               _oneData[_loc5_ = _loc4_++] = (_loc2_.redMultiplier + _loc3_.redMultiplier) / 2;
               _oneData[_loc6_ = _loc4_++] = (_loc2_.greenMultiplier + _loc3_.greenMultiplier) / 2;
               _oneData[_loc7_ = _loc4_++] = (_loc2_.blueMultiplier + _loc3_.blueMultiplier) / 2;
               _oneData[_loc8_ = _loc4_++] = (_loc2_.alphaMultiplier + _loc3_.alphaMultiplier) / 2;
               _oneData[_loc9_ = _loc4_++] = (_loc2_.redMultiplier - _loc3_.redMultiplier) / 2;
               _oneData[_loc10_ = _loc4_++] = (_loc2_.greenMultiplier - _loc3_.greenMultiplier) / 2;
               _oneData[_loc11_ = _loc4_++] = (_loc2_.blueMultiplier - _loc3_.blueMultiplier) / 2;
               _oneData[_loc12_ = _loc4_++] = (_loc2_.alphaMultiplier - _loc3_.alphaMultiplier) / 2;
            }
            if(this._usesOffset)
            {
               _oneData[_loc5_ = _loc4_++] = (_loc2_.redOffset + _loc3_.redOffset) / (255 * 2);
               _oneData[_loc6_ = _loc4_++] = (_loc2_.greenOffset + _loc3_.greenOffset) / (255 * 2);
               _oneData[_loc7_ = _loc4_++] = (_loc2_.blueOffset + _loc3_.blueOffset) / (255 * 2);
               _oneData[_loc8_ = _loc4_++] = (_loc2_.alphaOffset + _loc3_.alphaOffset) / (255 * 2);
               _oneData[_loc9_ = _loc4_++] = (_loc2_.redOffset - _loc3_.redOffset) / (255 * 2);
               _oneData[_loc10_ = _loc4_++] = (_loc2_.greenOffset - _loc3_.greenOffset) / (255 * 2);
               _oneData[_loc11_ = _loc4_++] = (_loc2_.blueOffset - _loc3_.blueOffset) / (255 * 2);
               _oneData[_loc12_ = _loc4_++] = (_loc2_.alphaOffset - _loc3_.alphaOffset) / (255 * 2);
            }
         }
      }
   }
}

