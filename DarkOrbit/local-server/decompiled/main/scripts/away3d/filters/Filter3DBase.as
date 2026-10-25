package away3d.filters
{
   import away3d.cameras.*;
   import away3d.core.managers.*;
   import away3d.filters.tasks.*;
   import flash.display3D.textures.*;
   
   public class Filter3DBase
   {
      
      private var _tasks:Vector.<Filter3DTaskBase>;
      
      private var _requireDepthRender:Boolean;
      
      private var _textureWidth:int;
      
      private var _textureHeight:int;
      
      public function Filter3DBase()
      {
         super();
         this._tasks = new Vector.<Filter3DTaskBase>();
      }
      
      public function get requireDepthRender() : Boolean
      {
         return this._requireDepthRender;
      }
      
      protected function addTask(param1:Filter3DTaskBase) : void
      {
         this._tasks.push(param1);
         this._requireDepthRender = this._requireDepthRender || param1.requireDepthRender;
      }
      
      public function get tasks() : Vector.<Filter3DTaskBase>
      {
         return this._tasks;
      }
      
      public function getMainInputTexture(param1:Stage3DProxy) : TextureBase
      {
         return this._tasks[0].getMainInputTexture(param1);
      }
      
      public function get textureWidth() : int
      {
         return this._textureWidth;
      }
      
      public function set textureWidth(param1:int) : void
      {
         this._textureWidth = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._tasks.length)
         {
            this._tasks[_loc2_].textureWidth = param1;
            _loc2_++;
         }
      }
      
      public function get textureHeight() : int
      {
         return this._textureHeight;
      }
      
      public function set textureHeight(param1:int) : void
      {
         this._textureHeight = param1;
         var _loc2_:int = 0;
         while(_loc2_ < this._tasks.length)
         {
            this._tasks[_loc2_].textureHeight = param1;
            _loc2_++;
         }
      }
      
      public function setRenderTargets(param1:Texture, param2:Stage3DProxy) : void
      {
         this._tasks[this._tasks.length - 1].target = param1;
      }
      
      public function dispose() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._tasks.length)
         {
            this._tasks[_loc1_].dispose();
            _loc1_++;
         }
      }
      
      public function update(param1:Stage3DProxy, param2:Camera3D) : void
      {
      }
   }
}

