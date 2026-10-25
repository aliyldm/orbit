package away3d.containers
{
   import away3d.*;
   import away3d.cameras.*;
   import away3d.cameras.lenses.*;
   import away3d.core.managers.*;
   import away3d.core.pick.*;
   import away3d.core.render.*;
   import away3d.core.traverse.*;
   import away3d.events.*;
   import away3d.filters.*;
   import away3d.textures.*;
   import flash.display.*;
   import flash.display3D.*;
   import flash.display3D.textures.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.ui.*;
   import flash.utils.*;
   
   use namespace arcane;
   
   public class View3D extends Sprite
   {
      
      private var _width:Number = 0;
      
      private var _height:Number = 0;
      
      private var _localPos:Point = new Point();
      
      private var _globalPos:Point = new Point();
      
      private var _globalPosDirty:Boolean;
      
      protected var _scene:Scene3D;
      
      protected var _camera:Camera3D;
      
      protected var _entityCollector:EntityCollector;
      
      protected var _aspectRatio:Number;
      
      private var _time:Number = 0;
      
      private var _deltaTime:uint;
      
      private var _backgroundColor:uint = 0;
      
      private var _backgroundAlpha:Number = 1;
      
      protected var _mouse3DManager:Mouse3DManager;
      
      protected var _touch3DManager:Touch3DManager;
      
      protected var _renderer:RendererBase;
      
      protected var _cubeRenderer:RendererBase;
      
      private var _depthRenderer:DepthRenderer;
      
      private var _addedToStage:Boolean;
      
      private var _forceSoftware:Boolean;
      
      protected var _filter3DRenderer:Filter3DRenderer;
      
      protected var _requireDepthRender:Boolean;
      
      protected var _depthRender:Texture;
      
      private var _depthTextureInvalid:Boolean = true;
      
      private var _hitField:Sprite;
      
      protected var _parentIsStage:Boolean;
      
      private var _background:Texture2DBase;
      
      protected var _stage3DProxy:Stage3DProxy;
      
      protected var _backBufferInvalid:Boolean = true;
      
      private var _antiAlias:uint;
      
      protected var _rttBufferManager:RTTBufferManager;
      
      private var _rightClickMenuEnabled:Boolean = true;
      
      private var _sourceURL:String;
      
      private var _menu0:ContextMenuItem;
      
      private var _menu1:ContextMenuItem;
      
      private var _ViewContextMenu:ContextMenu;
      
      protected var _shareContext:Boolean = false;
      
      protected var _scissorRect:Rectangle;
      
      private var _scissorRectDirty:Boolean = true;
      
      private var _viewportDirty:Boolean = true;
      
      private var _depthPrepass:Boolean;
      
      private var _profile:String;
      
      private var _layeredView:Boolean = false;
      
      private var _cameras:Vector.<Camera3D>;
      
      private var _lenses:Vector.<PerspectiveLens>;
      
      private var _container:ObjectContainer3D;
      
      public function View3D(param1:Scene3D = null, param2:Camera3D = null, param3:RendererBase = null, param4:Boolean = false, param5:String = "baseline")
      {
         super();
         this._profile = param5;
         this._scene = param1 || new Scene3D();
         this._scene.addEventListener(Scene3DEvent.PARTITION_CHANGED,this.onScenePartitionChanged);
         this._camera = param2 || new Camera3D();
         this._renderer = param3 || new DefaultRenderer();
         this._depthRenderer = new DepthRenderer();
         this._forceSoftware = param4;
         this._entityCollector = this._renderer.createEntityCollector();
         this._entityCollector.camera = this._camera;
         this._scissorRect = new Rectangle();
         this.initHitField();
         this._mouse3DManager = new Mouse3DManager();
         this._mouse3DManager.enableMouseListeners(this);
         this._touch3DManager = new Touch3DManager();
         this._touch3DManager.view = this;
         this._touch3DManager.enableTouchListeners(this);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         addEventListener(Event.ADDED,this.onAdded,false,0,true);
         this._camera.addEventListener(CameraEvent.LENS_CHANGED,this.onLensChanged);
         this._camera.partition = this._scene.partition;
         this.initRightClickMenu();
      }
      
      private function viewSource(param1:ContextMenuEvent) : void
      {
         var _loc2_:URLRequest = new URLRequest(this._sourceURL);
         try
         {
            navigateToURL(_loc2_,"_blank");
         }
         catch(error:Error)
         {
         }
      }
      
      public function get depthPrepass() : Boolean
      {
         return this._depthPrepass;
      }
      
      public function set depthPrepass(param1:Boolean) : void
      {
         this._depthPrepass = param1;
      }
      
      private function visitWebsite(param1:ContextMenuEvent) : void
      {
         var _loc2_:String = Away3D.WEBSITE_URL;
         var _loc3_:URLRequest = new URLRequest(_loc2_);
         try
         {
            navigateToURL(_loc3_);
         }
         catch(error:Error)
         {
         }
      }
      
      private function initRightClickMenu() : void
      {
         this._menu0 = new ContextMenuItem("Away3D.com\tv" + Away3D.MAJOR_VERSION + "." + Away3D.MINOR_VERSION + "." + Away3D.REVISION,true,true,true);
         this._menu1 = new ContextMenuItem("View Source",true,true,true);
         this._menu0.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.visitWebsite);
         this._menu1.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,this.viewSource);
         this._ViewContextMenu = new ContextMenu();
         this.updateRightClickMenu();
      }
      
      private function updateRightClickMenu() : void
      {
         if(this._rightClickMenuEnabled)
         {
            this._ViewContextMenu.customItems = this._sourceURL ? [this._menu0,this._menu1] : [this._menu0];
         }
         else
         {
            this._ViewContextMenu.customItems = [];
         }
         contextMenu = this._ViewContextMenu;
      }
      
      private function onScenePartitionChanged(param1:Scene3DEvent) : void
      {
         if(this._camera)
         {
            this._camera.partition = this.scene.partition;
         }
      }
      
      public function get rightClickMenuEnabled() : Boolean
      {
         return this._rightClickMenuEnabled;
      }
      
      public function set rightClickMenuEnabled(param1:Boolean) : void
      {
         this._rightClickMenuEnabled = param1;
         this.updateRightClickMenu();
      }
      
      public function get stage3DProxy() : Stage3DProxy
      {
         return this._stage3DProxy;
      }
      
      public function set stage3DProxy(param1:Stage3DProxy) : void
      {
         if(this._stage3DProxy)
         {
            this._stage3DProxy.removeEventListener(Stage3DEvent.VIEWPORT_UPDATED,this.onViewportUpdated);
            this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContext3DRecreated);
         }
         this._stage3DProxy = param1;
         this._stage3DProxy.addEventListener(Stage3DEvent.VIEWPORT_UPDATED,this.onViewportUpdated);
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContext3DRecreated);
         this._renderer.stage3DProxy = this._depthRenderer.stage3DProxy = this._stage3DProxy;
         this._globalPosDirty = true;
         this._backBufferInvalid = true;
      }
      
      private function onContext3DRecreated(param1:Stage3DEvent) : void
      {
         this._depthTextureInvalid = true;
      }
      
      public function get forceMouseMove() : Boolean
      {
         return this._mouse3DManager.forceMouseMove;
      }
      
      public function set forceMouseMove(param1:Boolean) : void
      {
         this._mouse3DManager.forceMouseMove = param1;
         this._touch3DManager.forceTouchMove = param1;
      }
      
      public function get background() : Texture2DBase
      {
         return this._background;
      }
      
      public function set background(param1:Texture2DBase) : void
      {
         this._background = param1;
         this._renderer.background = this._background;
      }
      
      public function get layeredView() : Boolean
      {
         return this._layeredView;
      }
      
      public function set layeredView(param1:Boolean) : void
      {
         this._layeredView = param1;
      }
      
      private function initHitField() : void
      {
         this._hitField = new Sprite();
         this._hitField.alpha = 0;
         this._hitField.doubleClickEnabled = true;
         this._hitField.graphics.beginFill(0);
         this._hitField.graphics.drawRect(0,0,100,100);
         addChild(this._hitField);
      }
      
      override public function get filters() : Array
      {
         throw new Error("filters is not supported in View3D. Use filters3d instead.");
      }
      
      override public function set filters(param1:Array) : void
      {
         throw new Error("filters is not supported in View3D. Use filters3d instead.");
      }
      
      public function get filters3d() : Vector.<Filter3DBase>
      {
         return this._filter3DRenderer ? this._filter3DRenderer.filters : null;
      }
      
      public function set filters3d(param1:Vector.<Filter3DBase>) : void
      {
         if(Boolean(param1) && param1.length == 0)
         {
            param1 = null;
         }
         if(Boolean(this._filter3DRenderer) && !param1)
         {
            this._filter3DRenderer.dispose();
            this._filter3DRenderer = null;
         }
         else if(!this._filter3DRenderer && Boolean(param1))
         {
            this._filter3DRenderer = new Filter3DRenderer(this.stage3DProxy);
            this._filter3DRenderer.filters = param1;
         }
         if(this._filter3DRenderer)
         {
            this._filter3DRenderer.filters = param1;
            this._requireDepthRender = this._filter3DRenderer.requireDepthRender;
         }
         else
         {
            this._requireDepthRender = false;
            if(this._depthRender)
            {
               this._depthRender.dispose();
               this._depthRender = null;
            }
         }
      }
      
      public function get renderer() : RendererBase
      {
         return this._renderer;
      }
      
      public function set renderer(param1:RendererBase) : void
      {
         this._renderer.dispose();
         this._renderer = param1;
         this._entityCollector = this._renderer.createEntityCollector();
         this._entityCollector.camera = this._camera;
         this._renderer.stage3DProxy = this._stage3DProxy;
         this._renderer.antiAlias = this._antiAlias;
         this._renderer.backgroundR = (this._backgroundColor >> 16 & 0xFF) / 255;
         this._renderer.backgroundG = (this._backgroundColor >> 8 & 0xFF) / 255;
         this._renderer.backgroundB = (this._backgroundColor & 0xFF) / 255;
         this._renderer.backgroundAlpha = this._backgroundAlpha;
         this._renderer.viewWidth = this._width;
         this._renderer.viewHeight = this._height;
         this._backBufferInvalid = true;
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         this._backgroundColor = param1;
         this._renderer.backgroundR = (param1 >> 16 & 0xFF) / 255;
         this._renderer.backgroundG = (param1 >> 8 & 0xFF) / 255;
         this._renderer.backgroundB = (param1 & 0xFF) / 255;
      }
      
      public function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      public function set backgroundAlpha(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < 0)
         {
            param1 = 0;
         }
         this._renderer.backgroundAlpha = param1;
         this._backgroundAlpha = param1;
      }
      
      public function get camera() : Camera3D
      {
         return this._camera;
      }
      
      public function set camera(param1:Camera3D) : void
      {
         this._camera.removeEventListener(CameraEvent.LENS_CHANGED,this.onLensChanged);
         this._camera = param1;
         this._entityCollector.camera = this._camera;
         if(this._scene)
         {
            this._camera.partition = this._scene.partition;
         }
         this._camera.addEventListener(CameraEvent.LENS_CHANGED,this.onLensChanged);
         this._scissorRectDirty = true;
         this._viewportDirty = true;
      }
      
      public function get scene() : Scene3D
      {
         return this._scene;
      }
      
      public function set scene(param1:Scene3D) : void
      {
         this._scene.removeEventListener(Scene3DEvent.PARTITION_CHANGED,this.onScenePartitionChanged);
         this._scene = param1;
         this._scene.addEventListener(Scene3DEvent.PARTITION_CHANGED,this.onScenePartitionChanged);
         if(this._camera)
         {
            this._camera.partition = this._scene.partition;
         }
      }
      
      public function get deltaTime() : uint
      {
         return this._deltaTime;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         if(Boolean(this._stage3DProxy) && Boolean(this._stage3DProxy.usesSoftwareRendering) && param1 > 2048)
         {
            param1 = 2048;
         }
         if(this._width == param1)
         {
            return;
         }
         if(this._rttBufferManager)
         {
            this._rttBufferManager.viewWidth = param1;
         }
         this._hitField.width = param1;
         this._width = param1;
         this._aspectRatio = this._width / this._height;
         this._camera.lens.aspectRatio = this._aspectRatio;
         this._depthTextureInvalid = true;
         this._renderer.viewWidth = param1;
         this._scissorRect.width = param1;
         this._backBufferInvalid = true;
         this._scissorRectDirty = true;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         if(Boolean(this._stage3DProxy) && Boolean(this._stage3DProxy.usesSoftwareRendering) && param1 > 2048)
         {
            param1 = 2048;
         }
         if(this._height == param1)
         {
            return;
         }
         if(this._rttBufferManager)
         {
            this._rttBufferManager.viewHeight = param1;
         }
         this._hitField.height = param1;
         this._height = param1;
         this._aspectRatio = this._width / this._height;
         this._camera.lens.aspectRatio = this._aspectRatio;
         this._depthTextureInvalid = true;
         this._renderer.viewHeight = param1;
         this._scissorRect.height = param1;
         this._backBufferInvalid = true;
         this._scissorRectDirty = true;
      }
      
      override public function set x(param1:Number) : void
      {
         if(x == param1)
         {
            return;
         }
         this._localPos.x = super.x = param1;
         this._globalPos.x = parent ? parent.localToGlobal(this._localPos).x : param1;
         this._globalPosDirty = true;
      }
      
      override public function set y(param1:Number) : void
      {
         if(y == param1)
         {
            return;
         }
         this._localPos.y = super.y = param1;
         this._globalPos.y = parent ? parent.localToGlobal(this._localPos).y : param1;
         this._globalPosDirty = true;
      }
      
      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         if(Boolean(this._stage3DProxy) && !this._shareContext)
         {
            this._stage3DProxy.visible = param1;
         }
      }
      
      public function get antiAlias() : uint
      {
         return this._antiAlias;
      }
      
      public function set antiAlias(param1:uint) : void
      {
         this._antiAlias = param1;
         this._renderer.antiAlias = param1;
         this._backBufferInvalid = true;
      }
      
      public function get renderedFacesCount() : uint
      {
         return this._entityCollector.numTriangles;
      }
      
      public function get shareContext() : Boolean
      {
         return this._shareContext;
      }
      
      public function set shareContext(param1:Boolean) : void
      {
         if(this._shareContext == param1)
         {
            return;
         }
         this._shareContext = param1;
         this._globalPosDirty = true;
      }
      
      protected function updateBackBuffer() : void
      {
         if(Boolean(this._stage3DProxy.context3D) && !this._shareContext)
         {
            if(Boolean(this._width) && Boolean(this._height))
            {
               if(this._stage3DProxy.usesSoftwareRendering)
               {
                  if(this._width > 2048)
                  {
                     this._width = 2048;
                  }
                  if(this._height > 2048)
                  {
                     this._height = 2048;
                  }
               }
               this._stage3DProxy.configureBackBuffer(this._width,this._height,this._antiAlias);
               this._backBufferInvalid = false;
            }
            else
            {
               this.width = stage.stageWidth;
               this.height = stage.stageHeight;
            }
         }
      }
      
      public function addSourceURL(param1:String) : void
      {
         this._sourceURL = param1;
         this.updateRightClickMenu();
      }
      
      public function render() : void
      {
         var _loc1_:TextureBase = null;
         var _loc2_:uint = 0;
         if(!this.stage3DProxy.recoverFromDisposal())
         {
            this._backBufferInvalid = true;
            return;
         }
         if(this._backBufferInvalid)
         {
            this.updateBackBuffer();
         }
         if(this._shareContext && this._layeredView)
         {
            this.stage3DProxy.clearDepthBuffer();
         }
         if(this._globalPosDirty)
         {
            this.updateGlobalPos();
         }
         this.updateTime();
         this.updateViewSizeData();
         if(!this._filter3DRenderer || !this._stage3DProxy._context3D || !(this._filter3DRenderer.getMainInputTexture(this._stage3DProxy) is CubeTexture))
         {
            this._entityCollector.clear();
            this._scene.traversePartitions(this._entityCollector);
            if(this._requireDepthRender)
            {
               this.renderSceneDepthToTexture(this._entityCollector);
            }
            if(this._depthPrepass)
            {
               this.renderDepthPrepass(this._entityCollector);
            }
            this._renderer.clearOnRender = !this._depthPrepass;
         }
         if(Boolean(this._filter3DRenderer) && Boolean(this._stage3DProxy._context3D))
         {
            _loc1_ = this._filter3DRenderer.getMainInputTexture(this._stage3DProxy);
            if(_loc1_ is CubeTexture)
            {
               if(!this._cameras)
               {
                  this.initCameras();
               }
               this.scene.partition.updateEntities();
               this._container.transform = this._camera.transform;
               _loc2_ = 0;
               while(_loc2_ < 6)
               {
                  this.renderSurface(_loc2_,this.scene,_loc1_);
                  _loc2_++;
               }
               this._filter3DRenderer.render(this._stage3DProxy,this.camera,this._depthRender,this._shareContext);
            }
            else
            {
               this._renderer.render(this._entityCollector,_loc1_,this._rttBufferManager.renderToTextureRect);
               this._filter3DRenderer.render(this._stage3DProxy,this.camera,this._depthRender,this._shareContext);
            }
         }
         else
         {
            this._renderer.shareContext = this._shareContext;
            if(this._shareContext)
            {
               this._renderer.render(this._entityCollector,null,this._scissorRect);
            }
            else
            {
               this._renderer.render(this._entityCollector);
            }
         }
         if(!this._shareContext)
         {
            this.stage3DProxy.present();
         }
         if(!this._filter3DRenderer || !this._stage3DProxy._context3D || !(this._filter3DRenderer.getMainInputTexture(this._stage3DProxy) is CubeTexture))
         {
            this._entityCollector.cleanUp();
         }
         this.stage3DProxy.bufferClear = false;
      }
      
      protected function updateGlobalPos() : void
      {
         this._globalPosDirty = false;
         if(!this._stage3DProxy)
         {
            return;
         }
         if(this._shareContext)
         {
            this._scissorRect.x = this._globalPos.x - this._stage3DProxy.x;
            this._scissorRect.y = this._globalPos.y - this._stage3DProxy.y;
         }
         else
         {
            this._scissorRect.x = 0;
            this._scissorRect.y = 0;
            this._stage3DProxy.x = this._globalPos.x;
            this._stage3DProxy.y = this._globalPos.y;
         }
         this._scissorRectDirty = true;
      }
      
      protected function updateTime() : void
      {
         var _loc1_:Number = getTimer();
         if(this._time == 0)
         {
            this._time = _loc1_;
         }
         this._deltaTime = _loc1_ - this._time;
         this._time = _loc1_;
      }
      
      protected function updateViewSizeData() : void
      {
         this._camera.lens.aspectRatio = this._aspectRatio;
         if(this._scissorRectDirty)
         {
            this._scissorRectDirty = false;
            this._camera.lens.updateScissorRect(this._scissorRect.x,this._scissorRect.y,this._scissorRect.width,this._scissorRect.height);
         }
         if(this._viewportDirty)
         {
            this._viewportDirty = false;
            this._camera.lens.updateViewport(this._stage3DProxy.viewPort.x,this._stage3DProxy.viewPort.y,this._stage3DProxy.viewPort.width,this._stage3DProxy.viewPort.height);
         }
         if(Boolean(this._filter3DRenderer) || this._renderer.renderToTexture)
         {
            this._renderer.textureRatioX = this._rttBufferManager.textureRatioX;
            this._renderer.textureRatioY = this._rttBufferManager.textureRatioY;
         }
         else
         {
            this._renderer.textureRatioX = 1;
            this._renderer.textureRatioY = 1;
         }
      }
      
      protected function renderDepthPrepass(param1:EntityCollector) : void
      {
         this._depthRenderer.disableColor = true;
         if(Boolean(this._filter3DRenderer) || this._renderer.renderToTexture)
         {
            this._depthRenderer.textureRatioX = this._rttBufferManager.textureRatioX;
            this._depthRenderer.textureRatioY = this._rttBufferManager.textureRatioY;
            this._depthRenderer.render(param1,this._filter3DRenderer.getMainInputTexture(this._stage3DProxy),this._rttBufferManager.renderToTextureRect);
         }
         else
         {
            this._depthRenderer.textureRatioX = 1;
            this._depthRenderer.textureRatioY = 1;
            this._depthRenderer.render(param1);
         }
         this._depthRenderer.disableColor = false;
      }
      
      protected function renderSceneDepthToTexture(param1:EntityCollector) : void
      {
         if(this._depthTextureInvalid || !this._depthRender)
         {
            this.initDepthTexture(this._stage3DProxy._context3D);
         }
         this._depthRenderer.textureRatioX = this._rttBufferManager.textureRatioX;
         this._depthRenderer.textureRatioY = this._rttBufferManager.textureRatioY;
         this._depthRenderer.render(param1,this._depthRender);
      }
      
      private function initDepthTexture(param1:Context3D) : void
      {
         this._depthTextureInvalid = false;
         if(this._depthRender)
         {
            this._depthRender.dispose();
         }
         this._depthRender = param1.createTexture(this._rttBufferManager.textureWidth,this._rttBufferManager.textureHeight,Context3DTextureFormat.BGRA,true);
      }
      
      public function dispose() : void
      {
         this._stage3DProxy.removeEventListener(Stage3DEvent.VIEWPORT_UPDATED,this.onViewportUpdated);
         this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContext3DRecreated);
         if(!this.shareContext)
         {
            this._stage3DProxy.dispose();
         }
         this._renderer.dispose();
         if(this._depthRender)
         {
            this._depthRender.dispose();
         }
         if(this._rttBufferManager)
         {
            this._rttBufferManager.dispose();
         }
         this._mouse3DManager.disableMouseListeners(this);
         this._mouse3DManager.dispose();
         this._touch3DManager.disableTouchListeners(this);
         this._touch3DManager.dispose();
         this._rttBufferManager = null;
         this._depthRender = null;
         this._mouse3DManager = null;
         this._touch3DManager = null;
         this._depthRenderer = null;
         this._stage3DProxy = null;
         this._renderer = null;
         this._entityCollector = null;
      }
      
      public function project(param1:Vector3D) : Vector3D
      {
         var _loc2_:Vector3D = this._camera.project(param1);
         _loc2_.x = (_loc2_.x + 1) * this._width / 2;
         _loc2_.y = (_loc2_.y + 1) * this._height / 2;
         return _loc2_;
      }
      
      public function unproject(param1:Number, param2:Number, param3:Number, param4:Vector3D = null) : Vector3D
      {
         return this._camera.unproject((param1 * 2 - this._width) / this._stage3DProxy.width,(param2 * 2 - this._height) / this._stage3DProxy.height,param3,param4);
      }
      
      public function getRay(param1:Number, param2:Number, param3:Number) : Vector3D
      {
         return this._camera.getRay((param1 * 2 - this._width) / this._width,(param2 * 2 - this._height) / this._height,param3);
      }
      
      public function get mousePicker() : IPicker
      {
         return this._mouse3DManager.mousePicker;
      }
      
      public function set mousePicker(param1:IPicker) : void
      {
         this._mouse3DManager.mousePicker = param1;
      }
      
      public function get touchPicker() : IPicker
      {
         return this._touch3DManager.touchPicker;
      }
      
      public function set touchPicker(param1:IPicker) : void
      {
         this._touch3DManager.touchPicker = param1;
      }
      
      arcane function get entityCollector() : EntityCollector
      {
         return this._entityCollector;
      }
      
      private function onLensChanged(param1:CameraEvent) : void
      {
         this._scissorRectDirty = true;
         this._viewportDirty = true;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         if(this._addedToStage)
         {
            return;
         }
         this._addedToStage = true;
         if(!this._stage3DProxy)
         {
            this._stage3DProxy = Stage3DManager.getInstance(stage).getFreeStage3DProxy(this._forceSoftware,this._profile);
            this._stage3DProxy.addEventListener(Stage3DEvent.VIEWPORT_UPDATED,this.onViewportUpdated);
            this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContext3DRecreated);
         }
         this._globalPosDirty = true;
         this._rttBufferManager = RTTBufferManager.getInstance(this._stage3DProxy);
         this._renderer.stage3DProxy = this._depthRenderer.stage3DProxy = this._stage3DProxy;
         if(this._width == 0)
         {
            this.width = stage.stageWidth;
         }
         else
         {
            this._rttBufferManager.viewWidth = this._width;
         }
         if(this._height == 0)
         {
            this.height = stage.stageHeight;
         }
         else
         {
            this._rttBufferManager.viewHeight = this._height;
         }
         if(this._shareContext)
         {
            this._mouse3DManager.addViewLayer(this);
         }
      }
      
      private function onAdded(param1:Event) : void
      {
         this._parentIsStage = parent == stage;
         this._globalPos = parent.localToGlobal(this._localPos);
         this._globalPosDirty = true;
      }
      
      private function onViewportUpdated(param1:Stage3DEvent) : void
      {
         if(this._shareContext)
         {
            this._scissorRect.x = this._globalPos.x - this._stage3DProxy.x;
            this._scissorRect.y = this._globalPos.y - this._stage3DProxy.y;
            this._scissorRectDirty = true;
         }
         this._viewportDirty = true;
      }
      
      private function renderSurface(param1:uint, param2:Scene3D, param3:TextureBase) : void
      {
         var _loc4_:Camera3D = this._cameras[param1];
         _loc4_.lens.near = this._camera.lens.near;
         _loc4_.lens.far = this._camera.lens.far;
         this._entityCollector.camera = _loc4_;
         this._entityCollector.clear();
         param2.traversePartitions(this._entityCollector);
         this._cubeRenderer.render(this._entityCollector,param3,null,param1);
         this._entityCollector.cleanUp();
      }
      
      private function initCameras() : void
      {
         this._cameras = new Vector.<Camera3D>();
         this._lenses = new Vector.<PerspectiveLens>();
         this._container = new ObjectContainer3D();
         this.scene.addChild(this._container);
         this.addCamera(0,90,0);
         this.addCamera(0,-90,0);
         this.addCamera(-90,0,0);
         this.addCamera(90,0,0);
         this.addCamera(0,0,0);
         this.addCamera(0,180,0);
         this._cubeRenderer = new DefaultRenderer();
         this._cubeRenderer.stage3DProxy = this.stage3DProxy;
         this._cubeRenderer.shareContext = this.shareContext;
         this._cubeRenderer.backgroundAlpha = 0;
      }
      
      private function addCamera(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:Camera3D = new Camera3D();
         _loc4_.position = new Vector3D(0,0,0);
         this._container.addChild(_loc4_);
         _loc4_.rotationX = param1;
         _loc4_.rotationY = param2;
         _loc4_.rotationZ = param3;
         _loc4_.lens.near = 0.01;
         PerspectiveLens(_loc4_.lens).fieldOfView = 90;
         this._lenses.push(PerspectiveLens(_loc4_.lens));
         _loc4_.lens.aspectRatio = 1;
         this._cameras.push(_loc4_);
      }
      
      override public function set z(param1:Number) : void
      {
      }
      
      override public function set scaleZ(param1:Number) : void
      {
      }
      
      override public function set rotation(param1:Number) : void
      {
      }
      
      override public function set rotationX(param1:Number) : void
      {
      }
      
      override public function set rotationY(param1:Number) : void
      {
      }
      
      override public function set rotationZ(param1:Number) : void
      {
      }
      
      override public function set transform(param1:Transform) : void
      {
      }
      
      override public function set scaleX(param1:Number) : void
      {
      }
      
      override public function set scaleY(param1:Number) : void
      {
      }
   }
}

