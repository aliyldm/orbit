package away3d.materials
{
   import away3d.arcane;
   import away3d.textures.Texture2DBase;
   import flash.display.BlendMode;
   import flash.geom.ColorTransform;
   
   use namespace arcane;
   
   public class TextureMaterial extends SinglePassMaterialBase
   {
      
      public function TextureMaterial(param1:Texture2DBase = null, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true)
      {
         super();
         this.texture = param1;
         this.smooth = param2;
         this.repeat = param3;
         this.mipmap = param4;
      }
      
      public function get animateUVs() : Boolean
      {
         return _screenPass.animateUVs;
      }
      
      public function set animateUVs(param1:Boolean) : void
      {
         _screenPass.animateUVs = param1;
      }
      
      public function get alpha() : Number
      {
         return _screenPass.colorTransform ? _screenPass.colorTransform.alphaMultiplier : 1;
      }
      
      public function set alpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         colorTransform = colorTransform || new ColorTransform();
         colorTransform.alphaMultiplier = param1;
         _screenPass.setBlendMode(blendMode == BlendMode.NORMAL && requiresBlending ? BlendMode.LAYER : blendMode);
      }
      
      public function get texture() : Texture2DBase
      {
         return _screenPass.diffuseMethod.texture;
      }
      
      public function set texture(param1:Texture2DBase) : void
      {
         _screenPass.diffuseMethod.texture = param1;
      }
      
      public function get ambientTexture() : Texture2DBase
      {
         return _screenPass.ambientMethod.texture;
      }
      
      public function set ambientTexture(param1:Texture2DBase) : void
      {
         _screenPass.ambientMethod.texture = param1;
         _screenPass.diffuseMethod.useAmbientTexture = Boolean(param1);
      }
   }
}

