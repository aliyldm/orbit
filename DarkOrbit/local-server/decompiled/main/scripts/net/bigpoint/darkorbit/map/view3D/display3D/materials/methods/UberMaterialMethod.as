package net.bigpoint.darkorbit.map.view3D.display3D.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.MethodVO;
   import away3d.textures.Texture2DBase;
   import flash.utils.getTimer;
   
   use namespace arcane;
   
   public class UberMaterialMethod extends EffectMethodBase
   {
      
      public var timeScale:Number = 10;
      
      public var glowStrength:Number = 5;
      
      private var _colorTex:Texture2DBase;
      
      private var _offsetTex:Texture2DBase;
      
      private var _offsetTextureReg:ShaderRegisterElement;
      
      private var _colorTextureReg:ShaderRegisterElement;
      
      public function UberMaterialMethod(param1:Texture2DBase, param2:Texture2DBase)
      {
         super();
         this._colorTex = param1;
         this._offsetTex = param2;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsUV = true;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         param2.context3D.setTextureAt(this._offsetTextureReg.index,this._offsetTex.getTextureForStage3D(param2));
         param2.context3D.setTextureAt(this._colorTextureReg.index,this._colorTex.getTextureForStage3D(param2));
         param1.fragmentData[param1.fragmentConstantsIndex] = getTimer() / 1000 / this.timeScale;
         param1.fragmentData[param1.fragmentConstantsIndex + 1] = this.glowStrength;
      }
      
      override arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         param2.context3D.setTextureAt(this._offsetTextureReg.index,null);
         param2.context3D.setTextureAt(this._colorTextureReg.index,null);
         super.arcane::deactivate(param1,param2);
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         this._offsetTextureReg = param2.getFreeTextureReg();
         this._colorTextureReg = param2.getFreeTextureReg();
         var _loc4_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc4_.index * 4;
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc5_,1);
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc6_,1);
         var _loc7_:String = [getTex2DSampleCode(param1,_loc5_,this._offsetTextureReg,this._offsetTex,null,"clamp"),"mul " + _loc6_ + ", " + _loc5_ + ", " + _sharedRegisters.uvVarying,"add " + _loc6_ + ".xy, " + _loc6_ + ".xy, " + _loc4_ + ".xx",getTex2DSampleCode(param1,_loc6_,this._colorTextureReg,this._colorTex,_loc6_,"repeat"),"mul " + _loc5_ + ", " + _loc5_ + ", " + _loc6_,"mul " + _loc5_ + ", " + _loc5_ + ", " + _loc4_ + ".yyyy","add " + param3 + ".xyz, " + param3 + ", " + _loc5_ + "\n"].join("\n");
         param2.removeFragmentTempUsage(_loc5_);
         param2.removeFragmentTempUsage(_loc6_);
         return _loc7_;
      }
   }
}

