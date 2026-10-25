package net.bigpoint.darkorbit.map.view3D.loaders
{
   import flash.utils.Dictionary;
   import net.bigpoint.darkorbit.map.view3D.utils.usage.UsageGroup;
   
   public class AbstractLoader
   {
      
      protected const _loaders:Dictionary = new Dictionary();
      
      protected var _pool:UsageGroup = new UsageGroup();
      
      public function AbstractLoader(param1:Function = null, param2:Number = 0)
      {
         super();
         this._pool = new UsageGroup(param2);
         if(param1 != null)
         {
            this._pool.notUsed.add(param1);
         }
         this.reset(0);
      }
      
      public function reset(param1:uint) : void
      {
         this._pool.reset();
      }
      
      public function useObj(param1:Object) : void
      {
         if(param1)
         {
            this._pool.getUsage(param1).increase();
         }
      }
      
      public function freeObj(param1:Object) : void
      {
         if(param1)
         {
            this._pool.getUsage(param1).decrease();
         }
      }
      
      public function get objectsCount() : int
      {
         return this._pool.objectsCount;
      }
   }
}

