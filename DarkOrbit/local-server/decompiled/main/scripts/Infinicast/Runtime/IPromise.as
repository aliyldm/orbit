package Infinicast.Runtime
{
   public interface IPromise
   {
      
      function reject(param1:Object) : void;
      
      function resolve(param1:Object) : void;
      
      function getData() : Object;
   }
}

