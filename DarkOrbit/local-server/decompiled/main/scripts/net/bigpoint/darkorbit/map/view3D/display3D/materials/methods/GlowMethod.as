package net.bigpoint.darkorbit.map.view3D.display3D.materials.methods
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.MethodVO;
   import away3d.materials.methods.ShadingMethodBase;
   import away3d.textures.TextureProxyBase;
   
   use namespace arcane;
   
   public class GlowMethod extends EffectMethodBase
   {
      
      private var _useTexture:Boolean;
      
      private var _texture:TextureProxyBase;
      
      public function GlowMethod(param1:Number = 1)
      {
         super();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         super.arcane::initVO(param1);
         param1.needsUV = true;
      }
      
      public function get texture() : TextureProxyBase
      {
         return this._texture;
      }
      
      public function set texture(param1:TextureProxyBase) : void
      {
         if(Boolean(param1) != this._useTexture || Boolean(param1 && this._texture) && (Boolean(param1.hasMipMaps != this._texture.hasMipMaps || param1.format != this._texture.format)))
         {
            invalidateShaderProgram();
         }
         this._useTexture = Boolean(param1);
         this._texture = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         if(this._useTexture)
         {
            param2.context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
         }
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         super.arcane::setRenderState(param1,param2,param3,param4);
         if(this._useTexture)
         {
            param1.fragmentData[param1.fragmentConstantsIndex] = param2.shaderParams ? Number(param2.shaderParams.glow) || 0 : 1;
         }
      }
      
      override arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         if(this._useTexture)
         {
            param2.context3D.setTextureAt(param1.texturesIndex,null);
         }
         super.arcane::deactivate(param1,param2);
      }
      
      override public function copyFrom(param1:ShadingMethodBase) : void
      {
         var _loc2_:GlowMethod = param1 as GlowMethod;
         this.texture = _loc2_.texture;
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         var _loc4_:String = "";
         if(this._useTexture)
         {
            _loc5_ = param2.getFreeTextureReg();
            param1.texturesIndex = _loc5_.index;
            _loc6_ = param2.getFreeFragmentConstant();
            param1.fragmentConstantsIndex = _loc6_.index * 4;
            _loc7_ = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(_loc7_,1);
            _loc4_ += getTex2DSampleCode(param1,_loc7_,_loc5_,this._texture) + "mul " + _loc7_ + ".xyz, " + _loc7_ + "," + _loc6_ + ".xxxx\n" + "add " + param3 + ".xyz, " + param3 + ", " + _loc7_ + "\n";
            param2.removeFragmentTempUsage(_loc7_);
         }
         return _loc4_;
      }
   }
}

