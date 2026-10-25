package away3d.core.managers
{
   import away3d.arcane;
   import away3d.debug.Debug;
   import away3d.events.Stage3DEvent;
   import flash.display.Shape;
   import flash.display.Stage3D;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DClearMask;
   import flash.display3D.Context3DRenderMode;
   import flash.display3D.Program3D;
   import flash.display3D.textures.TextureBase;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   
   use namespace arcane;
   
   public class Stage3DProxy extends EventDispatcher
   {
      
      private static var _frameEventDriver:Shape = new Shape();
      
      arcane var _context3D:Context3D;
      
      arcane var _stage3DIndex:int = -1;
      
      private var _usesSoftwareRendering:Boolean;
      
      private var _profile:String;
      
      private var _stage3D:Stage3D;
      
      private var _activeProgram3D:Program3D;
      
      private var _stage3DManager:Stage3DManager;
      
      private var _backBufferWidth:int;
      
      private var _backBufferHeight:int;
      
      private var _antiAlias:int;
      
      private var _enableDepthAndStencil:Boolean;
      
      private var _backBufferEnableDepthAndStencil:Boolean = true;
      
      private var _renderTarget:TextureBase;
      
      private var _renderSurfaceSelector:int;
      
      private var _scissorRect:Rectangle;
      
      private var _color:uint;
      
      private var _backBufferDirty:Boolean;
      
      private var _viewPort:Rectangle;
      
      private var _enterFrame:Event;
      
      private var _exitFrame:Event;
      
      private var _viewportUpdated:Stage3DEvent;
      
      private var _viewportDirty:Boolean;
      
      private var _bufferClear:Boolean;
      
      private var _mouse3DManager:Mouse3DManager;
      
      private var _touch3DManager:Touch3DManager;
      
      public function Stage3DProxy(param1:int, param2:Stage3D, param3:Stage3DManager, param4:Boolean = false, param5:String = "baseline")
      {
         super();
         this._stage3DIndex = param1;
         this._stage3D = param2;
         this._stage3D.x = 0;
         this._stage3D.y = 0;
         this._stage3D.visible = true;
         this._stage3DManager = param3;
         this._viewPort = new Rectangle();
         this._enableDepthAndStencil = true;
         this._stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.onContext3DUpdate,false,1000,false);
         this.requestContext(param4,param5);
      }
      
      private function notifyViewportUpdated() : void
      {
         if(this._viewportDirty)
         {
            return;
         }
         this._viewportDirty = true;
         if(!hasEventListener(Stage3DEvent.VIEWPORT_UPDATED))
         {
            return;
         }
         this._viewportUpdated = new Stage3DEvent(Stage3DEvent.VIEWPORT_UPDATED);
         dispatchEvent(this._viewportUpdated);
      }
      
      private function notifyEnterFrame() : void
      {
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            return;
         }
         if(!this._enterFrame)
         {
            this._enterFrame = new Event(Event.ENTER_FRAME);
         }
         dispatchEvent(this._enterFrame);
      }
      
      private function notifyExitFrame() : void
      {
         if(!hasEventListener(Event.EXIT_FRAME))
         {
            return;
         }
         if(!this._exitFrame)
         {
            this._exitFrame = new Event(Event.EXIT_FRAME);
         }
         dispatchEvent(this._exitFrame);
      }
      
      public function get profile() : String
      {
         return this._profile;
      }
      
      public function dispose() : void
      {
         this._stage3DManager.removeStage3DProxy(this);
         this._stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.onContext3DUpdate);
         this.freeContext3D();
         this._stage3D = null;
         this._stage3DManager = null;
         this._stage3DIndex = -1;
      }
      
      public function configureBackBuffer(param1:int, param2:int, param3:int) : void
      {
         if(param1 < 50)
         {
            param1 = 50;
         }
         if(param2 < 50)
         {
            param2 = 50;
         }
         var _loc4_:uint = uint(this._backBufferWidth);
         var _loc5_:uint = uint(this._backBufferHeight);
         this._backBufferWidth = this._viewPort.width = param1;
         this._backBufferHeight = this._viewPort.height = param2;
         if(_loc4_ != this._backBufferWidth || _loc5_ != this._backBufferHeight)
         {
            this.notifyViewportUpdated();
         }
         this._antiAlias = param3;
         if(this._context3D)
         {
            this._context3D.configureBackBuffer(param1,param2,param3,this._backBufferEnableDepthAndStencil);
         }
      }
      
      public function get enableDepthAndStencil() : Boolean
      {
         return this._enableDepthAndStencil;
      }
      
      public function set enableDepthAndStencil(param1:Boolean) : void
      {
         this._enableDepthAndStencil = param1;
         this._backBufferDirty = true;
      }
      
      public function get renderTarget() : TextureBase
      {
         return this._renderTarget;
      }
      
      public function get renderSurfaceSelector() : int
      {
         return this._renderSurfaceSelector;
      }
      
      public function setRenderTarget(param1:TextureBase, param2:Boolean = false, param3:int = 0) : void
      {
         if(this._renderTarget == param1 && param3 == this._renderSurfaceSelector && this._enableDepthAndStencil == param2)
         {
            return;
         }
         this._renderTarget = param1;
         this._renderSurfaceSelector = param3;
         this._enableDepthAndStencil = param2;
         if(param1)
         {
            this._context3D.setRenderToTexture(param1,param2,this._antiAlias,param3);
         }
         else
         {
            this._context3D.setRenderToBackBuffer();
         }
      }
      
      public function clear() : void
      {
         if(!this._context3D)
         {
            return;
         }
         if(this._backBufferDirty)
         {
            this.configureBackBuffer(this._backBufferWidth,this._backBufferHeight,this._antiAlias);
            this._backBufferDirty = false;
         }
         this._context3D.clear((this._color >> 16 & 0xFF) / 255,(this._color >> 8 & 0xFF) / 255,(this._color & 0xFF) / 255,(this._color >> 24 & 0xFF) / 255);
         this._bufferClear = true;
      }
      
      public function present() : void
      {
         if(!this._context3D)
         {
            return;
         }
         this._context3D.present();
         this._activeProgram3D = null;
         if(this._mouse3DManager)
         {
            this._mouse3DManager.fireMouseEvents();
         }
      }
      
      override public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         super.addEventListener(param1,param2,param3,param4,param5);
         if((param1 == Event.ENTER_FRAME || param1 == Event.EXIT_FRAME) && !_frameEventDriver.hasEventListener(Event.ENTER_FRAME))
         {
            _frameEventDriver.addEventListener(Event.ENTER_FRAME,this.onEnterFrame,param3,param4,param5);
         }
      }
      
      override public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         super.removeEventListener(param1,param2,param3);
         if(!hasEventListener(Event.ENTER_FRAME) && !hasEventListener(Event.EXIT_FRAME) && _frameEventDriver.hasEventListener(Event.ENTER_FRAME))
         {
            _frameEventDriver.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame,param3);
         }
      }
      
      public function get scissorRect() : Rectangle
      {
         return this._scissorRect;
      }
      
      public function set scissorRect(param1:Rectangle) : void
      {
         this._scissorRect = param1;
         this._context3D.setScissorRectangle(this._scissorRect);
      }
      
      public function get stage3DIndex() : int
      {
         return this._stage3DIndex;
      }
      
      public function get stage3D() : Stage3D
      {
         return this._stage3D;
      }
      
      public function get context3D() : Context3D
      {
         return this._context3D;
      }
      
      public function get driverInfo() : String
      {
         return this._context3D ? this._context3D.driverInfo : null;
      }
      
      public function get usesSoftwareRendering() : Boolean
      {
         return this._usesSoftwareRendering;
      }
      
      public function get x() : Number
      {
         return this._stage3D.x;
      }
      
      public function set x(param1:Number) : void
      {
         if(this._viewPort.x == param1)
         {
            return;
         }
         this._stage3D.x = this._viewPort.x = param1;
         this.notifyViewportUpdated();
      }
      
      public function get y() : Number
      {
         return this._stage3D.y;
      }
      
      public function set y(param1:Number) : void
      {
         if(this._viewPort.y == param1)
         {
            return;
         }
         this._stage3D.y = this._viewPort.y = param1;
         this.notifyViewportUpdated();
      }
      
      public function get width() : int
      {
         return this._backBufferWidth;
      }
      
      public function set width(param1:int) : void
      {
         if(this._viewPort.width == param1)
         {
            return;
         }
         if(param1 < 50)
         {
            param1 = 50;
         }
         this._backBufferWidth = this._viewPort.width = param1;
         this._backBufferDirty = true;
         this.notifyViewportUpdated();
      }
      
      public function get height() : int
      {
         return this._backBufferHeight;
      }
      
      public function set height(param1:int) : void
      {
         if(this._viewPort.height == param1)
         {
            return;
         }
         if(param1 < 50)
         {
            param1 = 50;
         }
         this._backBufferHeight = this._viewPort.height = param1;
         this._backBufferDirty = true;
         this.notifyViewportUpdated();
      }
      
      public function get antiAlias() : int
      {
         return this._antiAlias;
      }
      
      public function set antiAlias(param1:int) : void
      {
         this._antiAlias = param1;
         this._backBufferDirty = true;
      }
      
      public function get viewPort() : Rectangle
      {
         this._viewportDirty = false;
         return this._viewPort;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         this._color = param1;
      }
      
      public function get visible() : Boolean
      {
         return this._stage3D.visible;
      }
      
      public function set visible(param1:Boolean) : void
      {
         this._stage3D.visible = param1;
      }
      
      public function get bufferClear() : Boolean
      {
         return this._bufferClear;
      }
      
      public function set bufferClear(param1:Boolean) : void
      {
         this._bufferClear = param1;
      }
      
      public function get mouse3DManager() : Mouse3DManager
      {
         return this._mouse3DManager;
      }
      
      public function set mouse3DManager(param1:Mouse3DManager) : void
      {
         this._mouse3DManager = param1;
      }
      
      public function get touch3DManager() : Touch3DManager
      {
         return this._touch3DManager;
      }
      
      public function set touch3DManager(param1:Touch3DManager) : void
      {
         this._touch3DManager = param1;
      }
      
      private function freeContext3D() : void
      {
         if(this._context3D)
         {
            if(this._context3D.dispose.length == 0)
            {
               this._context3D.dispose();
            }
            else
            {
               this._context3D.dispose(false);
            }
            dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_DISPOSED));
         }
         this._context3D = null;
      }
      
      private function onContext3DUpdate(param1:Event) : void
      {
         var _loc2_:Boolean = false;
         if(this._stage3D.context3D)
         {
            _loc2_ = this._context3D != null;
            this._context3D = this._stage3D.context3D;
            this._context3D.enableErrorChecking = Debug.active;
            this._usesSoftwareRendering = this._context3D.driverInfo.indexOf("Software") == 0;
            if(Boolean(this._backBufferWidth) && Boolean(this._backBufferHeight))
            {
               this._context3D.configureBackBuffer(this._backBufferWidth,this._backBufferHeight,this._antiAlias,this._backBufferEnableDepthAndStencil);
            }
            dispatchEvent(new Stage3DEvent(_loc2_ ? Stage3DEvent.CONTEXT3D_RECREATED : Stage3DEvent.CONTEXT3D_CREATED));
            return;
         }
         throw new Error("Rendering context lost!");
      }
      
      public function requestContext(param1:Boolean = false, param2:String = "baseline") : void
      {
         var renderMode:String;
         var forceSoftware:Boolean = param1;
         var profile:String = param2;
         this._usesSoftwareRendering = this._usesSoftwareRendering || forceSoftware;
         this._profile = profile;
         renderMode = forceSoftware ? Context3DRenderMode.SOFTWARE : Context3DRenderMode.AUTO;
         if(profile == "baseline")
         {
            this._stage3D.requestContext3D(renderMode);
         }
         else
         {
            try
            {
               this._stage3D["requestContext3D"](renderMode,profile);
            }
            catch(error:Error)
            {
               throw "An error occurred creating a context using the given profile. Profiles are not supported for the SDK this was compiled with.";
            }
         }
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         if(!this._context3D)
         {
            return;
         }
         this.clear();
         this.notifyEnterFrame();
         this.present();
         this.notifyExitFrame();
      }
      
      public function recoverFromDisposal() : Boolean
      {
         if(!this._context3D)
         {
            return false;
         }
         if(this._context3D.driverInfo == "Disposed")
         {
            this._context3D = null;
            dispatchEvent(new Stage3DEvent(Stage3DEvent.CONTEXT3D_DISPOSED));
            return false;
         }
         return true;
      }
      
      public function clearDepthBuffer() : void
      {
         if(!this._context3D)
         {
            return;
         }
         this._context3D.clear(0,0,0,1,1,0,Context3DClearMask.DEPTH);
      }
      
      public function get backBufferEnableDepthAndStencil() : Boolean
      {
         return this._backBufferEnableDepthAndStencil;
      }
      
      public function set backBufferEnableDepthAndStencil(param1:Boolean) : void
      {
         this._backBufferEnableDepthAndStencil = param1;
         this._backBufferDirty = true;
      }
   }
}

