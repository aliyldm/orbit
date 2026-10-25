package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class BasicDiffuseMethod extends LightingMethodBase
   {
      
      private var _useAmbientTexture:Boolean;
      
      protected var _useTexture:Boolean;
      
      arcane var _totalLightColorReg:ShaderRegisterElement;
      
      protected var _diffuseInputRegister:ShaderRegisterElement;
      
      private var _texture:Texture2DBase;
      
      private var _diffuseColor:uint = 16777215;
      
      private var _diffuseR:Number = 1;
      
      private var _diffuseG:Number = 1;
      
      private var _diffuseB:Number = 1;
      
      private var _diffuseA:Number = 1;
      
      protected var _shadowRegister:ShaderRegisterElement;
      
      protected var _alphaThreshold:Number = 0;
      
      protected var _isFirstLight:Boolean;
      
      public function BasicDiffuseMethod()
      {
         super();
      }
      
      arcane function get useAmbientTexture() : Boolean
      {
         return this._useAmbientTexture;
      }
      
      arcane function set useAmbientTexture(param1:Boolean) : void
      {
         if(this._useAmbientTexture == param1)
         {
            return;
         }
         this._useAmbientTexture = param1;
         invalidateShaderProgram();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsUV = this._useTexture;
         param1.needsNormals = param1.numLights > 0;
      }
      
      public function generateMip(param1:Stage3DProxy) : void
      {
         if(this._useTexture)
         {
            this._texture.getTextureForStage3D(param1);
         }
      }
      
      public function get diffuseAlpha() : Number
      {
         return this._diffuseA;
      }
      
      public function set diffuseAlpha(param1:Number) : void
      {
         this._diffuseA = param1;
      }
      
      public function get diffuseColor() : uint
      {
         return this._diffuseColor;
      }
      
      public function set diffuseColor(param1:uint) : void
      {
         this._diffuseColor = param1;
         this.updateDiffuse();
      }
      
      public function get texture() : Texture2DBase
      {
         return this._texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         if(Boolean(param1) != this._useTexture || Boolean(param1 && this._texture) && (Boolean(param1.hasMipMaps != this._texture.hasMipMaps || param1.format != this._texture.format)))
         {
            invalidateShaderProgram();
         }
         this._useTexture = Boolean(param1);
         this._texture = param1;
      }
      
      public function get alphaThreshold() : Number
      {
         return this._alphaThreshold;
      }
      
      public function set alphaThreshold(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         if(param1 == this._alphaThreshold)
         {
            return;
         }
         if(param1 == 0 || this._alphaThreshold == 0)
         {
            invalidateShaderProgram();
         }
         this._alphaThreshold = param1;
      }
      
      override public function dispose() : void
      {
         this._texture = null;
      }
      
      override public function copyFrom(param1:ShadingMethodBase) : void
      {
         var _loc2_:BasicDiffuseMethod = BasicDiffuseMethod(param1);
         this.alphaThreshold = _loc2_.alphaThreshold;
         this.texture = _loc2_.texture;
         this.useAmbientTexture = _loc2_.useAmbientTexture;
         this.diffuseAlpha = _loc2_.diffuseAlpha;
         this.diffuseColor = _loc2_.diffuseColor;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._shadowRegister = null;
         this._totalLightColorReg = null;
         this._diffuseInputRegister = null;
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:String = "";
         this._isFirstLight = true;
         if(param1.numLights > 0)
         {
            this._totalLightColorReg = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(this._totalLightColorReg,1);
         }
         return _loc3_;
      }
      
      override arcane function getFragmentCodePerLight(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterCache) : String
      {
         var _loc6_:ShaderRegisterElement = null;
         var _loc5_:String = "";
         if(this._isFirstLight)
         {
            _loc6_ = this._totalLightColorReg;
         }
         else
         {
            _loc6_ = param4.getFreeFragmentVectorTemp();
            param4.addFragmentTempUsages(_loc6_,1);
         }
         _loc5_ += "dp3 " + _loc6_ + ".x, " + param2 + ", " + _sharedRegisters.normalFragment + "\n" + "max " + _loc6_ + ".w, " + _loc6_ + ".x, " + _sharedRegisters.commons + ".y\n";
         if(param1.useLightFallOff)
         {
            _loc5_ += "mul " + _loc6_ + ".w, " + _loc6_ + ".w, " + param2 + ".w\n";
         }
         if(_modulateMethod != null)
         {
            _loc5_ += _modulateMethod(param1,_loc6_,param4,_sharedRegisters);
         }
         _loc5_ += "mul " + _loc6_ + ", " + _loc6_ + ".w, " + param3 + "\n";
         if(!this._isFirstLight)
         {
            _loc5_ += "add " + this._totalLightColorReg + ".xyz, " + this._totalLightColorReg + ", " + _loc6_ + "\n";
            param4.removeFragmentTempUsage(_loc6_);
         }
         this._isFirstLight = false;
         return _loc5_;
      }
      
      override arcane function getFragmentCodePerProbe(param1:MethodVO, param2:ShaderRegisterElement, param3:String, param4:ShaderRegisterCache) : String
      {
         var _loc6_:ShaderRegisterElement = null;
         var _loc5_:String = "";
         if(this._isFirstLight)
         {
            _loc6_ = this._totalLightColorReg;
         }
         else
         {
            _loc6_ = param4.getFreeFragmentVectorTemp();
            param4.addFragmentTempUsages(_loc6_,1);
         }
         _loc5_ += "tex " + _loc6_ + ", " + _sharedRegisters.normalFragment + ", " + param2 + " <cube,linear,miplinear>\n" + "mul " + _loc6_ + ".xyz, " + _loc6_ + ".xyz, " + param3 + "\n";
         if(_modulateMethod != null)
         {
            _loc5_ += _modulateMethod(param1,_loc6_,param4,_sharedRegisters);
         }
         if(!this._isFirstLight)
         {
            _loc5_ += "add " + this._totalLightColorReg + ".xyz, " + this._totalLightColorReg + ", " + _loc6_ + "\n";
            param4.removeFragmentTempUsage(_loc6_);
         }
         this._isFirstLight = false;
         return _loc5_;
      }
      
      override arcane function getFragmentPostLightingCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc5_:ShaderRegisterElement = null;
         var _loc6_:ShaderRegisterElement = null;
         var _loc4_:String = "";
         if(param1.numLights > 0)
         {
            if(this._shadowRegister)
            {
               _loc4_ += this.applyShadow(param1,param2);
            }
            _loc5_ = param2.getFreeFragmentVectorTemp();
            param2.addFragmentTempUsages(_loc5_,1);
         }
         else
         {
            _loc5_ = param3;
         }
         if(this._useTexture)
         {
            this._diffuseInputRegister = param2.getFreeTextureReg();
            param1.texturesIndex = this._diffuseInputRegister.index;
            _loc4_ += getTex2DSampleCode(param1,_loc5_,this._diffuseInputRegister,this._texture);
            if(this._alphaThreshold > 0)
            {
               _loc6_ = param2.getFreeFragmentConstant();
               param1.fragmentConstantsIndex = _loc6_.index * 4;
               _loc4_ += "sub " + _loc5_ + ".w, " + _loc5_ + ".w, " + _loc6_ + ".x\n" + "kil " + _loc5_ + ".w\n" + "add " + _loc5_ + ".w, " + _loc5_ + ".w, " + _loc6_ + ".x\n";
            }
         }
         else
         {
            this._diffuseInputRegister = param2.getFreeFragmentConstant();
            param1.fragmentConstantsIndex = this._diffuseInputRegister.index * 4;
            _loc4_ += "mov " + _loc5_ + ", " + this._diffuseInputRegister + "\n";
         }
         if(param1.numLights == 0)
         {
            return _loc4_;
         }
         _loc4_ += "sat " + this._totalLightColorReg + ", " + this._totalLightColorReg + "\n";
         if(this._useAmbientTexture)
         {
            _loc4_ += "mul " + _loc5_ + ".xyz, " + _loc5_ + ", " + this._totalLightColorReg + "\n" + "mul " + this._totalLightColorReg + ".xyz, " + param3 + ", " + this._totalLightColorReg + "\n" + "sub " + param3 + ".xyz, " + param3 + ", " + this._totalLightColorReg + "\n" + "add " + param3 + ".xyz, " + _loc5_ + ", " + param3 + "\n";
         }
         else
         {
            _loc4_ += "add " + param3 + ".xyz, " + this._totalLightColorReg + ", " + param3 + "\n";
            if(this._useTexture)
            {
               _loc4_ += "mul " + param3 + ".xyz, " + _loc5_ + ", " + param3 + "\n" + "mov " + param3 + ".w, " + _loc5_ + ".w\n";
            }
            else
            {
               _loc4_ += "mul " + param3 + ".xyz, " + this._diffuseInputRegister + ", " + param3 + "\n" + "mov " + param3 + ".w, " + this._diffuseInputRegister + ".w\n";
            }
         }
         param2.removeFragmentTempUsage(this._totalLightColorReg);
         param2.removeFragmentTempUsage(_loc5_);
         return _loc4_;
      }
      
      protected function applyShadow(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return "mul " + this._totalLightColorReg + ".xyz, " + this._totalLightColorReg + ", " + this._shadowRegister + ".w\n";
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<Number> = null;
         if(this._useTexture)
         {
            param2._context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
            if(this._alphaThreshold > 0)
            {
               param1.fragmentData[param1.fragmentConstantsIndex] = this._alphaThreshold;
            }
         }
         else
         {
            _loc3_ = param1.fragmentConstantsIndex;
            _loc4_ = param1.fragmentData;
            _loc4_[_loc3_] = this._diffuseR;
            _loc4_[_loc3_ + 1] = this._diffuseG;
            _loc4_[_loc3_ + 2] = this._diffuseB;
            _loc4_[_loc3_ + 3] = this._diffuseA;
         }
      }
      
      private function updateDiffuse() : void
      {
         this._diffuseR = (this._diffuseColor >> 16 & 0xFF) / 255;
         this._diffuseG = (this._diffuseColor >> 8 & 0xFF) / 255;
         this._diffuseB = (this._diffuseColor & 0xFF) / 255;
      }
      
      arcane function set shadowRegister(param1:ShaderRegisterElement) : void
      {
         this._shadowRegister = param1;
      }
   }
}

