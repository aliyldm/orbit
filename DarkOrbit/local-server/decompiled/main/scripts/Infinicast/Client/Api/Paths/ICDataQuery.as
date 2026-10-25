package Infinicast.Client.Api.Paths
{
   import Infinicast.*;
   import Infinicast.Client.Api.*;
   import Infinicast.Client.Api.Errors.*;
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
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class ICDataQuery
   {
      
      private var _dataFilters:Vector.<ICDataFilter>;
      
      private var _limit:int;
      
      private var _start:int;
      
      private var _orderCriteria:SortCriteria;
      
      public function ICDataQuery()
      {
         super();
         this.dataFilters = new Vector.<ICDataFilter>();
         this.limit = -1;
         this.start = -1;
      }
      
      public function toJson() : *
      {
         var _loc3_:ICDataFilter = null;
         var _loc1_:* = new Object();
         var _loc2_:Vector.<Object> = new Vector.<Object>();
         for each(_loc3_ in this.dataFilters)
         {
            _loc2_.push(_loc3_.toJson());
         }
         _loc1_["filters"] = _loc2_;
         if(this.limit != -1)
         {
            _loc1_["limit"] = this.limit;
         }
         if(this.start != -1)
         {
            _loc1_["start"] = this.start;
         }
         if(this.orderCriteria != null)
         {
            _loc1_["order"] = this.orderCriteria.field;
            if(this.orderCriteria.isAscending)
            {
               _loc1_["orderAsc"] = this.orderCriteria.isAscending;
            }
         }
         return _loc1_;
      }
      
      public function get dataFilters() : Vector.<ICDataFilter>
      {
         return this._dataFilters;
      }
      
      public function set dataFilters(param1:Vector.<ICDataFilter>) : void
      {
         this._dataFilters = param1;
      }
      
      public function get limit() : int
      {
         return this._limit;
      }
      
      public function set limit(param1:int) : void
      {
         this._limit = param1;
      }
      
      public function get start() : int
      {
         return this._start;
      }
      
      public function set start(param1:int) : void
      {
         this._start = param1;
      }
      
      public function get orderCriteria() : SortCriteria
      {
         return this._orderCriteria;
      }
      
      public function set orderCriteria(param1:SortCriteria) : void
      {
         this._orderCriteria = param1;
      }
   }
}

