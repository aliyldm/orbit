package away3d.materials.compilation
{
   import away3d.arcane;
   
   use namespace arcane;
   
   public class LightingShaderCompiler extends ShaderCompiler
   {
      
      public var _pointLightFragmentConstants:Vector.<ShaderRegisterElement>;
      
      public var _pointLightVertexConstants:Vector.<ShaderRegisterElement>;
      
      public var _dirLightFragmentConstants:Vector.<ShaderRegisterElement>;
      
      public var _dirLightVertexConstants:Vector.<ShaderRegisterElement>;
      
      private var _lightVertexConstantIndex:int;
      
      private var _shadowRegister:ShaderRegisterElement;
      
      public function LightingShaderCompiler(param1:String)
      {
         super(param1);
      }
      
      public function get lightVertexConstantIndex() : int
      {
         return this._lightVertexConstantIndex;
      }
      
      override protected function initRegisterIndices() : void
      {
         super.initRegisterIndices();
         this._lightVertexConstantIndex = -1;
      }
      
      override protected function createNormalRegisters() : void
      {
         if(this.tangentSpace)
         {
            _sharedRegisters.animatedTangent = _registerCache.getFreeVertexVectorTemp();
            _registerCache.addVertexTempUsages(_sharedRegisters.animatedTangent,1);
            _sharedRegisters.bitangent = _registerCache.getFreeVertexVectorTemp();
            _registerCache.addVertexTempUsages(_sharedRegisters.bitangent,1);
            _sharedRegisters.tangentInput = _registerCache.getFreeVertexAttribute();
            _tangentBufferIndex = _sharedRegisters.tangentInput.index;
            _animatableAttributes.push(_sharedRegisters.tangentInput.toString());
            _animationTargetRegisters.push(_sharedRegisters.animatedTangent.toString());
         }
         _sharedRegisters.normalInput = _registerCache.getFreeVertexAttribute();
         _normalBufferIndex = _sharedRegisters.normalInput.index;
         _sharedRegisters.animatedNormal = _registerCache.getFreeVertexVectorTemp();
         _registerCache.addVertexTempUsages(_sharedRegisters.animatedNormal,1);
         _animatableAttributes.push(_sharedRegisters.normalInput.toString());
         _animationTargetRegisters.push(_sharedRegisters.animatedNormal.toString());
      }
      
      public function get tangentSpace() : Boolean
      {
         return _numLightProbes == 0 && methodSetup._normalMethod.hasOutput && _methodSetup._normalMethod.tangentSpace;
      }
      
      override protected function initLightData() : void
      {
         super.initLightData();
         this._pointLightVertexConstants = new Vector.<ShaderRegisterElement>(_numPointLights,true);
         this._pointLightFragmentConstants = new Vector.<ShaderRegisterElement>(_numPointLights * 2,true);
         if(this.tangentSpace)
         {
            this._dirLightVertexConstants = new Vector.<ShaderRegisterElement>(_numDirectionalLights,true);
            this._dirLightFragmentConstants = new Vector.<ShaderRegisterElement>(_numDirectionalLights * 2,true);
         }
         else
         {
            this._dirLightFragmentConstants = new Vector.<ShaderRegisterElement>(_numDirectionalLights * 3,true);
         }
      }
      
      override protected function calculateDependencies() : void
      {
         super.calculateDependencies();
         if(!this.tangentSpace)
         {
            _dependencyCounter.addWorldSpaceDependencies(false);
         }
      }
      
      override protected function compileNormalCode() : void
      {
         var _loc1_:Vector.<ShaderRegisterElement> = null;
         _sharedRegisters.normalFragment = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_sharedRegisters.normalFragment,_dependencyCounter.normalDependencies);
         if(_methodSetup._normalMethod.hasOutput && !_methodSetup._normalMethod.tangentSpace)
         {
            _vertexCode += _methodSetup._normalMethod.getVertexCode(_methodSetup._normalMethodVO,_registerCache);
            _fragmentCode += _methodSetup._normalMethod.getFragmentCode(_methodSetup._normalMethodVO,_registerCache,_sharedRegisters.normalFragment);
            return;
         }
         if(this.tangentSpace)
         {
            this.compileTangentSpaceNormalMapCode();
         }
         else
         {
            _loc1_ = new Vector.<ShaderRegisterElement>(3,true);
            _loc1_[0] = _registerCache.getFreeVertexConstant();
            _loc1_[1] = _registerCache.getFreeVertexConstant();
            _loc1_[2] = _registerCache.getFreeVertexConstant();
            _registerCache.getFreeVertexConstant();
            _sceneNormalMatrixIndex = _loc1_[0].index * 4;
            _sharedRegisters.normalVarying = _registerCache.getFreeVarying();
            _vertexCode += "m33 " + _sharedRegisters.normalVarying + ".xyz, " + _sharedRegisters.animatedNormal + ", " + _loc1_[0] + "\n" + "mov " + _sharedRegisters.normalVarying + ".w, " + _sharedRegisters.animatedNormal + ".w\t\n";
            _fragmentCode += "nrm " + _sharedRegisters.normalFragment + ".xyz, " + _sharedRegisters.normalVarying + "\n" + "mov " + _sharedRegisters.normalFragment + ".w, " + _sharedRegisters.normalVarying + ".w\t\t\n";
         }
         if(_dependencyCounter.tangentDependencies > 0)
         {
            _sharedRegisters.tangentInput = _registerCache.getFreeVertexAttribute();
            _tangentBufferIndex = _sharedRegisters.tangentInput.index;
            _sharedRegisters.tangentVarying = _registerCache.getFreeVarying();
         }
      }
      
      private function compileTangentSpaceNormalMapCode() : void
      {
         _vertexCode += "nrm " + _sharedRegisters.animatedNormal + ".xyz, " + _sharedRegisters.animatedNormal + "\n" + "nrm " + _sharedRegisters.animatedTangent + ".xyz, " + _sharedRegisters.animatedTangent + "\n";
         _vertexCode += "crs " + _sharedRegisters.bitangent + ".xyz, " + _sharedRegisters.animatedNormal + ", " + _sharedRegisters.animatedTangent + "\n";
         _fragmentCode += _methodSetup._normalMethod.getFragmentCode(_methodSetup._normalMethodVO,_registerCache,_sharedRegisters.normalFragment);
         if(_methodSetup._normalMethodVO.needsView)
         {
            _registerCache.removeFragmentTempUsage(_sharedRegisters.viewDirFragment);
         }
         if(_methodSetup._normalMethodVO.needsGlobalFragmentPos || _methodSetup._normalMethodVO.needsGlobalVertexPos)
         {
            _registerCache.removeVertexTempUsage(_sharedRegisters.globalPositionVertex);
         }
      }
      
      override protected function compileViewDirCode() : void
      {
         var _loc2_:ShaderRegisterElement = null;
         var _loc1_:ShaderRegisterElement = _registerCache.getFreeVertexConstant();
         _sharedRegisters.viewDirVarying = _registerCache.getFreeVarying();
         _sharedRegisters.viewDirFragment = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_sharedRegisters.viewDirFragment,_dependencyCounter.viewDirDependencies);
         _cameraPositionIndex = _loc1_.index * 4;
         if(this.tangentSpace)
         {
            _loc2_ = _registerCache.getFreeVertexVectorTemp();
            _vertexCode += "sub " + _loc2_ + ", " + _loc1_ + ", " + _sharedRegisters.localPosition + "\n" + "m33 " + _sharedRegisters.viewDirVarying + ".xyz, " + _loc2_ + ", " + _sharedRegisters.animatedTangent + "\n" + "mov " + _sharedRegisters.viewDirVarying + ".w, " + _sharedRegisters.localPosition + ".w\n";
         }
         else
         {
            _vertexCode += "sub " + _sharedRegisters.viewDirVarying + ", " + _loc1_ + ", " + _sharedRegisters.globalPositionVertex + "\n";
            _registerCache.removeVertexTempUsage(_sharedRegisters.globalPositionVertex);
         }
         _fragmentCode += "nrm " + _sharedRegisters.viewDirFragment + ".xyz, " + _sharedRegisters.viewDirVarying + "\n" + "mov " + _sharedRegisters.viewDirFragment + ".w,   " + _sharedRegisters.viewDirVarying + ".w \t\t\n";
      }
      
      override protected function compileLightingCode() : void
      {
         if(_methodSetup._shadowMethod)
         {
            this.compileShadowCode();
         }
         _methodSetup._diffuseMethod.shadowRegister = this._shadowRegister;
         _sharedRegisters.shadedTarget = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_sharedRegisters.shadedTarget,1);
         _vertexCode += _methodSetup._diffuseMethod.getVertexCode(_methodSetup._diffuseMethodVO,_registerCache);
         _fragmentCode += _methodSetup._diffuseMethod.getFragmentPreLightingCode(_methodSetup._diffuseMethodVO,_registerCache);
         if(_usingSpecularMethod)
         {
            _vertexCode += _methodSetup._specularMethod.getVertexCode(_methodSetup._specularMethodVO,_registerCache);
            _fragmentCode += _methodSetup._specularMethod.getFragmentPreLightingCode(_methodSetup._specularMethodVO,_registerCache);
         }
         if(usesLights())
         {
            this.initLightRegisters();
            this.compileDirectionalLightCode();
            this.compilePointLightCode();
         }
         if(usesProbes())
         {
            this.compileLightProbeCode();
         }
         _vertexCode += _methodSetup._ambientMethod.getVertexCode(_methodSetup._ambientMethodVO,_registerCache);
         _fragmentCode += _methodSetup._ambientMethod.getFragmentCode(_methodSetup._ambientMethodVO,_registerCache,_sharedRegisters.shadedTarget);
         if(_methodSetup._ambientMethodVO.needsNormals)
         {
            _registerCache.removeFragmentTempUsage(_sharedRegisters.normalFragment);
         }
         if(_methodSetup._ambientMethodVO.needsView)
         {
            _registerCache.removeFragmentTempUsage(_sharedRegisters.viewDirFragment);
         }
         _fragmentCode += _methodSetup._diffuseMethod.getFragmentPostLightingCode(_methodSetup._diffuseMethodVO,_registerCache,_sharedRegisters.shadedTarget);
         if(_alphaPremultiplied)
         {
            _fragmentCode += "add " + _sharedRegisters.shadedTarget + ".w, " + _sharedRegisters.shadedTarget + ".w, " + _sharedRegisters.commons + ".z\n" + "div " + _sharedRegisters.shadedTarget + ".xyz, " + _sharedRegisters.shadedTarget + ", " + _sharedRegisters.shadedTarget + ".w\n" + "sub " + _sharedRegisters.shadedTarget + ".w, " + _sharedRegisters.shadedTarget + ".w, " + _sharedRegisters.commons + ".z\n" + "sat " + _sharedRegisters.shadedTarget + ".xyz, " + _sharedRegisters.shadedTarget + "\n";
         }
         if(_methodSetup._diffuseMethodVO.needsNormals)
         {
            _registerCache.removeFragmentTempUsage(_sharedRegisters.normalFragment);
         }
         if(_methodSetup._diffuseMethodVO.needsView)
         {
            _registerCache.removeFragmentTempUsage(_sharedRegisters.viewDirFragment);
         }
         if(_usingSpecularMethod)
         {
            _methodSetup._specularMethod.shadowRegister = this._shadowRegister;
            _fragmentCode += _methodSetup._specularMethod.getFragmentPostLightingCode(_methodSetup._specularMethodVO,_registerCache,_sharedRegisters.shadedTarget);
            if(_methodSetup._specularMethodVO.needsNormals)
            {
               _registerCache.removeFragmentTempUsage(_sharedRegisters.normalFragment);
            }
            if(_methodSetup._specularMethodVO.needsView)
            {
               _registerCache.removeFragmentTempUsage(_sharedRegisters.viewDirFragment);
            }
         }
         if(_methodSetup._shadowMethod)
         {
            _registerCache.removeFragmentTempUsage(this._shadowRegister);
         }
      }
      
      private function compileShadowCode() : void
      {
         if(_sharedRegisters.normalFragment)
         {
            this._shadowRegister = _sharedRegisters.normalFragment;
         }
         else
         {
            this._shadowRegister = _registerCache.getFreeFragmentVectorTemp();
         }
         _registerCache.addFragmentTempUsages(this._shadowRegister,1);
         _vertexCode += _methodSetup._shadowMethod.getVertexCode(_methodSetup._shadowMethodVO,_registerCache);
         _fragmentCode += _methodSetup._shadowMethod.getFragmentCode(_methodSetup._shadowMethodVO,_registerCache,this._shadowRegister);
      }
      
      private function initLightRegisters() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         if(this._dirLightVertexConstants)
         {
            _loc2_ = this._dirLightVertexConstants.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this._dirLightVertexConstants[_loc1_] = _registerCache.getFreeVertexConstant();
               if(this._lightVertexConstantIndex == -1)
               {
                  this._lightVertexConstantIndex = this._dirLightVertexConstants[_loc1_].index * 4;
               }
               _loc1_++;
            }
         }
         _loc2_ = this._pointLightVertexConstants.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._pointLightVertexConstants[_loc1_] = _registerCache.getFreeVertexConstant();
            if(this._lightVertexConstantIndex == -1)
            {
               this._lightVertexConstantIndex = this._pointLightVertexConstants[_loc1_].index * 4;
            }
            _loc1_++;
         }
         _loc2_ = this._dirLightFragmentConstants.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._dirLightFragmentConstants[_loc1_] = _registerCache.getFreeFragmentConstant();
            if(_lightFragmentConstantIndex == -1)
            {
               _lightFragmentConstantIndex = this._dirLightFragmentConstants[_loc1_].index * 4;
            }
            _loc1_++;
         }
         _loc2_ = this._pointLightFragmentConstants.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._pointLightFragmentConstants[_loc1_] = _registerCache.getFreeFragmentConstant();
            if(_lightFragmentConstantIndex == -1)
            {
               _lightFragmentConstantIndex = this._pointLightFragmentConstants[_loc1_].index * 4;
            }
            _loc1_++;
         }
      }
      
      private function compileDirectionalLightCode() : void
      {
         var _loc1_:ShaderRegisterElement = null;
         var _loc2_:ShaderRegisterElement = null;
         var _loc3_:ShaderRegisterElement = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         var _loc9_:ShaderRegisterElement = null;
         var _loc6_:Boolean = _usingSpecularMethod && usesLightsForSpecular();
         var _loc7_:Boolean = usesLightsForDiffuse();
         if(!(_loc6_ || _loc7_))
         {
            return;
         }
         var _loc8_:uint = 0;
         while(_loc8_ < _numDirectionalLights)
         {
            if(this.tangentSpace)
            {
               _loc3_ = this._dirLightVertexConstants[_loc4_++];
               _loc9_ = _registerCache.getFreeVarying();
               _vertexCode += "m33 " + _loc9_ + ".xyz, " + _loc3_ + ", " + _sharedRegisters.animatedTangent + "\n" + "mov " + _loc9_ + ".w, " + _loc3_ + ".w\n";
               _loc3_ = _registerCache.getFreeFragmentVectorTemp();
               _registerCache.addVertexTempUsages(_loc3_,1);
               _fragmentCode += "nrm " + _loc3_ + ".xyz, " + _loc9_ + "\n";
               _fragmentCode += "mov " + _loc3_ + ".w, " + _loc9_ + ".w\n";
            }
            else
            {
               _loc3_ = this._dirLightFragmentConstants[_loc5_++];
            }
            _loc1_ = this._dirLightFragmentConstants[_loc5_++];
            _loc2_ = this._dirLightFragmentConstants[_loc5_++];
            if(_loc7_)
            {
               _fragmentCode += _methodSetup._diffuseMethod.getFragmentCodePerLight(_methodSetup._diffuseMethodVO,_loc3_,_loc1_,_registerCache);
            }
            if(_loc6_)
            {
               _fragmentCode += _methodSetup._specularMethod.getFragmentCodePerLight(_methodSetup._specularMethodVO,_loc3_,_loc2_,_registerCache);
            }
            if(this.tangentSpace)
            {
               _registerCache.removeVertexTempUsage(_loc3_);
            }
            _loc8_++;
         }
      }
      
      private function compilePointLightCode() : void
      {
         var _loc1_:ShaderRegisterElement = null;
         var _loc2_:ShaderRegisterElement = null;
         var _loc3_:ShaderRegisterElement = null;
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:* = 0;
         var _loc6_:* = 0;
         var _loc7_:Boolean = false;
         var _loc8_:Boolean = false;
         var _loc10_:ShaderRegisterElement = null;
         var _loc11_:ShaderRegisterElement = null;
         _loc7_ = _usingSpecularMethod && usesLightsForSpecular();
         _loc8_ = usesLightsForDiffuse();
         if(!(_loc7_ || _loc8_))
         {
            return;
         }
         var _loc9_:uint = 0;
         while(_loc9_ < _numPointLights)
         {
            _loc3_ = this._pointLightVertexConstants[_loc5_++];
            _loc1_ = this._pointLightFragmentConstants[_loc6_++];
            _loc2_ = this._pointLightFragmentConstants[_loc6_++];
            _loc4_ = _registerCache.getFreeFragmentVectorTemp();
            _registerCache.addFragmentTempUsages(_loc4_,1);
            _loc10_ = _registerCache.getFreeVarying();
            if(this.tangentSpace)
            {
               _loc11_ = _registerCache.getFreeVertexVectorTemp();
               _vertexCode += "sub " + _loc11_ + ", " + _loc3_ + ", " + _sharedRegisters.localPosition + "\n" + "m33 " + _loc10_ + ".xyz, " + _loc11_ + ", " + _sharedRegisters.animatedTangent + "\n" + "mov " + _loc10_ + ".w, " + _sharedRegisters.localPosition + ".w\n";
            }
            else
            {
               _vertexCode += "sub " + _loc10_ + ", " + _loc3_ + ", " + _sharedRegisters.globalPositionVertex + "\n";
            }
            if(_enableLightFallOff && _profile != "baselineConstrained")
            {
               _fragmentCode += "dp3 " + _loc4_ + ".w, " + _loc10_ + ", " + _loc10_ + "\n" + "sub " + _loc4_ + ".w, " + _loc4_ + ".w, " + _loc1_ + ".w\n" + "mul " + _loc4_ + ".w, " + _loc4_ + ".w, " + _loc2_ + ".w\n" + "sat " + _loc4_ + ".w, " + _loc4_ + ".w\n" + "sub " + _loc4_ + ".w, " + _sharedRegisters.commons + ".w, " + _loc4_ + ".w\n" + "nrm " + _loc4_ + ".xyz, " + _loc10_ + "\n";
            }
            else
            {
               _fragmentCode += "nrm " + _loc4_ + ".xyz, " + _loc10_ + "\n" + "mov " + _loc4_ + ".w, " + _loc10_ + ".w\n";
            }
            if(_lightFragmentConstantIndex == -1)
            {
               _lightFragmentConstantIndex = _loc3_.index * 4;
            }
            if(_loc8_)
            {
               _fragmentCode += _methodSetup._diffuseMethod.getFragmentCodePerLight(_methodSetup._diffuseMethodVO,_loc4_,_loc1_,_registerCache);
            }
            if(_loc7_)
            {
               _fragmentCode += _methodSetup._specularMethod.getFragmentCodePerLight(_methodSetup._specularMethodVO,_loc4_,_loc2_,_registerCache);
            }
            _registerCache.removeFragmentTempUsage(_loc4_);
            _loc9_++;
         }
      }
      
      private function compileLightProbeCode() : void
      {
         var _loc1_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:ShaderRegisterElement = null;
         var _loc2_:Array = [".x",".y",".z",".w"];
         var _loc3_:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>();
         var _loc6_:Boolean = _usingSpecularMethod && usesProbesForSpecular();
         var _loc7_:Boolean = usesProbesForDiffuse();
         if(!(_loc6_ || _loc7_))
         {
            return;
         }
         if(_loc7_)
         {
            _lightProbeDiffuseIndices = new Vector.<uint>();
         }
         if(_loc6_)
         {
            _lightProbeSpecularIndices = new Vector.<uint>();
         }
         _loc4_ = 0;
         while(_loc4_ < _numProbeRegisters)
         {
            _loc3_[_loc4_] = _registerCache.getFreeFragmentConstant();
            if(_loc4_ == 0)
            {
               _probeWeightsIndex = _loc3_[_loc4_].index * 4;
            }
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < _numLightProbes)
         {
            _loc1_ = _loc3_[Math.floor(_loc4_ / 4)].toString() + _loc2_[_loc4_ % 4];
            if(_loc7_)
            {
               _loc5_ = _registerCache.getFreeTextureReg();
               _lightProbeDiffuseIndices[_loc4_] = _loc5_.index;
               _fragmentCode += _methodSetup._diffuseMethod.getFragmentCodePerProbe(_methodSetup._diffuseMethodVO,_loc5_,_loc1_,_registerCache);
            }
            if(_loc6_)
            {
               _loc5_ = _registerCache.getFreeTextureReg();
               _lightProbeSpecularIndices[_loc4_] = _loc5_.index;
               _fragmentCode += _methodSetup._specularMethod.getFragmentCodePerProbe(_methodSetup._specularMethodVO,_loc5_,_loc1_,_registerCache);
            }
            _loc4_++;
         }
      }
   }
}

