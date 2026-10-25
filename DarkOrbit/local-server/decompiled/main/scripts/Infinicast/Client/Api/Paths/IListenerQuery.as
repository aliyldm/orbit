package Infinicast.Client.Api.Paths
{
   public interface IListenerQuery
   {
      
      function filterRole(param1:String) : IListenerQuery;
      
      function filterType(param1:int) : IListenerQuery;
      
      function toList(param1:Function) : void;
      
      function onStart(param1:Function, param2:Function = null) : void;
      
      function onDataChange(param1:Function, param2:Function = null) : void;
      
      function onEnd(param1:Function, param2:Function = null) : void;
      
      function live(param1:Function, param2:Function, param3:Function = null, param4:Function = null) : void;
   }
}

