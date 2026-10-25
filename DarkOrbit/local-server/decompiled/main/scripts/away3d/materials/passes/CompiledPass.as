package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.Matrix3DUtils;
   import away3d.errors.AbstractMethodError;
   import away3d.events.ShadingMethodEvent;
   import away3d.materials.LightSources;
   import away3d.materials.MaterialBase;
   import away3d.materials.compilation.ShaderCompiler;
   import away3d.materials.methods.BasicAmbientMethod;
   import away3d.materials.methods.BasicDiffuseMethod;
   import away3d.materials.methods.BasicNormalMethod;
   import away3d.materials.methods.BasicSpecularMethod;
   import away3d.materials.methods.MethodVOSet;
   import away3d.materials.methods.ShaderMethodSetup;
   import away3d.materials.methods.ShadowMapMethodBase;
   import away3d.textures.Texture2DBase;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DProgramType;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class CompiledPass extends MaterialPassBase
   {
      
      arcane var _passes:Vector.<MaterialPassBase>;
      
      arcane var _passesDirty:Boolean;
      
      protected var _specularLightSources:uint = 1;
      
      protected var _diffuseLightSources:uint = 3;
      
      protected var _vertexCode:String;
      
      protected var _fragmentLightCode:String;
      
      protected var _framentPostLightCode:String;
      
      protected var _vertexConstantData:Vector.<Number> = new Vector.<Number>();
      
      protected var _fragmentConstantData:Vector.<Number> = new Vector.<Number>();
      
      protected var _commonsDataIndex:int;
      
      protected var _probeWeightsIndex:int;
      
      protected var _uvBufferIndex:int;
      
      protected var _secondaryUVBufferIndex:int;
      
      protected var _normalBufferIndex:int;
      
      protected var _tangentBufferIndex:int;
      
      protected var _sceneMatrixIndex:int;
      
      protected var _sceneNormalMatrixIndex:int;
      
      protected var _lightFragmentConstantIndex:int;
      
      protected var _cameraPositionIndex:int;
      
      protected var _uvTransformIndex:int;
      
      protected var _lightProbeDiffuseIndices:Vector.<uint>;
      
      protected var _lightProbeSpecularIndices:Vector.<uint>;
      
      protected var _ambientLightR:Number;
      
      protected var _ambientLightG:Number;
      
      protected var _ambientLightB:Number;
      
      protected var _compiler:ShaderCompiler;
      
      protected var _methodSetup:ShaderMethodSetup;
      
      protected var _usingSpecularMethod:Boolean;
      
      protected var _usesNormals:Boolean;
      
      protected var _preserveAlpha:Boolean = true;
      
      protected var _animateUVs:Boolean;
      
      protected var _numPointLights:uint;
      
      protected var _numDirectionalLights:uint;
      
      protected var _numLightProbes:uint;
      
      protected var _enableLightFallOff:Boolean = true;
      
      private var _forceSeparateMVP:Boolean;
      
      public function CompiledPass(param1:MaterialBase)
      {
         super();
         _material = param1;
         this.init();
      }
      
      public function get enableLightFallOff() : Boolean
      {
         return this._enableLightFallOff;
      }
      
      public function set enableLightFallOff(param1:Boolean) : void
      {
         if(param1 != this._enableLightFallOff)
         {
            this.invalidateShaderProgram(true);
         }
         this._enableLightFallOff = param1;
      }
      
      public function get forceSeparateMVP() : Boolean
      {
         return this._forceSeparateMVP;
      }
      
      public function set forceSeparateMVP(param1:Boolean) : void
      {
         this._forceSeparateMVP = param1;
      }
      
      arcane function get numPointLights() : uint
      {
         return this._numPointLights;
      }
      
      arcane function get numDirectionalLights() : uint
      {
         return this._numDirectionalLights;
      }
      
      arcane function get numLightProbes() : uint
      {
         return this._numLightProbes;
      }
      
      override arcane function updateProgram(param1:Stage3DProxy) : void
      {
         this.reset(param1.profile);
         super.arcane::updateProgram(param1);
      }
      
      private function reset(param1:String) : void
      {
         this.initCompiler(param1);
         this.updateShaderProperties();
         this.initConstantData();
         this.cleanUp();
      }
      
      private function updateUsedOffsets() : void
      {
         _numUsedVertexConstants = this._compiler.numUsedVertexConstants;
         _numUsedFragmentConstants = this._compiler.numUsedFragmentConstants;
         _numUsedStreams = this._compiler.numUsedStreams;
         _numUsedTextures = this._compiler.numUsedTextures;
         _numUsedVaryings = this._compiler.numUsedVaryings;
         _numUsedFragmentConstants = this._compiler.numUsedFragmentConstants;
      }
      
      private function initConstantData() : void
      {
         this._vertexConstantData.length = _numUsedVertexConstants * 4;
         this._fragmentConstantData.length = _numUsedFragmentConstants * 4;
         this.initCommonsData();
         if(this._uvTransformIndex >= 0)
         {
            this.initUVTransformData();
         }
         if(this._cameraPositionIndex >= 0)
         {
            this._vertexConstantData[this._cameraPositionIndex + 3] = 1;
         }
         this.updateMethodConstants();
      }
      
      protected function initCompiler(param1:String) : void
      {
         this._compiler = this.createCompiler(param1);
         this._compiler.forceSeperateMVP = this._forceSeparateMVP;
         this._compiler.numPointLights = this._numPointLights;
         this._compiler.numDirectionalLights = this._numDirectionalLights;
         this._compiler.numLightProbes = this._numLightProbes;
         this._compiler.methodSetup = this._methodSetup;
         this._compiler.diffuseLightSources = this._diffuseLightSources;
         this._compiler.specularLightSources = this._specularLightSources;
         this._compiler.setTextureSampling(_smooth,_repeat,_mipmap);
         this._compiler.setConstantDataBuffers(this._vertexConstantData,this._fragmentConstantData);
         this._compiler.animateUVs = this._animateUVs;
         this._compiler.alphaPremultiplied = _alphaPremultiplied && _enableBlending;
         this._compiler.preserveAlpha = this._preserveAlpha && _enableBlending;
         this._compiler.enableLightFallOff = this._enableLightFallOff;
         this._compiler.compile();
      }
      
      protected function createCompiler(param1:String) : ShaderCompiler
      {
         throw new AbstractMethodError();
      }
      
      protected function updateShaderProperties() : void
      {
         _animatableAttributes = this._compiler.animatableAttributes;
         _animationTargetRegisters = this._compiler.animationTargetRegisters;
         this._vertexCode = this._compiler.vertexCode;
         this._fragmentLightCode = this._compiler.fragmentLightCode;
         this._framentPostLightCode = this._compiler.fragmentPostLightCode;
         _shadedTarget = this._compiler.shadedTarget;
         this._usingSpecularMethod = this._compiler.usingSpecularMethod;
         this._usesNormals = this._compiler.usesNormals;
         _needUVAnimation = this._compiler.needUVAnimation;
         _UVSource = this._compiler.UVSource;
         _UVTarget = this._compiler.UVTarget;
         this.updateRegisterIndices();
         this.updateUsedOffsets();
      }
      
      protected function updateRegisterIndices() : void
      {
         this._uvBufferIndex = this._compiler.uvBufferIndex;
         this._uvTransformIndex = this._compiler.uvTransformIndex;
         this._secondaryUVBufferIndex = this._compiler.secondaryUVBufferIndex;
         this._normalBufferIndex = this._compiler.normalBufferIndex;
         this._tangentBufferIndex = this._compiler.tangentBufferIndex;
         this._lightFragmentConstantIndex = this._compiler.lightFragmentConstantIndex;
         this._cameraPositionIndex = this._compiler.cameraPositionIndex;
         this._commonsDataIndex = this._compiler.commonsDataIndex;
         this._sceneMatrixIndex = this._compiler.sceneMatrixIndex;
         this._sceneNormalMatrixIndex = this._compiler.sceneNormalMatrixIndex;
         this._probeWeightsIndex = this._compiler.probeWeightsIndex;
         this._lightProbeDiffuseIndices = this._compiler.lightProbeDiffuseIndices;
         this._lightProbeSpecularIndices = this._compiler.lightProbeSpecularIndices;
      }
      
      public function get preserveAlpha() : Boolean
      {
         return this._preserveAlpha;
      }
      
      public function set preserveAlpha(param1:Boolean) : void
      {
         if(this._preserveAlpha == param1)
         {
            return;
         }
         this._preserveAlpha = param1;
         this.invalidateShaderProgram();
      }
      
      public function get animateUVs() : Boolean
      {
         return this._animateUVs;
      }
      
      public function set animateUVs(param1:Boolean) : void
      {
         if(this._animateUVs == param1)
         {
            return;
         }
         this._animateUVs = param1;
         this.invalidateShaderProgram();
      }
      
      override public function set mipmap(param1:Boolean) : void
      {
         if(_mipmap == param1)
         {
            return;
         }
         super.mipmap = param1;
      }
      
      public function get normalMap() : Texture2DBase
      {
         return this._methodSetup._normalMethod.normalMap;
      }
      
      public function set normalMap(param1:Texture2DBase) : void
      {
         this._methodSetup._normalMethod.normalMap = param1;
      }
      
      public function get normalMethod() : BasicNormalMethod
      {
         return this._methodSetup.normalMethod;
      }
      
      public function set normalMethod(param1:BasicNormalMethod) : void
      {
         this._methodSetup.normalMethod = param1;
      }
      
      public function get ambientMethod() : BasicAmbientMethod
      {
         return this._methodSetup.ambientMethod;
      }
      
      public function set ambientMethod(param1:BasicAmbientMethod) : void
      {
         this._methodSetup.ambientMethod = param1;
      }
      
      public function get shadowMethod() : ShadowMapMethodBase
      {
         return this._methodSetup.shadowMethod;
      }
      
      public function set shadowMethod(param1:ShadowMapMethodBase) : void
      {
         this._methodSetup.shadowMethod = param1;
      }
      
      public function get diffuseMethod() : BasicDiffuseMethod
      {
         return this._methodSetup.diffuseMethod;
      }
      
      public function set diffuseMethod(param1:BasicDiffuseMethod) : void
      {
         this._methodSetup.diffuseMethod = param1;
      }
      
      public function get specularMethod() : BasicSpecularMethod
      {
         return this._methodSetup.specularMethod;
      }
      
      public function set specularMethod(param1:BasicSpecularMethod) : void
      {
         this._methodSetup.specularMethod = param1;
      }
      
      private function init() : void
      {
         this._methodSetup = new ShaderMethodSetup();
         this._methodSetup.addEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._methodSetup)
         {
            this._methodSetup.removeEventListener(ShadingMethodEvent.SHADER_INVALIDATED,this.onShaderInvalidated);
            this._methodSetup.dispose();
            this._methodSetup = null;
         }
      }
      
      override arcane function invalidateShaderProgram(param1:Boolean = true) : void
      {
         var _loc2_:Vector.<MaterialPassBase> = this._passes;
         this._passes = new Vector.<MaterialPassBase>();
         if(this._methodSetup)
         {
            this.addPassesFromMethods();
         }
         if(!_loc2_ || this._passes.length != _loc2_.length)
         {
            this._passesDirty = true;
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._passes.length)
         {
            if(this._passes[_loc3_] != _loc2_[_loc3_])
            {
               this._passesDirty = true;
               return;
            }
            _loc3_++;
         }
         super.arcane::invalidateShaderProgram(param1);
      }
      
      protected function addPassesFromMethods() : void
      {
         if(Boolean(this._methodSetup._normalMethod) && this._methodSetup._normalMethod.hasOutput)
         {
            this.addPasses(this._methodSetup._normalMethod.passes);
         }
         if(this._methodSetup._ambientMethod)
         {
            this.addPasses(this._methodSetup._ambientMethod.passes);
         }
         if(this._methodSetup._shadowMethod)
         {
            this.addPasses(this._methodSetup._shadowMethod.passes);
         }
         if(this._methodSetup._diffuseMethod)
         {
            this.addPasses(this._methodSetup._diffuseMethod.passes);
         }
         if(this._methodSetup._specularMethod)
         {
            this.addPasses(this._methodSetup._specularMethod.passes);
         }
      }
      
      protected function addPasses(param1:Vector.<MaterialPassBase>) : void
      {
         if(!param1)
         {
            return;
         }
         var _loc2_:uint = param1.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            param1[_loc3_].material = material;
            param1[_loc3_].lightPicker = _lightPicker;
            this._passes.push(param1[_loc3_]);
            _loc3_++;
         }
      }
      
      protected function initUVTransformData() : void
      {
         this._vertexConstantData[this._uvTransformIndex] = 1;
         this._vertexConstantData[this._uvTransformIndex + 1] = 0;
         this._vertexConstantData[this._uvTransformIndex + 2] = 0;
         this._vertexConstantData[this._uvTransformIndex + 3] = 0;
         this._vertexConstantData[this._uvTransformIndex + 4] = 0;
         this._vertexConstantData[this._uvTransformIndex + 5] = 1;
         this._vertexConstantData[this._uvTransformIndex + 6] = 0;
         this._vertexConstantData[this._uvTransformIndex + 7] = 0;
      }
      
      protected function initCommonsData() : void
      {
         this._fragmentConstantData[this._commonsDataIndex] = 0.5;
         this._fragmentConstantData[this._commonsDataIndex + 1] = 0;
         this._fragmentConstantData[this._commonsDataIndex + 2] = 1 / 255;
         this._fragmentConstantData[this._commonsDataIndex + 3] = 1;
      }
      
      protected function cleanUp() : void
      {
         this._compiler.dispose();
         this._compiler = null;
      }
      
      protected function updateMethodConstants() : void
      {
         if(this._methodSetup._normalMethod)
         {
            this._methodSetup._normalMethod.initConstants(this._methodSetup._normalMethodVO);
         }
         if(this._methodSetup._diffuseMethod)
         {
            this._methodSetup._diffuseMethod.initConstants(this._methodSetup._diffuseMethodVO);
         }
         if(this._methodSetup._ambientMethod)
         {
            this._methodSetup._ambientMethod.initConstants(this._methodSetup._ambientMethodVO);
         }
         if(this._usingSpecularMethod)
         {
            this._methodSetup._specularMethod.initConstants(this._methodSetup._specularMethodVO);
         }
         if(this._methodSetup._shadowMethod)
         {
            this._methodSetup._shadowMethod.initConstants(this._methodSetup._shadowMethodVO);
         }
      }
      
      protected function updateLightConstants() : void
      {
      }
      
      protected function updateProbes(param1:Stage3DProxy) : void
      {
      }
      
      private function onShaderInvalidated(param1:ShadingMethodEvent) : void
      {
         this.invalidateShaderProgram();
      }
      
      override arcane function getVertexCode() : String
      {
         return this._vertexCode;
      }
      
      override arcane function getFragmentCode(param1:String) : String
      {
         return this._fragmentLightCode + param1 + this._framentPostLightCode;
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         super.arcane::activate(param1,param2);
         if(this._usesNormals)
         {
            this._methodSetup._normalMethod.activate(this._methodSetup._normalMethodVO,param1);
         }
         this._methodSetup._ambientMethod.activate(this._methodSetup._ambientMethodVO,param1);
         if(this._methodSetup._shadowMethod)
         {
            this._methodSetup._shadowMethod.activate(this._methodSetup._shadowMethodVO,param1);
         }
         this._methodSetup._diffuseMethod.activate(this._methodSetup._diffuseMethodVO,param1);
         if(this._usingSpecularMethod)
         {
            this._methodSetup._specularMethod.activate(this._methodSetup._specularMethodVO,param1);
         }
      }
      
      override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         var _loc5_:uint = 0;
         var _loc10_:Matrix = null;
         var _loc11_:Matrix3D = null;
         var _loc12_:MethodVOSet = null;
         var _loc6_:Context3D = param2._context3D;
         if(this._uvBufferIndex >= 0)
         {
            param1.activateUVBuffer(this._uvBufferIndex,param2);
         }
         if(this._secondaryUVBufferIndex >= 0)
         {
            param1.activateSecondaryUVBuffer(this._secondaryUVBufferIndex,param2);
         }
         if(this._normalBufferIndex >= 0)
         {
            param1.activateVertexNormalBuffer(this._normalBufferIndex,param2);
         }
         if(this._tangentBufferIndex >= 0)
         {
            param1.activateVertexTangentBuffer(this._tangentBufferIndex,param2);
         }
         if(this._animateUVs)
         {
            _loc10_ = param1.uvTransform;
            if(_loc10_)
            {
               this._vertexConstantData[this._uvTransformIndex] = _loc10_.a;
               this._vertexConstantData[this._uvTransformIndex + 1] = _loc10_.b;
               this._vertexConstantData[this._uvTransformIndex + 3] = _loc10_.tx;
               this._vertexConstantData[this._uvTransformIndex + 4] = _loc10_.c;
               this._vertexConstantData[this._uvTransformIndex + 5] = _loc10_.d;
               this._vertexConstantData[this._uvTransformIndex + 7] = _loc10_.ty;
            }
            else
            {
               this._vertexConstantData[this._uvTransformIndex] = 1;
               this._vertexConstantData[this._uvTransformIndex + 1] = 0;
               this._vertexConstantData[this._uvTransformIndex + 3] = 0;
               this._vertexConstantData[this._uvTransformIndex + 4] = 0;
               this._vertexConstantData[this._uvTransformIndex + 5] = 1;
               this._vertexConstantData[this._uvTransformIndex + 7] = 0;
            }
         }
         this._ambientLightR = this._ambientLightG = this._ambientLightB = 0;
         if(this.usesLights())
         {
            this.updateLightConstants();
         }
         if(this.usesProbes())
         {
            this.updateProbes(param2);
         }
         if(this._sceneMatrixIndex >= 0)
         {
            param1.getRenderSceneTransform(param3).copyRawDataTo(this._vertexConstantData,this._sceneMatrixIndex,true);
            param4.copyRawDataTo(this._vertexConstantData,0,true);
         }
         else
         {
            _loc11_ = Matrix3DUtils.CALCULATION_MATRIX;
            _loc11_.copyFrom(param1.getRenderSceneTransform(param3));
            _loc11_.append(param4);
            _loc11_.copyRawDataTo(this._vertexConstantData,0,true);
         }
         if(this._sceneNormalMatrixIndex >= 0)
         {
            param1.inverseSceneTransform.copyRawDataTo(this._vertexConstantData,this._sceneNormalMatrixIndex,false);
         }
         if(this._usesNormals)
         {
            this._methodSetup._normalMethod.setRenderState(this._methodSetup._normalMethodVO,param1,param2,param3);
         }
         var _loc7_:BasicAmbientMethod = this._methodSetup._ambientMethod;
         _loc7_._lightAmbientR = this._ambientLightR;
         _loc7_._lightAmbientG = this._ambientLightG;
         _loc7_._lightAmbientB = this._ambientLightB;
         _loc7_.setRenderState(this._methodSetup._ambientMethodVO,param1,param2,param3);
         if(this._methodSetup._shadowMethod)
         {
            this._methodSetup._shadowMethod.setRenderState(this._methodSetup._shadowMethodVO,param1,param2,param3);
         }
         this._methodSetup._diffuseMethod.setRenderState(this._methodSetup._diffuseMethodVO,param1,param2,param3);
         if(this._usingSpecularMethod)
         {
            this._methodSetup._specularMethod.setRenderState(this._methodSetup._specularMethodVO,param1,param2,param3);
         }
         if(this._methodSetup._colorTransformMethod)
         {
            this._methodSetup._colorTransformMethod.setRenderState(this._methodSetup._colorTransformMethodVO,param1,param2,param3);
         }
         var _loc8_:Vector.<MethodVOSet> = this._methodSetup._methods;
         var _loc9_:uint = _loc8_.length;
         _loc5_ = 0;
         while(_loc5_ < _loc9_)
         {
            _loc12_ = _loc8_[_loc5_];
            _loc12_.method.setRenderState(_loc12_.data,param1,param2,param3);
            _loc5_++;
         }
         _loc6_.setProgramConstantsFromVector(Context3DProgramType.VERTEX,0,this._vertexConstantData,_numUsedVertexConstants);
         _loc6_.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._fragmentConstantData,_numUsedFragmentConstants);
         param1.activateVertexBuffer(0,param2);
         _loc6_.drawTriangles(param1.getIndexBuffer(param2),0,param1.numTriangles);
      }
      
      protected function usesProbes() : Boolean
      {
         return this._numLightProbes > 0 && ((this._diffuseLightSources | this._specularLightSources) & LightSources.PROBES) != 0;
      }
      
      protected function usesLights() : Boolean
      {
         return (this._numPointLights > 0 || this._numDirectionalLights > 0) && ((this._diffuseLightSources | this._specularLightSources) & LightSources.LIGHTS) != 0;
      }
      
      override arcane function deactivate(param1:Stage3DProxy) : void
      {
         super.arcane::deactivate(param1);
         if(this._usesNormals)
         {
            this._methodSetup._normalMethod.deactivate(this._methodSetup._normalMethodVO,param1);
         }
         this._methodSetup._ambientMethod.deactivate(this._methodSetup._ambientMethodVO,param1);
         if(this._methodSetup._shadowMethod)
         {
            this._methodSetup._shadowMethod.deactivate(this._methodSetup._shadowMethodVO,param1);
         }
         this._methodSetup._diffuseMethod.deactivate(this._methodSetup._diffuseMethodVO,param1);
         if(this._usingSpecularMethod)
         {
            this._methodSetup._specularMethod.deactivate(this._methodSetup._specularMethodVO,param1);
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
   }
}

