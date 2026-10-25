package away3d.materials
{
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.managers.Stage3DProxy;
   import away3d.materials.lightpickers.LightPickerBase;
   import away3d.materials.lightpickers.StaticLightPicker;
   import away3d.materials.methods.BasicAmbientMethod;
   import away3d.materials.methods.BasicDiffuseMethod;
   import away3d.materials.methods.BasicNormalMethod;
   import away3d.materials.methods.BasicSpecularMethod;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.ShadowMapMethodBase;
   import away3d.materials.passes.CompiledPass;
   import away3d.materials.passes.LightingPass;
   import away3d.materials.passes.ShadowCasterPass;
   import away3d.materials.passes.SuperShaderPass;
   import away3d.textures.Texture2DBase;
   import flash.display.BlendMode;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.events.Event;
   
   use namespace arcane;
   
   public class MultiPassMaterialBase extends MaterialBase
   {
      
      protected var _casterLightPass:ShadowCasterPass;
      
      protected var _nonCasterLightPasses:Vector.<LightingPass>;
      
      protected var _effectsPass:SuperShaderPass;
      
      protected var _prePass:SuperShaderPass;
      
      private var _alphaThreshold:Number = 0;
      
      private var _specularLightSources:uint = 1;
      
      private var _diffuseLightSources:uint = 3;
      
      private var _ambientMethod:BasicAmbientMethod = new BasicAmbientMethod();
      
      private var _shadowMethod:ShadowMapMethodBase;
      
      private var _diffuseMethod:BasicDiffuseMethod = new BasicDiffuseMethod();
      
      private var _normalMethod:BasicNormalMethod = new BasicNormalMethod();
      
      private var _specularMethod:BasicSpecularMethod = new BasicSpecularMethod();
      
      private var _screenPassesInvalid:Boolean = true;
      
      private var _enableLightFallOff:Boolean = true;
      
      public function MultiPassMaterialBase()
      {
         super();
      }
      
      public function get enableLightFallOff() : Boolean
      {
         return this._enableLightFallOff;
      }
      
      public function set enableLightFallOff(param1:Boolean) : void
      {
         if(this._enableLightFallOff != param1)
         {
            this.invalidateScreenPasses();
         }
         this._enableLightFallOff = param1;
      }
      
      public function get alphaThreshold() : Number
      {
         return this._alphaThreshold;
      }
      
      public function set alphaThreshold(param1:Number) : void
      {
         this._alphaThreshold = param1;
         this._diffuseMethod.alphaThreshold = param1;
         _depthPass.alphaThreshold = param1;
         _distancePass.alphaThreshold = param1;
      }
      
      override public function set depthCompareMode(param1:String) : void
      {
         super.depthCompareMode = param1;
         this.invalidateScreenPasses();
      }
      
      override public function set blendMode(param1:String) : void
      {
         super.blendMode = param1;
         this.invalidateScreenPasses();
      }
      
      override arcane function activateForDepth(param1:Stage3DProxy, param2:Camera3D, param3:Boolean = false) : void
      {
         if(param3)
         {
            _distancePass.alphaMask = this._diffuseMethod.texture;
         }
         else
         {
            _depthPass.alphaMask = this._diffuseMethod.texture;
         }
         super.arcane::activateForDepth(param1,param2,param3);
      }
      
      public function get specularLightSources() : uint
      {
         return this._specularLightSources;
      }
      
      public function set specularLightSources(param1:uint) : void
      {
         this._specularLightSources = param1;
      }
      
      public function get diffuseLightSources() : uint
      {
         return this._diffuseLightSources;
      }
      
      public function set diffuseLightSources(param1:uint) : void
      {
         this._diffuseLightSources = param1;
      }
      
      override public function set lightPicker(param1:LightPickerBase) : void
      {
         if(_lightPicker)
         {
            _lightPicker.removeEventListener(Event.CHANGE,this.onLightsChange);
         }
         super.lightPicker = param1;
         if(_lightPicker)
         {
            _lightPicker.addEventListener(Event.CHANGE,this.onLightsChange);
         }
         this.invalidateScreenPasses();
      }
      
      override public function get requiresBlending() : Boolean
      {
         return false;
      }
      
      public function get ambientMethod() : BasicAmbientMethod
      {
         return this._ambientMethod;
      }
      
      public function set ambientMethod(param1:BasicAmbientMethod) : void
      {
         param1.copyFrom(this._ambientMethod);
         this._ambientMethod = param1;
         this.invalidateScreenPasses();
      }
      
      public function get shadowMethod() : ShadowMapMethodBase
      {
         return this._shadowMethod;
      }
      
      public function set shadowMethod(param1:ShadowMapMethodBase) : void
      {
         if(Boolean(param1) && Boolean(this._shadowMethod))
         {
            param1.copyFrom(this._shadowMethod);
         }
         this._shadowMethod = param1;
         this.invalidateScreenPasses();
      }
      
      public function get diffuseMethod() : BasicDiffuseMethod
      {
         return this._diffuseMethod;
      }
      
      public function set diffuseMethod(param1:BasicDiffuseMethod) : void
      {
         param1.copyFrom(this._diffuseMethod);
         this._diffuseMethod = param1;
         this.invalidateScreenPasses();
      }
      
      public function get specularMethod() : BasicSpecularMethod
      {
         return this._specularMethod;
      }
      
      public function set specularMethod(param1:BasicSpecularMethod) : void
      {
         if(Boolean(param1) && Boolean(this._specularMethod))
         {
            param1.copyFrom(this._specularMethod);
         }
         this._specularMethod = param1;
         this.invalidateScreenPasses();
      }
      
      public function get normalMethod() : BasicNormalMethod
      {
         return this._normalMethod;
      }
      
      public function set normalMethod(param1:BasicNormalMethod) : void
      {
         param1.copyFrom(this._normalMethod);
         this._normalMethod = param1;
         this.invalidateScreenPasses();
      }
      
      public function addPrePassMethod(param1:EffectMethodBase) : void
      {
         this._prePass = this._prePass || new SuperShaderPass(this);
         this._prePass.addMethod(param1);
         this.invalidateScreenPasses();
      }
      
      public function addMethod(param1:EffectMethodBase) : void
      {
         this._effectsPass = this._effectsPass || new SuperShaderPass(this);
         this._effectsPass.addMethod(param1);
         this.invalidateScreenPasses();
      }
      
      public function get numMethods() : int
      {
         return this._effectsPass ? this._effectsPass.numMethods : 0;
      }
      
      public function hasMethod(param1:EffectMethodBase) : Boolean
      {
         return this._effectsPass ? this._effectsPass.hasMethod(param1) : false;
      }
      
      public function getMethodAt(param1:int) : EffectMethodBase
      {
         return this._effectsPass.getMethodAt(param1);
      }
      
      public function addMethodAt(param1:EffectMethodBase, param2:int) : void
      {
         this._effectsPass = this._effectsPass || new SuperShaderPass(this);
         this._effectsPass.addMethodAt(param1,param2);
         this.invalidateScreenPasses();
      }
      
      public function removeMethod(param1:EffectMethodBase) : void
      {
         if(!this._effectsPass)
         {
            return;
         }
         this._effectsPass.removeMethod(param1);
         if(this._effectsPass.numMethods == 0)
         {
            this.invalidateScreenPasses();
         }
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
         return this._normalMethod.normalMap;
      }
      
      public function set normalMap(param1:Texture2DBase) : void
      {
         this._normalMethod.normalMap = param1;
      }
      
      public function get specularMap() : Texture2DBase
      {
         return this._specularMethod.texture;
      }
      
      public function set specularMap(param1:Texture2DBase) : void
      {
         if(this._specularMethod)
         {
            this._specularMethod.texture = param1;
            return;
         }
         throw new Error("No specular method was set to assign the specularGlossMap to");
      }
      
      public function get gloss() : Number
      {
         return this._specularMethod ? this._specularMethod.gloss : 0;
      }
      
      public function set gloss(param1:Number) : void
      {
         if(this._specularMethod)
         {
            this._specularMethod.gloss = param1;
         }
      }
      
      public function get ambient() : Number
      {
         return this._ambientMethod.ambient;
      }
      
      public function set ambient(param1:Number) : void
      {
         this._ambientMethod.ambient = param1;
      }
      
      public function get specular() : Number
      {
         return this._specularMethod ? this._specularMethod.specular : 0;
      }
      
      public function set specular(param1:Number) : void
      {
         if(this._specularMethod)
         {
            this._specularMethod.specular = param1;
         }
      }
      
      public function get ambientColor() : uint
      {
         return this._ambientMethod.ambientColor;
      }
      
      public function set ambientColor(param1:uint) : void
      {
         this._ambientMethod.ambientColor = param1;
      }
      
      public function get specularColor() : uint
      {
         return this._specularMethod.specularColor;
      }
      
      public function set specularColor(param1:uint) : void
      {
         this._specularMethod.specularColor = param1;
      }
      
      override arcane function updateMaterial(param1:Context3D) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         if(this._screenPassesInvalid)
         {
            this.updateScreenPasses();
            _loc2_ = true;
         }
         if(_loc2_ || this.isAnyScreenPassInvalid())
         {
            clearPasses();
            this.addChildPassesFor(this._prePass);
            this.addScreenPass(this._prePass);
            this.addChildPassesFor(this._casterLightPass);
            if(this._nonCasterLightPasses)
            {
               _loc3_ = 0;
               while(_loc3_ < this._nonCasterLightPasses.length)
               {
                  this.addChildPassesFor(this._nonCasterLightPasses[_loc3_]);
                  _loc3_++;
               }
            }
            this.addChildPassesFor(this._effectsPass);
            this.addScreenPass(this._casterLightPass);
            if(this._nonCasterLightPasses)
            {
               _loc3_ = 0;
               while(_loc3_ < this._nonCasterLightPasses.length)
               {
                  this.addScreenPass(this._nonCasterLightPasses[_loc3_]);
                  _loc3_++;
               }
            }
            this.addScreenPass(this._effectsPass);
         }
      }
      
      private function addScreenPass(param1:CompiledPass) : void
      {
         if(param1)
         {
            addPass(param1);
            param1._passesDirty = false;
         }
      }
      
      private function isAnyScreenPassInvalid() : Boolean
      {
         var _loc1_:int = 0;
         if(Boolean(this._casterLightPass) && Boolean(this._casterLightPass._passesDirty) || Boolean(this._effectsPass) && Boolean(this._effectsPass._passesDirty))
         {
            return true;
         }
         if(this._nonCasterLightPasses)
         {
            _loc1_ = 0;
            while(_loc1_ < this._nonCasterLightPasses.length)
            {
               if(this._nonCasterLightPasses[_loc1_]._passesDirty)
               {
                  return true;
               }
               _loc1_++;
            }
         }
         return false;
      }
      
      private function addChildPassesFor(param1:CompiledPass) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(!param1)
         {
            return;
         }
         if(param1._passes)
         {
            _loc2_ = param1._passes.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               addPass(param1._passes[_loc3_]);
               _loc3_++;
            }
         }
      }
      
      override arcane function activatePass(param1:uint, param2:Stage3DProxy, param3:Camera3D) : void
      {
         if(param1 == 0)
         {
            param2._context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         }
         super.arcane::activatePass(param1,param2,param3);
      }
      
      override arcane function deactivate(param1:Stage3DProxy) : void
      {
         super.arcane::deactivate(param1);
         param1._context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
      }
      
      protected function updateScreenPasses() : void
      {
         this.initPasses();
         this.setBlendAndCompareModes();
         this._screenPassesInvalid = false;
      }
      
      private function initPasses() : void
      {
         if(this.numLights == 0 || this.numMethods > 0)
         {
            this.initEffectsPass();
         }
         else if(Boolean(this._effectsPass) && this.numMethods == 0)
         {
            this.removeEffectsPass();
         }
         if(this._shadowMethod)
         {
            this.initCasterLightPass();
         }
         else
         {
            this.removeCasterLightPass();
         }
         if(this.numNonCasters > 0)
         {
            this.initNonCasterLightPasses();
         }
         else
         {
            this.removeNonCasterLightPasses();
         }
      }
      
      private function setBlendAndCompareModes() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:Boolean = Boolean(this._casterLightPass || this._effectsPass);
         if(this._casterLightPass)
         {
            this._casterLightPass.setBlendMode(BlendMode.NORMAL);
            this._casterLightPass.depthCompareMode = depthCompareMode;
            this._casterLightPass.forceSeparateMVP = _loc1_;
         }
         if(this._nonCasterLightPasses)
         {
            _loc2_ = 0;
            if(!this._casterLightPass)
            {
               this._nonCasterLightPasses[0].forceSeparateMVP = _loc1_;
               this._nonCasterLightPasses[0].setBlendMode(BlendMode.NORMAL);
               this._nonCasterLightPasses[0].depthCompareMode = depthCompareMode;
               _loc2_ = 1;
            }
            _loc3_ = _loc2_;
            while(_loc3_ < this._nonCasterLightPasses.length)
            {
               this._nonCasterLightPasses[_loc3_].forceSeparateMVP = _loc1_;
               this._nonCasterLightPasses[_loc3_].setBlendMode(BlendMode.ADD);
               this._nonCasterLightPasses[_loc3_].depthCompareMode = Context3DCompareMode.LESS_EQUAL;
               _loc3_++;
            }
         }
         if(Boolean(this._casterLightPass) || Boolean(this._nonCasterLightPasses))
         {
            if(this._effectsPass)
            {
               this._effectsPass.ignoreLights = true;
               this._effectsPass.depthCompareMode = Context3DCompareMode.LESS_EQUAL;
               this._effectsPass.setBlendMode(BlendMode.SCREEN);
               this._effectsPass.forceSeparateMVP = _loc1_;
            }
         }
         else if(this._effectsPass)
         {
            this._effectsPass.ignoreLights = false;
            this._effectsPass.depthCompareMode = depthCompareMode;
            this._effectsPass.setBlendMode(BlendMode.NORMAL);
            this._effectsPass.forceSeparateMVP = false;
         }
      }
      
      private function initCasterLightPass() : void
      {
         this._casterLightPass = this._casterLightPass || new ShadowCasterPass(this);
         this._casterLightPass.diffuseMethod = null;
         this._casterLightPass.ambientMethod = null;
         this._casterLightPass.normalMethod = null;
         this._casterLightPass.specularMethod = null;
         this._casterLightPass.shadowMethod = null;
         this._casterLightPass.enableLightFallOff = this._enableLightFallOff;
         this._casterLightPass.lightPicker = new StaticLightPicker([this._shadowMethod.castingLight]);
         this._casterLightPass.shadowMethod = this._shadowMethod;
         this._casterLightPass.diffuseMethod = this._diffuseMethod;
         this._casterLightPass.ambientMethod = this._ambientMethod;
         this._casterLightPass.normalMethod = this._normalMethod;
         this._casterLightPass.specularMethod = this._specularMethod;
         this._casterLightPass.diffuseLightSources = this._diffuseLightSources;
         this._casterLightPass.specularLightSources = this._specularLightSources;
      }
      
      private function removeCasterLightPass() : void
      {
         if(!this._casterLightPass)
         {
            return;
         }
         this._casterLightPass.dispose();
         removePass(this._casterLightPass);
         this._casterLightPass = null;
      }
      
      private function initNonCasterLightPasses() : void
      {
         var _loc1_:LightingPass = null;
         this.removeNonCasterLightPasses();
         var _loc2_:int = int(_lightPicker.numDirectionalLights);
         var _loc3_:int = int(_lightPicker.numPointLights);
         var _loc4_:int = int(_lightPicker.numLightProbes);
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(!this._casterLightPass)
         {
            _loc2_ += _lightPicker.numCastingDirectionalLights;
            _loc3_ += _lightPicker.numCastingPointLights;
         }
         this._nonCasterLightPasses = new Vector.<LightingPass>();
         while(_loc5_ < _loc2_ || _loc6_ < _loc3_ || _loc7_ < _loc4_)
         {
            _loc1_ = new LightingPass(this);
            _loc1_.enableLightFallOff = this._enableLightFallOff;
            _loc1_.includeCasters = this._shadowMethod == null;
            _loc1_.directionalLightsOffset = _loc5_;
            _loc1_.pointLightsOffset = _loc6_;
            _loc1_.lightProbesOffset = _loc7_;
            _loc1_.diffuseMethod = null;
            _loc1_.ambientMethod = null;
            _loc1_.normalMethod = null;
            _loc1_.specularMethod = null;
            _loc1_.lightPicker = _lightPicker;
            _loc1_.diffuseMethod = this._diffuseMethod;
            _loc1_.ambientMethod = this._ambientMethod;
            _loc1_.normalMethod = this._normalMethod;
            _loc1_.specularMethod = this._specularMethod;
            _loc1_.diffuseLightSources = this._diffuseLightSources;
            _loc1_.specularLightSources = this._specularLightSources;
            this._nonCasterLightPasses.push(_loc1_);
            _loc5_ += _loc1_.numDirectionalLights;
            _loc6_ += _loc1_.numPointLights;
            _loc7_ += _loc1_.numLightProbes;
         }
      }
      
      private function removeNonCasterLightPasses() : void
      {
         if(!this._nonCasterLightPasses)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < this._nonCasterLightPasses.length)
         {
            removePass(this._nonCasterLightPasses[_loc1_]);
            this._nonCasterLightPasses[_loc1_].dispose();
            _loc1_++;
         }
         this._nonCasterLightPasses = null;
      }
      
      private function removeEffectsPass() : void
      {
         if(this._effectsPass.diffuseMethod != this._diffuseMethod)
         {
            this._effectsPass.diffuseMethod.dispose();
         }
         removePass(this._effectsPass);
         this._effectsPass.dispose();
         this._effectsPass = null;
      }
      
      private function initEffectsPass() : SuperShaderPass
      {
         this._effectsPass = this._effectsPass || new SuperShaderPass(this);
         this._effectsPass.enableLightFallOff = this._enableLightFallOff;
         if(this.numLights == 0)
         {
            this._effectsPass.diffuseMethod = null;
            this._effectsPass.diffuseMethod = this._diffuseMethod;
         }
         else
         {
            this._effectsPass.diffuseMethod = null;
            this._effectsPass.diffuseMethod = new BasicDiffuseMethod();
            this._effectsPass.diffuseMethod.diffuseColor = 0;
            this._effectsPass.diffuseMethod.diffuseAlpha = 0;
         }
         this._effectsPass.preserveAlpha = false;
         this._effectsPass.normalMethod = null;
         this._effectsPass.normalMethod = this._normalMethod;
         return this._effectsPass;
      }
      
      protected function get numLights() : int
      {
         return _lightPicker ? int(_lightPicker.numLightProbes + _lightPicker.numDirectionalLights + _lightPicker.numPointLights + _lightPicker.numCastingDirectionalLights + _lightPicker.numCastingPointLights) : 0;
      }
      
      private function get numNonCasters() : int
      {
         return _lightPicker ? int(_lightPicker.numLightProbes + _lightPicker.numDirectionalLights + _lightPicker.numPointLights) : 0;
      }
      
      protected function invalidateScreenPasses() : void
      {
         this._screenPassesInvalid = true;
      }
      
      private function onLightsChange(param1:Event) : void
      {
         this.invalidateScreenPasses();
      }
   }
}

