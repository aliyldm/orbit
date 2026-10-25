package net.bigpoint.darkorbit.map.view3D.display3D.materials.methods
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.MethodVO;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   
   use namespace arcane;
   
   public class XRayMethod extends EffectMethodBase
   {
      
      public const DEFAULT_COLOR:uint = 16711680;
      
      public const DEFAULT_ALPHA:Number = 0.5;
      
      private var _color:uint;
      
      private var _xrayR:Number = 0;
      
      private var _xrayG:Number = 0;
      
      private var _xrayB:Number = 0;
      
      private var _xrayA:Number = 1;
      
      public function XRayMethod()
      {
         super();
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         if(this._color != param1)
         {
            this._color = param1;
            this.updateXray();
         }
      }
      
      public function get alpha() : Number
      {
         return this._xrayA;
      }
      
      public function set alpha(param1:Number) : void
      {
         this._xrayA = param1;
      }
      
      override arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
         super.arcane::setRenderState(param1,param2,param3,param4);
         this.color = param2.shaderParams ? uint(param2.shaderParams.xRayColor) || this.DEFAULT_COLOR : this.DEFAULT_COLOR;
         this.alpha = Boolean(param2.shaderParams) && param2.shaderParams.xRayAlpha != null ? Number(param2.shaderParams.xRayAlpha) : this.DEFAULT_ALPHA;
         var _loc5_:int = param1.fragmentConstantsIndex;
         var _loc6_:Vector.<Number> = param1.fragmentData;
         _loc6_[_loc5_] = this._xrayR;
         _loc6_[_loc5_ + 1] = this._xrayG;
         _loc6_[_loc5_ + 2] = this._xrayB;
         _loc6_[_loc5_ + 3] = this._xrayA;
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         super.arcane::activate(param1,param2);
         param2._context3D.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
         param2._context3D.setDepthTest(false,Context3DCompareMode.GREATER);
      }
      
      override arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
      {
         param2._context3D.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
         super.arcane::deactivate(param1,param2);
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         var _loc4_:String = "";
         var _loc5_:ShaderRegisterElement = param3;
         var _loc6_:ShaderRegisterElement = param2.getFreeFragmentConstant();
         param1.fragmentConstantsIndex = _loc6_.index * 4;
         return _loc4_ + ("mov " + _loc5_ + ", " + _loc6_ + "\n");
      }
      
      private function updateXray() : void
      {
         this._xrayR = (this._color >> 16 & 0xFF) / 255;
         this._xrayG = (this._color >> 8 & 0xFF) / 255;
         this._xrayB = (this._color & 0xFF) / 255;
      }
   }
}

