package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightProbe;
   import away3d.lights.PointLight;
   import away3d.materials.LightSources;
   import away3d.materials.MaterialBase;
   import away3d.materials.compilation.ShaderCompiler;
   import away3d.materials.compilation.SuperShaderCompiler;
   import away3d.materials.methods.ColorTransformMethod;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.MethodVOSet;
   import flash.display3D.Context3D;
   import flash.geom.ColorTransform;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class SuperShaderPass extends CompiledPass
   {
      
      private var _includeCasters:Boolean = true;
      
      private var _ignoreLights:Boolean;
      
      public function SuperShaderPass(param1:MaterialBase)
      {
         super(param1);
         _needFragmentAnimation = true;
      }
      
      override protected function createCompiler(param1:String) : ShaderCompiler
      {
         return new SuperShaderCompiler(param1);
      }
      
      public function get includeCasters() : Boolean
      {
         return this._includeCasters;
      }
      
      public function set includeCasters(param1:Boolean) : void
      {
         if(this._includeCasters == param1)
         {
            return;
         }
         this._includeCasters = param1;
         invalidateShaderProgram();
      }
      
      public function get colorTransform() : ColorTransform
      {
         return _methodSetup.colorTransformMethod ? _methodSetup._colorTransformMethod.colorTransform : null;
      }
      
      public function set colorTransform(param1:ColorTransform) : void
      {
         if(param1)
         {
            this.colorTransformMethod = this.colorTransformMethod || new ColorTransformMethod();
            _methodSetup._colorTransformMethod.colorTransform = param1;
         }
         else if(!param1)
         {
            if(_methodSetup._colorTransformMethod)
            {
               this.colorTransformMethod = null;
            }
            this.colorTransformMethod = _methodSetup._colorTransformMethod = null;
         }
      }
      
      public function get colorTransformMethod() : ColorTransformMethod
      {
         return _methodSetup.colorTransformMethod;
      }
      
      public function set colorTransformMethod(param1:ColorTransformMethod) : void
      {
         _methodSetup.colorTransformMethod = param1;
      }
      
      public function addMethod(param1:EffectMethodBase) : void
      {
         _methodSetup.addMethod(param1);
      }
      
      public function get numMethods() : int
      {
         return _methodSetup.numMethods;
      }
      
      public function hasMethod(param1:EffectMethodBase) : Boolean
      {
         return _methodSetup.hasMethod(param1);
      }
      
      public function getMethodAt(param1:int) : EffectMethodBase
      {
         return _methodSetup.getMethodAt(param1);
      }
      
      public function addMethodAt(param1:EffectMethodBase, param2:int) : void
      {
         _methodSetup.addMethodAt(param1,param2);
      }
      
      public function removeMethod(param1:EffectMethodBase) : void
      {
         _methodSetup.removeMethod(param1);
      }
      
      override protected function updateLights() : void
      {
         if(Boolean(_lightPicker) && !this._ignoreLights)
         {
            _numPointLights = _lightPicker.numPointLights;
            _numDirectionalLights = _lightPicker.numDirectionalLights;
            _numLightProbes = _lightPicker.numLightProbes;
            if(this._includeCasters)
            {
               _numPointLights += _lightPicker.numCastingPointLights;
               _numDirectionalLights += _lightPicker.numCastingDirectionalLights;
            }
         }
         else
         {
            _numPointLights = 0;
            _numDirectionalLights = 0;
            _numLightProbes = 0;
         }
         invalidateShaderProgram();
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         var _loc6_:MethodVOSet = null;
         var _loc7_:Vector3D = null;
         super.arcane::activate(param1,param2);
         if(_methodSetup._colorTransformMethod)
         {
            _methodSetup._colorTransformMethod.activate(_methodSetup._colorTransformMethodVO,param1);
         }
         var _loc3_:Vector.<MethodVOSet> = _methodSetup._methods;
         var _loc4_:uint = _loc3_.length;
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = _loc3_[_loc5_];
            _loc6_.method.activate(_loc6_.data,param1);
            _loc5_++;
         }
         if(_cameraPositionIndex >= 0)
         {
            _loc7_ = param2.scenePosition;
            _vertexConstantData[_cameraPositionIndex] = _loc7_.x;
            _vertexConstantData[_cameraPositionIndex + 1] = _loc7_.y;
            _vertexConstantData[_cameraPositionIndex + 2] = _loc7_.z;
         }
      }
      
      override arcane function deactivate(param1:Stage3DProxy) : void
      {
         var _loc2_:MethodVOSet = null;
         super.arcane::deactivate(param1);
         if(_methodSetup._colorTransformMethod)
         {
            _methodSetup._colorTransformMethod.deactivate(_methodSetup._colorTransformMethodVO,param1);
         }
         var _loc3_:Vector.<MethodVOSet> = _methodSetup._methods;
         var _loc4_:uint = _loc3_.length;
         var _loc5_:uint = 0;
         while(_loc5_ < _loc4_)
         {
            _loc2_ = _loc3_[_loc5_];
            _loc2_.method.deactivate(_loc2_.data,param1);
            _loc5_++;
         }
      }
      
      override protected function addPassesFromMethods() : void
      {
         super.addPassesFromMethods();
         if(_methodSetup._colorTransformMethod)
         {
            addPasses(_methodSetup._colorTransformMethod.passes);
         }
         var _loc1_:Vector.<MethodVOSet> = _methodSetup._methods;
         var _loc2_:uint = 0;
         while(_loc2_ < _loc1_.length)
         {
            addPasses(_loc1_[_loc2_].method.passes);
            _loc2_++;
         }
      }
      
      private function usesProbesForSpecular() : Boolean
      {
         return _numLightProbes > 0 && (_specularLightSources & LightSources.PROBES) != 0;
      }
      
      private function usesProbesForDiffuse() : Boolean
      {
         return _numLightProbes > 0 && (_diffuseLightSources & LightSources.PROBES) != 0;
      }
      
      override protected function updateMethodConstants() : void
      {
         super.updateMethodConstants();
         if(_methodSetup._colorTransformMethod)
         {
            _methodSetup._colorTransformMethod.initConstants(_methodSetup._colorTransformMethodVO);
         }
         var _loc1_:Vector.<MethodVOSet> = _methodSetup._methods;
         var _loc2_:uint = _loc1_.length;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_)
         {
            _loc1_[_loc3_].method.initConstants(_loc1_[_loc3_].data);
            _loc3_++;
         }
      }
      
      override protected function updateLightConstants() : void
      {
         var _loc1_:DirectionalLight = null;
         var _loc2_:PointLight = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector3D = null;
         var _loc10_:Vector.<DirectionalLight> = null;
         var _loc11_:Vector.<PointLight> = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = this._includeCasters ? 2 : 1;
         _loc4_ = uint(_lightFragmentConstantIndex);
         var _loc9_:int = 0;
         while(_loc9_ < _loc8_)
         {
            _loc10_ = _loc9_ ? _lightPicker.castingDirectionalLights : _lightPicker.directionalLights;
            _loc5_ = int(_loc10_.length);
            _loc7_ += _loc5_;
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc1_ = _loc10_[_loc3_];
               _loc6_ = _loc1_.sceneDirection;
               _ambientLightR += _loc1_._ambientR;
               _ambientLightG += _loc1_._ambientG;
               _ambientLightB += _loc1_._ambientB;
               var _loc12_:uint;
               _fragmentConstantData[_loc12_ = _loc4_++] = -_loc6_.x;
               var _loc13_:uint;
               _fragmentConstantData[_loc13_ = _loc4_++] = -_loc6_.y;
               var _loc14_:uint;
               _fragmentConstantData[_loc14_ = _loc4_++] = -_loc6_.z;
               var _loc15_:uint;
               _fragmentConstantData[_loc15_ = _loc4_++] = 1;
               var _loc16_:uint;
               _fragmentConstantData[_loc16_ = _loc4_++] = _loc1_._diffuseR;
               var _loc17_:uint;
               _fragmentConstantData[_loc17_ = _loc4_++] = _loc1_._diffuseG;
               var _loc18_:uint;
               _fragmentConstantData[_loc18_ = _loc4_++] = _loc1_._diffuseB;
               var _loc19_:uint;
               _fragmentConstantData[_loc19_ = _loc4_++] = 1;
               var _loc20_:uint;
               _fragmentConstantData[_loc20_ = _loc4_++] = _loc1_._specularR;
               var _loc21_:uint;
               _fragmentConstantData[_loc21_ = _loc4_++] = _loc1_._specularG;
               var _loc22_:uint;
               _fragmentConstantData[_loc22_ = _loc4_++] = _loc1_._specularB;
               var _loc23_:uint;
               _fragmentConstantData[_loc23_ = _loc4_++] = 1;
               _loc3_++;
            }
            _loc9_++;
         }
         if(_numDirectionalLights > _loc7_)
         {
            _loc3_ = _loc4_ + (_numDirectionalLights - _loc7_) * 12;
            while(_loc4_ < _loc3_)
            {
               _fragmentConstantData[_loc12_ = _loc4_++] = 0;
            }
         }
         _loc7_ = 0;
         _loc9_ = 0;
         while(_loc9_ < _loc8_)
         {
            _loc11_ = _loc9_ ? _lightPicker.castingPointLights : _lightPicker.pointLights;
            _loc5_ = int(_loc11_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc2_ = _loc11_[_loc3_];
               _loc6_ = _loc2_.scenePosition;
               _ambientLightR += _loc2_._ambientR;
               _ambientLightG += _loc2_._ambientG;
               _ambientLightB += _loc2_._ambientB;
               _fragmentConstantData[_loc12_ = _loc4_++] = _loc6_.x;
               _fragmentConstantData[_loc13_ = _loc4_++] = _loc6_.y;
               _fragmentConstantData[_loc14_ = _loc4_++] = _loc6_.z;
               _fragmentConstantData[_loc15_ = _loc4_++] = 1;
               _fragmentConstantData[_loc16_ = _loc4_++] = _loc2_._diffuseR;
               _fragmentConstantData[_loc17_ = _loc4_++] = _loc2_._diffuseG;
               _fragmentConstantData[_loc18_ = _loc4_++] = _loc2_._diffuseB;
               _fragmentConstantData[_loc19_ = _loc4_++] = _loc2_._radius * _loc2_._radius;
               _fragmentConstantData[_loc20_ = _loc4_++] = _loc2_._specularR;
               _fragmentConstantData[_loc21_ = _loc4_++] = _loc2_._specularG;
               _fragmentConstantData[_loc22_ = _loc4_++] = _loc2_._specularB;
               _fragmentConstantData[_loc23_ = _loc4_++] = _loc2_._fallOffFactor;
               _loc3_++;
            }
            _loc9_++;
         }
         if(_numPointLights > _loc7_)
         {
            _loc3_ = _loc4_ + (_loc7_ - _numPointLights) * 12;
            while(_loc4_ < _loc3_)
            {
               _fragmentConstantData[_loc4_] = 0;
               _loc4_++;
            }
         }
      }
      
      override protected function updateProbes(param1:Stage3DProxy) : void
      {
         var _loc2_:LightProbe = null;
         var _loc3_:Vector.<LightProbe> = _lightPicker.lightProbes;
         var _loc4_:Vector.<Number> = _lightPicker.lightProbeWeights;
         var _loc5_:int = int(_loc3_.length);
         var _loc6_:Boolean = this.usesProbesForDiffuse();
         var _loc7_:Boolean = Boolean(_methodSetup._specularMethod && this.usesProbesForSpecular());
         var _loc8_:Context3D = param1._context3D;
         if(!(_loc6_ || _loc7_))
         {
            return;
         }
         var _loc9_:uint = 0;
         while(_loc9_ < _loc5_)
         {
            _loc2_ = _loc3_[_loc9_];
            if(_loc6_)
            {
               _loc8_.setTextureAt(_lightProbeDiffuseIndices[_loc9_],_loc2_.diffuseMap.getTextureForStage3D(param1));
            }
            if(_loc7_)
            {
               _loc8_.setTextureAt(_lightProbeSpecularIndices[_loc9_],_loc2_.specularMap.getTextureForStage3D(param1));
            }
            _loc9_++;
         }
         _fragmentConstantData[_probeWeightsIndex] = _loc4_[0];
         _fragmentConstantData[_probeWeightsIndex + 1] = _loc4_[1];
         _fragmentConstantData[_probeWeightsIndex + 2] = _loc4_[2];
         _fragmentConstantData[_probeWeightsIndex + 3] = _loc4_[3];
      }
      
      arcane function set ignoreLights(param1:Boolean) : void
      {
         this._ignoreLights = param1;
      }
      
      arcane function get ignoreLights() : Boolean
      {
         return this._ignoreLights;
      }
   }
}

