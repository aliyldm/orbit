package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.math.PoissonLookup;
   import away3d.lights.DirectionalLight;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class SoftShadowMapMethod extends SimpleShadowMapMethodBase
   {
      
      private var _range:Number = 1;
      
      private var _numSamples:int;
      
      private var _offsets:Vector.<Number>;
      
      public function SoftShadowMapMethod(param1:DirectionalLight, param2:int = 5, param3:Number = 1)
      {
         super(param1);
         this.numSamples = param2;
         this.range = param3;
      }
      
      public function get numSamples() : int
      {
         return this._numSamples;
      }
      
      public function set numSamples(param1:int) : void
      {
         this._numSamples = param1;
         if(this._numSamples < 1)
         {
            this._numSamples = 1;
         }
         else if(this._numSamples > 32)
         {
            this._numSamples = 32;
         }
         this._offsets = PoissonLookup.getDistribution(this._numSamples);
         invalidateShaderProgram();
      }
      
      public function get range() : Number
      {
         return this._range;
      }
      
      public function set range(param1:Number) : void
      {
         this._range = param1;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         super.arcane::initConstants(param1);
         param1.fragmentData[param1.fragmentConstantsIndex + 8] = 1 / this._numSamples;
         param1.fragmentData[param1.fragmentConstantsIndex + 9] = 0;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:Number = 0.5 * this._range / _castingLight.shadowMapper.depthMapSize;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         var _loc5_:uint = param1.fragmentConstantsIndex + 10;
         var _loc6_:uint = uint(this._numSamples << 1);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_[uint(_loc5_ + _loc7_)] = this._offsets[_loc7_] * _loc3_;
            _loc7_++;
         }
      }
      
      override protected function getPlanarFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc5_.index * 4;
         param1.texturesIndex = _loc4_.index;
         return this.getSampleCode(param2,_loc4_,_loc5_,param3,_loc7_);
      }
      
      private function addSample(param1:ShaderRegisterElement, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterCache) : String
      {
         var _loc6_:ShaderRegisterElement = param5.getFreeFragmentVectorTemp();
         return "tex " + _loc6_ + ", " + param1 + ", " + param2 + " <2d,nearest,clamp>\n" + "dp4 " + _loc6_ + ".z, " + _loc6_ + ", " + param3 + "\n" + "slt " + param1 + ".w, " + _depthMapCoordReg + ".z, " + _loc6_ + ".z\n" + "add " + param4 + ".w, " + param4 + ".w, " + param1 + ".w\n";
      }
      
      override arcane function activateForCascade(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:Number = this._range / _castingLight.shadowMapper.depthMapSize;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         var _loc5_:uint = uint(param1.secondaryFragmentConstantsIndex);
         var _loc6_:uint = uint(this._numSamples << 1);
         _loc4_[_loc5_] = 1 / this._numSamples;
         _loc4_[uint(_loc5_ + 1)] = 0;
         _loc5_ += 2;
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc4_[uint(_loc5_ + _loc7_)] = this._offsets[_loc7_] * _loc3_;
            _loc7_++;
         }
         if(_loc6_ % 4 == 0)
         {
            _loc4_[uint(_loc5_ + _loc6_)] = 0;
            _loc4_[uint(_loc5_ + _loc6_ + 1)] = 0;
         }
      }
      
      override arcane function getCascadeFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterElement, param6:ShaderRegisterElement) : String
      {
         _depthMapCoordReg = param5;
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = _loc7_.index * 4;
         return this.getSampleCode(param2,param4,param3,param6,_loc7_);
      }
      
      private function getSampleCode(param1:ShaderRegisterCache, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterElement) : String
      {
         var _loc6_:ShaderRegisterElement = null;
         var _loc7_:String = null;
         var _loc12_:ShaderRegisterElement = null;
         var _loc8_:Vector.<String> = new <String>[param5 + ".zw"];
         _loc6_ = param1.getFreeFragmentVectorTemp();
         param1.addFragmentTempUsages(_loc6_,1);
         var _loc9_:ShaderRegisterElement = param1.getFreeFragmentVectorTemp();
         var _loc10_:int = this._numSamples >> 1;
         var _loc11_:int = 0;
         while(_loc11_ < _loc10_)
         {
            _loc12_ = param1.getFreeFragmentConstant();
            _loc8_.push(_loc12_ + ".xy");
            _loc8_.push(_loc12_ + ".zw");
            _loc11_++;
         }
         _loc11_ = 0;
         while(_loc11_ < this._numSamples)
         {
            if(_loc11_ == 0)
            {
               _loc7_ = "add " + _loc6_ + ", " + _depthMapCoordReg + ", " + param5 + ".zwyy\n";
               _loc7_ = _loc7_ + ("tex " + _loc9_ + ", " + _loc6_ + ", " + param2 + " <2d,nearest,clamp>\n" + "dp4 " + _loc9_ + ".z, " + _loc9_ + ", " + param3 + "\n" + "slt " + param4 + ".w, " + _depthMapCoordReg + ".z, " + _loc9_ + ".z\n");
            }
            else
            {
               _loc7_ += "add " + _loc6_ + ".xy, " + _depthMapCoordReg + ".xy, " + _loc8_[_loc11_] + "\n";
               _loc7_ = _loc7_ + this.addSample(_loc6_,param2,param3,param4,param1);
            }
            _loc11_++;
         }
         param1.removeFragmentTempUsage(_loc6_);
         return _loc7_ + ("mul " + param4 + ".w, " + param4 + ".w, " + param5 + ".x\n");
      }
   }
}

