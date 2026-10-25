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
   
   public class InternAtomicChange
   {
      
      public var json:*;
      
      public function InternAtomicChange()
      {
         super();
         this.json = new Object();
      }
      
      public function setData1(param1:*) : void
      {
         this.json["data"] = param1;
      }
      
      public function setData2(param1:Vector.<Object>) : void
      {
         this.json["data"] = param1;
      }
      
      public function setData3(param1:String) : void
      {
         this.json["data"] = param1;
      }
      
      public function setData4(param1:int) : void
      {
         this.json["data"] = param1;
      }
      
      public function setData5(param1:int) : void
      {
         this.json["data"] = param1;
      }
      
      public function setData6(param1:Number) : void
      {
         this.json["data"] = param1;
      }
      
      public function setData7(param1:Number) : void
      {
         this.json["data"] = param1;
      }
      
      public function setData8(param1:Boolean) : void
      {
         this.json["data"] = param1;
      }
      
      public function toJson() : *
      {
         return this.json;
      }
      
      public function setData(param1:*) : void
      {
         if(param1 is Object)
         {
            this.setData1(param1);
         }
         else if(param1 is Vector.<Object>)
         {
            this.setData2(Vector.<Object>(param1));
         }
         else if(param1 is String)
         {
            this.setData3(String(param1));
         }
         else if(param1 is int)
         {
            this.setData4(int(param1));
         }
         else if(param1 is int)
         {
            this.setData5(int(param1));
         }
         else if(param1 is Number)
         {
            this.setData6(Number(param1));
         }
         else if(param1 is Number)
         {
            this.setData7(Number(param1));
         }
         else
         {
            if(!(param1 is Boolean))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.setData8(Boolean(param1));
         }
      }
      
      public function get jsonProperty() : String
      {
         return String(this.json["property"]);
      }
      
      public function set jsonProperty(param1:String) : void
      {
         this.json["property"] = param1;
      }
      
      public function get type() : int
      {
         return AtomicChangeType.parse(String(this.json["type"]));
      }
      
      public function set type(param1:int) : void
      {
         this.json["type"] = AtomicChangeType.toString(param1);
      }
   }
}

