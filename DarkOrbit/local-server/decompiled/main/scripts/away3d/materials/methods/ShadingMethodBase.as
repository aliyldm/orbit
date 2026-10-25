package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.events.ShadingMethodEvent;
   import away3d.library.assets.NamedAssetBase;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterData;
   import away3d.materials.compilation.ShaderRegisterElement;
   import away3d.materials.passes.MaterialPassBase;
   import away3d.textures.TextureProxyBase;
   import flash.display3D.Context3DTextureFormat;
   
   use namespace arcane;
   
   public class ShadingMethodBase extends NamedAssetBase
   {
      
      protected var _sharedRegisters:ShaderRegisterData;
      
      protected var _passes:Vector.<MaterialPassBase>;
      
      public function ShadingMethodBase()
      {
         super();
      }
      
      arcane function initVO(param1:MethodVO) : void
      {
      }
      
      arcane function initConstants(param1:MethodVO) : void
      {
      }
      
      arcane function get sharedRegisters() : ShaderRegisterData
      {
         return this._sharedRegisters;
      }
      
      arcane function set sharedRegisters(param1:ShaderRegisterData) : void
      {
         this._sharedRegisters = param1;
      }
      
      public function get passes() : Vector.<MaterialPassBase>
      {
         return this._passes;
      }
      
      public function dispose() : void
      {
      }
      
      arcane function createMethodVO() : MethodVO
      {
         return new MethodVO();
      }
      
      arcane function reset() : void
      {
         this.cleanCompilationData();
      }
      
      arcane function cleanCompilationData() : void
      {
      }
      
      arcane function getVertexCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return "";
      }
      
      arcane function activate(param1:MethodVO, param2:Stage3DProxy) : void
      {
      }
      
      arcane function setRenderState(param1:MethodVO, param2:IRenderable, param3:Stage3DProxy, param4:Camera3D) : void
      {
      }
      
      arcane function deactivate(param1:MethodVO, param2:Stage3DProxy) : void
      {
      }
      
      protected function getTex2DSampleCode(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:TextureProxyBase, param5:ShaderRegisterElement = null, param6:String = null) : String
      {
         var _loc8_:String = null;
         var _loc7_:String = param6 || (param1.repeatTextures ? "wrap" : "clamp");
         var _loc9_:String = this.getFormatStringForTexture(param4);
         var _loc10_:Boolean = param1.useMipmapping && param4.hasMipMaps;
         if(param1.useSmoothTextures)
         {
            _loc8_ = _loc10_ ? "linear,miplinear" : "linear";
         }
         else
         {
            _loc8_ = _loc10_ ? "nearest,mipnearest" : "nearest";
         }
         param5 ||= this._sharedRegisters.uvVarying;
         return "tex " + param2 + ", " + param5 + ", " + param3 + " <2d," + _loc8_ + "," + _loc9_ + _loc7_ + ">\n";
      }
      
      protected function getTexCubeSampleCode(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:TextureProxyBase, param5:ShaderRegisterElement) : String
      {
         var _loc6_:String = null;
         var _loc7_:String = this.getFormatStringForTexture(param4);
         var _loc8_:Boolean = param1.useMipmapping && param4.hasMipMaps;
         if(param1.useSmoothTextures)
         {
            _loc6_ = _loc8_ ? "linear,miplinear" : "linear";
         }
         else
         {
            _loc6_ = _loc8_ ? "nearest,mipnearest" : "nearest";
         }
         return "tex " + param2 + ", " + param5 + ", " + param3 + " <cube," + _loc7_ + _loc6_ + ">\n";
      }
      
      private function getFormatStringForTexture(param1:TextureProxyBase) : String
      {
         switch(param1.format)
         {
            case Context3DTextureFormat.COMPRESSED:
               return "dxt1,";
            case "compressedAlpha":
               return "dxt5,";
            default:
               return "";
         }
      }
      
      protected function invalidateShaderProgram() : void
      {
         dispatchEvent(new ShadingMethodEvent(ShadingMethodEvent.SHADER_INVALIDATED));
      }
      
      public function copyFrom(param1:ShadingMethodBase) : void
      {
      }
   }
}

