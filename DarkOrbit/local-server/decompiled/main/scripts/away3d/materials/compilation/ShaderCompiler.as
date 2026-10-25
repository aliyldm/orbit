package away3d.materials.compilation
{
   import away3d.arcane;
   import away3d.materials.LightSources;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.MethodVO;
   import away3d.materials.methods.MethodVOSet;
   import away3d.materials.methods.ShaderMethodSetup;
   import away3d.materials.methods.ShadingMethodBase;
   
   use namespace arcane;
   
   public class ShaderCompiler
   {
      
      protected var _sharedRegisters:ShaderRegisterData;
      
      protected var _registerCache:ShaderRegisterCache;
      
      protected var _dependencyCounter:MethodDependencyCounter;
      
      protected var _methodSetup:ShaderMethodSetup;
      
      protected var _smooth:Boolean;
      
      protected var _repeat:Boolean;
      
      protected var _mipmap:Boolean;
      
      protected var _enableLightFallOff:Boolean;
      
      protected var _preserveAlpha:Boolean = true;
      
      protected var _animateUVs:Boolean;
      
      protected var _alphaPremultiplied:Boolean;
      
      protected var _vertexConstantData:Vector.<Number>;
      
      protected var _fragmentConstantData:Vector.<Number>;
      
      protected var _vertexCode:String;
      
      protected var _fragmentCode:String;
      
      protected var _fragmentLightCode:String;
      
      protected var _fragmentPostLightCode:String;
      
      private var _commonsDataIndex:int = -1;
      
      protected var _animatableAttributes:Vector.<String>;
      
      protected var _animationTargetRegisters:Vector.<String>;
      
      protected var _lightProbeDiffuseIndices:Vector.<uint>;
      
      protected var _lightProbeSpecularIndices:Vector.<uint>;
      
      protected var _uvBufferIndex:int = -1;
      
      protected var _uvTransformIndex:int = -1;
      
      protected var _secondaryUVBufferIndex:int = -1;
      
      protected var _normalBufferIndex:int = -1;
      
      protected var _tangentBufferIndex:int = -1;
      
      protected var _lightFragmentConstantIndex:int = -1;
      
      protected var _sceneMatrixIndex:int = -1;
      
      protected var _sceneNormalMatrixIndex:int = -1;
      
      protected var _cameraPositionIndex:int = -1;
      
      protected var _probeWeightsIndex:int = -1;
      
      protected var _specularLightSources:uint;
      
      protected var _diffuseLightSources:uint;
      
      protected var _numLights:int;
      
      protected var _numLightProbes:uint;
      
      protected var _numPointLights:uint;
      
      protected var _numDirectionalLights:uint;
      
      protected var _numProbeRegisters:Number;
      
      protected var _combinedLightSources:uint;
      
      protected var _usingSpecularMethod:Boolean;
      
      protected var _needUVAnimation:Boolean;
      
      protected var _UVTarget:String;
      
      protected var _UVSource:String;
      
      protected var _profile:String;
      
      protected var _forceSeperateMVP:Boolean;
      
      public function ShaderCompiler(param1:String)
      {
         super();
         this._sharedRegisters = new ShaderRegisterData();
         this._dependencyCounter = new MethodDependencyCounter();
         this._profile = param1;
         this.initRegisterCache(param1);
      }
      
      public function get enableLightFallOff() : Boolean
      {
         return this._enableLightFallOff;
      }
      
      public function set enableLightFallOff(param1:Boolean) : void
      {
         this._enableLightFallOff = param1;
      }
      
      public function get needUVAnimation() : Boolean
      {
         return this._needUVAnimation;
      }
      
      public function get UVTarget() : String
      {
         return this._UVTarget;
      }
      
      public function get UVSource() : String
      {
         return this._UVSource;
      }
      
      public function get forceSeperateMVP() : Boolean
      {
         return this._forceSeperateMVP;
      }
      
      public function set forceSeperateMVP(param1:Boolean) : void
      {
         this._forceSeperateMVP = param1;
      }
      
      private function initRegisterCache(param1:String) : void
      {
         this._registerCache = new ShaderRegisterCache(param1);
         this._registerCache.vertexAttributesOffset = 1;
         this._registerCache.reset();
      }
      
      public function get animateUVs() : Boolean
      {
         return this._animateUVs;
      }
      
      public function set animateUVs(param1:Boolean) : void
      {
         this._animateUVs = param1;
      }
      
      public function get alphaPremultiplied() : Boolean
      {
         return this._alphaPremultiplied;
      }
      
      public function set alphaPremultiplied(param1:Boolean) : void
      {
         this._alphaPremultiplied = param1;
      }
      
      public function get preserveAlpha() : Boolean
      {
         return this._preserveAlpha;
      }
      
      public function set preserveAlpha(param1:Boolean) : void
      {
         this._preserveAlpha = param1;
      }
      
      public function setTextureSampling(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this._smooth = param1;
         this._repeat = param2;
         this._mipmap = param3;
      }
      
      public function setConstantDataBuffers(param1:Vector.<Number>, param2:Vector.<Number>) : void
      {
         this._vertexConstantData = param1;
         this._fragmentConstantData = param2;
      }
      
      public function get methodSetup() : ShaderMethodSetup
      {
         return this._methodSetup;
      }
      
      public function set methodSetup(param1:ShaderMethodSetup) : void
      {
         this._methodSetup = param1;
      }
      
      public function compile() : void
      {
         this.initRegisterIndices();
         this.initLightData();
         this._animatableAttributes = Vector.<String>(["va0"]);
         this._animationTargetRegisters = Vector.<String>(["vt0"]);
         this._vertexCode = "";
         this._fragmentCode = "";
         this._sharedRegisters.localPosition = this._registerCache.getFreeVertexVectorTemp();
         this._registerCache.addVertexTempUsages(this._sharedRegisters.localPosition,1);
         this.createCommons();
         this.calculateDependencies();
         this.updateMethodRegisters();
         var _loc1_:uint = 0;
         while(_loc1_ < 4)
         {
            this._registerCache.getFreeVertexConstant();
            _loc1_++;
         }
         this.createNormalRegisters();
         if(this._dependencyCounter.globalPosDependencies > 0 || this._forceSeperateMVP)
         {
            this.compileGlobalPositionCode();
         }
         this.compileProjectionCode();
         this.compileMethodsCode();
         this.compileFragmentOutput();
         this._fragmentPostLightCode = this.fragmentCode;
      }
      
      protected function createNormalRegisters() : void
      {
      }
      
      protected function compileMethodsCode() : void
      {
         if(this._dependencyCounter.uvDependencies > 0)
         {
            this.compileUVCode();
         }
         if(this._dependencyCounter.secondaryUVDependencies > 0)
         {
            this.compileSecondaryUVCode();
         }
         if(this._dependencyCounter.normalDependencies > 0)
         {
            this.compileNormalCode();
         }
         if(this._dependencyCounter.viewDirDependencies > 0)
         {
            this.compileViewDirCode();
         }
         this.compileLightingCode();
         this._fragmentLightCode = this._fragmentCode;
         this._fragmentCode = "";
         this.compileMethods();
      }
      
      protected function compileLightingCode() : void
      {
      }
      
      protected function compileViewDirCode() : void
      {
      }
      
      protected function compileNormalCode() : void
      {
      }
      
      private function compileUVCode() : void
      {
         var _loc3_:ShaderRegisterElement = null;
         var _loc4_:ShaderRegisterElement = null;
         var _loc1_:ShaderRegisterElement = this._registerCache.getFreeVertexAttribute();
         this._uvBufferIndex = _loc1_.index;
         var _loc2_:ShaderRegisterElement = this._registerCache.getFreeVarying();
         this._sharedRegisters.uvVarying = _loc2_;
         if(this.animateUVs)
         {
            _loc3_ = this._registerCache.getFreeVertexConstant();
            _loc4_ = this._registerCache.getFreeVertexConstant();
            this._uvTransformIndex = _loc3_.index * 4;
            this._vertexCode += "dp4 " + _loc2_ + ".x, " + _loc1_ + ", " + _loc3_ + "\n" + "dp4 " + _loc2_ + ".y, " + _loc1_ + ", " + _loc4_ + "\n" + "mov " + _loc2_ + ".zw, " + _loc1_ + ".zw \n";
         }
         else
         {
            this._uvTransformIndex = -1;
            this._needUVAnimation = true;
            this._UVTarget = _loc2_.toString();
            this._UVSource = _loc1_.toString();
         }
      }
      
      private function compileSecondaryUVCode() : void
      {
         var _loc1_:ShaderRegisterElement = this._registerCache.getFreeVertexAttribute();
         this._secondaryUVBufferIndex = _loc1_.index;
         this._sharedRegisters.secondaryUVVarying = this._registerCache.getFreeVarying();
         this._vertexCode += "mov " + this._sharedRegisters.secondaryUVVarying + ", " + _loc1_ + "\n";
      }
      
      protected function compileGlobalPositionCode() : void
      {
         this._sharedRegisters.globalPositionVertex = this._registerCache.getFreeVertexVectorTemp();
         this._registerCache.addVertexTempUsages(this._sharedRegisters.globalPositionVertex,this._dependencyCounter.globalPosDependencies);
         var _loc1_:ShaderRegisterElement = this._registerCache.getFreeVertexConstant();
         this._registerCache.getFreeVertexConstant();
         this._registerCache.getFreeVertexConstant();
         this._registerCache.getFreeVertexConstant();
         this._sceneMatrixIndex = _loc1_.index * 4;
         this._vertexCode += "m44 " + this._sharedRegisters.globalPositionVertex + ", " + this._sharedRegisters.localPosition + ", " + _loc1_ + "\n";
         if(this._dependencyCounter.usesGlobalPosFragment)
         {
            this._sharedRegisters.globalPositionVarying = this._registerCache.getFreeVarying();
            this._vertexCode += "mov " + this._sharedRegisters.globalPositionVarying + ", " + this._sharedRegisters.globalPositionVertex + "\n";
         }
      }
      
      private function compileProjectionCode() : void
      {
         var _loc2_:String = null;
         var _loc1_:String = this._dependencyCounter.globalPosDependencies > 0 || this._forceSeperateMVP ? this._sharedRegisters.globalPositionVertex.toString() : this._animationTargetRegisters[0];
         if(this._dependencyCounter.projectionDependencies > 0)
         {
            this._sharedRegisters.projectionFragment = this._registerCache.getFreeVarying();
            _loc2_ = "m44 vt5, " + _loc1_ + ", vc0\t\t\n" + "mov " + this._sharedRegisters.projectionFragment + ", vt5\n" + "mov op, vt5\n";
         }
         else
         {
            _loc2_ = "m44 op, " + _loc1_ + ", vc0\t\t\n";
         }
         this._vertexCode += _loc2_;
      }
      
      private function compileFragmentOutput() : void
      {
         this._fragmentCode += "mov " + this._registerCache.fragmentOutputRegister + ", " + this._sharedRegisters.shadedTarget + "\n";
         this._registerCache.removeFragmentTempUsage(this._sharedRegisters.shadedTarget);
      }
      
      protected function initRegisterIndices() : void
      {
         this._commonsDataIndex = -1;
         this._cameraPositionIndex = -1;
         this._uvBufferIndex = -1;
         this._uvTransformIndex = -1;
         this._secondaryUVBufferIndex = -1;
         this._normalBufferIndex = -1;
         this._tangentBufferIndex = -1;
         this._lightFragmentConstantIndex = -1;
         this._sceneMatrixIndex = -1;
         this._sceneNormalMatrixIndex = -1;
         this._probeWeightsIndex = -1;
      }
      
      protected function initLightData() : void
      {
         this._numLights = this._numPointLights + this._numDirectionalLights;
         this._numProbeRegisters = Math.ceil(this._numLightProbes / 4);
         if(this._methodSetup._specularMethod)
         {
            this._combinedLightSources = this._specularLightSources | this._diffuseLightSources;
         }
         else
         {
            this._combinedLightSources = this._diffuseLightSources;
         }
         this._usingSpecularMethod = Boolean(this._methodSetup._specularMethod && (this.usesLightsForSpecular() || this.usesProbesForSpecular()));
      }
      
      private function createCommons() : void
      {
         this._sharedRegisters.commons = this._registerCache.getFreeFragmentConstant();
         this._commonsDataIndex = this._sharedRegisters.commons.index * 4;
      }
      
      protected function calculateDependencies() : void
      {
         var _loc2_:uint = 0;
         this._dependencyCounter.reset();
         var _loc1_:Vector.<MethodVOSet> = this._methodSetup._methods;
         this.setupAndCountMethodDependencies(this._methodSetup._diffuseMethod,this._methodSetup._diffuseMethodVO);
         if(this._methodSetup._shadowMethod)
         {
            this.setupAndCountMethodDependencies(this._methodSetup._shadowMethod,this._methodSetup._shadowMethodVO);
         }
         this.setupAndCountMethodDependencies(this._methodSetup._ambientMethod,this._methodSetup._ambientMethodVO);
         if(this._usingSpecularMethod)
         {
            this.setupAndCountMethodDependencies(this._methodSetup._specularMethod,this._methodSetup._specularMethodVO);
         }
         if(this._methodSetup._colorTransformMethod)
         {
            this.setupAndCountMethodDependencies(this._methodSetup._colorTransformMethod,this._methodSetup._colorTransformMethodVO);
         }
         _loc2_ = _loc1_.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            this.setupAndCountMethodDependencies(_loc1_[_loc3_].method,_loc1_[_loc3_].data);
            _loc3_++;
         }
         if(this.usesNormals)
         {
            this.setupAndCountMethodDependencies(this._methodSetup._normalMethod,this._methodSetup._normalMethodVO);
         }
         this._dependencyCounter.setPositionedLights(this._numPointLights,this._combinedLightSources);
      }
      
      private function setupAndCountMethodDependencies(param1:ShadingMethodBase, param2:MethodVO) : void
      {
         this.setupMethod(param1,param2);
         this._dependencyCounter.includeMethodVO(param2);
      }
      
      private function setupMethod(param1:ShadingMethodBase, param2:MethodVO) : void
      {
         param1.reset();
         param2.reset();
         param2.vertexData = this._vertexConstantData;
         param2.fragmentData = this._fragmentConstantData;
         param2.useSmoothTextures = this._smooth;
         param2.repeatTextures = this._repeat;
         param2.useMipmapping = this._mipmap;
         param2.useLightFallOff = this._enableLightFallOff && this._profile != "baselineConstrained";
         param2.numLights = this._numLights + this._numLightProbes;
         param1.initVO(param2);
      }
      
      public function get commonsDataIndex() : int
      {
         return this._commonsDataIndex;
      }
      
      private function updateMethodRegisters() : void
      {
         this._methodSetup._normalMethod.sharedRegisters = this._sharedRegisters;
         this._methodSetup._diffuseMethod.sharedRegisters = this._sharedRegisters;
         if(this._methodSetup._shadowMethod)
         {
            this._methodSetup._shadowMethod.sharedRegisters = this._sharedRegisters;
         }
         this._methodSetup._ambientMethod.sharedRegisters = this._sharedRegisters;
         if(this._methodSetup._specularMethod)
         {
            this._methodSetup._specularMethod.sharedRegisters = this._sharedRegisters;
         }
         if(this._methodSetup._colorTransformMethod)
         {
            this._methodSetup._colorTransformMethod.sharedRegisters = this._sharedRegisters;
         }
         var _loc1_:Vector.<MethodVOSet> = this._methodSetup._methods;
         var _loc2_:int = int(_loc1_.length);
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].method.sharedRegisters = this._sharedRegisters;
            _loc3_++;
         }
      }
      
      public function get numUsedVertexConstants() : uint
      {
         return this._registerCache.numUsedVertexConstants;
      }
      
      public function get numUsedFragmentConstants() : uint
      {
         return this._registerCache.numUsedFragmentConstants;
      }
      
      public function get numUsedStreams() : uint
      {
         return this._registerCache.numUsedStreams;
      }
      
      public function get numUsedTextures() : uint
      {
         return this._registerCache.numUsedTextures;
      }
      
      public function get numUsedVaryings() : uint
      {
         return this._registerCache.numUsedVaryings;
      }
      
      protected function usesLightsForSpecular() : Boolean
      {
         return this._numLights > 0 && (this._specularLightSources & LightSources.LIGHTS) != 0;
      }
      
      protected function usesLightsForDiffuse() : Boolean
      {
         return this._numLights > 0 && (this._diffuseLightSources & LightSources.LIGHTS) != 0;
      }
      
      public function dispose() : void
      {
         this.cleanUpMethods();
         this._registerCache.dispose();
         this._registerCache = null;
         this._sharedRegisters = null;
      }
      
      private function cleanUpMethods() : void
      {
         if(this._methodSetup._normalMethod)
         {
            this._methodSetup._normalMethod.cleanCompilationData();
         }
         if(this._methodSetup._diffuseMethod)
         {
            this._methodSetup._diffuseMethod.cleanCompilationData();
         }
         if(this._methodSetup._ambientMethod)
         {
            this._methodSetup._ambientMethod.cleanCompilationData();
         }
         if(this._methodSetup._specularMethod)
         {
            this._methodSetup._specularMethod.cleanCompilationData();
         }
         if(this._methodSetup._shadowMethod)
         {
            this._methodSetup._shadowMethod.cleanCompilationData();
         }
         if(this._methodSetup._colorTransformMethod)
         {
            this._methodSetup._colorTransformMethod.cleanCompilationData();
         }
         var _loc1_:Vector.<MethodVOSet> = this._methodSetup._methods;
         var _loc2_:uint = _loc1_.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].method.cleanCompilationData();
            _loc3_++;
         }
      }
      
      public function get specularLightSources() : uint
      {
         return this._specularLightSources;
      }
      
      public function set specularLightSources(param1:uint) : void
      {
         this._specularLightSources = param1;
      }
      
      public function get diffuseLightSources() : uint
      {
         return this._diffuseLightSources;
      }
      
      public function set diffuseLightSources(param1:uint) : void
      {
         this._diffuseLightSources = param1;
      }
      
      protected function usesProbesForSpecular() : Boolean
      {
         return this._numLightProbes > 0 && (this._specularLightSources & LightSources.PROBES) != 0;
      }
      
      protected function usesProbesForDiffuse() : Boolean
      {
         return this._numLightProbes > 0 && (this._diffuseLightSources & LightSources.PROBES) != 0;
      }
      
      protected function usesProbes() : Boolean
      {
         return this._numLightProbes > 0 && ((this._diffuseLightSources | this._specularLightSources) & LightSources.PROBES) != 0;
      }
      
      public function get uvBufferIndex() : int
      {
         return this._uvBufferIndex;
      }
      
      public function get uvTransformIndex() : int
      {
         return this._uvTransformIndex;
      }
      
      public function get secondaryUVBufferIndex() : int
      {
         return this._secondaryUVBufferIndex;
      }
      
      public function get normalBufferIndex() : int
      {
         return this._normalBufferIndex;
      }
      
      public function get tangentBufferIndex() : int
      {
         return this._tangentBufferIndex;
      }
      
      public function get lightFragmentConstantIndex() : int
      {
         return this._lightFragmentConstantIndex;
      }
      
      public function get cameraPositionIndex() : int
      {
         return this._cameraPositionIndex;
      }
      
      public function get sceneMatrixIndex() : int
      {
         return this._sceneMatrixIndex;
      }
      
      public function get sceneNormalMatrixIndex() : int
      {
         return this._sceneNormalMatrixIndex;
      }
      
      public function get probeWeightsIndex() : int
      {
         return this._probeWeightsIndex;
      }
      
      public function get vertexCode() : String
      {
         return this._vertexCode;
      }
      
      public function get fragmentCode() : String
      {
         return this._fragmentCode;
      }
      
      public function get fragmentLightCode() : String
      {
         return this._fragmentLightCode;
      }
      
      public function get fragmentPostLightCode() : String
      {
         return this._fragmentPostLightCode;
      }
      
      public function get shadedTarget() : String
      {
         return this._sharedRegisters.shadedTarget.toString();
      }
      
      public function get numPointLights() : uint
      {
         return this._numPointLights;
      }
      
      public function set numPointLights(param1:uint) : void
      {
         this._numPointLights = param1;
      }
      
      public function get numDirectionalLights() : uint
      {
         return this._numDirectionalLights;
      }
      
      public function set numDirectionalLights(param1:uint) : void
      {
         this._numDirectionalLights = param1;
      }
      
      public function get numLightProbes() : uint
      {
         return this._numLightProbes;
      }
      
      public function set numLightProbes(param1:uint) : void
      {
         this._numLightProbes = param1;
      }
      
      public function get usingSpecularMethod() : Boolean
      {
         return this._usingSpecularMethod;
      }
      
      public function get animatableAttributes() : Vector.<String>
      {
         return this._animatableAttributes;
      }
      
      public function get animationTargetRegisters() : Vector.<String>
      {
         return this._animationTargetRegisters;
      }
      
      public function get usesNormals() : Boolean
      {
         return this._dependencyCounter.normalDependencies > 0 && this._methodSetup._normalMethod.hasOutput;
      }
      
      protected function usesLights() : Boolean
      {
         return this._numLights > 0 && (this._combinedLightSources & LightSources.LIGHTS) != 0;
      }
      
      protected function compileMethods() : void
      {
         var _loc3_:EffectMethodBase = null;
         var _loc4_:MethodVO = null;
         var _loc5_:ShaderRegisterElement = null;
         var _loc1_:Vector.<MethodVOSet> = this._methodSetup._methods;
         var _loc2_:uint = _loc1_.length;
         if(this._preserveAlpha)
         {
            _loc5_ = this._registerCache.getFreeFragmentSingleTemp();
            this._registerCache.addFragmentTempUsages(_loc5_,1);
            this._fragmentCode += "mov " + _loc5_ + ", " + this._sharedRegisters.shadedTarget + ".w\n";
         }
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_)
         {
            _loc3_ = _loc1_[_loc6_].method;
            _loc4_ = _loc1_[_loc6_].data;
            this._vertexCode += _loc3_.getVertexCode(_loc4_,this._registerCache);
            if(_loc4_.needsGlobalVertexPos || _loc4_.needsGlobalFragmentPos)
            {
               this._registerCache.removeVertexTempUsage(this._sharedRegisters.globalPositionVertex);
            }
            this._fragmentCode += _loc3_.getFragmentCode(_loc4_,this._registerCache,this._sharedRegisters.shadedTarget);
            if(_loc4_.needsNormals)
            {
               this._registerCache.removeFragmentTempUsage(this._sharedRegisters.normalFragment);
            }
            if(_loc4_.needsView)
            {
               this._registerCache.removeFragmentTempUsage(this._sharedRegisters.viewDirFragment);
            }
            _loc6_++;
         }
         if(this._preserveAlpha)
         {
            this._fragmentCode += "mov " + this._sharedRegisters.shadedTarget + ".w, " + _loc5_ + "\n";
            this._registerCache.removeFragmentTempUsage(_loc5_);
         }
         if(this._methodSetup._colorTransformMethod)
         {
            this._vertexCode += this._methodSetup._colorTransformMethod.getVertexCode(this._methodSetup._colorTransformMethodVO,this._registerCache);
            this._fragmentCode += this._methodSetup._colorTransformMethod.getFragmentCode(this._methodSetup._colorTransformMethodVO,this._registerCache,this._sharedRegisters.shadedTarget);
         }
      }
      
      public function get lightProbeDiffuseIndices() : Vector.<uint>
      {
         return this._lightProbeDiffuseIndices;
      }
      
      public function get lightProbeSpecularIndices() : Vector.<uint>
      {
         return this._lightProbeSpecularIndices;
      }
   }
}

