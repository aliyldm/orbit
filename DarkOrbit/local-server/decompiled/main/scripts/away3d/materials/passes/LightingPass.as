package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.lights.DirectionalLight;
   import away3d.lights.LightProbe;
   import away3d.lights.PointLight;
   import away3d.materials.LightSources;
   import away3d.materials.MaterialBase;
   import away3d.materials.compilation.LightingShaderCompiler;
   import away3d.materials.compilation.ShaderCompiler;
   import flash.display3D.Context3D;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class LightingPass extends CompiledPass
   {
      
      private var _includeCasters:Boolean = true;
      
      private var _tangentSpace:Boolean;
      
      private var _lightVertexConstantIndex:int;
      
      private var _inverseSceneMatrix:Vector.<Number> = new Vector.<Number>();
      
      private var _directionalLightsOffset:uint;
      
      private var _pointLightsOffset:uint;
      
      private var _lightProbesOffset:uint;
      
      private var _maxLights:int = 3;
      
      public function LightingPass(param1:MaterialBase)
      {
         super(param1);
      }
      
      public function get directionalLightsOffset() : uint
      {
         return this._directionalLightsOffset;
      }
      
      public function set directionalLightsOffset(param1:uint) : void
      {
         this._directionalLightsOffset = param1;
      }
      
      public function get pointLightsOffset() : uint
      {
         return this._pointLightsOffset;
      }
      
      public function set pointLightsOffset(param1:uint) : void
      {
         this._pointLightsOffset = param1;
      }
      
      public function get lightProbesOffset() : uint
      {
         return this._lightProbesOffset;
      }
      
      public function set lightProbesOffset(param1:uint) : void
      {
         this._lightProbesOffset = param1;
      }
      
      override protected function createCompiler(param1:String) : ShaderCompiler
      {
         this._maxLights = param1 == "baselineConstrained" ? 1 : 3;
         return new LightingShaderCompiler(param1);
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
      
      override protected function updateLights() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.updateLights();
         var _loc1_:int = int(_numDirectionalLights);
         _loc2_ = int(_numPointLights);
         _loc3_ = int(_numLightProbes);
         if(_lightPicker)
         {
            _numDirectionalLights = this.calculateNumDirectionalLights(_lightPicker.numDirectionalLights);
            _numPointLights = this.calculateNumPointLights(_lightPicker.numPointLights);
            _numLightProbes = this.calculateNumProbes(_lightPicker.numLightProbes);
            if(this._includeCasters)
            {
               _numPointLights += _lightPicker.numCastingPointLights;
               _numDirectionalLights += _lightPicker.numCastingDirectionalLights;
            }
         }
         else
         {
            _numDirectionalLights = 0;
            _numPointLights = 0;
            _numLightProbes = 0;
         }
         if(_loc2_ != _numPointLights || _loc1_ != _numDirectionalLights || _loc3_ != _numLightProbes)
         {
            invalidateShaderProgram();
         }
      }
      
      private function calculateNumDirectionalLights(param1:uint) : int
      {
         return Math.min(param1 - this._directionalLightsOffset,this._maxLights);
      }
      
      private function calculateNumPointLights(param1:uint) : int
      {
         var _loc2_:int = this._maxLights - _numDirectionalLights;
         return Math.min(param1 - this._pointLightsOffset,_loc2_);
      }
      
      private function calculateNumProbes(param1:uint) : int
      {
         var _loc2_:int = 0;
         if((_specularLightSources & LightSources.PROBES) != 0)
         {
            _loc2_++;
         }
         if((_diffuseLightSources & LightSources.PROBES) != 0)
         {
            _loc2_++;
         }
         return Math.min(param1 - this._lightProbesOffset,int(4 / _loc2_));
      }
      
      override protected function updateShaderProperties() : void
      {
         super.updateShaderProperties();
         this._tangentSpace = LightingShaderCompiler(_compiler).tangentSpace;
      }
      
      override protected function updateRegisterIndices() : void
      {
         super.updateRegisterIndices();
         this._lightVertexConstantIndex = LightingShaderCompiler(_compiler).lightVertexConstantIndex;
      }
      
      override arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         param1.inverseSceneTransform.copyRawDataTo(this._inverseSceneMatrix);
         if(this._tangentSpace && _cameraPositionIndex >= 0)
         {
            _loc5_ = param3.scenePosition;
            _loc6_ = _loc5_.x;
            _loc7_ = _loc5_.y;
            _loc8_ = _loc5_.z;
            _vertexConstantData[_cameraPositionIndex] = this._inverseSceneMatrix[0] * _loc6_ + this._inverseSceneMatrix[4] * _loc7_ + this._inverseSceneMatrix[8] * _loc8_ + this._inverseSceneMatrix[12];
            _vertexConstantData[_cameraPositionIndex + 1] = this._inverseSceneMatrix[1] * _loc6_ + this._inverseSceneMatrix[5] * _loc7_ + this._inverseSceneMatrix[9] * _loc8_ + this._inverseSceneMatrix[13];
            _vertexConstantData[_cameraPositionIndex + 2] = this._inverseSceneMatrix[2] * _loc6_ + this._inverseSceneMatrix[6] * _loc7_ + this._inverseSceneMatrix[10] * _loc8_ + this._inverseSceneMatrix[14];
         }
         super.arcane::render(param1,param2,param3,param4);
      }
      
      override arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         var _loc3_:Vector3D = null;
         super.arcane::activate(param1,param2);
         if(!this._tangentSpace && _cameraPositionIndex >= 0)
         {
            _loc3_ = param2.scenePosition;
            _vertexConstantData[_cameraPositionIndex] = _loc3_.x;
            _vertexConstantData[_cameraPositionIndex + 1] = _loc3_.y;
            _vertexConstantData[_cameraPositionIndex + 2] = _loc3_.z;
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
      
      override protected function updateLightConstants() : void
      {
         var _loc1_:DirectionalLight = null;
         var _loc2_:PointLight = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector3D = null;
         var _loc9_:* = 0;
         var _loc10_:int = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc7_:uint = 0;
         var _loc8_:uint = this._includeCasters ? 2 : 1;
         _loc9_ = this._lightVertexConstantIndex;
         _loc4_ = uint(_lightFragmentConstantIndex);
         var _loc11_:int = 0;
         var _loc12_:Vector.<DirectionalLight> = _lightPicker.directionalLights;
         _loc10_ = int(this._directionalLightsOffset);
         _loc5_ = int(_lightPicker.directionalLights.length);
         if(_loc10_ > _loc5_)
         {
            _loc11_ = 1;
            _loc10_ -= _loc5_;
         }
         while(_loc11_ < _loc8_)
         {
            if(_loc11_)
            {
               _loc12_ = _lightPicker.castingDirectionalLights;
            }
            _loc5_ = int(_loc12_.length);
            if(_loc5_ > _numDirectionalLights)
            {
               _loc5_ = int(_numDirectionalLights);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc1_ = _loc12_[_loc10_ + _loc3_];
               _loc6_ = _loc1_.sceneDirection;
               _ambientLightR += _loc1_._ambientR;
               _ambientLightG += _loc1_._ambientG;
               _ambientLightB += _loc1_._ambientB;
               if(this._tangentSpace)
               {
                  _loc14_ = -_loc6_.x;
                  _loc15_ = -_loc6_.y;
                  _loc16_ = -_loc6_.z;
                  var _loc18_:*;
                  _vertexConstantData[_loc18_ = _loc9_++] = this._inverseSceneMatrix[0] * _loc14_ + this._inverseSceneMatrix[4] * _loc15_ + this._inverseSceneMatrix[8] * _loc16_;
                  var _loc19_:*;
                  _vertexConstantData[_loc19_ = _loc9_++] = this._inverseSceneMatrix[1] * _loc14_ + this._inverseSceneMatrix[5] * _loc15_ + this._inverseSceneMatrix[9] * _loc16_;
                  var _loc20_:*;
                  _vertexConstantData[_loc20_ = _loc9_++] = this._inverseSceneMatrix[2] * _loc14_ + this._inverseSceneMatrix[6] * _loc15_ + this._inverseSceneMatrix[10] * _loc16_;
                  var _loc21_:*;
                  _vertexConstantData[_loc21_ = _loc9_++] = 1;
               }
               else
               {
                  _fragmentConstantData[_loc18_ = _loc4_++] = -_loc6_.x;
                  _fragmentConstantData[_loc19_ = _loc4_++] = -_loc6_.y;
                  _fragmentConstantData[_loc20_ = _loc4_++] = -_loc6_.z;
                  _fragmentConstantData[_loc21_ = _loc4_++] = 1;
               }
               _fragmentConstantData[_loc18_ = _loc4_++] = _loc1_._diffuseR;
               _fragmentConstantData[_loc19_ = _loc4_++] = _loc1_._diffuseG;
               _fragmentConstantData[_loc20_ = _loc4_++] = _loc1_._diffuseB;
               _fragmentConstantData[_loc21_ = _loc4_++] = 1;
               var _loc22_:uint;
               _fragmentConstantData[_loc22_ = _loc4_++] = _loc1_._specularR;
               var _loc23_:uint;
               _fragmentConstantData[_loc23_ = _loc4_++] = _loc1_._specularG;
               var _loc24_:uint;
               _fragmentConstantData[_loc24_ = _loc4_++] = _loc1_._specularB;
               var _loc25_:uint;
               _fragmentConstantData[_loc25_ = _loc4_++] = 1;
               if(++_loc7_ == _numDirectionalLights)
               {
                  _loc3_ = uint(_loc5_);
                  _loc11_ = int(_loc8_);
               }
               _loc3_++;
            }
            _loc11_++;
         }
         if(_numDirectionalLights > _loc7_)
         {
            _loc3_ = _loc4_ + (_numDirectionalLights - _loc7_) * 12;
            while(_loc4_ < _loc3_)
            {
               _fragmentConstantData[_loc18_ = _loc4_++] = 0;
            }
         }
         _loc7_ = 0;
         var _loc13_:Vector.<PointLight> = _lightPicker.pointLights;
         _loc10_ = int(this._pointLightsOffset);
         _loc5_ = int(_lightPicker.pointLights.length);
         if(_loc10_ > _loc5_)
         {
            _loc11_ = 1;
            _loc10_ -= _loc5_;
         }
         else
         {
            _loc11_ = 0;
         }
         while(_loc11_ < _loc8_)
         {
            if(_loc11_)
            {
               _loc13_ = _lightPicker.castingPointLights;
            }
            _loc5_ = int(_loc13_.length);
            _loc3_ = 0;
            while(_loc3_ < _loc5_)
            {
               _loc2_ = _loc13_[_loc10_ + _loc3_];
               _loc6_ = _loc2_.scenePosition;
               _ambientLightR += _loc2_._ambientR;
               _ambientLightG += _loc2_._ambientG;
               _ambientLightB += _loc2_._ambientB;
               if(this._tangentSpace)
               {
                  _loc14_ = _loc6_.x;
                  _loc15_ = _loc6_.y;
                  _loc16_ = _loc6_.z;
                  _vertexConstantData[_loc18_ = _loc9_++] = this._inverseSceneMatrix[0] * _loc14_ + this._inverseSceneMatrix[4] * _loc15_ + this._inverseSceneMatrix[8] * _loc16_ + this._inverseSceneMatrix[12];
                  _vertexConstantData[_loc19_ = _loc9_++] = this._inverseSceneMatrix[1] * _loc14_ + this._inverseSceneMatrix[5] * _loc15_ + this._inverseSceneMatrix[9] * _loc16_ + this._inverseSceneMatrix[13];
                  _vertexConstantData[_loc20_ = _loc9_++] = this._inverseSceneMatrix[2] * _loc14_ + this._inverseSceneMatrix[6] * _loc15_ + this._inverseSceneMatrix[10] * _loc16_ + this._inverseSceneMatrix[14];
               }
               else
               {
                  _vertexConstantData[_loc18_ = _loc9_++] = _loc6_.x;
                  _vertexConstantData[_loc19_ = _loc9_++] = _loc6_.y;
                  _vertexConstantData[_loc20_ = _loc9_++] = _loc6_.z;
               }
               _vertexConstantData[_loc18_ = _loc9_++] = 1;
               _fragmentConstantData[_loc19_ = _loc4_++] = _loc2_._diffuseR;
               _fragmentConstantData[_loc20_ = _loc4_++] = _loc2_._diffuseG;
               _fragmentConstantData[_loc21_ = _loc4_++] = _loc2_._diffuseB;
               _loc17_ = _loc2_._radius;
               _fragmentConstantData[_loc22_ = _loc4_++] = _loc17_ * _loc17_;
               _fragmentConstantData[_loc23_ = _loc4_++] = _loc2_._specularR;
               _fragmentConstantData[_loc24_ = _loc4_++] = _loc2_._specularG;
               _fragmentConstantData[_loc25_ = _loc4_++] = _loc2_._specularB;
               var _loc26_:uint;
               _fragmentConstantData[_loc26_ = _loc4_++] = _loc2_._fallOffFactor;
               if(++_loc7_ == _numPointLights)
               {
                  _loc3_ = uint(_loc5_);
                  _loc11_ = int(_loc8_);
               }
               _loc3_++;
            }
            _loc11_++;
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
         var _loc3_:LightProbe = null;
         var _loc2_:Context3D = param1._context3D;
         var _loc4_:Vector.<LightProbe> = _lightPicker.lightProbes;
         var _loc5_:Vector.<Number> = _lightPicker.lightProbeWeights;
         var _loc6_:int = _loc4_.length - this._lightProbesOffset;
         var _loc7_:Boolean = this.usesProbesForDiffuse();
         var _loc8_:Boolean = Boolean(_methodSetup._specularMethod && this.usesProbesForSpecular());
         if(!(_loc7_ || _loc8_))
         {
            return;
         }
         if(_loc6_ > _numLightProbes)
         {
            _loc6_ = int(_numLightProbes);
         }
         var _loc9_:uint = 0;
         while(_loc9_ < _loc6_)
         {
            _loc3_ = _loc4_[this._lightProbesOffset + _loc9_];
            if(_loc7_)
            {
               _loc2_.setTextureAt(_lightProbeDiffuseIndices[_loc9_],_loc3_.diffuseMap.getTextureForStage3D(param1));
            }
            if(_loc8_)
            {
               _loc2_.setTextureAt(_lightProbeSpecularIndices[_loc9_],_loc3_.specularMap.getTextureForStage3D(param1));
            }
            _loc9_++;
         }
         _loc9_ = 0;
         while(_loc9_ < _loc6_)
         {
            _fragmentConstantData[_probeWeightsIndex + _loc9_] = _loc5_[this._lightProbesOffset + _loc9_];
            _loc9_++;
         }
      }
   }
}

