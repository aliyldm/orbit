package away3d.materials
{
   import away3d.animators.IAnimationSet;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IMaterialOwner;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.traverse.EntityCollector;
   import away3d.library.assets.AssetType;
   import away3d.library.assets.IAsset;
   import away3d.library.assets.NamedAssetBase;
   import away3d.materials.lightpickers.LightPickerBase;
   import away3d.materials.passes.DepthMapPass;
   import away3d.materials.passes.DistanceMapPass;
   import away3d.materials.passes.MaterialPassBase;
   import flash.display.BlendMode;
   import flash.display3D.Context3D;
   import flash.events.Event;
   import flash.geom.Matrix3D;
   
   use namespace arcane;
   
   public class MaterialBase extends NamedAssetBase implements IAsset
   {
      
      private static var MATERIAL_ID_COUNT:uint = 0;
      
      public var extra:Object;
      
      arcane var _classification:String;
      
      arcane var _uniqueId:uint;
      
      arcane var _renderOrderId:int;
      
      arcane var _depthPassId:int;
      
      private var _bothSides:Boolean;
      
      private var _animationSet:IAnimationSet;
      
      private var _owners:Vector.<IMaterialOwner>;
      
      private var _alphaPremultiplied:Boolean;
      
      private var _blendMode:String = "normal";
      
      protected var _numPasses:uint;
      
      protected var _passes:Vector.<MaterialPassBase>;
      
      protected var _mipmap:Boolean = true;
      
      protected var _smooth:Boolean = true;
      
      protected var _repeat:Boolean;
      
      protected var _depthPass:DepthMapPass;
      
      protected var _distancePass:DistanceMapPass;
      
      protected var _lightPicker:LightPickerBase;
      
      private var _distanceBasedDepthRender:Boolean;
      
      private var _depthCompareMode:String = "lessEqual";
      
      public function MaterialBase()
      {
         super();
         this._owners = new Vector.<IMaterialOwner>();
         this._passes = new Vector.<MaterialPassBase>();
         this._depthPass = new DepthMapPass();
         this._distancePass = new DistanceMapPass();
         this._depthPass.addEventListener(Event.CHANGE,this.onDepthPassChange);
         this._distancePass.addEventListener(Event.CHANGE,this.onDistancePassChange);
         this.alphaPremultiplied = true;
         this._uniqueId = MATERIAL_ID_COUNT++;
      }
      
      public function get assetType() : String
      {
         return AssetType.MATERIAL;
      }
      
      public function get lightPicker() : LightPickerBase
      {
         return this._lightPicker;
      }
      
      public function set lightPicker(param1:LightPickerBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         if(param1 != this._lightPicker)
         {
            this._lightPicker = param1;
            _loc2_ = this._passes.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               this._passes[_loc3_].lightPicker = this._lightPicker;
               _loc3_++;
            }
         }
      }
      
      public function get mipmap() : Boolean
      {
         return this._mipmap;
      }
      
      public function set mipmap(param1:Boolean) : void
      {
         this._mipmap = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._numPasses)
         {
            this._passes[_loc2_].mipmap = param1;
            _loc2_++;
         }
         this._depthPass.mipmap = param1;
         this._distancePass.mipmap = param1;
      }
      
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         this._smooth = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._numPasses)
         {
            this._passes[_loc2_].smooth = param1;
            _loc2_++;
         }
         this._depthPass.smooth = param1;
         this._distancePass.smooth = param1;
      }
      
      public function get depthCompareMode() : String
      {
         return this._depthCompareMode;
      }
      
      public function set depthCompareMode(param1:String) : void
      {
         this._depthCompareMode = param1;
      }
      
      public function get repeat() : Boolean
      {
         return this._repeat;
      }
      
      public function set repeat(param1:Boolean) : void
      {
         this._repeat = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._numPasses)
         {
            this._passes[_loc2_].repeat = param1;
            _loc2_++;
         }
         this._depthPass.repeat = param1;
         this._distancePass.repeat = param1;
      }
      
      public function dispose() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this._numPasses)
         {
            this._passes[_loc1_].dispose();
            _loc1_++;
         }
         this._depthPass.dispose();
         this._distancePass.dispose();
         this._depthPass.removeEventListener(Event.CHANGE,this.onDepthPassChange);
         this._distancePass.removeEventListener(Event.CHANGE,this.onDistancePassChange);
      }
      
      public function get bothSides() : Boolean
      {
         return this._bothSides;
      }
      
      public function set bothSides(param1:Boolean) : void
      {
         this._bothSides = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._numPasses)
         {
            this._passes[_loc2_].bothSides = param1;
            _loc2_++;
         }
         this._depthPass.bothSides = param1;
         this._distancePass.bothSides = param1;
      }
      
      public function get blendMode() : String
      {
         return this._blendMode;
      }
      
      public function set blendMode(param1:String) : void
      {
         this._blendMode = param1;
      }
      
      public function get alphaPremultiplied() : Boolean
      {
         return this._alphaPremultiplied;
      }
      
      public function set alphaPremultiplied(param1:Boolean) : void
      {
         this._alphaPremultiplied = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._numPasses)
         {
            this._passes[_loc2_].alphaPremultiplied = param1;
            _loc2_++;
         }
      }
      
      public function get requiresBlending() : Boolean
      {
         return this._blendMode != BlendMode.NORMAL;
      }
      
      public function get uniqueId() : uint
      {
         return this._uniqueId;
      }
      
      arcane function get numPasses() : uint
      {
         return this._numPasses;
      }
      
      arcane function hasDepthAlphaThreshold() : Boolean
      {
         return this._depthPass.alphaThreshold > 0;
      }
      
      arcane function activateForDepth(param1:Stage3DProxy, param2:Camera3D, param3:Boolean = false) : void
      {
         this._distanceBasedDepthRender = param3;
         if(param3)
         {
            this._distancePass.activate(param1,param2);
         }
         else
         {
            this._depthPass.activate(param1,param2);
         }
      }
      
      arcane function deactivateForDepth(param1:Stage3DProxy) : void
      {
         if(this._distanceBasedDepthRender)
         {
            this._distancePass.deactivate(param1);
         }
         else
         {
            this._depthPass.deactivate(param1);
         }
      }
      
      arcane function renderDepth(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         if(this._distanceBasedDepthRender)
         {
            if(param1.animator)
            {
               this._distancePass.updateAnimationState(param1,param2,param3);
            }
            this._distancePass.render(param1,param2,param3,param4);
         }
         else
         {
            if(param1.animator)
            {
               this._depthPass.updateAnimationState(param1,param2,param3);
            }
            this._depthPass.render(param1,param2,param3,param4);
         }
      }
      
      arcane function passRendersToTexture(param1:uint) : Boolean
      {
         return this._passes[param1].renderToTexture;
      }
      
      arcane function activatePass(param1:uint, param2:Stage3DProxy, param3:Camera3D) : void
      {
         this._passes[param1].activate(param2,param3);
      }
      
      arcane function deactivatePass(param1:uint, param2:Stage3DProxy) : void
      {
         this._passes[param1].deactivate(param2);
      }
      
      arcane function renderPass(param1:uint, param2:IRenderable, param3:Stage3DProxy, param4:EntityCollector, param5:Matrix3D) : void
      {
         if(this._lightPicker)
         {
            this._lightPicker.collectLights(param2,param4);
         }
         var _loc6_:MaterialPassBase = this._passes[param1];
         if(param2.animator)
         {
            _loc6_.updateAnimationState(param2,param3,param4.camera);
         }
         _loc6_.render(param2,param3,param4.camera,param5);
      }
      
      arcane function addOwner(param1:IMaterialOwner) : void
      {
         var _loc2_:int = 0;
         this._owners.push(param1);
         if(param1.animator)
         {
            if(Boolean(this._animationSet) && param1.animator.animationSet != this._animationSet)
            {
               throw new Error("A Material instance cannot be shared across renderables with different animator libraries");
            }
            if(this._animationSet != param1.animator.animationSet)
            {
               this._animationSet = param1.animator.animationSet;
               _loc2_ = 0;
               while(_loc2_ < this._numPasses)
               {
                  this._passes[_loc2_].animationSet = this._animationSet;
                  _loc2_++;
               }
               this._depthPass.animationSet = this._animationSet;
               this._distancePass.animationSet = this._animationSet;
               this.invalidatePasses(null);
            }
         }
      }
      
      arcane function removeOwner(param1:IMaterialOwner) : void
      {
         var _loc2_:int = 0;
         this._owners.splice(this._owners.indexOf(param1),1);
         if(this._owners.length == 0)
         {
            this._animationSet = null;
            _loc2_ = 0;
            while(_loc2_ < this._numPasses)
            {
               this._passes[_loc2_].animationSet = this._animationSet;
               _loc2_++;
            }
            this._depthPass.animationSet = this._animationSet;
            this._distancePass.animationSet = this._animationSet;
            this.invalidatePasses(null);
         }
      }
      
      arcane function get owners() : Vector.<IMaterialOwner>
      {
         return this._owners;
      }
      
      arcane function updateMaterial(param1:Context3D) : void
      {
      }
      
      arcane function deactivate(param1:Stage3DProxy) : void
      {
         this._passes[this._numPasses - 1].deactivate(param1);
      }
      
      arcane function invalidatePasses(param1:MaterialPassBase) : void
      {
         var _loc2_:IMaterialOwner = null;
         this._depthPass.invalidateShaderProgram();
         this._distancePass.invalidateShaderProgram();
         if(this._animationSet)
         {
            this._animationSet.resetGPUCompatibility();
            for each(_loc2_ in this._owners)
            {
               if(_loc2_.animator)
               {
                  _loc2_.animator.testGPUCompatibility(this._depthPass);
                  _loc2_.animator.testGPUCompatibility(this._distancePass);
               }
            }
         }
         var _loc3_:int = 0;
         while(_loc3_ < this._numPasses)
         {
            if(this._passes[_loc3_] != param1)
            {
               this._passes[_loc3_].invalidateShaderProgram(false);
            }
            if(this._animationSet)
            {
               for each(_loc2_ in this._owners)
               {
                  if(_loc2_.animator)
                  {
                     _loc2_.animator.testGPUCompatibility(this._passes[_loc3_]);
                  }
               }
            }
            _loc3_++;
         }
      }
      
      protected function removePass(param1:MaterialPassBase) : void
      {
         this._passes.splice(this._passes.indexOf(param1),1);
         --this._numPasses;
      }
      
      protected function clearPasses() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._numPasses)
         {
            this._passes[_loc1_].removeEventListener(Event.CHANGE,this.onPassChange);
            _loc1_++;
         }
         this._passes.length = 0;
         this._numPasses = 0;
      }
      
      protected function addPass(param1:MaterialPassBase) : void
      {
         this._passes[this._numPasses++] = param1;
         param1.animationSet = this._animationSet;
         param1.alphaPremultiplied = this._alphaPremultiplied;
         param1.mipmap = this._mipmap;
         param1.smooth = this._smooth;
         param1.repeat = this._repeat;
         param1.lightPicker = this._lightPicker;
         param1.bothSides = this._bothSides;
         param1.addEventListener(Event.CHANGE,this.onPassChange);
         this.invalidatePasses(null);
      }
      
      private function onPassChange(param1:Event) : void
      {
         var _loc3_:Vector.<int> = null;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Number = 1;
         this._renderOrderId = 0;
         var _loc5_:int = 0;
         while(_loc5_ < this._numPasses)
         {
            _loc3_ = this._passes[_loc5_]._program3Dids;
            _loc4_ = int(_loc3_.length);
            _loc6_ = 0;
            while(_loc6_ < _loc4_)
            {
               if(_loc3_[_loc6_] != -1)
               {
                  this._renderOrderId += _loc2_ * _loc3_[_loc6_];
                  _loc6_ = _loc4_;
               }
               _loc6_++;
            }
            _loc2_ *= 1000;
            _loc5_++;
         }
      }
      
      private function onDistancePassChange(param1:Event) : void
      {
         var _loc2_:Vector.<int> = this._distancePass._program3Dids;
         var _loc3_:uint = _loc2_.length;
         this._depthPassId = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_] != -1)
            {
               this._depthPassId += _loc2_[_loc4_];
               _loc4_ = int(_loc3_);
            }
            _loc4_++;
         }
      }
      
      private function onDepthPassChange(param1:Event) : void
      {
         var _loc2_:Vector.<int> = this._depthPass._program3Dids;
         var _loc3_:uint = _loc2_.length;
         this._depthPassId = 0;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_] != -1)
            {
               this._depthPassId += _loc2_[_loc4_];
               _loc4_ = int(_loc3_);
            }
            _loc4_++;
         }
      }
   }
}

