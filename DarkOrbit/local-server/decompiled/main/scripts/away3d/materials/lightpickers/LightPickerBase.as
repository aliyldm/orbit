package away3d.materials.lightpickers
{
   import away3d.*;
   import away3d.core.base.*;
   import away3d.core.traverse.*;
   import away3d.library.assets.*;
   import away3d.lights.*;
   import flash.geom.*;
   
   use namespace arcane;
   
   public class LightPickerBase extends NamedAssetBase implements IAsset
   {
      
      protected var _numPointLights:uint;
      
      protected var _numDirectionalLights:uint;
      
      protected var _numCastingPointLights:uint;
      
      protected var _numCastingDirectionalLights:uint;
      
      protected var _numLightProbes:uint;
      
      protected var _allPickedLights:Vector.<LightBase>;
      
      protected var _pointLights:Vector.<PointLight>;
      
      protected var _castingPointLights:Vector.<PointLight>;
      
      protected var _directionalLights:Vector.<DirectionalLight>;
      
      protected var _castingDirectionalLights:Vector.<DirectionalLight>;
      
      protected var _lightProbes:Vector.<LightProbe>;
      
      protected var _lightProbeWeights:Vector.<Number>;
      
      public function LightPickerBase()
      {
         super();
      }
      
      public function dispose() : void
      {
      }
      
      public function get assetType() : String
      {
         return AssetType.LIGHT_PICKER;
      }
      
      public function get numDirectionalLights() : uint
      {
         return this._numDirectionalLights;
      }
      
      public function get numPointLights() : uint
      {
         return this._numPointLights;
      }
      
      public function get numCastingDirectionalLights() : uint
      {
         return this._numCastingDirectionalLights;
      }
      
      public function get numCastingPointLights() : uint
      {
         return this._numCastingPointLights;
      }
      
      public function get numLightProbes() : uint
      {
         return this._numLightProbes;
      }
      
      public function get pointLights() : Vector.<PointLight>
      {
         return this._pointLights;
      }
      
      public function get directionalLights() : Vector.<DirectionalLight>
      {
         return this._directionalLights;
      }
      
      public function get castingPointLights() : Vector.<PointLight>
      {
         return this._castingPointLights;
      }
      
      public function get castingDirectionalLights() : Vector.<DirectionalLight>
      {
         return this._castingDirectionalLights;
      }
      
      public function get lightProbes() : Vector.<LightProbe>
      {
         return this._lightProbes;
      }
      
      public function get lightProbeWeights() : Vector.<Number>
      {
         return this._lightProbeWeights;
      }
      
      public function get allPickedLights() : Vector.<LightBase>
      {
         return this._allPickedLights;
      }
      
      public function collectLights(param1:IRenderable, param2:EntityCollector) : void
      {
         this.updateProbeWeights(param1);
      }
      
      private function updateProbeWeights(param1:IRenderable) : void
      {
         var _loc3_:Vector3D = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc12_:int = 0;
         var _loc2_:Vector3D = param1.sourceEntity.scenePosition;
         var _loc4_:Number = _loc2_.x;
         var _loc5_:Number = _loc2_.y;
         var _loc6_:Number = _loc2_.z;
         var _loc11_:Number = 0;
         _loc12_ = 0;
         while(_loc12_ < this._numLightProbes)
         {
            _loc3_ = this._lightProbes[_loc12_].scenePosition;
            _loc7_ = _loc4_ - _loc3_.x;
            _loc8_ = _loc5_ - _loc3_.y;
            _loc9_ = _loc6_ - _loc3_.z;
            _loc10_ = _loc7_ * _loc7_ + _loc8_ * _loc8_ + _loc9_ * _loc9_;
            _loc10_ = _loc10_ > 0.00001 ? 1 / _loc10_ : 50000000;
            this._lightProbeWeights[_loc12_] = _loc10_;
            _loc11_ += _loc10_;
            _loc12_++;
         }
         _loc11_ = 1 / _loc11_;
         _loc12_ = 0;
         while(_loc12_ < this._numLightProbes)
         {
            this._lightProbeWeights[_loc12_] *= _loc11_;
            _loc12_++;
         }
      }
   }
}

