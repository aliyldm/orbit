package away3d.materials
{
   import away3d.arcane;
   import away3d.textures.Texture2DBase;
   
   use namespace arcane;
   
   public class TextureMultiPassMaterial extends MultiPassMaterialBase
   {
      
      private var _animateUVs:Boolean;
      
      public function TextureMultiPassMaterial(param1:Texture2DBase = null, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true)
      {
         super();
         this.texture = param1;
         this.smooth = param2;
         this.repeat = param3;
         this.mipmap = param4;
      }
      
      public function get animateUVs() : Boolean
      {
         return this._animateUVs;
      }
      
      public function set animateUVs(param1:Boolean) : void
      {
         this._animateUVs = param1;
         invalidateScreenPasses();
      }
      
      public function get texture() : Texture2DBase
      {
         return diffuseMethod.texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         diffuseMethod.texture = param1;
      }
      
      public function get ambientTexture() : Texture2DBase
      {
         return ambientMethod.texture;
      }
      
      public function set ambientTexture(param1:Texture2DBase) : void
      {
         ambientMethod.texture = param1;
         diffuseMethod.useAmbientTexture = Boolean(param1);
      }
      
      override protected function updateScreenPasses() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.updateScreenPasses();
         if(Boolean(_effectsPass) && numLights == 0)
         {
            _effectsPass.animateUVs = this._animateUVs;
         }
         if(_casterLightPass)
         {
            _casterLightPass.animateUVs = this._animateUVs;
         }
         if(_nonCasterLightPasses)
         {
            _loc1_ = _nonCasterLightPasses.length;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _nonCasterLightPasses[_loc2_].animateUVs = this._animateUVs;
               _loc2_++;
            }
         }
      }
   }
}

