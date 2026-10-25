package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class LightingMethodBase extends ShadingMethodBase
   {
      
      arcane var _modulateMethod:Function;
      
      public function LightingMethodBase()
      {
         super();
      }
      
      arcane function getFragmentPreLightingCode(param1:MethodVO, param2:ShaderRegisterCache) : String
      {
         return "";
      }
      
      arcane function getFragmentCodePerLight(param1:MethodVO, param2:ShaderRegisterElement, param3:ShaderRegisterElement, param4:ShaderRegisterCache) : String
      {
         return "";
      }
      
      arcane function getFragmentCodePerProbe(param1:MethodVO, param2:ShaderRegisterElement, param3:String, param4:ShaderRegisterCache) : String
      {
         return "";
      }
      
      arcane function getFragmentPostLightingCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         return "";
      }
   }
}

