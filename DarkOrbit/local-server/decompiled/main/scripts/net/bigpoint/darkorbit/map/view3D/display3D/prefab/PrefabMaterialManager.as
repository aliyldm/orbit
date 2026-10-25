package net.bigpoint.darkorbit.map.view3D.display3D.prefab
{
   import away3d.materials.MaterialBase;
   import away3d.textures.Texture2DBase;
   import com.bigpoint.utils.bindables.BindableInt;
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.view3D.display3D.World3D;
   import net.bigpoint.darkorbit.map.view3D.display3D.materials.ITextureMaterial;
   import net.bigpoint.darkorbit.map.view3D.settings.Settings3D;
   
   public class PrefabMaterialManager
   {
      
      private static const POOL:Dictionary = new Dictionary(true);
      
      World3D.instance.resetSignal.add(clearPool);
      
      public const sizeMultiplier:BindableInt = new BindableInt(1);
      
      private var _animationSet2material:Dictionary = new Dictionary(true);
      
      private var _shaderClass:Class;
      
      private var _descriptor:XML;
      
      private var _materialPrototype:ITextureMaterial;
      
      private var _textures:Dictionary = new Dictionary();
      
      private var _disposed:Boolean = false;
      
      private var _textureSize:BindableInt;
      
      private var _materials:Vector.<MaterialBase> = new Vector.<MaterialBase>();
      
      private var _hash:String;
      
      private var _textureTypes:Vector.<String>;
      
      public function PrefabMaterialManager(param1:XML, param2:String, param3:Class)
      {
         super();
         this._descriptor = param1;
         this._hash = param2;
         this._shaderClass = param3 || Settings3D.getShaderClass(String(this._descriptor.@shader));
         this._materialPrototype = new this._shaderClass() as ITextureMaterial;
         if(this._materialPrototype)
         {
            this._materialPrototype.supportedTexturesChanged.add(this.reloadTextures);
         }
         this.sizeMultiplier.changed.add(this.reloadTextures);
         this.textureSize = Settings3D.getTextureSize(this._descriptor.@tex_settings);
      }
      
      public static function getMaterial(param1:XML, param2:Class = null) : PrefabMaterialManager
      {
         var _loc3_:String = param1 ? param1.toXMLString() : "";
         if(param2)
         {
            _loc3_ += "_" + String(param2);
         }
         if(POOL[_loc3_] == null)
         {
            POOL[_loc3_] = {
               "counter":0,
               "material":new PrefabMaterialManager(param1,_loc3_,param2)
            };
         }
         POOL[_loc3_].counter += 1;
         return POOL[_loc3_].material;
      }
      
      public static function freeMaterial(param1:PrefabMaterialManager) : void
      {
         var _loc2_:Object = POOL[param1.hash];
         if(Boolean(_loc2_) && --_loc2_.counter <= 0)
         {
            param1.dispose();
            POOL[param1.hash] = null;
            delete POOL[param1.hash];
         }
      }
      
      public static function clearPool() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in POOL)
         {
            PrefabMaterialManager(POOL[_loc1_].material).dispose();
            POOL[_loc1_] = null;
            delete POOL[_loc1_];
         }
      }
      
      public function set textureSize(param1:BindableInt) : void
      {
         if(this._textureSize)
         {
            this._textureSize.changed.remove(this.reloadTextures);
            this._textureSize = null;
         }
         this._textureSize = param1;
         if(this._textureSize)
         {
            this._textureSize.changed.add(this.reloadTextures);
            this.reloadTextures();
         }
      }
      
      public function get materials() : Vector.<MaterialBase>
      {
         return this._materials;
      }
      
      public function get hash() : String
      {
         return this._hash;
      }
      
      public function setTexture(param1:String, param2:Texture2DBase) : void
      {
         World3D.instance.textureLoader.freeTexture(this._textures[param1]);
         this._textures[param1] = param2;
         World3D.instance.textureLoader.useTexture(this._textures[param1]);
         this.updateMaterials();
      }
      
      public function get shaderClass() : Class
      {
         return this._shaderClass;
      }
      
      public function getMaterial(param1:String) : MaterialBase
      {
         var _loc2_:MaterialBase = null;
         if(this._animationSet2material[param1] == null)
         {
            _loc2_ = new this._shaderClass() as MaterialBase;
            if(_loc2_ is ITextureMaterial)
            {
               ITextureMaterial(_loc2_).setShaderParams(this._descriptor);
            }
            this._animationSet2material[param1] = _loc2_;
            this._materials.push(_loc2_);
            _loc2_.lightPicker = World3D.instance.lights.picker;
            this.updateMaterial(_loc2_);
            return _loc2_;
         }
         return this._animationSet2material[param1] as MaterialBase;
      }
      
      public function clearTextures() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this._textures)
         {
            this.setTexture(_loc1_,null);
         }
      }
      
      public function dispose() : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         this.log("- dispose");
         while(this._materials.length)
         {
            this._materials.pop().dispose();
         }
         this._animationSet2material = null;
         if(this._materialPrototype)
         {
            if(this._materialPrototype.supportedTexturesChanged)
            {
               this._materialPrototype.supportedTexturesChanged.remove(this.reloadTextures);
            }
            this._materialPrototype = null;
         }
         this.clearTextures();
         this.textureSize = null;
      }
      
      private function reloadTextures() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         if(this._textureTypes)
         {
            for each(_loc1_ in this._textureTypes)
            {
               if(this._materialPrototype == null || this._materialPrototype.supportedTextures.indexOf(_loc1_) == -1)
               {
                  this.setTexture(_loc1_,null);
               }
            }
         }
         if(this._materialPrototype == null)
         {
            return;
         }
         this._textureTypes = this._materialPrototype.supportedTextures;
         for each(_loc1_ in this._textureTypes)
         {
            _loc2_ = this.assembleTextureResKey(_loc1_,this._textureSize.value);
            if(_loc2_)
            {
               this.log("- " + _loc1_ + " map url: " + _loc2_);
               World3D.instance.textureLoader.loadTexture(_loc2_,World3D.LIFETIME_USE_COUNTER).addOnce(this.createHandler(_loc1_));
            }
            else
            {
               this.setTexture(_loc1_,null);
            }
         }
      }
      
      private function assembleTextureResKey(param1:String, param2:int, param3:int = 1024) : String
      {
         var _loc6_:int = 0;
         var _loc4_:String = this.getTextureName(String(this._descriptor.@texture),String(this._descriptor.@geometry));
         var _loc5_:String = this.getTextureName(String(this._descriptor.attribute(param1)),_loc4_);
         if((Boolean(_loc5_)) && param2 > 0)
         {
            _loc6_ = param2 < 512 ? int(this.sizeMultiplier.value) : 1;
            return _loc5_ + "_" + param1 + "_" + Math.max(128,Math.min(param2 * _loc6_,param3));
         }
         return null;
      }
      
      private function getTextureName(param1:String, param2:String) : String
      {
         return param1 == "none" ? "" : param1 || param2;
      }
      
      private function createHandler(param1:String) : Function
      {
         var textureType:String = param1;
         return function(param1:Texture2DBase):void
         {
            setTexture(textureType,param1);
         };
      }
      
      private function updateMaterials() : void
      {
         var _loc1_:* = int(this._materials.length - 1);
         while(_loc1_ >= 0)
         {
            this.updateMaterial(this._materials[_loc1_]);
            _loc1_--;
         }
      }
      
      private function updateMaterial(param1:MaterialBase) : void
      {
         var _loc2_:ITextureMaterial = null;
         var _loc3_:String = null;
         if(param1 is ITextureMaterial)
         {
            _loc2_ = param1 as ITextureMaterial;
            for(_loc3_ in this._textures)
            {
               _loc2_.setTexture(_loc3_,this._textures[_loc3_] as Texture2DBase);
            }
         }
      }
      
      private function log(param1:String) : void
      {
      }
   }
}

