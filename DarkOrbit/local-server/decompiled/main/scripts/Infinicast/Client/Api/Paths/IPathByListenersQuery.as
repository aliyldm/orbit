package Infinicast.Client.Api.Paths
{
   public interface IPathByListenersQuery
   {
      
      function start(param1:int) : IPathByListenersQuery;
      
      function limit(param1:int) : IPathByListenersQuery;
      
      function toList(param1:Function) : void;
   }
}

