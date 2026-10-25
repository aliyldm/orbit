package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.textures.Texture2DBase;
   
   public class SectorControlBeaconMaterial extends EntityBasicMaterial
   {
      
      private var _progressMethod:ProgressMethod;
      
      public function SectorControlBeaconMaterial()
      {
         super();
         this._progressMethod = new ProgressMethod();
         addMethod(this._progressMethod);
      }
      
      override public function setTexture(param1:String, param2:Texture2DBase) : void
      {
         switch(param1)
         {
            case "glow":
               this._progressMethod.texture = param2;
               break;
            default:
               super.setTexture(param1,param2);
         }
      }
   }
}

import away3d.arcane;
import away3d.cameras.Camera3D;
import away3d.core.base.IRenderable;
import away3d.core.managers.Stage3DProxy;
import away3d.materials.compilation.ShaderRegisterCache;
import away3d.materials.compilation.ShaderRegisterElement;
import away3d.materials.methods.EffectMethodBase;
import away3d.materials.methods.MethodVO;
import away3d.textures.TextureProxyBase;

use namespace arcane;

class ProgressMethod extends EffectMethodBase
{
   
   private var _useTexture:Boolean;
   
   private var _texture:TextureProxyBase;
   
   public function ProgressMethod()
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
      var _loc5_:Number = NaN;
      var _loc6_:uint = 0;
      super.arcane::setRenderState(param1,param2,param3,param4);
      if(this._useTexture)
      {
         _loc5_ = Number(param2.shaderParams ? Number(param2.shaderParams.progress) || 0 : 0);
         _loc6_ = uint(param2.shaderParams ? uint(param2.shaderParams.progressColor) || 0 : 0);
         param1.fragmentData[param1.fragmentConstantsIndex + 0] = (_loc6_ >> 16 & 0xFF) / 255;
         param1.fragmentData[param1.fragmentConstantsIndex + 1] = (_loc6_ >> 8 & 0xFF) / 255;
         param1.fragmentData[param1.fragmentConstantsIndex + 2] = (_loc6_ >> 0 & 0xFF) / 255;
         param1.fragmentData[param1.fragmentConstantsIndex + 3] = 1 - _loc5_;
         param1.fragmentData[param1.fragmentConstantsIndex + 4] = 1.5;
      }
   }
   
   override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
   {
      var _loc5_:ShaderRegisterElement = null;
      var _loc6_:ShaderRegisterElement = null;
      var _loc7_:ShaderRegisterElement = null;
      var _loc8_:ShaderRegisterElement = null;
      var _loc4_:String = "";
      if(this._useTexture)
      {
         _loc5_ = param2.getFreeTextureReg();
         param1.texturesIndex = _loc5_.index;
         _loc6_ = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc6_.index * 4;
         _loc7_ = param2.getFreeFragmentConstant();
         _loc8_ = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc8_,1);
         _loc4_ += [getTex2DSampleCode(param1,_loc8_,_loc5_,this._texture),"mul " + _loc8_ + ".xyz, " + _loc8_ + ".xyz, " + _loc6_ + ".xyz","sge " + _loc8_ + ".w, " + _loc8_ + ".wwww, " + _loc6_ + ".wwww","mul " + _loc8_ + ".xyz, " + _loc8_ + ".xyz, " + _loc8_ + ".wwww","mul " + _loc8_ + ".xyz, " + _loc8_ + ".xyz, " + _loc7_ + ".xxxx","add " + param3 + ".xyz, " + param3 + ", " + _loc8_].join("\n") + "\n";
         param2.removeFragmentTempUsage(_loc8_);
      }
      else
      {
         _loc4_ += "mov " + param3 + ", " + param3 + "\n";
      }
      return _loc4_;
   }
}
