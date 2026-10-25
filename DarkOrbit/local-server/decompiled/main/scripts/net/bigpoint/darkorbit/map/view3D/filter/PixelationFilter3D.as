package net.bigpoint.darkorbit.map.view3D.filter
{
   import away3d.filters.Filter3DBase;
   
   public class PixelationFilter3D extends Filter3DBase
   {
      
      private var _pixelationTask:Filter3DPixelationTask;
      
      public function PixelationFilter3D(param1:Number = 2)
      {
         super();
         this._pixelationTask = new Filter3DPixelationTask();
         this._pixelationTask.pixelSize = param1;
         addTask(this._pixelationTask);
      }
      
      public function get pixelSize() : Number
      {
         return this._pixelationTask.pixelSize;
      }
      
      public function set pixelSize(param1:Number) : void
      {
         if(this._pixelationTask.pixelSize == param1)
         {
            return;
         }
         this._pixelationTask.pixelSize = param1;
      }
   }
}

