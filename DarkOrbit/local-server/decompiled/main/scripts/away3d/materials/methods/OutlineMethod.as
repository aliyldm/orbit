package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.methods.attributeInterface.IAlphaMethod;
   import away3d.materials.passes.MaterialPassBase;
   import away3d.materials.passes.OutlinePass;
   
   use namespace arcane;
   
   public class OutlineMethod extends EffectMethodBase implements IAlphaMethod
   {
      
      private var _outlinePass:OutlinePass;
      
      public function OutlineMethod(param1:uint = 0, param2:Number = 1, param3:Boolean = true, param4:Boolean = false)
      {
         super();
         _passes = new Vector.<MaterialPassBase>();
         this._outlinePass = new OutlinePass(param1,param2,param3,param4);
         _passes.push(this._outlinePass);
      }
      
      override arcane function initVO(param1:MethodVO) : void
      {
         param1.needsNormals = true;
      }
      
      public function get showInnerLines() : Boolean
      {
         return this._outlinePass.showInnerLines;
      }
      
      public function set showInnerLines(param1:Boolean) : void
      {
         this._outlinePass.showInnerLines = param1;
      }
      
      public function get outlineColor() : uint
      {
         return this._outlinePass.outlineColor;
      }
      
      public function set outlineColor(param1:uint) : void
      {
         this._outlinePass.outlineColor = param1;
      }
      
      public function get outlineSize() : Number
      {
         return this._outlinePass.outlineSize;
      }
      
      public function set outlineSize(param1:Number) : void
      {
         this._outlinePass.outlineSize = param1;
      }
      
      override arcane function reset() : void
      {
         super.arcane::reset();
      }
      
      override arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
      }
      
      override arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         return "";
      }
      
      public function set alpha(param1:Number) : void
      {
         this._outlinePass.alpha = param1;
      }
   }
}

