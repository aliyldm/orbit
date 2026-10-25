package away3d.materials.compilation
{
   import away3d.arcane;
   
   use namespace arcane;
   
   public class SuperShaderCompiler extends ShaderCompiler
   {
      
      public var _pointLightRegisters:Vector.<ShaderRegisterElement>;
      
      public var _dirLightRegisters:Vector.<ShaderRegisterElement>;
      
      public function SuperShaderCompiler(param1:String)
      {
         super(param1);
      }
      
      override protected function initLightData() : void
      {
         super.initLightData();
         this._pointLightRegisters = new Vector.<ShaderRegisterElement>(_numPointLights * 3,true);
         this._dirLightRegisters = new Vector.<ShaderRegisterElement>(_numDirectionalLights * 3,true);
      }
      
      override protected function calculateDependencies() : void
      {
         super.calculateDependencies();
         _dependencyCounter.addWorldSpaceDependencies(true);
      }
      
      override protected function compileNormalCode() : void
      {
         var _loc1_:Vector.<ShaderRegisterElement> = new Vector.<ShaderRegisterElement>(3,true);
         _sharedRegisters.normalFragment = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_sharedRegisters.normalFragment,_dependencyCounter.normalDependencies);
         if(_methodSetup._normalMethod.hasOutput && !_methodSetup._normalMethod.tangentSpace)
         {
            _vertexCode += _methodSetup._normalMethod.getVertexCode(_methodSetup._normalMethodVO,_registerCache);
            _fragmentCode += _methodSetup._normalMethod.getFragmentCode(_methodSetup._normalMethodVO,_registerCache,_sharedRegisters.normalFragment);
            return;
         }
         _sharedRegisters.normalVarying = _registerCache.getFreeVarying();
         _loc1_[0] = _registerCache.getFreeVertexConstant();
         _loc1_[1] = _registerCache.getFreeVertexConstant();
         _loc1_[2] = _registerCache.getFreeVertexConstant();
         _registerCache.getFreeVertexConstant();
         _sceneNormalMatrixIndex = _loc1_[0].index * 4;
         if(_methodSetup._normalMethod.hasOutput)
         {
            this.compileTangentVertexCode(_loc1_);
            this.compileTangentNormalMapFragmentCode();
         }
         else
         {
            _vertexCode += "m33 " + _sharedRegisters.normalVarying + ".xyz, " + _sharedRegisters.animatedNormal + ", " + _loc1_[0] + "\n" + "mov " + _sharedRegisters.normalVarying + ".w, " + _sharedRegisters.animatedNormal + ".w\t\n";
            _fragmentCode += "nrm " + _sharedRegisters.normalFragment + ".xyz, " + _sharedRegisters.normalVarying + "\n" + "mov " + _sharedRegisters.normalFragment + ".w, " + _sharedRegisters.normalVarying + ".w\t\t\n";
            if(_dependencyCounter.tangentDependencies > 0)
            {
               _sharedRegisters.tangentInput = _registerCache.getFreeVertexAttribute();
               _tangentBufferIndex = _sharedRegisters.tangentInput.index;
               _sharedRegisters.tangentVarying = _registerCache.getFreeVarying();
               _vertexCode += "mov " + _sharedRegisters.tangentVarying + ", " + _sharedRegisters.tangentInput + "\n";
            }
         }
         _registerCache.removeVertexTempUsage(_sharedRegisters.animatedNormal);
      }
      
      override protected function createNormalRegisters() : void
      {
         if(_dependencyCounter.normalDependencies > 0)
         {
            _sharedRegisters.normalInput = _registerCache.getFreeVertexAttribute();
            _normalBufferIndex = _sharedRegisters.normalInput.index;
            _sharedRegisters.animatedNormal = _registerCache.getFreeVertexVectorTemp();
            _registerCache.addVertexTempUsages(_sharedRegisters.animatedNormal,1);
            _animatableAttributes.push(_sharedRegisters.normalInput.toString());
            _animationTargetRegisters.push(_sharedRegisters.animatedNormal.toString());
         }
         if(_methodSetup._normalMethod.hasOutput)
         {
            _sharedRegisters.tangentInput = _registerCache.getFreeVertexAttribute();
            _tangentBufferIndex = _sharedRegisters.tangentInput.index;
            _sharedRegisters.animatedTangent = _registerCache.getFreeVertexVectorTemp();
            _registerCache.addVertexTempUsages(_sharedRegisters.animatedTangent,1);
            _animatableAttributes.push(_sharedRegisters.tangentInput.toString());
            _animationTargetRegisters.push(_sharedRegisters.animatedTangent.toString());
         }
      }
      
      private function compileTangentVertexCode(param1:Vector.<ShaderRegisterElement>) : void
      {
         _sharedRegisters.tangentVarying = _registerCache.getFreeVarying();
         _sharedRegisters.bitangentVarying = _registerCache.getFreeVarying();
         _vertexCode += "m33 " + _sharedRegisters.animatedNormal + ".xyz, " + _sharedRegisters.animatedNormal + ", " + param1[0] + "\n" + "nrm " + _sharedRegisters.animatedNormal + ".xyz, " + _sharedRegisters.animatedNormal + "\n";
         _vertexCode += "m33 " + _sharedRegisters.animatedTangent + ".xyz, " + _sharedRegisters.animatedTangent + ", " + param1[0] + "\n" + "nrm " + _sharedRegisters.animatedTangent + ".xyz, " + _sharedRegisters.animatedTangent + "\n";
         var _loc2_:ShaderRegisterElement = _registerCache.getFreeVertexVectorTemp();
         _vertexCode += "mov " + _sharedRegisters.tangentVarying + ".x, " + _sharedRegisters.animatedTangent + ".x  \n" + "mov " + _sharedRegisters.tangentVarying + ".z, " + _sharedRegisters.animatedNormal + ".x  \n" + "mov " + _sharedRegisters.tangentVarying + ".w, " + _sharedRegisters.normalInput + ".w  \n" + "mov " + _sharedRegisters.bitangentVarying + ".x, " + _sharedRegisters.animatedTangent + ".y  \n" + "mov " + _sharedRegisters.bitangentVarying + ".z, " + _sharedRegisters.animatedNormal + ".y  \n" + "mov " + _sharedRegisters.bitangentVarying + ".w, " + _sharedRegisters.normalInput + ".w  \n" + "mov " + _sharedRegisters.normalVarying + ".x, " + _sharedRegisters.animatedTangent + ".z  \n" + "mov " + _sharedRegisters.normalVarying + ".z, " + _sharedRegisters.animatedNormal + ".z  \n" + "mov " + _sharedRegisters.normalVarying + ".w, " + _sharedRegisters.normalInput + ".w  \n" + "crs " + _loc2_ + ".xyz, " + _sharedRegisters.animatedNormal + ", " + _sharedRegisters.animatedTangent + "\n" + "mov " + _sharedRegisters
         .tangentVarying + ".y, " + _loc2_ + ".x    \n" + "mov " + _sharedRegisters.bitangentVarying + ".y, " + _loc2_ + ".y  \n" + "mov " + _sharedRegisters.normalVarying + ".y, " + _loc2_ + ".z    \n";
         _registerCache.removeVertexTempUsage(_sharedRegisters.animatedTangent);
      }
      
      private function compileTangentNormalMapFragmentCode() : void
      {
         var _loc1_:ShaderRegisterElement = null;
         var _loc2_:ShaderRegisterElement = null;
         var _loc3_:ShaderRegisterElement = null;
         _loc1_ = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_loc1_,1);
         _loc2_ = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_loc2_,1);
         _loc3_ = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_loc3_,1);
         _fragmentCode += "nrm " + _loc1_ + ".xyz, " + _sharedRegisters.tangentVarying + "\n" + "mov " + _loc1_ + ".w, " + _sharedRegisters.tangentVarying + ".w\t\n" + "nrm " + _loc2_ + ".xyz, " + _sharedRegisters.bitangentVarying + "\n" + "nrm " + _loc3_ + ".xyz, " + _sharedRegisters.normalVarying + "\n";
         var _loc4_:ShaderRegisterElement = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_loc4_,1);
         _fragmentCode += _methodSetup._normalMethod.getFragmentCode(_methodSetup._normalMethodVO,_registerCache,_loc4_) + "m33 " + _sharedRegisters.normalFragment + ".xyz, " + _loc4_ + ", " + _loc1_ + "\t\n" + "mov " + _sharedRegisters.normalFragment + ".w,   " + _sharedRegisters.normalVarying + ".w\t\t\t\n";
         _registerCache.removeFragmentTempUsage(_loc4_);
         if(_methodSetup._normalMethodVO.needsView)
         {
            _registerCache.removeFragmentTempUsage(_sharedRegisters.viewDirFragment);
         }
         if(_methodSetup._normalMethodVO.needsGlobalVertexPos || _methodSetup._normalMethodVO.needsGlobalFragmentPos)
         {
            _registerCache.removeVertexTempUsage(_sharedRegisters.globalPositionVertex);
         }
         _registerCache.removeFragmentTempUsage(_loc2_);
         _registerCache.removeFragmentTempUsage(_loc1_);
         _registerCache.removeFragmentTempUsage(_loc3_);
      }
      
      override protected function compileViewDirCode() : void
      {
         var _loc1_:ShaderRegisterElement = _registerCache.getFreeVertexConstant();
         _sharedRegisters.viewDirVarying = _registerCache.getFreeVarying();
         _sharedRegisters.viewDirFragment = _registerCache.getFreeFragmentVectorTemp();
         _registerCache.addFragmentTempUsages(_sharedRegisters.viewDirFragment,_dependencyCounter.viewDirDependencies);
         _cameraPositionIndex = _loc1_.index * 4;
         _vertexCode += "sub " + _sharedRegisters.viewDirVarying + ", " + _loc1_ + ", " + _sharedRegisters.globalPositionVertex + "\n";
         _fragmentCode += "nrm " + _sharedRegisters.viewDirFragment + ".xyz, " + _sharedRegisters.viewDirVarying + "\n" + "mov " + _sharedRegisters.viewDirFragment + ".w,   " + _sharedRegisters.viewDirVarying + ".w \t\t\n";
         _registerCache.removeVertexTempUsage(_sharedRegisters.globalPositionVertex);
      }
      
      override protected function compileLightingCode() : void
      {
         var _loc1_:ShaderRegisterElement = null;
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
         if(_methodSetup._shadowMethod)
         {
            _vertexCode += _methodSetup._shadowMethod.getVertexCode(_methodSetup._shadowMethodVO,_registerCache);
            if(_dependencyCounter.normalDependencies == 0)
            {
               _loc1_ = _registerCache.getFreeFragmentVectorTemp();
               _registerCache.addFragmentTempUsages(_loc1_,1);
            }
            else
            {
               _loc1_ = _sharedRegisters.normalFragment;
            }
            _methodSetup._diffuseMethod.shadowRegister = _loc1_;
            _fragmentCode += _methodSetup._shadowMethod.getFragmentCode(_methodSetup._shadowMethodVO,_registerCache,_loc1_);
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
            _methodSetup._specularMethod.shadowRegister = _loc1_;
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
      }
      
      private function initLightRegisters() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this._dirLightRegisters.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._dirLightRegisters[_loc1_] = _registerCache.getFreeFragmentConstant();
            if(_lightFragmentConstantIndex == -1)
            {
               _lightFragmentConstantIndex = this._dirLightRegisters[_loc1_].index * 4;
            }
            _loc1_++;
         }
         _loc2_ = this._pointLightRegisters.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this._pointLightRegisters[_loc1_] = _registerCache.getFreeFragmentConstant();
            if(_lightFragmentConstantIndex == -1)
            {
               _lightFragmentConstantIndex = this._pointLightRegisters[_loc1_].index * 4;
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
         var _loc5_:Boolean = _usingSpecularMethod && usesLightsForSpecular();
         var _loc6_:Boolean = usesLightsForDiffuse();
         if(!(_loc5_ || _loc6_))
         {
            return;
         }
         var _loc7_:uint = 0;
         while(_loc7_ < _numDirectionalLights)
         {
            _loc3_ = this._dirLightRegisters[_loc4_++];
            _loc1_ = this._dirLightRegisters[_loc4_++];
            _loc2_ = this._dirLightRegisters[_loc4_++];
            if(_loc6_)
            {
               _fragmentCode += _methodSetup._diffuseMethod.getFragmentCodePerLight(_methodSetup._diffuseMethodVO,_loc3_,_loc1_,_registerCache);
            }
            if(_loc5_)
            {
               _fragmentCode += _methodSetup._specularMethod.getFragmentCodePerLight(_methodSetup._specularMethodVO,_loc3_,_loc2_,_registerCache);
            }
            _loc7_++;
         }
      }
      
      private function compilePointLightCode() : void
      {
         var _loc1_:ShaderRegisterElement = null;
         var _loc2_:ShaderRegisterElement = null;
         var _loc3_:ShaderRegisterElement = null;
         var _loc4_:ShaderRegisterElement = null;
         var _loc5_:* = 0;
         var _loc6_:Boolean = _usingSpecularMethod && usesLightsForSpecular();
         var _loc7_:Boolean = usesLightsForDiffuse();
         if(!(_loc6_ || _loc7_))
         {
            return;
         }
         var _loc8_:uint = 0;
         while(_loc8_ < _numPointLights)
         {
            _loc3_ = this._pointLightRegisters[_loc5_++];
            _loc1_ = this._pointLightRegisters[_loc5_++];
            _loc2_ = this._pointLightRegisters[_loc5_++];
            _loc4_ = _registerCache.getFreeFragmentVectorTemp();
            _registerCache.addFragmentTempUsages(_loc4_,1);
            _fragmentCode += "sub " + _loc4_ + ", " + _loc3_ + ", " + _sharedRegisters.globalPositionVarying + "\n" + "dp3 " + _loc4_ + ".w, " + _loc4_ + ", " + _loc4_ + "\n" + "sub " + _loc4_ + ".w, " + _loc4_ + ".w, " + _loc1_ + ".w\n" + "mul " + _loc4_ + ".w, " + _loc4_ + ".w, " + _loc2_ + ".w\n" + "sat " + _loc4_ + ".w, " + _loc4_ + ".w\n" + "sub " + _loc4_ + ".w, " + _loc3_ + ".w, " + _loc4_ + ".w\n" + "nrm " + _loc4_ + ".xyz, " + _loc4_ + "\n";
            if(_lightFragmentConstantIndex == -1)
            {
               _lightFragmentConstantIndex = _loc3_.index * 4;
            }
            if(_loc7_)
            {
               _fragmentCode += _methodSetup._diffuseMethod.getFragmentCodePerLight(_methodSetup._diffuseMethodVO,_loc4_,_loc1_,_registerCache);
            }
            if(_loc6_)
            {
               _fragmentCode += _methodSetup._specularMethod.getFragmentCodePerLight(_methodSetup._specularMethodVO,_loc4_,_loc2_,_registerCache);
            }
            _registerCache.removeFragmentTempUsage(_loc4_);
            _loc8_++;
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

