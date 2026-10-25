package Infinicast.Runtime
{
   public class HandlerPool
   {
      
      public function HandlerPool()
      {
         super();
      }
      
      public static function QueueHandlerCall(param1:Function) : void
      {
         ThreadPool.QueueUserWorkItem(param1);
      }
      
      public function Destroy() : void
      {
      }
      
      public function QueueHandlerCall(param1:Function) : void
      {
         ThreadPool.QueueUserWorkItem(param1);
      }
   }
}

