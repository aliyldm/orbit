package away3d.core.render
{
   import away3d.arcane;
   import away3d.core.managers.Stage3DProxy;
   import away3d.core.sort.IEntitySorter;
   import away3d.core.sort.RenderableMergeSort;
   import away3d.core.traverse.EntityCollector;
   import away3d.errors.AbstractMethodError;
   import away3d.events.Stage3DEvent;
   import away3d.textures.Texture2DBase;
   import flash.display.BitmapData;
   import flash.display3D.Context3D;
   import flash.display3D.Context3DCompareMode;
   import flash.display3D.textures.TextureBase;
   import flash.events.Event;
   import flash.geom.Matrix3D;
   import flash.geom.Rectangle;
   
   use namespace arcane;
   
   public class RendererBase
   {
      
      protected var _context:Context3D;
      
      protected var _stage3DProxy:Stage3DProxy;
      
      protected var _backgroundR:Number = 0;
      
      protected var _backgroundG:Number = 0;
      
      protected var _backgroundB:Number = 0;
      
      protected var _backgroundAlpha:Number = 1;
      
      protected var _shareContext:Boolean = false;
      
      protected var _renderTarget:TextureBase;
      
      protected var _renderTargetSurface:int;
      
      protected var _viewWidth:Number;
      
      protected var _viewHeight:Number;
      
      protected var _renderableSorter:IEntitySorter;
      
      private var _backgroundImageRenderer:BackgroundImageRenderer;
      
      private var _background:Texture2DBase;
      
      protected var _renderToTexture:Boolean;
      
      protected var _antiAlias:uint;
      
      protected var _textureRatioX:Number = 1;
      
      protected var _textureRatioY:Number = 1;
      
      private var _snapshotBitmapData:BitmapData;
      
      private var _snapshotRequired:Boolean;
      
      private var _clearOnRender:Boolean = true;
      
      protected var _rttViewProjectionMatrix:Matrix3D = new Matrix3D();
      
      public function RendererBase(param1:Boolean = false)
      {
         super();
         this._renderableSorter = new RenderableMergeSort();
         this._renderToTexture = param1;
      }
      
      arcane function createEntityCollector() : EntityCollector
      {
         return new EntityCollector();
      }
      
      arcane function get viewWidth() : Number
      {
         return this._viewWidth;
      }
      
      arcane function set viewWidth(param1:Number) : void
      {
         this._viewWidth = param1;
      }
      
      arcane function get viewHeight() : Number
      {
         return this._viewHeight;
      }
      
      arcane function set viewHeight(param1:Number) : void
      {
         this._viewHeight = param1;
      }
      
      arcane function get renderToTexture() : Boolean
      {
         return this._renderToTexture;
      }
      
      public function get renderableSorter() : IEntitySorter
      {
         return this._renderableSorter;
      }
      
      public function set renderableSorter(param1:IEntitySorter) : void
      {
         this._renderableSorter = param1;
      }
      
      arcane function get clearOnRender() : Boolean
      {
         return this._clearOnRender;
      }
      
      arcane function set clearOnRender(param1:Boolean) : void
      {
         this._clearOnRender = param1;
      }
      
      arcane function get backgroundR() : Number
      {
         return this._backgroundR;
      }
      
      arcane function set backgroundR(param1:Number) : void
      {
         this._backgroundR = param1;
      }
      
      arcane function get backgroundG() : Number
      {
         return this._backgroundG;
      }
      
      arcane function set backgroundG(param1:Number) : void
      {
         this._backgroundG = param1;
      }
      
      arcane function get backgroundB() : Number
      {
         return this._backgroundB;
      }
      
      arcane function set backgroundB(param1:Number) : void
      {
         this._backgroundB = param1;
      }
      
      arcane function get stage3DProxy() : Stage3DProxy
      {
         return this._stage3DProxy;
      }
      
      arcane function set stage3DProxy(param1:Stage3DProxy) : void
      {
         if(param1 == this._stage3DProxy)
         {
            return;
         }
         if(!param1)
         {
            if(this._stage3DProxy)
            {
               this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_CREATED,this.onContextUpdate);
               this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContextUpdate);
            }
            this._stage3DProxy = null;
            this._context = null;
            return;
         }
         this._stage3DProxy = param1;
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_CREATED,this.onContextUpdate);
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContextUpdate);
         if(this._backgroundImageRenderer)
         {
            this._backgroundImageRenderer.stage3DProxy = param1;
         }
         if(param1.context3D)
         {
            this._context = param1.context3D;
         }
      }
      
      arcane function get shareContext() : Boolean
      {
         return this._shareContext;
      }
      
      arcane function set shareContext(param1:Boolean) : void
      {
         this._shareContext = param1;
      }
      
      arcane function dispose() : void
      {
         this.stage3DProxy = null;
         if(this._backgroundImageRenderer)
         {
            this._backgroundImageRenderer.dispose();
            this._backgroundImageRenderer = null;
         }
      }
      
      arcane function render(param1:EntityCollector, param2:TextureBase = null, param3:Rectangle = null, param4:int = 0) : void
      {
         if(!this._stage3DProxy || !this._context)
         {
            return;
         }
         this._rttViewProjectionMatrix.copyFrom(param1.camera.viewProjection);
         this._rttViewProjectionMatrix.appendScale(this._textureRatioX,this._textureRatioY,1);
         this.executeRender(param1,param2,param3,param4);
         var _loc5_:uint = 0;
         while(_loc5_ < 8)
         {
            this._context.setVertexBufferAt(_loc5_,null);
            this._context.setTextureAt(_loc5_,null);
            _loc5_++;
         }
      }
      
      protected function executeRender(param1:EntityCollector, param2:TextureBase = null, param3:Rectangle = null, param4:int = 0) : void
      {
         this._renderTarget = param2;
         this._renderTargetSurface = param4;
         if(this._renderableSorter)
         {
            this._renderableSorter.sort(param1);
         }
         if(this._renderToTexture)
         {
            this.executeRenderToTexturePass(param1);
         }
         this._stage3DProxy.setRenderTarget(param2,true,param4);
         if((Boolean(param2) || Boolean(!this._shareContext)) && this._clearOnRender)
         {
            this._context.clear(this._backgroundR,this._backgroundG,this._backgroundB,this._backgroundAlpha,1,0);
         }
         this._context.setDepthTest(false,Context3DCompareMode.ALWAYS);
         this._stage3DProxy.scissorRect = param3;
         if(this._backgroundImageRenderer)
         {
            this._backgroundImageRenderer.render();
         }
         this.draw(param1,param2);
         this._context.setDepthTest(false,Context3DCompareMode.LESS_EQUAL);
         if(!this._shareContext)
         {
            if(this._snapshotRequired && Boolean(this._snapshotBitmapData))
            {
               this._context.drawToBitmapData(this._snapshotBitmapData);
               this._snapshotRequired = false;
            }
         }
         this._stage3DProxy.scissorRect = null;
      }
      
      public function queueSnapshot(param1:BitmapData) : void
      {
         this._snapshotRequired = true;
         this._snapshotBitmapData = param1;
      }
      
      protected function executeRenderToTexturePass(param1:EntityCollector) : void
      {
         throw new AbstractMethodError();
      }
      
      protected function draw(param1:EntityCollector, param2:TextureBase) : void
      {
         throw new AbstractMethodError();
      }
      
      private function onContextUpdate(param1:Event) : void
      {
         this._context = this._stage3DProxy.context3D;
      }
      
      arcane function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      arcane function set backgroundAlpha(param1:Number) : void
      {
         this._backgroundAlpha = param1;
      }
      
      arcane function get background() : Texture2DBase
      {
         return this._background;
      }
      
      arcane function set background(param1:Texture2DBase) : void
      {
         if(Boolean(this._backgroundImageRenderer) && !param1)
         {
            this._backgroundImageRenderer.dispose();
            this._backgroundImageRenderer = null;
         }
         if(!this._backgroundImageRenderer && Boolean(param1))
         {
            this._backgroundImageRenderer = new BackgroundImageRenderer(this._stage3DProxy);
         }
         this._background = param1;
         if(this._backgroundImageRenderer)
         {
            this._backgroundImageRenderer.texture = param1;
         }
      }
      
      public function get backgroundImageRenderer() : BackgroundImageRenderer
      {
         return this._backgroundImageRenderer;
      }
      
      public function get antiAlias() : uint
      {
         return this._antiAlias;
      }
      
      public function set antiAlias(param1:uint) : void
      {
         this._antiAlias = param1;
      }
      
      arcane function get textureRatioX() : Number
      {
         return this._textureRatioX;
      }
      
      arcane function set textureRatioX(param1:Number) : void
      {
         this._textureRatioX = param1;
      }
      
      arcane function get textureRatioY() : Number
      {
         return this._textureRatioY;
      }
      
      arcane function set textureRatioY(param1:Number) : void
      {
         this._textureRatioY = param1;
      }
   }
}

