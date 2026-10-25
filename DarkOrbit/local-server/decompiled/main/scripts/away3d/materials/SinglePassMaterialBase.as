package away3d.materials
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.lightpickers.LightPickerBase;
   import away3d.materials.methods.BasicAmbientMethod;
   import away3d.materials.methods.BasicDiffuseMethod;
   import away3d.materials.methods.BasicNormalMethod;
   import away3d.materials.methods.BasicSpecularMethod;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.ShadowMapMethodBase;
   import away3d.materials.passes.SuperShaderPass;
   import away3d.textures.Texture2DBase;
   import flash.display.BlendMode;
   import flash.display3D.Context3D;
   import flash.geom.ColorTransform;
   
   use namespace arcane;
   
   public class SinglePassMaterialBase extends MaterialBase
   {
      
      protected var _screenPass:SuperShaderPass;
      
      private var _alphaBlending:Boolean;
      
      public function SinglePassMaterialBase()
      {
         super();
         addPass(this._screenPass = new SuperShaderPass(this));
      }
      
      public function get enableLightFallOff() : Boolean
      {
         return this._screenPass.enableLightFallOff;
      }
      
      public function set enableLightFallOff(param1:Boolean) : void
      {
         this._screenPass.enableLightFallOff = param1;
      }
      
      public function get alphaThreshold() : Number
      {
         return this._screenPass.diffuseMethod.alphaThreshold;
      }
      
      public function set alphaThreshold(param1:Number) : void
      {
         this._screenPass.diffuseMethod.alphaThreshold = param1;
         _depthPass.alphaThreshold = param1;
         _distancePass.alphaThreshold = param1;
      }
      
      override public function set blendMode(param1:String) : void
      {
         super.blendMode = param1;
         this._screenPass.setBlendMode(blendMode == BlendMode.NORMAL && this.requiresBlending ? BlendMode.LAYER : blendMode);
      }
      
      override public function set depthCompareMode(param1:String) : void
      {
         super.depthCompareMode = param1;
         this._screenPass.depthCompareMode = param1;
      }
      
      override arcane function activateForDepth(param1:Stage3DProxy, param2:Camera3D, param3:Boolean = false) : void
      {
         if(param3)
         {
            _distancePass.alphaMask = this._screenPass.diffuseMethod.texture;
         }
         else
         {
            _depthPass.alphaMask = this._screenPass.diffuseMethod.texture;
         }
         super.arcane::activateForDepth(param1,param2,param3);
      }
      
      public function get specularLightSources() : uint
      {
         return this._screenPass.specularLightSources;
      }
      
      public function set specularLightSources(param1:uint) : void
      {
         this._screenPass.specularLightSources = param1;
      }
      
      public function get diffuseLightSources() : uint
      {
         return this._screenPass.diffuseLightSources;
      }
      
      public function set diffuseLightSources(param1:uint) : void
      {
         this._screenPass.diffuseLightSources = param1;
      }
      
      override public function get requiresBlending() : Boolean
      {
         return super.requiresBlending || this._alphaBlending || Boolean(this._screenPass.colorTransform) && this._screenPass.colorTransform.alphaMultiplier < 1;
      }
      
      public function get colorTransform() : ColorTransform
      {
         return this._screenPass.colorTransform;
      }
      
      public function set colorTransform(param1:ColorTransform) : void
      {
         this._screenPass.colorTransform = param1;
      }
      
      public function get ambientMethod() : BasicAmbientMethod
      {
         return this._screenPass.ambientMethod;
      }
      
      public function set ambientMethod(param1:BasicAmbientMethod) : void
      {
         this._screenPass.ambientMethod = param1;
      }
      
      public function get shadowMethod() : ShadowMapMethodBase
      {
         return this._screenPass.shadowMethod;
      }
      
      public function set shadowMethod(param1:ShadowMapMethodBase) : void
      {
         this._screenPass.shadowMethod = param1;
      }
      
      public function get diffuseMethod() : BasicDiffuseMethod
      {
         return this._screenPass.diffuseMethod;
      }
      
      public function set diffuseMethod(param1:BasicDiffuseMethod) : void
      {
         this._screenPass.diffuseMethod = param1;
      }
      
      public function get normalMethod() : BasicNormalMethod
      {
         return this._screenPass.normalMethod;
      }
      
      public function set normalMethod(param1:BasicNormalMethod) : void
      {
         this._screenPass.normalMethod = param1;
      }
      
      public function get specularMethod() : BasicSpecularMethod
      {
         return this._screenPass.specularMethod;
      }
      
      public function set specularMethod(param1:BasicSpecularMethod) : void
      {
         this._screenPass.specularMethod = param1;
      }
      
      public function addMethod(param1:EffectMethodBase) : void
      {
         this._screenPass.addMethod(param1);
      }
      
      public function get numMethods() : int
      {
         return this._screenPass.numMethods;
      }
      
      public function hasMethod(param1:EffectMethodBase) : Boolean
      {
         return this._screenPass.hasMethod(param1);
      }
      
      public function getMethodAt(param1:int) : EffectMethodBase
      {
         return this._screenPass.getMethodAt(param1);
      }
      
      public function addMethodAt(param1:EffectMethodBase, param2:int) : void
      {
         this._screenPass.addMethodAt(param1,param2);
      }
      
      public function removeMethod(param1:EffectMethodBase) : void
      {
         this._screenPass.removeMethod(param1);
      }
      
      override public function set mipmap(param1:Boolean) : void
      {
         if(_mipmap == param1)
         {
            return;
         }
         super.mipmap = param1;
      }
      
      public function get normalMap() : Texture2DBase
      {
         return this._screenPass.normalMap;
      }
      
      public function set normalMap(param1:Texture2DBase) : void
      {
         this._screenPass.normalMap = param1;
      }
      
      public function get specularMap() : Texture2DBase
      {
         return this._screenPass.specularMethod.texture;
      }
      
      public function set specularMap(param1:Texture2DBase) : void
      {
         if(this._screenPass.specularMethod)
         {
            this._screenPass.specularMethod.texture = param1;
            return;
         }
         throw new Error("No specular method was set to assign the specularGlossMap to");
      }
      
      public function get gloss() : Number
      {
         return this._screenPass.specularMethod ? this._screenPass.specularMethod.gloss : 0;
      }
      
      public function set gloss(param1:Number) : void
      {
         if(this._screenPass.specularMethod)
         {
            this._screenPass.specularMethod.gloss = param1;
         }
      }
      
      public function get ambient() : Number
      {
         return this._screenPass.ambientMethod.ambient;
      }
      
      public function set ambient(param1:Number) : void
      {
         this._screenPass.ambientMethod.ambient = param1;
      }
      
      public function get specular() : Number
      {
         return this._screenPass.specularMethod ? this._screenPass.specularMethod.specular : 0;
      }
      
      public function set specular(param1:Number) : void
      {
         if(this._screenPass.specularMethod)
         {
            this._screenPass.specularMethod.specular = param1;
         }
      }
      
      public function get ambientColor() : uint
      {
         return this._screenPass.ambientMethod.ambientColor;
      }
      
      public function set ambientColor(param1:uint) : void
      {
         this._screenPass.ambientMethod.ambientColor = param1;
      }
      
      public function get specularColor() : uint
      {
         return this._screenPass.specularMethod.specularColor;
      }
      
      public function set specularColor(param1:uint) : void
      {
         this._screenPass.specularMethod.specularColor = param1;
      }
      
      public function get alphaBlending() : Boolean
      {
         return this._alphaBlending;
      }
      
      public function set alphaBlending(param1:Boolean) : void
      {
         this._alphaBlending = param1;
         this._screenPass.setBlendMode(blendMode == BlendMode.NORMAL && this.requiresBlending ? BlendMode.LAYER : blendMode);
         this._screenPass.preserveAlpha = this.requiresBlending;
      }
      
      override arcane function updateMaterial(param1:Context3D) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(this._screenPass._passesDirty)
         {
            clearPasses();
            if(this._screenPass._passes)
            {
               _loc2_ = this._screenPass._passes.length;
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  addPass(this._screenPass._passes[_loc3_]);
                  _loc3_++;
               }
            }
            addPass(this._screenPass);
            this._screenPass._passesDirty = false;
         }
      }
      
      override public function set lightPicker(param1:LightPickerBase) : void
      {
         super.lightPicker = param1;
         this._screenPass.lightPicker = param1;
      }
   }
}

