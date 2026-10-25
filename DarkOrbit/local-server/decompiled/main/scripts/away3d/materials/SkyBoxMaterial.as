package away3d.materials
{
   import away3d.arcane;
   import away3d.materials.passes.SkyBoxPass;
   import away3d.textures.CubeTextureBase;
   
   use namespace arcane;
   
   public class SkyBoxMaterial extends MaterialBase
   {
      
      private var _cubeMap:CubeTextureBase;
      
      private var _skyboxPass:SkyBoxPass;
      
      public function SkyBoxMaterial(param1:CubeTextureBase)
      {
         super();
         this._cubeMap = param1;
         addPass(this._skyboxPass = new SkyBoxPass());
         this._skyboxPass.cubeTexture = this._cubeMap;
      }
      
      public function get cubeMap() : CubeTextureBase
      {
         return this._cubeMap;
      }
      
      public function set cubeMap(param1:CubeTextureBase) : void
      {
         if(Boolean(param1) && Boolean(this._cubeMap) && (param1.hasMipMaps != this._cubeMap.hasMipMaps || param1.format != this._cubeMap.format))
         {
            invalidatePasses(null);
         }
         this._cubeMap = param1;
         this._skyboxPass.cubeTexture = this._cubeMap;
      }
   }
}

