package Infinicast.Runtime
{
   public class Promise implements IPromise
   {
      
      private static var Factory:Function;
      
      private var innerPromise:IPromise;
      
      public function Promise()
      {
         super();
         this.innerPromise = Promise.Factory();
      }
      
      public function reject(param1:Object) : void
      {
         this.innerPromise.reject(param1);
      }
      
      public function resolve(param1:Object) : void
      {
         this.innerPromise.resolve(param1);
      }
      
      public function getData() : Object
      {
         return this.innerPromise.getData();
      }
   }
}

