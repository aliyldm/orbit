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
   
   public class ICDataFilter
   {
      
      private var _dataFilterType:int;
      
      private var _content:*;
      
      public function ICDataFilter()
      {
         super();
      }
      
      public static function fromJObject(param1:*) : ICDataFilter
      {
         var _loc2_:ICDataFilter = new ICDataFilter();
         _loc2_.content = param1;
         _loc2_.dataFilterType = 1;
         return _loc2_;
      }
      
      public static function fromFieldFilter(param1:Filter) : ICDataFilter
      {
         var _loc2_:ICDataFilter = new ICDataFilter();
         _loc2_.content = param1.toJson();
         _loc2_.dataFilterType = 2;
         return _loc2_;
      }
      
      public function toJson() : *
      {
         var _loc1_:* = new Object();
         _loc1_["type"] = this.dataFilterType;
         _loc1_["content"] = this.content;
         return _loc1_;
      }
      
      public function get dataFilterType() : int
      {
         return this._dataFilterType;
      }
      
      public function set dataFilterType(param1:int) : void
      {
         this._dataFilterType = param1;
      }
      
      public function get content() : *
      {
         return this._content;
      }
      
      public function set content(param1:*) : void
      {
         this._content = param1;
      }
   }
}

