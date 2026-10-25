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
   
   public class ParticleInitialColorNode extends ParticleNodeBase
   {
      
      arcane static const MULTIPLIER_INDEX:uint = 0;
      
      arcane static const OFFSET_INDEX:uint = 1;
      
      public static const COLOR_INITIAL_COLORTRANSFORM:String = "ColorInitialColorTransform";
      
      arcane var _usesMultiplier:Boolean;
      
      arcane var _usesOffset:Boolean;
      
      arcane var _initialColor:ColorTransform;
      
      public function ParticleInitialColorNode(param1:uint, param2:Boolean = true, param3:Boolean = false, param4:ColorTransform = null)
      {
         _stateClass = ParticleInitialColorState;
         this._usesMultiplier = param2;
         this._usesOffset = param3;
         this._initialColor = param4 || new ColorTransform();
         super("ParticleInitialColor",param1,this._usesMultiplier && this._usesOffset ? 8 : 4,ParticleAnimationSet.COLOR_PRIORITY);
      }
      
      override public function getAGALVertexCode(param1:MaterialPassBase, param2:AnimationRegisterCache) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:ShaderRegisterElement = null;
         param1 = param1;
         var _loc3_:String = "";
         if(param2.needFragmentAnimation)
         {
            if(this._usesMultiplier)
            {
               _loc4_ = _mode == ParticlePropertiesMode.GLOBAL ? param2.getFreeVertexConstant() : param2.getFreeVertexAttribute();
               param2.setRegisterIndex(this,MULTIPLIER_INDEX,_loc4_.index);
               _loc3_ += "mul " + param2.colorMulTarget + "," + _loc4_ + "," + param2.colorMulTarget + "\n";
            }
            if(this._usesOffset)
            {
               _loc5_ = _mode == ParticlePropertiesMode.LOCAL_STATIC ? param2.getFreeVertexAttribute() : param2.getFreeVertexConstant();
               param2.setRegisterIndex(this,OFFSET_INDEX,_loc5_.index);
               _loc3_ += "add " + param2.colorAddTarget + "," + _loc5_ + "," + param2.colorAddTarget + "\n";
            }
         }
         return _loc3_;
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
         var _loc3_:uint = 0;
         var _loc2_:ColorTransform = param1[COLOR_INITIAL_COLORTRANSFORM];
         if(!_loc2_)
         {
            throw new Error("there is no " + COLOR_INITIAL_COLORTRANSFORM + " in param!");
         }
         if(this._usesMultiplier)
         {
            var _loc4_:uint;
            _oneData[_loc4_ = _loc3_++] = _loc2_.redMultiplier;
            var _loc5_:uint;
            _oneData[_loc5_ = _loc3_++] = _loc2_.greenMultiplier;
            var _loc6_:uint;
            _oneData[_loc6_ = _loc3_++] = _loc2_.blueMultiplier;
            var _loc7_:uint;
            _oneData[_loc7_ = _loc3_++] = _loc2_.alphaMultiplier;
         }
         if(this._usesOffset)
         {
            _oneData[_loc4_ = _loc3_++] = _loc2_.redOffset / 255;
            _oneData[_loc5_ = _loc3_++] = _loc2_.greenOffset / 255;
            _oneData[_loc6_ = _loc3_++] = _loc2_.blueOffset / 255;
            _oneData[_loc7_ = _loc3_++] = _loc2_.alphaOffset / 255;
         }
      }
   }
}

