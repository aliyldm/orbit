package net.bigpoint.darkorbit.map.view3D.display3D.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.MethodVO;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class AlphaMaskMethod extends EffectMethodBase
   {
      
      public static const THRESHOLD:Number = 0.5;
      
      private var _texture:Texture2DBase;
      
      public function AlphaMaskMethod()
      {
         super();
      }
      
      public function get texture() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != Boolean(this._texture) || Boolean(param1 && this._texture) && (Boolean(param1.hasMipMaps != this._texture.hasMipMaps || param1.format != this._texture.format)))
         {
            invalidateShaderProgram();
         }
         this._texture = param1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsUV = this._texture != null;
         param1.useSmoothTextures = true;
         param1.useMipmapping = Boolean(this._texture) && this._texture.hasMipMaps;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         if(this._texture)
         {
            param1.fragmentData[param1.fragmentConstantsIndex] = THRESHOLD;
            param2._context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
         }
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         var _loc8_:String = null;
         if(this._texture)
         {
            _loc4_ = param2.getFreeTextureReg();
            _loc5_ = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(_loc5_,1);
            _loc6_ = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(_loc6_,1);
            param1.texturesIndex = _loc4_.index;
            _loc7_ = param2.getFreeFragmentConstant();
            param1.fragmentConstantsIndex = _loc7_.index * 4;
            _loc8_ = getTex2DSampleCode(param1,_loc6_,_loc4_,this._texture,_sharedRegisters.uvVarying) + "sub " + _loc5_ + ".x, " + _loc6_ + ".x, " + _loc7_ + ".x\n" + "kill " + _loc5_ + ".x\n" + "mul " + param3 + ", " + param3 + ", " + _loc6_ + ".x\n";
            param2.removeFragmentTempUsage(_loc5_);
            param2.removeFragmentTempUsage(_loc6_);
            return _loc8_;
         }
         return "";
      }
   }
}

