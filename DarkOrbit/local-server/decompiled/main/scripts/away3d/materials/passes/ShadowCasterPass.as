package away3d.materials.passes
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.lights.DirectionalLight;
   import away3d.lights.PointLight;
   import away3d.materials.MaterialBase;
   import away3d.materials.compilation.LightingShaderCompiler;
   import away3d.materials.compilation.ShaderCompiler;
   import flash.geom.Matrix3D;
   import flash.geom.Vector3D;
   
   use namespace arcane;
   
   public class ShadowCasterPass extends CompiledPass
   {
      
      private var _tangentSpace:Boolean;
      
      private var _lightVertexConstantIndex:int;
      
      private var _inverseSceneMatrix:Vector.<Number> = new Vector.<Number>();
      
      public function ShadowCasterPass(param1:MaterialBase)
      {
         super(param1);
      }
      
      override protected function createCompiler(param1:String) : ShaderCompiler
      {
         return new LightingShaderCompiler(param1);
      }
      
      override protected function updateLights() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.updateLights();
         if(_lightPicker)
         {
            _loc1_ = _lightPicker.numCastingPointLights > 0 ? 1 : 0;
            _loc2_ = _lightPicker.numCastingDirectionalLights > 0 ? 1 : 0;
         }
         else
         {
            _loc1_ = 0;
            _loc2_ = 0;
         }
         _numLightProbes = 0;
         if(_loc1_ + _loc2_ > 1)
         {
            throw new Error("Must have exactly one light!");
         }
         if(_loc1_ != _numPointLights || _loc2_ != _numDirectionalLights)
         {
            _numPointLights = _loc1_;
            _numDirectionalLights = _loc2_;
            invalidateShaderProgram();
         }
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
      
      override protected function updateLightConstants() : void
      {
         var _loc1_:DirectionalLight = null;
         var _loc2_:PointLight = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector3D = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         _loc4_ = uint(this._lightVertexConstantIndex);
         _loc3_ = uint(_lightFragmentConstantIndex);
         if(_numDirectionalLights > 0)
         {
            _loc1_ = _lightPicker.castingDirectionalLights[0];
            _loc5_ = _loc1_.sceneDirection;
            _ambientLightR += _loc1_._ambientR;
            _ambientLightG += _loc1_._ambientG;
            _ambientLightB += _loc1_._ambientB;
            if(this._tangentSpace)
            {
               _loc6_ = -_loc5_.x;
               _loc7_ = -_loc5_.y;
               _loc8_ = -_loc5_.z;
               var _loc9_:uint;
               _vertexConstantData[_loc9_ = _loc4_++] = this._inverseSceneMatrix[0] * _loc6_ + this._inverseSceneMatrix[4] * _loc7_ + this._inverseSceneMatrix[8] * _loc8_;
               var _loc10_:uint;
               _vertexConstantData[_loc10_ = _loc4_++] = this._inverseSceneMatrix[1] * _loc6_ + this._inverseSceneMatrix[5] * _loc7_ + this._inverseSceneMatrix[9] * _loc8_;
               var _loc11_:uint;
               _vertexConstantData[_loc11_ = _loc4_++] = this._inverseSceneMatrix[2] * _loc6_ + this._inverseSceneMatrix[6] * _loc7_ + this._inverseSceneMatrix[10] * _loc8_;
               var _loc12_:uint;
               _vertexConstantData[_loc12_ = _loc4_++] = 1;
            }
            else
            {
               _fragmentConstantData[_loc9_ = _loc3_++] = -_loc5_.x;
               _fragmentConstantData[_loc10_ = _loc3_++] = -_loc5_.y;
               _fragmentConstantData[_loc11_ = _loc3_++] = -_loc5_.z;
               _fragmentConstantData[_loc12_ = _loc3_++] = 1;
            }
            _fragmentConstantData[_loc9_ = _loc3_++] = _loc1_._diffuseR;
            _fragmentConstantData[_loc10_ = _loc3_++] = _loc1_._diffuseG;
            _fragmentConstantData[_loc11_ = _loc3_++] = _loc1_._diffuseB;
            _fragmentConstantData[_loc12_ = _loc3_++] = 1;
            var _loc13_:uint;
            _fragmentConstantData[_loc13_ = _loc3_++] = _loc1_._specularR;
            var _loc14_:uint;
            _fragmentConstantData[_loc14_ = _loc3_++] = _loc1_._specularG;
            var _loc15_:uint;
            _fragmentConstantData[_loc15_ = _loc3_++] = _loc1_._specularB;
            var _loc16_:uint;
            _fragmentConstantData[_loc16_ = _loc3_++] = 1;
            return;
         }
         if(_numPointLights > 0)
         {
            _loc2_ = _lightPicker.castingPointLights[0];
            _loc5_ = _loc2_.scenePosition;
            _ambientLightR += _loc2_._ambientR;
            _ambientLightG += _loc2_._ambientG;
            _ambientLightB += _loc2_._ambientB;
            if(this._tangentSpace)
            {
               _loc6_ = _loc5_.x;
               _loc7_ = _loc5_.y;
               _loc8_ = _loc5_.z;
               _vertexConstantData[_loc9_ = _loc4_++] = this._inverseSceneMatrix[0] * _loc6_ + this._inverseSceneMatrix[4] * _loc7_ + this._inverseSceneMatrix[8] * _loc8_ + this._inverseSceneMatrix[12];
               _vertexConstantData[_loc10_ = _loc4_++] = this._inverseSceneMatrix[1] * _loc6_ + this._inverseSceneMatrix[5] * _loc7_ + this._inverseSceneMatrix[9] * _loc8_ + this._inverseSceneMatrix[13];
               _vertexConstantData[_loc11_ = _loc4_++] = this._inverseSceneMatrix[2] * _loc6_ + this._inverseSceneMatrix[6] * _loc7_ + this._inverseSceneMatrix[10] * _loc8_ + this._inverseSceneMatrix[14];
            }
            else
            {
               _vertexConstantData[_loc9_ = _loc4_++] = _loc5_.x;
               _vertexConstantData[_loc10_ = _loc4_++] = _loc5_.y;
               _vertexConstantData[_loc11_ = _loc4_++] = _loc5_.z;
            }
            _vertexConstantData[_loc9_ = _loc4_++] = 1;
            _fragmentConstantData[_loc10_ = _loc3_++] = _loc2_._diffuseR;
            _fragmentConstantData[_loc11_ = _loc3_++] = _loc2_._diffuseG;
            _fragmentConstantData[_loc12_ = _loc3_++] = _loc2_._diffuseB;
            _fragmentConstantData[_loc13_ = _loc3_++] = _loc2_._radius * _loc2_._radius;
            _fragmentConstantData[_loc14_ = _loc3_++] = _loc2_._specularR;
            _fragmentConstantData[_loc15_ = _loc3_++] = _loc2_._specularG;
            _fragmentConstantData[_loc16_ = _loc3_++] = _loc2_._specularB;
            var _loc17_:uint;
            _fragmentConstantData[_loc17_ = _loc3_++] = _loc2_._fallOffFactor;
         }
      }
      
      override protected function usesProbes() : Boolean
      {
         return false;
      }
      
      override protected function usesLights() : Boolean
      {
         return true;
      }
      
      override protected function updateProbes(param1:Stage3DProxy) : void
      {
      }
   }
}

