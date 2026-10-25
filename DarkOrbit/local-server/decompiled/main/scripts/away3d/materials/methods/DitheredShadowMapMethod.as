package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.lights.DirectionalLight;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.BitmapTexture;
   import flash.display.BitmapData;
   
   use namespace arcane;
   
   public class DitheredShadowMapMethod extends SimpleShadowMapMethodBase
   {
      
      private static var _grainTexture:BitmapTexture;
      
      private static var _grainUsages:int;
      
      private static var _grainBitmapData:BitmapData;
      
      private var _depthMapSize:int;
      
      private var _range:Number = 1;
      
      private var _numSamples:int;
      
      public function DitheredShadowMapMethod(param1:DirectionalLight, param2:int = 4)
      {
         super(param1);
         this._depthMapSize = _castingLight.shadowMapper.depthMapSize;
         this.numSamples = param2;
         ++_grainUsages;
         if(!_grainTexture)
         {
            this.initGrainTexture();
         }
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
         else if(this._numSamples > 24)
         {
            this._numSamples = 24;
         }
         invalidateShaderProgram();
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         super.arcane::initVO(param1);
         param1.needsProjection = true;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         super.arcane::initConstants(param1);
         var _loc2_:Vector.<Number> = param1.fragmentData;
         var _loc3_:int = param1.fragmentConstantsIndex;
         _loc2_[_loc3_ + 8] = 1 / this._numSamples;
      }
      
      public function get range() : Number
      {
         return this._range * 2;
      }
      
      public function set range(param1:Number) : void
      {
         this._range = param1 / 2;
      }
      
      private function initGrainTexture() : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         _grainBitmapData = new BitmapData(64,64,false);
         var _loc1_:Vector.<uint> = new Vector.<uint>();
         var _loc2_:uint = 4096;
         var _loc3_:Number = 1 / (this._depthMapSize * this._range);
         var _loc6_:uint = 0;
         while(_loc6_ < _loc2_)
         {
            _loc4_ = 2 * (Math.random() - 0.5);
            _loc5_ = 2 * (Math.random() - 0.5);
            if(_loc4_ < 0)
            {
               _loc4_ -= _loc3_;
            }
            else
            {
               _loc4_ += _loc3_;
            }
            if(_loc5_ < 0)
            {
               _loc5_ -= _loc3_;
            }
            else
            {
               _loc5_ += _loc3_;
            }
            if(_loc4_ > 1)
            {
               _loc4_ = 1;
            }
            else if(_loc4_ < -1)
            {
               _loc4_ = -1;
            }
            if(_loc5_ > 1)
            {
               _loc5_ = 1;
            }
            else if(_loc5_ < -1)
            {
               _loc5_ = -1;
            }
            _loc1_[_loc6_] = int((_loc4_ * 0.5 + 0.5) * 255) << 16 | int((_loc5_ * 0.5 + 0.5) * 255) << 8;
            _loc6_++;
         }
         _grainBitmapData.setVector(_grainBitmapData.rect,_loc1_);
         _grainTexture = new BitmapTexture(_grainBitmapData);
      }
      
      override public function dispose() : void
      {
         if(--_grainUsages == 0)
         {
            _grainTexture.dispose();
            _grainBitmapData.dispose();
            _grainTexture = null;
         }
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:uint = uint(param1.fragmentConstantsIndex);
         _loc3_[_loc4_ + 9] = (param2.width - 1) / 63;
         _loc3_[_loc4_ + 10] = (param2.height - 1) / 63;
         _loc3_[_loc4_ + 11] = 2 * this._range / this._depthMapSize;
         param2._context3D.setTextureAt(param1.texturesIndex + 1,_grainTexture.getTextureForStage3D(param2));
      }
      
      override protected function getPlanarFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = param2.getFreeTextureReg();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc5_.index * 4;
         param1.texturesIndex = _loc4_.index;
         return this.getSampleCode(param2,_loc7_,_loc4_,_loc5_,param3);
      }
      
      private function getSampleCode(param1:ShaderRegisterCache, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterElement) : String
      {
         var _loc6_:String = "";
         var _loc7_:ShaderRegisterElement = param1.getFreeTextureReg();
         var _loc8_:ShaderRegisterElement = param1.getFreeFragmentVectorTemp();
         var _loc9_:int = this._numSamples;
         param1.addFragmentTempUsages(_loc8_,1);
         var _loc10_:ShaderRegisterElement = param1.getFreeFragmentVectorTemp();
         var _loc11_:ShaderRegisterElement = _sharedRegisters.projectionFragment;
         _loc6_ += "div " + _loc8_ + ", " + _loc11_ + ", " + _loc11_ + ".w\n" + "mul " + _loc8_ + ".xy, " + _loc8_ + ".xy, " + param2 + ".yz\n";
         while(_loc9_ > 0)
         {
            if(_loc9_ == this._numSamples)
            {
               _loc6_ += "tex " + _loc8_ + ", " + _loc8_ + ", " + _loc7_ + " <2d,nearest,repeat,mipnone>\n";
            }
            else
            {
               _loc6_ += "tex " + _loc8_ + ", " + _loc8_ + ".zwxy, " + _loc7_ + " <2d,nearest,repeat,mipnone>\n";
            }
            _loc6_ += "sub " + _loc8_ + ".zw, " + _loc8_ + ".xy, fc0.xx\n" + "mul " + _loc8_ + ".zw, " + _loc8_ + ".zw, " + param2 + ".w\n";
            if(_loc9_ == this._numSamples)
            {
               _loc6_ += "add " + _loc8_ + ".xy, " + _loc8_ + ".zw, " + _depthMapCoordReg + ".xy\n" + "tex " + _loc10_ + ", " + _loc8_ + ", " + param3 + " <2d,nearest,clamp,mipnone>\n" + "dp4 " + _loc10_ + ".z, " + _loc10_ + ", " + param4 + "\n" + "slt " + param5 + ".w, " + _depthMapCoordReg + ".z, " + _loc10_ + ".z\n";
            }
            else
            {
               _loc6_ += this.addSample(_loc8_,param3,param4,param5,param1);
            }
            if(_loc9_ > 4)
            {
               _loc6_ += "add " + _loc8_ + ".xy, " + _loc8_ + ".xy, " + _loc8_ + ".zw\n" + this.addSample(_loc8_,param3,param4,param5,param1);
            }
            if(_loc9_ > 1)
            {
               _loc6_ += "sub " + _loc8_ + ".xy, " + _depthMapCoordReg + ".xy, " + _loc8_ + ".zw\n" + this.addSample(_loc8_,param3,param4,param5,param1);
            }
            if(_loc9_ > 5)
            {
               _loc6_ += "sub " + _loc8_ + ".xy, " + _loc8_ + ".xy, " + _loc8_ + ".zw\n" + this.addSample(_loc8_,param3,param4,param5,param1);
            }
            if(_loc9_ > 2)
            {
               _loc6_ += "neg " + _loc8_ + ".w, " + _loc8_ + ".w\n";
               _loc6_ = _loc6_ + ("add " + _loc8_ + ".xy, " + _loc8_ + ".wz, " + _depthMapCoordReg + ".xy\n" + this.addSample(_loc8_,param3,param4,param5,param1));
            }
            if(_loc9_ > 6)
            {
               _loc6_ += "add " + _loc8_ + ".xy, " + _loc8_ + ".xy, " + _loc8_ + ".wz\n" + this.addSample(_loc8_,param3,param4,param5,param1);
            }
            if(_loc9_ > 3)
            {
               _loc6_ += "sub " + _loc8_ + ".xy, " + _depthMapCoordReg + ".xy, " + _loc8_ + ".wz\n" + this.addSample(_loc8_,param3,param4,param5,param1);
            }
            if(_loc9_ > 7)
            {
               _loc6_ += "sub " + _loc8_ + ".xy, " + _loc8_ + ".xy, " + _loc8_ + ".wz\n" + this.addSample(_loc8_,param3,param4,param5,param1);
            }
            _loc9_ -= 8;
         }
         param1.removeFragmentTempUsage(_loc8_);
         return _loc6_ + ("mul " + param5 + ".w, " + param5 + ".w, " + param2 + ".x\n");
      }
      
      private function addSample(param1:ShaderRegisterElement, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterCache) : String
      {
         var _loc6_:ShaderRegisterElement = param5.getFreeFragmentVectorTemp();
         return "tex " + _loc6_ + ", " + param1 + ", " + param2 + " <2d,nearest,clamp,mipnone>\n" + "dp4 " + _loc6_ + ".z, " + _loc6_ + ", " + param3 + "\n" + "slt " + _loc6_ + ".z, " + _depthMapCoordReg + ".z, " + _loc6_ + ".z\n" + "add " + param4 + ".w, " + param4 + ".w, " + _loc6_ + ".z\n";
      }
      
      override arcane function activateForCascade(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:uint = uint(param1.secondaryFragmentConstantsIndex);
         _loc3_[_loc4_] = 1 / this._numSamples;
         _loc3_[_loc4_ + 1] = (param2.width - 1) / 63;
         _loc3_[_loc4_ + 2] = (param2.height - 1) / 63;
         _loc3_[_loc4_ + 3] = 2 * this._range / this._depthMapSize;
         param2._context3D.setTextureAt(param1.texturesIndex + 1,_grainTexture.getTextureForStage3D(param2));
      }
      
      override arcane function getCascadeFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement, param4:ShaderRegisterElement, param5:ShaderRegisterElement, param6:ShaderRegisterElement) : String
      {
         _depthMapCoordReg = param5;
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.secondaryFragmentConstantsIndex = _loc7_.index * 4;
         return this.getSampleCode(param2,_loc7_,param4,param3,param6);
      }
   }
}

