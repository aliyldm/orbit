package away3d.materials.methods
{
   import away3d.*;
   import away3d.core.managers.*;
   import away3d.materials.compilation.*;
   import away3d.textures.*;
   
   use namespace arcane;
   
   public class BasicSpecularMethod extends LightingMethodBase
   {
      
      protected var _useTexture:Boolean;
      
      protected var _totalLightColorReg:ShaderRegisterElement;
      
      protected var _specularTextureRegister:ShaderRegisterElement;
      
      protected var _specularTexData:ShaderRegisterElement;
      
      protected var _specularDataRegister:ShaderRegisterElement;
      
      private var _texture:Texture2DBase;
      
      private var _gloss:int = 50;
      
      private var _specular:Number = 1;
      
      private var _specularColor:uint = 16777215;
      
      arcane var _specularR:Number = 1;
      
      arcane var _specularG:Number = 1;
      
      arcane var _specularB:Number = 1;
      
      private var _shadowRegister:ShaderRegisterElement;
      
      protected var _isFirstLight:Boolean;
      
      public function BasicSpecularMethod()
      {
         super();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsUV = this._useTexture;
         param1.needsNormals = param1.numLights > 0;
         param1.needsView = param1.numLights > 0;
      }
      
      public function get gloss() : Number
      {
         return this._gloss;
      }
      
      public function set gloss(param1:Number) : void
      {
         this._gloss = param1;
      }
      
      public function get specular() : Number
      {
         return this._specular;
      }
      
      public function set specular(param1:Number) : void
      {
         if(param1 == this._specular)
         {
            return;
         }
         this._specular = param1;
         this.updateSpecular();
      }
      
      public function get specularColor() : uint
      {
         return this._specularColor;
      }
      
      public function set specularColor(param1:uint) : void
      {
         if(this._specularColor == param1)
         {
            return;
         }
         if(this._specularColor == 0 || param1 == 0)
         {
            invalidateShaderProgram();
         }
         this._specularColor = param1;
         this.updateSpecular();
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
      
      override public function copyFrom(param1:ShadingMethodBase) : void
      {
         var _loc2_:BasicSpecularMethod = BasicSpecularMethod(param1);
         this.texture = _loc2_.texture;
         this.specular = _loc2_.specular;
         this.specularColor = _loc2_.specularColor;
         this.gloss = _loc2_.gloss;
      }
      
      override arcane function cleanCompilationData() : void
      {
         super.arcane::cleanCompilationData();
         this._shadowRegister = null;
         this._totalLightColorReg = null;
         this._specularTextureRegister = null;
         this._specularTexData = null;
         this._specularDataRegister = null;
      }
      
      override arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         var _loc3_:String = "";
         this._isFirstLight = true;
         if(param1.numLights > 0)
         {
            this._specularDataRegister = param2.getFreeFragmentConstant();
            param1.fragmentConstantsIndex = this._specularDataRegister.index * 4;
            if(this._useTexture)
            {
               this._specularTexData = param2.getFreeFragmentVectorTemp();
               param2.addFragmentTempUsages(this._specularTexData,1);
               this._specularTextureRegister = param2.getFreeTextureReg();
               param1.texturesIndex = this._specularTextureRegister.index;
               _loc3_ = getTex2DSampleCode(param1,this._specularTexData,this._specularTextureRegister,this._texture);
            }
            else
            {
               this._specularTextureRegister = null;
            }
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
         var _loc7_:ShaderRegisterElement = _sharedRegisters.viewDirFragment;
         var _loc8_:ShaderRegisterElement = _sharedRegisters.normalFragment;
         _loc5_ += "add " + _loc6_ + ", " + param2 + ", " + _loc7_ + "\n" + "nrm " + _loc6_ + ".xyz, " + _loc6_ + "\n" + "dp3 " + _loc6_ + ".w, " + _loc8_ + ", " + _loc6_ + "\n" + "sat " + _loc6_ + ".w, " + _loc6_ + ".w\n";
         if(this._useTexture)
         {
            _loc5_ += "mul " + this._specularTexData + ".w, " + this._specularTexData + ".y, " + this._specularDataRegister + ".w\n" + "pow " + _loc6_ + ".w, " + _loc6_ + ".w, " + this._specularTexData + ".w\n" + "sat " + _loc6_ + ".w, " + _loc6_ + ".w\n";
         }
         else
         {
            _loc5_ += "pow " + _loc6_ + ".w, " + _loc6_ + ".w, " + this._specularDataRegister + ".w\n";
         }
         if(param1.useLightFallOff)
         {
            _loc5_ += "mul " + _loc6_ + ".w, " + _loc6_ + ".w, " + param2 + ".w\n";
         }
         if(_modulateMethod != null)
         {
            _loc5_ += _modulateMethod(param1,_loc6_,param4,_sharedRegisters);
         }
         _loc5_ += "mul " + _loc6_ + ".xyz, " + param3 + ", " + _loc6_ + ".w\n";
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
         var _loc7_:ShaderRegisterElement = _sharedRegisters.normalFragment;
         var _loc8_:ShaderRegisterElement = _sharedRegisters.viewDirFragment;
         _loc5_ += "dp3 " + _loc6_ + ".w, " + _loc7_ + ", " + _loc8_ + "\n" + "add " + _loc6_ + ".w, " + _loc6_ + ".w, " + _loc6_ + ".w\n" + "mul " + _loc6_ + ", " + _loc6_ + ".w, " + _loc7_ + "\n" + "sub " + _loc6_ + ", " + _loc6_ + ", " + _loc8_ + "\n" + "tex " + _loc6_ + ", " + _loc6_ + ", " + param2 + " <cube," + (param1.useSmoothTextures ? "linear" : "nearest") + ",miplinear>\n" + "mul " + _loc6_ + ".xyz, " + _loc6_ + ", " + param3 + "\n";
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
         var _loc4_:String = "";
         if(param1.numLights == 0)
         {
            return _loc4_;
         }
         if(this._shadowRegister)
         {
            _loc4_ += "mul " + this._totalLightColorReg + ".xyz, " + this._totalLightColorReg + ", " + this._shadowRegister + ".w\n";
         }
         if(this._useTexture)
         {
            _loc4_ += "mul " + this._totalLightColorReg + ".xyz, " + this._totalLightColorReg + ", " + this._specularTexData + ".x\n";
            param2.removeFragmentTempUsage(this._specularTexData);
         }
         _loc4_ += "mul " + this._totalLightColorReg + ".xyz, " + this._totalLightColorReg + ", " + this._specularDataRegister + "\n" + "add " + param3 + ".xyz, " + param3 + ", " + this._totalLightColorReg + "\n" + "max " + param3 + ".w, " + param3 + ".wwww, " + this._totalLightColorReg + ".wwww\n";
         param2.removeFragmentTempUsage(this._totalLightColorReg);
         return _loc4_;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         if(param1.numLights == 0)
         {
            return;
         }
         if(this._useTexture)
         {
            param2._context3D.setTextureAt(param1.texturesIndex,this._texture.getTextureForStage3D(param2));
         }
         var _loc3_:int = param1.fragmentConstantsIndex;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         _loc4_[_loc3_] = this._specularR;
         _loc4_[_loc3_ + 1] = this._specularG;
         _loc4_[_loc3_ + 2] = this._specularB;
         _loc4_[_loc3_ + 3] = this._gloss;
      }
      
      private function updateSpecular() : void
      {
         this._specularR = (this._specularColor >> 16 & 0xFF) / 255 * this._specular;
         this._specularG = (this._specularColor >> 8 & 0xFF) / 255 * this._specular;
         this._specularB = (this._specularColor & 0xFF) / 255 * this._specular;
      }
      
      arcane function set shadowRegister(param1:ShaderRegisterElement) : void
      {
         this._shadowRegister = param1;
      }
   }
}

