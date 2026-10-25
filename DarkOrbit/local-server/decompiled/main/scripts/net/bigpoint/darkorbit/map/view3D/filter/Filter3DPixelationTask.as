package net.bigpoint.darkorbit.map.view3D.filter
{
   import away3d.cameras.Camera3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.filters.tasks.Filter3DTaskBase;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.textures.Texture;
   import net.bigpoint.darkorbit.map.view3D.utils.AgalHelper;
   
   public class Filter3DPixelationTask extends Filter3DTaskBase
   {
      
      private var _pixelData:Vector.<Number>;
      
      private var _pixelSize:Number = 0;
      
      public function Filter3DPixelationTask()
      {
         super();
         this.updateConstants();
      }
      
      public function get pixelSize() : Number
      {
         return this._pixelSize;
      }
      
      public function set pixelSize(param1:Number) : void
      {
         if(this._pixelSize == param1)
         {
            return;
         }
         this._pixelSize = param1;
         this.updateConstants();
      }
      
      override protected function getFragmentCode() : String
      {
         return AgalHelper.div("ft0","v0","fc0") + AgalHelper.frc("ft1","ft0") + AgalHelper.sub("ft0","ft0","ft1") + AgalHelper.mul("ft0","ft0","fc0") + AgalHelper.texture("ft2","ft0","fs0","<2d,clamp,nearest>") + AgalHelper.mov("oc","ft2");
      }
      
      override public function activate(param1:Stage3DProxy, param2:Camera3D, param3:Texture) : void
      {
         param1.context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         param1.context3D.setDepthTest(false,Context3DCompareMode.ALWAYS);
         param1.context3D.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this._pixelData);
      }
      
      protected function updateConstants() : void
      {
         this._pixelData = Vector.<Number>([1 / 512 * this.pixelSize,1 / 512 * this.pixelSize * 1.5,8,3,0,0,0,0,0,0,0,0]);
      }
   }
}

