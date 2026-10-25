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
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class CombinedGALMethod extends EffectMethodBase
   {
      
      public static const MULTIPLY:String = "multiply";
      
      public static const ADD:String = "add";
      
      public static const ALPHA_MASK_THRESHOLD:Number = 0.5;
      
      private var _lightMapUsesSecondaryUV:Boolean = true;
      
      private var _diffuseTexture:Texture2DBase;
      
      private var _galTexture:Texture2DBase;
      
      private var _lightMapBlendMode:String = "multiply";
      
      public function CombinedGALMethod(param1:Boolean, param2:String = "multiply")
      {
         super();
         this._lightMapUsesSecondaryUV = param1;
         this._lightMapBlendMode = param2;
      }
      
      public function get diffuseTexture() : Texture2DBase
      {
         return this._diffuseTexture;
      }
      
      public function set diffuseTexture(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != Boolean(this._diffuseTexture) || Boolean(param1 && this._diffuseTexture) && (Boolean(param1.hasMipMaps != this._diffuseTexture.hasMipMaps || param1.format != this._diffuseTexture.format)))
         {
            invalidateShaderProgram();
         }
         this._diffuseTexture = param1;
      }
      
      public function get galTexture() : Texture2DBase
      {
         return this._galTexture;
      }
      
      public function set galTexture(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != Boolean(this._galTexture) || Boolean(param1 && this._galTexture) && (Boolean(param1.hasMipMaps != this._galTexture.hasMipMaps || param1.format != this._galTexture.format)))
         {
            invalidateShaderProgram();
         }
         this._galTexture = param1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsUV = this._galTexture != null;
         param1.needsSecondaryUV = this.lightMapUsesSecondaryUV;
      }
      
      override public function copyFrom(param1:ShadingMethodBase) : void
      {
         var _loc2_:CombinedGALMethod = param1 as CombinedGALMethod;
         this.diffuseTexture = _loc2_.diffuseTexture;
         this.galTexture = _loc2_.galTexture;
         this.lightMapUsesSecondaryUV = _loc2_.lightMapUsesSecondaryUV;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         if(Boolean(this._diffuseTexture) && Boolean(this._galTexture))
         {
            param2._context3D.setTextureAt(param1.texturesIndex,this._diffuseTexture.getTextureForStage3D(param2));
            param2._context3D.setTextureAt(param1.texturesIndex + 1,this._galTexture.getTextureForStage3D(param2));
         }
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         super.arcane::setRenderState(param1,param2,param3,param4);
         if(this._galTexture)
         {
            param1.fragmentData[param1.fragmentConstantsIndex] = ALPHA_MASK_THRESHOLD;
            param1.fragmentData[param1.fragmentConstantsIndex + 1] = param2.shaderParams ? Number(param2.shaderParams.glow) || 0 : 1;
         }
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:ShaderRegisterElement = null;
         var _loc8_:ShaderRegisterElement = null;
         var _loc9_:ShaderRegisterElement = null;
         var _loc10_:Array = null;
         if(Boolean(this._diffuseTexture) && Boolean(this._galTexture))
         {
            _loc4_ = param2.getFreeTextureReg();
            _loc5_ = param2.getFreeTextureReg();
            param1.texturesIndex = _loc4_.index;
            _loc6_ = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(_loc6_,1);
            _loc7_ = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(_loc6_,1);
            _loc8_ = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(_loc8_,1);
            _loc9_ = param2.getFreeFragmentConstant();
            param1.fragmentConstantsIndex = _loc9_.index * 4;
            _loc10_ = [];
            _loc10_.push(getTex2DSampleCode(param1,_loc6_,_loc5_,this._galTexture,_sharedRegisters.uvVarying));
            _loc10_.push("sub " + _loc8_ + ".x, " + _loc6_ + ".yyyy, " + _loc9_ + ".x");
            _loc10_.push("kill " + _loc8_ + ".x");
            _loc10_.push("mul " + param3 + ", " + param3 + ", " + _loc6_ + ".yyyy");
            if(this._lightMapUsesSecondaryUV)
            {
               _loc10_.push(getTex2DSampleCode(param1,_loc7_,_loc5_,this._galTexture,_sharedRegisters.secondaryUVVarying));
            }
            else
            {
               _loc7_ = _loc6_;
            }
            switch(this._lightMapBlendMode)
            {
               case MULTIPLY:
                  _loc10_.push("mul " + param3 + ", " + param3 + ", " + _loc7_ + ".zzzz");
                  break;
               case ADD:
                  _loc10_.push("add " + param3 + ", " + param3 + ", " + _loc7_ + ".zzzz");
            }
            _loc10_.push(getTex2DSampleCode(param1,_loc8_,_loc4_,this._diffuseTexture));
            _loc10_.push("mul " + _loc8_ + ".xyz, " + _loc8_ + "," + _loc6_ + ".xxxx");
            _loc10_.push("mul " + _loc8_ + ".xyz, " + _loc8_ + "," + _loc9_ + ".yyyy");
            _loc10_.push("max " + param3 + ".xyz, " + param3 + ", " + _loc8_);
            param2.removeFragmentTempUsage(_loc8_);
            return _loc10_.join("\n") + "\n";
         }
         return "";
      }
      
      public function get lightMapUsesSecondaryUV() : Boolean
      {
         return this._lightMapUsesSecondaryUV;
      }
      
      public function set lightMapUsesSecondaryUV(param1:Boolean) : void
      {
         if(this._lightMapUsesSecondaryUV != param1)
         {
            this._lightMapUsesSecondaryUV = param1;
            invalidateShaderProgram();
         }
      }
      
      public function get lightMapBlendMode() : String
      {
         return this._lightMapBlendMode;
      }
      
      public function set lightMapBlendMode(param1:String) : void
      {
         if(param1 != ADD && param1 != MULTIPLY)
         {
            throw new Error("Unknown blendmode!");
         }
         if(this._lightMapBlendMode == param1)
         {
            return;
         }
         this._lightMapBlendMode = param1;
         invalidateShaderProgram();
      }
   }
}

