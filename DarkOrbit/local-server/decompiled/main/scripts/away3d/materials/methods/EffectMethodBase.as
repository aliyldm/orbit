package away3d.materials.methods
{
   import away3d.arcane;
   import away3d.errors.AbstractMethodError;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.materials.compilation.ShaderRegisterCache;
   import away3d.materials.compilation.ShaderRegisterElement;
   
   use namespace arcane;
   
   public class EffectMethodBase extends ShadingMethodBase implements IAsset
   {
      
      public function EffectMethodBase()
      {
         super();
      }
      
      public function get assetType() : String
      {
         return AssetType.EFFECTS_METHOD;
      }
      
      arcane function getFragmentCode(param1:MethodVO, param2:ShaderRegisterCache, param3:ShaderRegisterElement) : String
      {
         throw new AbstractMethodError();
      }
   }
}

