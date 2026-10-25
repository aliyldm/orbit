package away3d.materials.passes
{
   import away3d.animators.IAnimationSet;
   import away3d.animators.data.AnimationRegisterCache;
   import away3d.arcane;
   import away3d.cameras.Camera3D;
   import away3d.core.base.IRenderable;
   import away3d.core.managers.AGALProgram3DCache;
   import away3d.core.managers.Stage3DProxy;
   import away3d.debug.Debug;
   import away3d.errors.AbstractMethodError;
   import away3d.materials.MaterialBase;
   import away3d.materials.lightpickers.LightPickerBase;
   import flash.display.BlendMode;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DBlendFactor;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.Context3DTriangleFace;
   import flash.display3D.Program3D;
   import flash.display3D.textures.TextureBase;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   
   use namespace arcane;
   
   public class MaterialPassBase extends EventDispatcher
   {
      
      private static var _previousUsedStreams:Vector.<int> = Vector.<int>([0,0,0,0,0,0,0,0]);
      
      private static var _previousUsedTexs:Vector.<int> = Vector.<int>([0,0,0,0,0,0,0,0]);
      
      protected var _material:MaterialBase;
      
      protected var _animationSet:IAnimationSet;
      
      arcane var _program3Ds:Vector.<Program3D> = new Vector.<Program3D>(8);
      
      arcane var _program3Dids:Vector.<int> = Vector.<int>([-1,-1,-1,-1,-1,-1,-1,-1]);
      
      private var _context3Ds:Vector.<Context3D> = new Vector.<Context3D>(8);
      
      protected var _numUsedStreams:uint;
      
      protected var _numUsedTextures:uint;
      
      protected var _numUsedVertexConstants:uint;
      
      protected var _numUsedFragmentConstants:uint;
      
      protected var _numUsedVaryings:uint;
      
      protected var _smooth:Boolean = true;
      
      protected var _repeat:Boolean = false;
      
      protected var _mipmap:Boolean = true;
      
      protected var _depthCompareMode:String = "lessEqual";
      
      protected var _blendFactorSource:String = "one";
      
      protected var _blendFactorDest:String = "zero";
      
      protected var _enableBlending:Boolean;
      
      private var _bothSides:Boolean;
      
      protected var _lightPicker:LightPickerBase;
      
      protected var _animatableAttributes:Vector.<String> = Vector.<String>(["va0"]);
      
      protected var _animationTargetRegisters:Vector.<String> = Vector.<String>(["vt0"]);
      
      protected var _shadedTarget:String = "ft0";
      
      protected var _defaultCulling:String = "back";
      
      private var _renderToTexture:Boolean;
      
      private var _oldTarget:TextureBase;
      
      private var _oldSurface:int;
      
      private var _oldDepthStencil:Boolean;
      
      private var _oldRect:Rectangle;
      
      protected var _alphaPremultiplied:Boolean;
      
      protected var _needFragmentAnimation:Boolean;
      
      protected var _needUVAnimation:Boolean;
      
      protected var _UVTarget:String;
      
      protected var _UVSource:String;
      
      protected var _writeDepth:Boolean = true;
      
      public var animationRegisterCache:AnimationRegisterCache;
      
      public function MaterialPassBase(param1:Boolean = false)
      {
         super();
         this._renderToTexture = param1;
         this._numUsedStreams = 1;
         this._numUsedVertexConstants = 5;
      }
      
      public function get material() : MaterialBase
      {
         return this._material;
      }
      
      public function set material(param1:MaterialBase) : void
      {
         this._material = param1;
      }
      
      public function get writeDepth() : Boolean
      {
         return this._writeDepth;
      }
      
      public function set writeDepth(param1:Boolean) : void
      {
         this._writeDepth = param1;
      }
      
      public function get mipmap() : Boolean
      {
         return this._mipmap;
      }
      
      public function set mipmap(param1:Boolean) : void
      {
         if(this._mipmap == param1)
         {
            return;
         }
         this._mipmap = param1;
         this.invalidateShaderProgram();
      }
      
      public function get smooth() : Boolean
      {
         return this._smooth;
      }
      
      public function set smooth(param1:Boolean) : void
      {
         if(this._smooth == param1)
         {
            return;
         }
         this._smooth = param1;
         this.invalidateShaderProgram();
      }
      
      public function get repeat() : Boolean
      {
         return this._repeat;
      }
      
      public function set repeat(param1:Boolean) : void
      {
         if(this._repeat == param1)
         {
            return;
         }
         this._repeat = param1;
         this.invalidateShaderProgram();
      }
      
      public function get bothSides() : Boolean
      {
         return this._bothSides;
      }
      
      public function set bothSides(param1:Boolean) : void
      {
         this._bothSides = param1;
      }
      
      public function get depthCompareMode() : String
      {
         return this._depthCompareMode;
      }
      
      public function set depthCompareMode(param1:String) : void
      {
         this._depthCompareMode = param1;
      }
      
      public function get animationSet() : IAnimationSet
      {
         return this._animationSet;
      }
      
      public function set animationSet(param1:IAnimationSet) : void
      {
         if(this._animationSet == param1)
         {
            return;
         }
         this._animationSet = param1;
         this.invalidateShaderProgram();
      }
      
      public function get renderToTexture() : Boolean
      {
         return this._renderToTexture;
      }
      
      public function dispose() : void
      {
         if(this._lightPicker)
         {
            this._lightPicker.removeEventListener(Event.CHANGE,this.onLightsChange);
         }
         var _loc1_:uint = 0;
         while(_loc1_ < 8)
         {
            if(this._program3Ds[_loc1_])
            {
               if(AGALProgram3DCache.getInstanceFromIndex(_loc1_))
               {
                  AGALProgram3DCache.getInstanceFromIndex(_loc1_).freeProgram3D(this._program3Dids[_loc1_]);
               }
               this._program3Ds[_loc1_] = null;
            }
            _loc1_++;
         }
      }
      
      public function get numUsedStreams() : uint
      {
         return this._numUsedStreams;
      }
      
      public function get numUsedVertexConstants() : uint
      {
         return this._numUsedVertexConstants;
      }
      
      public function get numUsedVaryings() : uint
      {
         return this._numUsedVaryings;
      }
      
      public function get numUsedFragmentConstants() : uint
      {
         return this._numUsedFragmentConstants;
      }
      
      public function get needFragmentAnimation() : Boolean
      {
         return this._needFragmentAnimation;
      }
      
      public function get needUVAnimation() : Boolean
      {
         return this._needUVAnimation;
      }
      
      arcane function updateAnimationState(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D) : void
      {
         param1.animator.setRenderState(param2,param1,this._numUsedVertexConstants,this._numUsedStreams,param3);
      }
      
      arcane function render(param1:IRenderable, param2:Stage3DProxy, param3:Camera3D, param4:Matrix3D) : void
      {
         throw new AbstractMethodError();
      }
      
      arcane function getVertexCode() : String
      {
         throw new AbstractMethodError();
      }
      
      arcane function getFragmentCode(param1:String) : String
      {
         throw new AbstractMethodError();
      }
      
      public function setBlendMode(param1:String) : void
      {
         switch(param1)
         {
            case BlendMode.NORMAL:
               this._blendFactorSource = Context3DBlendFactor.ONE;
               this._blendFactorDest = Context3DBlendFactor.ZERO;
               this._enableBlending = false;
               break;
            case BlendMode.LAYER:
               this._blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
               this._blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
               this._enableBlending = true;
               break;
            case BlendMode.MULTIPLY:
               this._blendFactorSource = Context3DBlendFactor.ZERO;
               this._blendFactorDest = Context3DBlendFactor.SOURCE_COLOR;
               this._enableBlending = true;
               break;
            case BlendMode.ADD:
               this._blendFactorSource = Context3DBlendFactor.SOURCE_ALPHA;
               this._blendFactorDest = Context3DBlendFactor.ONE;
               this._enableBlending = true;
               break;
            case BlendMode.ALPHA:
               this._blendFactorSource = Context3DBlendFactor.ZERO;
               this._blendFactorDest = Context3DBlendFactor.SOURCE_ALPHA;
               this._enableBlending = true;
               break;
            case BlendMode.SCREEN:
               this._blendFactorSource = Context3DBlendFactor.ONE;
               this._blendFactorDest = Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR;
               this._enableBlending = true;
               break;
            default:
               throw new ArgumentError("Unsupported blend mode!");
         }
      }
      
      arcane function activate(param1:Stage3DProxy, param2:Camera3D) : void
      {
         var _loc6_:uint = 0;
         var _loc3_:int = param1._stage3DIndex;
         var _loc4_:Context3D = param1._context3D;
         _loc4_.setDepthTest(this._writeDepth && !this._enableBlending,this._depthCompareMode);
         if(this._enableBlending)
         {
            _loc4_.setBlendFactors(this._blendFactorSource,this._blendFactorDest);
         }
         if(this._context3Ds[_loc3_] != _loc4_ || !this._program3Ds[_loc3_])
         {
            this._context3Ds[_loc3_] = _loc4_;
            this.updateProgram(param1);
            dispatchEvent(new Event(Event.CHANGE));
         }
         var _loc5_:int = _previousUsedStreams[_loc3_];
         _loc6_ = this._numUsedStreams;
         while(_loc6_ < _loc5_)
         {
            _loc4_.setVertexBufferAt(_loc6_,null);
            _loc6_++;
         }
         _loc5_ = _previousUsedTexs[_loc3_];
         _loc6_ = this._numUsedTextures;
         while(_loc6_ < _loc5_)
         {
            _loc4_.setTextureAt(_loc6_,null);
            _loc6_++;
         }
         if(Boolean(this._animationSet) && !this._animationSet.usesCPU)
         {
            this._animationSet.activate(param1,this);
         }
         _loc4_.setProgram(this._program3Ds[_loc3_]);
         _loc4_.setCulling(this._bothSides ? Context3DTriangleFace.NONE : this._defaultCulling);
         if(this._renderToTexture)
         {
            this._oldTarget = param1.renderTarget;
            this._oldSurface = param1.renderSurfaceSelector;
            this._oldDepthStencil = param1.enableDepthAndStencil;
            this._oldRect = param1.scissorRect;
         }
      }
      
      arcane function deactivate(param1:Stage3DProxy) : void
      {
         var _loc2_:uint = uint(param1._stage3DIndex);
         _previousUsedStreams[_loc2_] = this._numUsedStreams;
         _previousUsedTexs[_loc2_] = this._numUsedTextures;
         if(Boolean(this._animationSet) && !this._animationSet.usesCPU)
         {
            this._animationSet.deactivate(param1,this);
         }
         if(this._renderToTexture)
         {
            param1.setRenderTarget(this._oldTarget,this._oldDepthStencil,this._oldSurface);
            param1.scissorRect = this._oldRect;
         }
         if(this._enableBlending)
         {
            param1._context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         }
         param1._context3D.setDepthTest(true,Context3DCompareMode.LESS_EQUAL);
      }
      
      arcane function invalidateShaderProgram(param1:Boolean = true) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < 8)
         {
            this._program3Ds[_loc2_] = null;
            _loc2_++;
         }
         if(Boolean(this._material) && param1)
         {
            this._material.invalidatePasses(this);
         }
      }
      
      arcane function updateProgram(param1:Stage3DProxy) : void
      {
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc2_:String = "";
         var _loc3_:String = "";
         var _loc4_:String = "";
         var _loc5_:String = this.getVertexCode();
         if(Boolean(this._animationSet) && !this._animationSet.usesCPU)
         {
            _loc2_ = this._animationSet.getAGALVertexCode(this,this._animatableAttributes,this._animationTargetRegisters,param1.profile);
            if(this._needFragmentAnimation)
            {
               _loc4_ = this._animationSet.getAGALFragmentCode(this,this._shadedTarget,param1.profile);
            }
            if(this._needUVAnimation)
            {
               _loc3_ = this._animationSet.getAGALUVCode(this,this._UVSource,this._UVTarget);
            }
            this._animationSet.doneAGALCode(this);
         }
         else
         {
            _loc7_ = this._animatableAttributes.length;
            _loc8_ = 0;
            while(_loc8_ < _loc7_)
            {
               _loc2_ += "mov " + this._animationTargetRegisters[_loc8_] + ", " + this._animatableAttributes[_loc8_] + "\n";
               _loc8_++;
            }
            if(this._needUVAnimation)
            {
               _loc3_ = "mov " + this._UVTarget + "," + this._UVSource + "\n";
            }
         }
         _loc5_ = _loc2_ + _loc3_ + _loc5_;
         var _loc6_:String = this.getFragmentCode(_loc4_);
         if(Debug.active)
         {
         }
         AGALProgram3DCache.getInstance(param1).setProgram3D(this,_loc5_,_loc6_);
      }
      
      arcane function get lightPicker() : LightPickerBase
      {
         return this._lightPicker;
      }
      
      arcane function set lightPicker(param1:LightPickerBase) : void
      {
         if(this._lightPicker)
         {
            this._lightPicker.removeEventListener(Event.CHANGE,this.onLightsChange);
         }
         this._lightPicker = param1;
         if(this._lightPicker)
         {
            this._lightPicker.addEventListener(Event.CHANGE,this.onLightsChange);
         }
         this.updateLights();
      }
      
      private function onLightsChange(param1:Event) : void
      {
         this.updateLights();
      }
      
      protected function updateLights() : void
      {
      }
      
      public function get alphaPremultiplied() : Boolean
      {
         return this._alphaPremultiplied;
      }
      
      public function set alphaPremultiplied(param1:Boolean) : void
      {
         this._alphaPremultiplied = param1;
         this.invalidateShaderProgram(false);
      }
   }
}

