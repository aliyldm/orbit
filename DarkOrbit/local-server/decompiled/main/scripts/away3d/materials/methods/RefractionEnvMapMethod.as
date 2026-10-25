package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.textures.CubeTextureBase;
   
   use namespace arcane;
   
   public class RefractionEnvMapMethod extends EffectMethodBase
   {
      
      private var _envMap:CubeTextureBase;
      
      private var _dispersionR:Number = 0;
      
      private var _dispersionG:Number = 0;
      
      private var _dispersionB:Number = 0;
      
      private var _useDispersion:Boolean;
      
      private var _refractionIndex:Number;
      
      private var _alpha:Number = 1;
      
      public function RefractionEnvMapMethod(param1:CubeTextureBase, param2:Number = 0.1, param3:Number = 0, param4:Number = 0, param5:Number = 0)
      {
         super();
         this._envMap = param1;
         this._dispersionR = param3;
         this._dispersionG = param4;
         this._dispersionB = param5;
         this._useDispersion = !(this._dispersionR == this._dispersionB && this._dispersionR == this._dispersionG);
         this._refractionIndex = param2;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:int = param1.fragmentConstantsIndex;
         var _loc3_:Vector.<Number> = param1.fragmentData;
         _loc3_[_loc2_ + 4] = 1;
         _loc3_[_loc2_ + 5] = 0;
         _loc3_[_loc2_ + 7] = 1;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsNormals = true;
         param1.needsView = true;
      }
      
      public function get envMap() : CubeTextureBase
      {
         return this._envMap;
      }
      
      public function set envMap(param1:CubeTextureBase) : void
      {
         this._envMap = param1;
      }
      
      public function get refractionIndex() : Number
      {
         return this._refractionIndex;
      }
      
      public function set refractionIndex(param1:Number) : void
      {
         this._refractionIndex = param1;
      }
      
      public function get dispersionR() : Number
      {
         return this._dispersionR;
      }
      
      public function set dispersionR(param1:Number) : void
      {
         this._dispersionR = param1;
         var _loc2_:Boolean = !(this._dispersionR == this._dispersionB && this._dispersionR == this._dispersionG);
         if(this._useDispersion != _loc2_)
         {
            invalidateShaderProgram();
            this._useDispersion = _loc2_;
         }
      }
      
      public function get dispersionG() : Number
      {
         return this._dispersionG;
      }
      
      public function set dispersionG(param1:Number) : void
      {
         this._dispersionG = param1;
         var _loc2_:Boolean = !(this._dispersionR == this._dispersionB && this._dispersionR == this._dispersionG);
         if(this._useDispersion != _loc2_)
         {
            invalidateShaderProgram();
            this._useDispersion = _loc2_;
         }
      }
      
      public function get dispersionB() : Number
      {
         return this._dispersionB;
      }
      
      public function set dispersionB(param1:Number) : void
      {
         this._dispersionB = param1;
         var _loc2_:Boolean = !(this._dispersionR == this._dispersionB && this._dispersionR == this._dispersionG);
         if(this._useDispersion != _loc2_)
         {
            invalidateShaderProgram();
            this._useDispersion = _loc2_;
         }
      }
      
      public function get alpha() : Number
      {
         return this._alpha;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._alpha = param1;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:int = param1.fragmentConstantsIndex;
         var _loc4_:Vector.<Number> = param1.fragmentData;
         _loc4_[_loc3_] = this._dispersionR + this._refractionIndex;
         if(this._useDispersion)
         {
            _loc4_[_loc3_ + 1] = this._dispersionG + this._refractionIndex;
            _loc4_[_loc3_ + 2] = this._dispersionB + this._refractionIndex;
         }
         _loc4_[_loc3_ + 3] = this._alpha;
         param2._context3D.setTextureAt(param1.texturesIndex,this._envMap.getTextureForStage3D(param2));
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc8_:ShaderRegisterElement = null;
         var _loc9_:ShaderRegisterElement = null;
         var _loc10_:ShaderRegisterElement = null;
         var _loc4_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:String = "";
         var _loc7_:ShaderRegisterElement = param2.getFreeTextureReg();
         param1.texturesIndex = _loc7_.index;
         param1.fragmentConstantsIndex = _loc4_.index * 4;
         _loc8_ = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc8_,1);
         _loc9_ = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc9_,1);
         _loc10_ = param2.getFreeFragmentVectorTemp();
         var _loc11_:ShaderRegisterElement = _sharedRegisters.viewDirFragment;
         var _loc12_:ShaderRegisterElement = _sharedRegisters.normalFragment;
         _loc6_ += "neg " + _loc11_ + ".xyz, " + _loc11_ + ".xyz\n";
         _loc6_ = _loc6_ + ("dp3 " + _loc10_ + ".x, " + _loc11_ + ".xyz, " + _loc12_ + ".xyz\n" + "mul " + _loc10_ + ".w, " + _loc10_ + ".x, " + _loc10_ + ".x\n" + "sub " + _loc10_ + ".w, " + _loc5_ + ".x, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".w, " + _loc4_ + ".x, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".w, " + _loc4_ + ".x, " + _loc10_ + ".w\n" + "sub " + _loc10_ + ".w, " + _loc5_ + ".x, " + _loc10_ + ".w\n" + "sqt " + _loc10_ + ".y, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".x, " + _loc4_ + ".x, " + _loc10_ + ".x\n" + "add " + _loc10_ + ".x, " + _loc10_ + ".x, " + _loc10_ + ".y\n" + "mul " + _loc10_ + ".xyz, " + _loc10_ + ".x, " + _loc12_ + ".xyz\n" + "mul " + _loc8_ + ", " + _loc4_ + ".x, " + _loc11_ + "\n" + "sub " + _loc8_ + ".xyz, " + _loc8_ + ".xyz, " + _loc10_ + ".xyz\n" + "nrm " + _loc8_ + ".xyz, " + _loc8_ + ".xyz\n");
         _loc6_ = _loc6_ + (getTexCubeSampleCode(param1,_loc9_,_loc7_,this._envMap,_loc8_) + "sub " + _loc9_ + ".w, " + _loc9_ + ".w, fc0.x\t\n" + "kil " + _loc9_ + ".w\n");
         if(this._useDispersion)
         {
            _loc6_ += "dp3 " + _loc10_ + ".x, " + _loc11_ + ".xyz, " + _loc12_ + ".xyz\n" + "mul " + _loc10_ + ".w, " + _loc10_ + ".x, " + _loc10_ + ".x\n" + "sub " + _loc10_ + ".w, " + _loc5_ + ".x, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".w, " + _loc4_ + ".y, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".w, " + _loc4_ + ".y, " + _loc10_ + ".w\n" + "sub " + _loc10_ + ".w, " + _loc5_ + ".x, " + _loc10_ + ".w\n" + "sqt " + _loc10_ + ".y, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".x, " + _loc4_ + ".y, " + _loc10_ + ".x\n" + "add " + _loc10_ + ".x, " + _loc10_ + ".x, " + _loc10_ + ".y\n" + "mul " + _loc10_ + ".xyz, " + _loc10_ + ".x, " + _loc12_ + ".xyz\n" + "mul " + _loc8_ + ", " + _loc4_ + ".y, " + _loc11_ + "\n" + "sub " + _loc8_ + ".xyz, " + _loc8_ + ".xyz, " + _loc10_ + ".xyz\n" + "nrm " + _loc8_ + ".xyz, " + _loc8_ + ".xyz\n";
            _loc6_ = _loc6_ + (getTexCubeSampleCode(param1,_loc10_,_loc7_,this._envMap,_loc8_) + "mov " + _loc9_ + ".y, " + _loc10_ + ".y\n");
            _loc6_ = _loc6_ + ("dp3 " + _loc10_ + ".x, " + _loc11_ + ".xyz, " + _loc12_ + ".xyz\n" + "mul " + _loc10_ + ".w, " + _loc10_ + ".x, " + _loc10_ + ".x\n" + "sub " + _loc10_ + ".w, " + _loc5_ + ".x, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".w, " + _loc4_ + ".z, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".w, " + _loc4_ + ".z, " + _loc10_ + ".w\n" + "sub " + _loc10_ + ".w, " + _loc5_ + ".x, " + _loc10_ + ".w\n" + "sqt " + _loc10_ + ".y, " + _loc10_ + ".w\n" + "mul " + _loc10_ + ".x, " + _loc4_ + ".z, " + _loc10_ + ".x\n" + "add " + _loc10_ + ".x, " + _loc10_ + ".x, " + _loc10_ + ".y\n" + "mul " + _loc10_ + ".xyz, " + _loc10_ + ".x, " + _loc12_ + ".xyz\n" + "mul " + _loc8_ + ", " + _loc4_ + ".z, " + _loc11_ + "\n" + "sub " + _loc8_ + ".xyz, " + _loc8_ + ".xyz, " + _loc10_ + ".xyz\n" + "nrm " + _loc8_ + ".xyz, " + _loc8_ + ".xyz\n");
            _loc6_ = _loc6_ + (getTexCubeSampleCode(param1,_loc10_,_loc7_,this._envMap,_loc8_) + "mov " + _loc9_ + ".z, " + _loc10_ + ".z\n");
         }
         param2.removeFragmentTempUsage(_loc8_);
         _loc6_ += "sub " + _loc9_ + ".xyz, " + _loc9_ + ".xyz, " + param3 + ".xyz\n" + "mul " + _loc9_ + ".xyz, " + _loc9_ + ".xyz, " + _loc4_ + ".w\n" + "add " + param3 + ".xyz, " + param3 + ".xyz, " + _loc9_ + ".xyz\n";
         param2.removeFragmentTempUsage(_loc9_);
         return _loc6_ + ("neg " + _loc11_ + ".xyz, " + _loc11_ + ".xyz\n");
      }
   }
}

