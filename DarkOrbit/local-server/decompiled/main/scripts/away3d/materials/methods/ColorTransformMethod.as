package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import flash.geom.ColorTransform;
   
   use namespace arcane;
   
   public class ColorTransformMethod extends EffectMethodBase
   {
      
      private var _colorTransform:ColorTransform;
      
      public function ColorTransformMethod()
      {
         super();
      }
      
      public function get colorTransform() : ColorTransform
      {
         return this._colorTransform;
      }
      
      public function set colorTransform(param1:ColorTransform) : void
      {
         this._colorTransform = param1;
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc6_:ShaderRegisterElement = null;
         var _loc4_:String = "";
         var _loc5_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         _loc6_ = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc5_.index * 4;
         return _loc4_ + ("mul " + param3 + ", " + param3.toString() + ", " + _loc5_ + "\n" + "add " + param3 + ", " + param3.toString() + ", " + _loc6_ + "\n");
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         var _loc3_:Number = 1 / 255;
         var _loc4_:int = param1.fragmentConstantsIndex;
         var _loc5_:Vector.<Number> = param1.fragmentData;
         _loc5_[_loc4_] = this._colorTransform.redMultiplier;
         _loc5_[_loc4_ + 1] = this._colorTransform.greenMultiplier;
         _loc5_[_loc4_ + 2] = this._colorTransform.blueMultiplier;
         _loc5_[_loc4_ + 3] = this._colorTransform.alphaMultiplier;
         _loc5_[_loc4_ + 4] = this._colorTransform.redOffset * _loc3_;
         _loc5_[_loc4_ + 5] = this._colorTransform.greenOffset * _loc3_;
         _loc5_[_loc4_ + 6] = this._colorTransform.blueOffset * _loc3_;
         _loc5_[_loc4_ + 7] = this._colorTransform.alphaOffset * _loc3_;
      }
   }
}

