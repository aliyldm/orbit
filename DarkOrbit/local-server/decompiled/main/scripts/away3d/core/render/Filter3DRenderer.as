package away3d.core.render
{
   import away3d.cameras.*;
   import away3d.core.managers.*;
   import away3d.events.*;
   import away3d.filters.*;
   import away3d.filters.tasks.*;
   import flash.display3D.*;
   import flash.display3D.textures.*;
   import flash.events.*;
   
   public class Filter3DRenderer
   {
      
      private var _filters:Vector.<Filter3DBase>;
      
      private var _tasks:Vector.<Filter3DTaskBase>;
      
      private var _filterTasksInvalid:Boolean;
      
      private var _mainInputTexture:TextureBase;
      
      private var _requireDepthRender:Boolean;
      
      private var _rttManager:RTTBufferManager;
      
      private var _stage3DProxy:Stage3DProxy;
      
      private var _filterSizesInvalid:Boolean = true;
      
      public function Filter3DRenderer(param1:Stage3DProxy)
      {
         super();
         this._stage3DProxy = param1;
         this._stage3DProxy.addEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContext3DRecreated);
         this._rttManager = RTTBufferManager.getInstance(param1);
         this._rttManager.addEventListener(Event.RESIZE,this.onRTTResize);
      }
      
      private function onContext3DRecreated(param1:Stage3DEvent) : void
      {
         this._filterSizesInvalid = true;
      }
      
      private function onRTTResize(param1:Event) : void
      {
         this._filterSizesInvalid = true;
      }
      
      public function get requireDepthRender() : Boolean
      {
         return this._requireDepthRender;
      }
      
      public function getMainInputTexture(param1:Stage3DProxy) : TextureBase
      {
         if(this._filterTasksInvalid)
         {
            this.updateFilterTasks(param1);
         }
         return this._mainInputTexture;
      }
      
      public function get filters() : Vector.<Filter3DBase>
      {
         return this._filters;
      }
      
      public function set filters(param1:Vector.<Filter3DBase>) : void
      {
         this._filters = param1;
         this._filterTasksInvalid = true;
         this._requireDepthRender = false;
         if(!this._filters)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < this._filters.length)
         {
            this._requireDepthRender = this._requireDepthRender || Boolean(this._filters[_loc2_].requireDepthRender);
            _loc2_++;
         }
         this._filterSizesInvalid = true;
      }
      
      private function updateFilterTasks(param1:Stage3DProxy) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Filter3DBase = null;
         if(this._filterSizesInvalid)
         {
            this.updateFilterSizes();
         }
         if(!this._filters)
         {
            this._tasks = null;
            return;
         }
         this._tasks = new Vector.<Filter3DTaskBase>();
         _loc2_ = this._filters.length - 1;
         var _loc4_:uint = 0;
         while(_loc4_ <= _loc2_)
         {
            _loc3_ = this._filters[_loc4_];
            _loc3_.setRenderTargets(_loc4_ == _loc2_ ? null : Filter3DBase(this._filters[_loc4_ + 1]).getMainInputTexture(param1) as Texture,param1);
            this._tasks = this._tasks.concat(_loc3_.tasks);
            _loc4_++;
         }
         this._mainInputTexture = this._filters[0].getMainInputTexture(param1);
      }
      
      public function render(param1:Stage3DProxy, param2:Camera3D, param3:Texture, param4:Boolean) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Filter3DTaskBase = null;
         var _loc8_:Context3D = param1.context3D;
         var _loc9_:IndexBuffer3D = this._rttManager.indexBuffer;
         var _loc10_:VertexBuffer3D = this._rttManager.renderToTextureVertexBuffer;
         if(!this._filters)
         {
            return;
         }
         if(this._filterSizesInvalid)
         {
            this.updateFilterSizes();
         }
         if(this._filterTasksInvalid)
         {
            this.updateFilterTasks(param1);
         }
         _loc5_ = int(this._filters.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            this._filters[_loc6_].update(param1,param2);
            _loc6_++;
         }
         _loc5_ = int(this._tasks.length);
         if(_loc5_ > 1)
         {
            _loc8_.setVertexBufferAt(0,_loc10_,0,Context3DVertexBufferFormat.FLOAT_2);
            _loc8_.setVertexBufferAt(1,_loc10_,2,Context3DVertexBufferFormat.FLOAT_2);
         }
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = this._tasks[_loc6_];
            param1.setRenderTarget(_loc7_.target);
            _loc8_.setTextureAt(0,_loc7_.getMainInputTexture(param1));
            _loc8_.setProgram(_loc7_.getProgram3D(param1));
            if(!_loc7_.target)
            {
               param1.scissorRect = null;
               _loc10_ = this._rttManager.renderToScreenVertexBuffer;
               _loc8_.setVertexBufferAt(0,_loc10_,0,Context3DVertexBufferFormat.FLOAT_2);
               _loc8_.setVertexBufferAt(1,_loc10_,2,Context3DVertexBufferFormat.FLOAT_2);
            }
            if(!_loc7_.target && param4)
            {
               _loc8_.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA,Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
            }
            else
            {
               _loc8_.clear(0,0,0,0);
               _loc8_.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
            }
            _loc7_.activate(param1,param2,param3);
            _loc8_.drawTriangles(_loc9_,0,2);
            _loc7_.deactivate(param1);
            _loc6_++;
         }
         _loc8_.setTextureAt(0,null);
         _loc8_.setVertexBufferAt(0,null);
         _loc8_.setVertexBufferAt(1,null);
      }
      
      private function updateFilterSizes() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._filters.length)
         {
            this._filters[_loc1_].textureWidth = this._rttManager.textureWidth;
            this._filters[_loc1_].textureHeight = this._rttManager.textureHeight;
            _loc1_++;
         }
         this._filterSizesInvalid = false;
      }
      
      public function dispose() : void
      {
         this._rttManager.removeEventListener(Event.RESIZE,this.onRTTResize);
         this._rttManager = null;
         this._stage3DProxy.removeEventListener(Stage3DEvent.CONTEXT3D_RECREATED,this.onContext3DRecreated);
         this._stage3DProxy = null;
      }
   }
}

