package Infinicast.Client.Impl.Query
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
   import Infinicast.Client.Api.Errors.*;
   import Infinicast.Client.Api.Paths.*;
   import Infinicast.Client.Api.Paths.Handler.*;
   import Infinicast.Client.Api.Paths.Handler.Lists.*;
   import Infinicast.Client.Api.Paths.Handler.Messages.*;
   import Infinicast.Client.Api.Paths.Handler.Objects.*;
   import Infinicast.Client.Api.Paths.Handler.Reminders.*;
   import Infinicast.Client.Api.Paths.Handler.Requests.*;
   import Infinicast.Client.Api.Paths.Options.*;
   import Infinicast.Client.Api.Paths.TaskObjects.*;
   import Infinicast.Client.Api.Query.*;
   import Infinicast.Client.Impl.*;
   import Infinicast.Client.Impl.Contexts.*;
   import Infinicast.Client.Impl.Helper.*;
   import Infinicast.Client.Impl.Messaging.*;
   import Infinicast.Client.Impl.Messaging.Handlers.*;
   import Infinicast.Client.Impl.Messaging.Receiver.*;
   import Infinicast.Client.Impl.Messaging.sender.*;
   import Infinicast.Client.Impl.ObjectState.*;
   import Infinicast.Client.Impl.PathAccess.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class ChildrenQuery implements IChildrenQuery
   {
      
      private var _executor:ChildQueryExecutor;
      
      private var _dataQuery:ICDataQuery;
      
      private var _path:IPath;
      
      public function ChildrenQuery(param1:IPath, param2:ChildQueryExecutor)
      {
         super();
         this._dataQuery = new ICDataQuery();
         this._path = param1;
         this._executor = param2;
      }
      
      public function filterInData1(param1:Filter) : IChildrenQuery
      {
         this._dataQuery.dataFilters.push(ICDataFilter.fromFieldFilter(param1));
         return this;
      }
      
      public function filterInData2(param1:*) : IChildrenQuery
      {
         this._dataQuery.dataFilters.push(ICDataFilter.fromJObject(param1));
         return this;
      }
      
      public function orderByData(param1:SortCriteria) : IChildrenQuery
      {
         this._dataQuery.orderCriteria = param1;
         return this;
      }
      
      public function limit(param1:int) : IChildrenQuery
      {
         this._dataQuery.limit = param1;
         return this;
      }
      
      public function start(param1:int) : IChildrenQuery
      {
         this._dataQuery.start = param1;
         return this;
      }
      
      public function add(param1:*, param2:Function) : void
      {
         this._executor.addChild(param1,null,param2);
      }
      
      public function addOrFindOne(param1:*, param2:Function) : void
      {
         this._executor.findOneOrAddChild(this.getQuery(),param1,param2);
      }
      
      public function setData(param1:*, param2:Function = null) : void
      {
         this._executor.setChildrenData(this.getQuery(),param1,param2);
      }
      
      public function toList(param1:Function) : void
      {
         this._executor.findChildren(this.getQuery(),param1);
      }
      
      public function modifyAndGetData(param1:AtomicChange, param2:Function) : void
      {
         this._executor.modifyAndGetChildrenData(this.getQuery(),param1,param2);
      }
      
      public function remove(param1:Function = null) : void
      {
         this._executor.removeChildren(this.getQuery(),param1);
      }
      
      public function first(param1:Function) : void
      {
         var result:Function = param1;
         var self:ChildrenQuery = this;
         this._dataQuery.limit = 1;
         this.toList(function(param1:ICError, param2:Vector.<IPathAndData>, param3:int):void
         {
            if(param1 != null)
            {
               result(param1,null);
            }
            else if(param2 == null || param2.length < 1)
            {
               result(null,null);
            }
            else
            {
               result(null,param2[0]);
            }
         });
      }
      
      public function onAdd(param1:Function, param2:Function = null) : void
      {
         var self:ChildrenQuery = null;
         var handler:Function = param1;
         var completeCallback:Function = param2;
         self = this;
         this._executor.onChildAdd(function(param1:*, param2:IPathAndEndpointContext):void
         {
            handler(param1,param2);
         },null,function(param1:ICError):void
         {
            self.useCompletionCallback(completeCallback,param1);
         });
      }
      
      public function onChange(param1:Function, param2:Function = null) : void
      {
         var self:ChildrenQuery = null;
         var handler:Function = param1;
         var completeCallback:Function = param2;
         self = this;
         this._executor.onChildChange(function(param1:*, param2:IPathAndEndpointContext):void
         {
            handler(param1,param2);
         },null,function(param1:ICError):void
         {
            self.useCompletionCallback(completeCallback,param1);
         });
      }
      
      public function onDelete(param1:Function, param2:Function = null) : void
      {
         var self:ChildrenQuery = null;
         var handler:Function = param1;
         var completeCallback:Function = param2;
         self = this;
         this._executor.onChildDelete(function(param1:*, param2:IPathAndEndpointContext):void
         {
            handler(param1,param2);
         },null,function(param1:ICError):void
         {
            self.useCompletionCallback(completeCallback,param1);
         });
      }
      
      public function live(param1:Function, param2:Function, param3:Function, param4:Function = null) : void
      {
         var self:ChildrenQuery = null;
         var onAdd:Function = param1;
         var onRemove:Function = param2;
         var onChange:Function = param3;
         var completeCallback:Function = param4;
         self = this;
         this._executor.getAndListenOnChilden(this.getQuery(),onAdd == null && onChange == null && onRemove == null,onAdd,onChange,onRemove,false,false,function(param1:ICError):void
         {
            self.useCompletionCallback(completeCallback,param1);
         });
      }
      
      public function filterInData(param1:*) : IChildrenQuery
      {
         if(param1 is Filter)
         {
            return this.filterInData1(Filter(param1));
         }
         if(param1 is Object)
         {
            return this.filterInData2(param1);
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      private function useCompletionCallback(param1:Function, param2:ICError) : void
      {
         if(param1 != null)
         {
            param1(param2);
         }
         else if(param2 != null)
         {
            this._executor.unhandeledError(param2);
         }
      }
      
      public function getQuery() : ICDataQuery
      {
         if(this._dataQuery == null)
         {
            return new ICDataQuery();
         }
         return this._dataQuery;
      }
   }
}

