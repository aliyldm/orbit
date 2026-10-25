package Infinicast.Client.Api.Paths
{
   import Infinicast.Client.Api.Query.SortCriteria;
   
   public interface IChildrenQuery
   {
      
      function filterInData(param1:*) : IChildrenQuery;
      
      function limit(param1:int) : IChildrenQuery;
      
      function start(param1:int) : IChildrenQuery;
      
      function orderByData(param1:SortCriteria) : IChildrenQuery;
      
      function add(param1:*, param2:Function) : void;
      
      function addOrFindOne(param1:*, param2:Function) : void;
      
      function setData(param1:*, param2:Function = null) : void;
      
      function modifyAndGetData(param1:AtomicChange, param2:Function) : void;
      
      function remove(param1:Function = null) : void;
      
      function first(param1:Function) : void;
      
      function toList(param1:Function) : void;
      
      function onAdd(param1:Function, param2:Function = null) : void;
      
      function onChange(param1:Function, param2:Function = null) : void;
      
      function onDelete(param1:Function, param2:Function = null) : void;
      
      function live(param1:Function, param2:Function, param3:Function, param4:Function = null) : void;
   }
}

