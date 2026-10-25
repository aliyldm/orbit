package away3d.core.managers
{
   import away3d.events.Stage3DEvent;
   import away3d.tools.utils.TextureUtils;
   import flash.display3D.Context3D;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.VertexBuffer3D;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   
   public class RTTBufferManager extends EventDispatcher
   {
      
      private static var _instances:Dictionary;
      
      private var _renderToTextureVertexBuffer:VertexBuffer3D;
      
      private var _renderToScreenVertexBuffer:VertexBuffer3D;
      
      private var _indexBuffer:IndexBuffer3D;
      
      private var _stage3DProxy:Stage3DProxy;
      
      private var _viewWidth:int = -1;
      
      private var _viewHeight:int = -1;
      
      private var _textureWidth:int = -1;
      
      private var _textureHeight:int = -1;
      
      private var _renderToTextureRect:Rectangle;
      
      private var _buffersInvalid:Boolean = true;
      
      private var _textureRatioX:Number;
      
      private var _textureRatioY:Number;
      
      public function RTTBufferManager(param1:SingletonEnforcer, param2:Stage3DProxy)
      {
         super();
         if(!param1)
         {
            throw new Error("No cheating the multiton!");
         }
         this._renderToTextureRect = new Rectangle();
         this._stage3DProxy = param2;
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContextRecreated);
      }
      
      public static function getInstance(param1:Stage3DProxy) : RTTBufferManager
      {
         if(!param1)
         {
            throw new Error("stage3DProxy key cannot be null!");
         }
         _instances = _instances || new Dictionary();
         return _instances[param1] = _instances[param1] || new RTTBufferManager(new SingletonEnforcer(),param1);
      }
      
      public function get textureRatioX() : Number
      {
         if(this._buffersInvalid)
         {
            this.updateRTTBuffers();
         }
         return this._textureRatioX;
      }
      
      public function get textureRatioY() : Number
      {
         if(this._buffersInvalid)
         {
            this.updateRTTBuffers();
         }
         return this._textureRatioY;
      }
      
      public function get viewWidth() : int
      {
         return this._viewWidth;
      }
      
      public function set viewWidth(param1:int) : void
      {
         if(param1 == this._viewWidth)
         {
            return;
         }
         this._viewWidth = param1;
         this._buffersInvalid = true;
         this._textureWidth = TextureUtils.getBestPowerOf2(this._viewWidth);
         if(this._textureWidth > this._viewWidth)
         {
            this._renderToTextureRect.x = uint((this._textureWidth - this._viewWidth) * 0.5);
            this._renderToTextureRect.width = this._viewWidth;
         }
         else
         {
            this._renderToTextureRect.x = 0;
            this._renderToTextureRect.width = this._textureWidth;
         }
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      public function get viewHeight() : int
      {
         return this._viewHeight;
      }
      
      public function set viewHeight(param1:int) : void
      {
         if(param1 == this._viewHeight)
         {
            return;
         }
         this._viewHeight = param1;
         this._buffersInvalid = true;
         this._textureHeight = TextureUtils.getBestPowerOf2(this._viewHeight);
         if(this._textureHeight > this._viewHeight)
         {
            this._renderToTextureRect.y = uint((this._textureHeight - this._viewHeight) * 0.5);
            this._renderToTextureRect.height = this._viewHeight;
         }
         else
         {
            this._renderToTextureRect.y = 0;
            this._renderToTextureRect.height = this._textureHeight;
         }
         dispatchEvent(new Event(Event.RESIZE));
      }
      
      public function get renderToTextureVertexBuffer() : VertexBuffer3D
      {
         if(this._buffersInvalid)
         {
            this.updateRTTBuffers();
         }
         return this._renderToTextureVertexBuffer;
      }
      
      public function get renderToScreenVertexBuffer() : VertexBuffer3D
      {
         if(this._buffersInvalid)
         {
            this.updateRTTBuffers();
         }
         return this._renderToScreenVertexBuffer;
      }
      
      public function get indexBuffer() : IndexBuffer3D
      {
         return this._indexBuffer;
      }
      
      public function get renderToTextureRect() : Rectangle
      {
         if(this._buffersInvalid)
         {
            this.updateRTTBuffers();
         }
         return this._renderToTextureRect;
      }
      
      public function get textureWidth() : int
      {
         return this._textureWidth;
      }
      
      public function get textureHeight() : int
      {
         return this._textureHeight;
      }
      
      public function dispose() : void
      {
         delete _instances[this._stage3DProxy];
         this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContextRecreated);
         if(this._indexBuffer)
         {
            this._indexBuffer.dispose();
            this._renderToScreenVertexBuffer.dispose();
            this._renderToTextureVertexBuffer.dispose();
            this._renderToScreenVertexBuffer = null;
            this._renderToTextureVertexBuffer = null;
            this._indexBuffer = null;
         }
      }
      
      private function onContextRecreated(param1:Stage3DEvent) : void
      {
         this._indexBuffer = null;
         this._renderToTextureVertexBuffer = null;
         this._renderToScreenVertexBuffer = null;
         this.updateRTTBuffers();
      }
      
      private function updateRTTBuffers() : void
      {
         var _loc2_:Vector.<Number> = null;
         var _loc3_:Vector.<Number> = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc1_:Context3D = this._stage3DProxy.context3D;
         this._renderToTextureVertexBuffer = this._renderToTextureVertexBuffer || _loc1_.createVertexBuffer(4,5);
         this._renderToScreenVertexBuffer = this._renderToScreenVertexBuffer || _loc1_.createVertexBuffer(4,5);
         if(!this._indexBuffer)
         {
            this._indexBuffer = _loc1_.createIndexBuffer(6);
            this._indexBuffer.uploadFromVector(new <uint>[2,1,0,3,2,0],0,6);
         }
         this._textureRatioX = _loc4_ = Math.min(this._viewWidth / this._textureWidth,1);
         this._textureRatioY = _loc5_ = Math.min(this._viewHeight / this._textureHeight,1);
         var _loc6_:Number = (1 - _loc4_) * 0.5;
         var _loc7_:Number = (_loc4_ + 1) * 0.5;
         var _loc8_:Number = (_loc5_ + 1) * 0.5;
         var _loc9_:Number = (1 - _loc5_) * 0.5;
         _loc2_ = new <Number>[-_loc4_,-_loc5_,_loc6_,_loc8_,0,_loc4_,-_loc5_,_loc7_,_loc8_,1,_loc4_,_loc5_,_loc7_,_loc9_,2,-_loc4_,_loc5_,_loc6_,_loc9_,3];
         _loc3_ = new <Number>[-1,-1,_loc6_,_loc8_,0,1,-1,_loc7_,_loc8_,1,1,1,_loc7_,_loc9_,2,-1,1,_loc6_,_loc9_,3];
         this._renderToTextureVertexBuffer.uploadFromVector(_loc2_,0,4);
         this._renderToScreenVertexBuffer.uploadFromVector(_loc3_,0,4);
         this._buffersInvalid = false;
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
