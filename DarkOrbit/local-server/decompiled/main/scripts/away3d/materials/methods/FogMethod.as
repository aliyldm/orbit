package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class FogMethod extends EffectMethodBase
   {
      
      private var _minDistance:Number = 0;
      
      private var _maxDistance:Number = 1000;
      
      private var _fogColor:uint;
      
      private var _fogR:Number;
      
      private var _fogG:Number;
      
      private var _fogB:Number;
      
      public function FogMethod(param1:Number, param2:Number, param3:uint = 8421504)
      {
         super();
         this.minDistance = param1;
         this.maxDistance = param2;
         this.fogColor = param3;
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsProjection = true;
      }
      
      override arcane function initConstants(param1:MethodVO) : void
      {
         var _loc2_:Vector.<Number> = param1.fragmentData;
         var _loc3_:int = param1.fragmentConstantsIndex;
         _loc2_[_loc3_ + 3] = 1;
         _loc2_[_loc3_ + 6] = 0;
         _loc2_[_loc3_ + 7] = 0;
      }
      
      public function get minDistance() : Number
      {
         return this._minDistance;
      }
      
      public function set minDistance(param1:Number) : void
      {
         this._minDistance = param1;
      }
      
      public function get maxDistance() : Number
      {
         return this._maxDistance;
      }
      
      public function set maxDistance(param1:Number) : void
      {
         this._maxDistance = param1;
      }
      
      public function get fogColor() : uint
      {
         return this._fogColor;
      }
      
      public function set fogColor(param1:uint) : void
      {
         this._fogColor = param1;
         this._fogR = (param1 >> 16 & 0xFF) / 255;
         this._fogG = (param1 >> 8 & 0xFF) / 255;
         this._fogB = (param1 & 0xFF) / 255;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:Vector.<Number> = param1.fragmentData;
         var _loc4_:int = param1.fragmentConstantsIndex;
         _loc3_[_loc4_] = this._fogR;
         _loc3_[_loc4_ + 1] = this._fogG;
         _loc3_[_loc4_ + 2] = this._fogB;
         _loc3_[_loc4_ + 4] = this._minDistance;
         _loc3_[_loc4_ + 5] = 1 / (this._maxDistance - this._minDistance);
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         param2.addFragmentTempUsages(_loc6_,1);
         var _loc7_:ShaderRegisterElement = param2.getFreeFragmentVectorTemp();
         var _loc8_:String = "";
         param1.fragmentConstantsIndex = _loc4_.index * 4;
         _loc8_ += "sub " + _loc7_ + ".w, " + _sharedRegisters.projectionFragment + ".z, " + _loc5_ + ".x          \n" + "mul " + _loc7_ + ".w, " + _loc7_ + ".w, " + _loc5_ + ".y\t\t\t\t\t\n" + "sat " + _loc7_ + ".w, " + _loc7_ + ".w\t\t\t\t\t\t\t\t\t\t\n" + "sub " + _loc6_ + ", " + _loc4_ + ", " + param3 + "\n" + "mul " + _loc6_ + ", " + _loc6_ + ", " + _loc7_ + ".w\t\t\t\t\t\n" + "add " + param3 + ", " + param3 + ", " + _loc6_ + "\n";
         param2.removeFragmentTempUsage(_loc6_);
         return _loc8_;
      }
   }
}

