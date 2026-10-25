package Infinicast.Client.Api.Query
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
   
   public class Filter
   {
      
      private var data:* = new Object();
      
      public function Filter()
      {
         super();
      }
      
      public static function field(param1:String) : Filter
      {
         var _loc2_:Filter = new Filter();
         _loc2_.data["field"] = param1;
         return _loc2_;
      }
      
      public function not() : Filter
      {
         this.data["not"] = true;
         return this;
      }
      
      public function eq1(param1:Boolean) : Filter
      {
         this.data["op"] = "eq";
         this.data["value"] = param1;
         return this;
      }
      
      public function eq2(param1:String) : Filter
      {
         this.data["op"] = "eq";
         this.data["value"] = param1;
         return this;
      }
      
      public function eq3(param1:int) : Filter
      {
         this.data["op"] = "eq";
         this.data["value"] = param1;
         return this;
      }
      
      public function eq4(param1:int) : Filter
      {
         this.data["op"] = "eq";
         this.data["value"] = param1;
         return this;
      }
      
      public function eq5(param1:Number) : Filter
      {
         this.data["op"] = "eq";
         this.data["value"] = param1;
         return this;
      }
      
      public function eq6(param1:Number) : Filter
      {
         this.data["op"] = "eq";
         this.data["value"] = param1;
         return this;
      }
      
      public function gt1(param1:Number) : Filter
      {
         this.data["op"] = "gt";
         this.data["value"] = param1;
         return this;
      }
      
      public function gt2(param1:Number) : Filter
      {
         this.data["op"] = "gt";
         this.data["value"] = param1;
         return this;
      }
      
      public function gt3(param1:int) : Filter
      {
         this.data["op"] = "gt";
         this.data["value"] = param1;
         return this;
      }
      
      public function gt4(param1:int) : Filter
      {
         this.data["op"] = "gt";
         this.data["value"] = param1;
         return this;
      }
      
      public function lt1(param1:Number) : Filter
      {
         this.data["op"] = "lt";
         this.data["value"] = param1;
         return this;
      }
      
      public function lt2(param1:Number) : Filter
      {
         this.data["op"] = "lt";
         this.data["value"] = param1;
         return this;
      }
      
      public function lt3(param1:int) : Filter
      {
         this.data["op"] = "lt";
         this.data["value"] = param1;
         return this;
      }
      
      public function lt4(param1:int) : Filter
      {
         this.data["op"] = "lt";
         this.data["value"] = param1;
         return this;
      }
      
      public function collectionContains1(param1:String) : Filter
      {
         this.data["op"] = "contains";
         this.data["value"] = param1;
         return this;
      }
      
      public function collectionContains2(param1:int) : Filter
      {
         this.data["op"] = "contains";
         this.data["value"] = param1;
         return this;
      }
      
      public function collectionContains3(param1:int) : Filter
      {
         this.data["op"] = "contains";
         this.data["value"] = param1;
         return this;
      }
      
      public function collectionContains4(param1:Number) : Filter
      {
         this.data["op"] = "contains";
         this.data["value"] = param1;
         return this;
      }
      
      public function collectionContains5(param1:Number) : Filter
      {
         this.data["op"] = "contains";
         this.data["value"] = param1;
         return this;
      }
      
      public function toJson() : *
      {
         return this.data;
      }
      
      public function eq(param1:*) : Filter
      {
         if(param1 is Boolean)
         {
            return this.eq1(Boolean(param1));
         }
         if(param1 is String)
         {
            return this.eq2(String(param1));
         }
         if(param1 is int)
         {
            return this.eq3(int(param1));
         }
         if(param1 is int)
         {
            return this.eq4(int(param1));
         }
         if(param1 is Number)
         {
            return this.eq5(Number(param1));
         }
         if(param1 is Number)
         {
            return this.eq6(Number(param1));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function gt(param1:*) : Filter
      {
         if(param1 is Number)
         {
            return this.gt1(Number(param1));
         }
         if(param1 is Number)
         {
            return this.gt2(Number(param1));
         }
         if(param1 is int)
         {
            return this.gt3(int(param1));
         }
         if(param1 is int)
         {
            return this.gt4(int(param1));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function lt(param1:*) : Filter
      {
         if(param1 is Number)
         {
            return this.lt1(Number(param1));
         }
         if(param1 is Number)
         {
            return this.lt2(Number(param1));
         }
         if(param1 is int)
         {
            return this.lt3(int(param1));
         }
         if(param1 is int)
         {
            return this.lt4(int(param1));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
      
      public function collectionContains(param1:*) : Filter
      {
         if(param1 is String)
         {
            return this.collectionContains1(String(param1));
         }
         if(param1 is int)
         {
            return this.collectionContains2(int(param1));
         }
         if(param1 is int)
         {
            return this.collectionContains3(int(param1));
         }
         if(param1 is Number)
         {
            return this.collectionContains4(Number(param1));
         }
         if(param1 is Number)
         {
            return this.collectionContains5(Number(param1));
         }
         throw new ArgumentError("Bad combination of parameter types");
      }
   }
}

