package net.bigpoint.darkorbit.map.view3D.display3D.materials
{
   import away3d.arcane;
   import away3d.materials.TextureMultiPassMaterial;
   import away3d.materials.lightpickers.LightPickerBase;
   import away3d.materials.methods.EffectMethodBase;
   import away3d.materials.methods.LightMapMethod;
   import away3d.materials.methods.OutlineMethod;
   import away3d.materials.methods.RimLightMethod;
   import away3d.textures.ATFTexture;
   import away3d.textures.Texture2DBase;
   import flash.display.BlendMode;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.methods.AlphaMaskMethod;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.methods.CombinedGALMethod;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.methods.GlowMethod;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.methods.XRayMethod;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   use namespace arcane;
   
   public class EntityXRayMaterial extends TextureMultiPassMaterial implements ITextureMaterial, IDynamicMethodHolder
   {
      
      protected var _glowMethod:GlowMethod;
      
      protected var _alphaMask:AlphaMaskMethod;
      
      protected var _lightMap:LightMapMethod;
      
      protected var _supportedTexturesChanged:ISignal = new Signal();
      
      private var _customMethods:Vector.<EffectMethodBase> = new Vector.<EffectMethodBase>();
      
      private var _applyLight:Boolean = true;
      
      private var _gal:CombinedGALMethod;
      
      private var _params:XML;
      
      public function EntityXRayMaterial()
      {
         super();
         repeat = true;
         this.initCustomMethods();
         Settings3D.TEXTURE_USE_ADVANCED_TEXTURES.changed.add(this._supportedTexturesChanged.dispatch);
         Settings3D.TEXTURE_USE_GLOW_MAPS.changed.add(this._supportedTexturesChanged.dispatch);
         Settings3D.TEXTURE_FILTERING.changed.add(this.updateTextureFiltering);
         this.updateTextureFiltering();
      }
      
      protected function initCustomMethods() : void
      {
         var _loc1_:XRayMethod = new XRayMethod();
         _loc1_.alpha = 0.5;
         addPrePassMethod(_loc1_);
         addMethod(this._alphaMask = new AlphaMaskMethod());
         addMethod(this._glowMethod = new GlowMethod());
      }
      
      public function addDynamicMethod(param1:EffectMethodBase) : void
      {
         addMethod(param1);
         this._customMethods.push(param1);
      }
      
      public function removeDynamicMethod(param1:EffectMethodBase) : void
      {
         var _loc2_:int = this._customMethods.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._customMethods.splice(_loc2_,1);
         }
         super.removeMethod(param1);
      }
      
      public function removeDynamicMethods() : void
      {
         while(this._customMethods.length)
         {
            super.removeMethod(this._customMethods.pop());
         }
      }
      
      public function get supportedTextures() : Vector.<String>
      {
         var _loc1_:Vector.<String> = Vector.<String>(["diffuse","alpha","gal"]);
         if(Settings3D.TEXTURE_USE_ADVANCED_TEXTURES.value)
         {
            _loc1_.push("normal");
            _loc1_.push("specular");
            _loc1_.push("ao");
         }
         if(Settings3D.TEXTURE_USE_GLOW_MAPS.value)
         {
            _loc1_.push("glow");
         }
         return _loc1_;
      }
      
      public function get supportedTexturesChanged() : ISignal
      {
         return this._supportedTexturesChanged;
      }
      
      public function setTexture(param1:String, param2:Texture2DBase) : void
      {
         switch(param1)
         {
            case "diffuse":
               this.texture = param2;
               if(this._gal)
               {
                  this._gal.diffuseTexture = param2;
               }
               alphaPremultiplied = !(param2 is ATFTexture);
               break;
            case "normal":
               this.normalMap = param2;
               break;
            case "specular":
               this.specularMap = param2;
               break;
            case "glow":
               this._glowMethod.texture = param2;
               break;
            case "alpha":
               this._alphaMask.texture = param2;
               break;
            case "ao":
               if(this._lightMap == null && Boolean(param2))
               {
                  addMethod(this._lightMap = new LightMapMethod(param2,"multiply",this._params ? String(this._params.@secondaryUVForLightMap) == "true" : false));
               }
               if(this._lightMap)
               {
                  if(param2)
                  {
                     this._lightMap.texture = param2;
                  }
                  else
                  {
                     removeMethod(this._lightMap);
                     this._lightMap = null;
                  }
               }
               break;
            case "gal":
               if(this._gal == null && Boolean(param2))
               {
                  addMethod(this._gal = new CombinedGALMethod(this._params ? String(this._params.@secondaryUVForLightMap) == "true" : false));
               }
               if(this._gal)
               {
                  if(param2)
                  {
                     this._gal.galTexture = param2;
                     this._gal.diffuseTexture = this.texture;
                  }
                  else
                  {
                     removeMethod(this._gal);
                     this._gal = null;
                  }
               }
         }
      }
      
      public function setShaderParams(param1:XML) : void
      {
         var _loc6_:XML = null;
         var _loc7_:uint = 0;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         this._params = param1;
         blendMode = String(param1.@blendMode) || BlendMode.NORMAL;
         bothSides = String(param1.@materialBothSides) === "true";
         var _loc2_:Number = 1;
         if(param1.attribute("specularity").length() > 0)
         {
            _loc2_ = Number(param1.attribute("specularity"));
         }
         var _loc3_:Number = param1.attribute("specularityLow").length() > 0 ? Number(param1.attribute("specularityLow")) : _loc2_;
         var _loc4_:Number = 50;
         if(param1.attribute("gloss").length() > 0)
         {
            _loc4_ = Number(param1.attribute("gloss"));
         }
         var _loc5_:Number = param1.attribute("glossLow").length() > 0 ? Number(param1.attribute("glossLow")) : _loc4_;
         this.specular = Settings3D.TEXTURE_USE_ADVANCED_TEXTURES.value ? _loc2_ : _loc3_;
         this.gloss = Settings3D.TEXTURE_USE_ADVANCED_TEXTURES.value ? _loc4_ : _loc5_;
         if(param1.attribute("light") == "false")
         {
            this._applyLight = false;
            this.lightPicker = null;
         }
         if(param1.shader.rimLight.length() > 0)
         {
            _loc6_ = param1.shader.rimLight[0];
            _loc7_ = String(_loc6_.@color).length ? uint(_loc6_.@color) : 16711680;
            _loc8_ = String(_loc6_.@strength).length ? Number(_loc6_.@strength) : 0.5;
            _loc9_ = String(_loc6_.@power).length ? Number(_loc6_.@power) : 1;
            addMethod(new RimLightMethod(_loc7_,_loc8_,_loc9_));
         }
         if(param1.shader.outline.length() > 0)
         {
            _loc6_ = param1.shader.outline[0];
            _loc7_ = String(_loc6_.@color).length ? uint(_loc6_.@color) : 16711680;
            _loc10_ = String(_loc6_.@size).length ? Number(_loc6_.@size) : 0.25;
            addMethod(new OutlineMethod(_loc7_,_loc10_));
         }
      }
      
      private function updateTextureFiltering() : void
      {
         smooth = Settings3D.TEXTURE_FILTERING.medium.value;
         mipmap = Settings3D.TEXTURE_FILTERING.high.value;
      }
      
      override public function set lightPicker(param1:LightPickerBase) : void
      {
         super.lightPicker = this._applyLight ? param1 : null;
      }
      
      override public function dispose() : void
      {
         Settings3D.TEXTURE_USE_ADVANCED_TEXTURES.changed.remove(this._supportedTexturesChanged.dispatch);
         Settings3D.TEXTURE_USE_GLOW_MAPS.changed.remove(this._supportedTexturesChanged.dispatch);
         Settings3D.TEXTURE_FILTERING.changed.remove(this.updateTextureFiltering);
         super.dispose();
      }
   }
}

