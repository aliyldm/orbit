package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.materials.TextureMaterial;
   import away3d.textures.Texture2DBase;
   
   public class ExplosionMaterial extends TextureMaterial
   {
      
      private var _explosionMethod:ExplosionMaterialMethod;
      
      public function ExplosionMaterial(param1:Texture2DBase)
      {
         super();
         this._explosionMethod = new ExplosionMaterialMethod(param1);
         addMethod(this._explosionMethod);
         alphaBlending = true;
         this._screenPass.preserveAlpha = false;
      }
      
      public function get explosionMethod() : ExplosionMaterialMethod
      {
         return this._explosionMethod;
      }
   }
}

import away3d.animators.ParticleAnimator;
import away3d.animators.states.ParticleTimeState;
import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.base.SubMesh;
import away3d.core.managers.Stage3DProxy;
import away3d.materials.compilation.ShaderRegisterCache;
import away3d.materials.compilation.ShaderRegisterElement;
import away3d.materials.methods.EffectMethodBase;
import away3d.materials.methods.MethodVO;
import away3d.textures.Texture2DBase;

use namespace arcane;

class ExplosionMaterialMethod extends EffectMethodBase
{
   
   public var fireIntensity:Number = 8;
   
   private var _texture:Texture2DBase;
   
   public function ExplosionMaterialMethod(param1:Texture2DBase)
   {
      super();
      this._texture = param1;
   }
   
   override arcane function initVO(param1:MethodVO) : void
   {
      super.arcane::initVO(param1);
      param1.needsUV = true;
   }
   
   override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
   {
      super.arcane::activate(param1,param2);
      param2._context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
   }
   
   override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
   {
      super.arcane::setRenderState(param1,param2,param3,param4);
      var _loc5_:ParticleAnimator = SubMesh(param2).animator as ParticleAnimator;
      var _loc6_:ParticleTimeState = _loc5_.getAnimationStateByName("ParticleTimeLocalStatic") as ParticleTimeState;
      var _loc7_:Number = _loc5_.time / 1000;
      var _loc8_:Number = _loc6_ ? (_loc7_ - _loc6_.particleTimeNode.oneData[0]) / _loc6_.particleTimeNode.oneData[2] : 1;
      if(_loc8_ < 0 || _loc8_ > 1)
      {
         _loc8_ = 1;
      }
      param1.fragmentData[param1.fragmentConstantsIndex + 0] = Math.max(0,Math.min((_loc8_ - 0.25) * 4,1));
      var _loc9_:Number = 1 - Math.max(0,Math.min((_loc8_ - 0.25) / 0.75,1));
      param1.fragmentData[param1.fragmentConstantsIndex + 1] = _loc9_ * _loc9_;
      param1.fragmentData[param1.fragmentConstantsIndex + 2] = this.fireIntensity;
      param1.fragmentData[param1.fragmentConstantsIndex + 3] = 0.5;
   }
   
   override arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
   {
      param2._context3D.setTextureAt(param1.texturesIndex,null);
      param2._context3D.setTextureAt(param1.texturesIndex + 1,null);
      super.arcane::deactivate(param1,param2);
   }
   
   override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
   {
      var _loc4_:ShaderRegisterElement = param2.getFreeTextureReg();
      param1.texturesIndex = _loc4_.index;
      var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
      param1.fragmentConstantsIndex = _loc5_.index * 4;
      var _loc6_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
      param2.addFragmentTempUsages(_loc6_,1);
      var _loc7_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
      param2.addFragmentTempUsages(_loc7_,1);
      var _loc8_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
      param2.addFragmentTempUsages(_loc8_,1);
      var _loc9_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
      param2.addFragmentTempUsages(_loc9_,1);
      var _loc10_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
      param2.addFragmentTempUsages(_loc10_,1);
      var _loc11_:String = ["mov " + _loc6_ + ", " + _sharedRegisters.uvVarying,"add " + _loc6_ + ".y, " + _loc6_ + ", " + _loc5_ + ".wwww",getTex2DSampleCode(param1,_loc7_,_loc4_,this._texture,_loc6_),getTex2DSampleCode(param1,_loc8_,_loc4_,this._texture),"mov " + _loc6_ + ", " + _loc7_,"mul " + _loc6_ + ".w, " + _loc6_ + ".wwww, " + _loc5_ + ".yyyy","sub " + _loc10_ + ".x, " + _loc8_ + ".wwww, " + _loc5_ + ".xxxx","sat " + _loc10_ + ".x, " + _loc10_ + ".x","mul " + _loc10_ + ".x, " + _loc10_ + ".x, " + _loc5_ + ".z","sub " + _loc9_ + ", " + _loc8_ + ", " + _loc7_,"mul " + _loc9_ + ", " + _loc9_ + ", " + _loc10_ + ".xxxx","add " + _loc9_ + ", " + _loc9_ + ", " + _loc7_,"add " + param3 + ".xyz, " + _loc6_ + ", " + _loc9_,"mov " + param3 + ".w, " + _loc6_ + ".wwww"].join("\n");
      param2.removeFragmentTempUsage(_loc6_);
      param2.removeFragmentTempUsage(_loc7_);
      param2.removeFragmentTempUsage(_loc8_);
      param2.removeFragmentTempUsage(_loc9_);
      param2.removeFragmentTempUsage(_loc10_);
      return _loc11_ + "\n";
   }
}
