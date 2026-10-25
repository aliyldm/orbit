package Infinicast.Runtime
{
   public class ThreadPool
   {
      
      public function ThreadPool()
      {
         super();
      }
      
      public static function QueueUserWorkItem(param1:Function) : void
      {
         param1.call();
      }
   }
}

