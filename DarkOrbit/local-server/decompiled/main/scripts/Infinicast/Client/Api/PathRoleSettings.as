package Infinicast.Client.Api
{
   import Infinicast.*;
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
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   
   public class PathRoleSettings
   {
      
      public var sendMessage:*;
      
      public var receiveMessage:*;
      
      public var validateMessage:*;
      
      public var requiresMessageValidation:*;
      
      public var readMessageListenerList:*;
      
      public var sendRequest:*;
      
      public var answerRequest:*;
      
      public var readRequestListenerList:*;
      
      public var writeData:*;
      
      public var readData:*;
      
      public var validateData:*;
      
      public var requiresDataValidation:*;
      
      public var readDataListenerList:*;
      
      public function PathRoleSettings()
      {
         super();
      }
      
      public function allowAllMessage() : PathRoleSettings
      {
         this.sendMessage = true;
         this.receiveMessage = true;
         this.validateMessage = true;
         this.readMessageListenerList = true;
         return this;
      }
      
      public function allowAllRequest() : PathRoleSettings
      {
         this.sendRequest = true;
         this.answerRequest = true;
         this.readRequestListenerList = true;
         return this;
      }
      
      public function allowAllData() : PathRoleSettings
      {
         this.writeData = true;
         this.readData = true;
         this.validateData = true;
         this.readDataListenerList = true;
         return this;
      }
      
      public function allowAll() : PathRoleSettings
      {
         this.allowAllMessage();
         this.allowAllRequest();
         this.allowAllData();
         return this;
      }
      
      public function denyAllMessage() : PathRoleSettings
      {
         this.sendMessage = false;
         this.receiveMessage = false;
         this.validateMessage = false;
         this.readMessageListenerList = false;
         return this;
      }
      
      public function denyAllRequest() : PathRoleSettings
      {
         this.sendRequest = false;
         this.answerRequest = false;
         this.readRequestListenerList = false;
         return this;
      }
      
      public function denyAllData() : PathRoleSettings
      {
         this.writeData = false;
         this.readData = false;
         this.validateData = false;
         this.readDataListenerList = false;
         return this;
      }
      
      public function allowAllListenerLists() : PathRoleSettings
      {
         this.readMessageListenerList = true;
         this.readDataListenerList = true;
         this.readRequestListenerList = true;
         return this;
      }
      
      public function denyAllListenerLists() : PathRoleSettings
      {
         this.readMessageListenerList = false;
         this.readDataListenerList = false;
         this.readRequestListenerList = false;
         return this;
      }
      
      public function denyAll() : PathRoleSettings
      {
         this.denyAllMessage();
         this.denyAllRequest();
         this.denyAllData();
         return this;
      }
      
      public function toJson() : *
      {
         var _loc1_:* = new Object();
         if(this.sendMessage != null)
         {
            _loc1_["sendMessage"] = this.sendMessage;
         }
         if(this.receiveMessage != null)
         {
            _loc1_["receiveMessage"] = this.receiveMessage;
         }
         if(this.validateMessage != null)
         {
            _loc1_["validateMessage"] = this.validateMessage;
         }
         if(this.requiresMessageValidation != null)
         {
            _loc1_["requiresMessageValidation"] = this.requiresMessageValidation;
         }
         if(this.readMessageListenerList != null)
         {
            _loc1_["readMessageListenerList"] = this.readMessageListenerList;
         }
         if(this.sendRequest != null)
         {
            _loc1_["sendRequest"] = this.sendRequest;
         }
         if(this.answerRequest != null)
         {
            _loc1_["answerRequest"] = this.answerRequest;
         }
         if(this.readRequestListenerList != null)
         {
            _loc1_["readRequestListenerList"] = this.readRequestListenerList;
         }
         if(this.writeData != null)
         {
            _loc1_["writeData"] = this.writeData;
         }
         if(this.readData != null)
         {
            _loc1_["readData"] = this.readData;
         }
         if(this.validateData != null)
         {
            _loc1_["validateData"] = this.validateData;
         }
         if(this.requiresDataValidation != null)
         {
            _loc1_["requiresDataValidation"] = this.requiresDataValidation;
         }
         if(this.readDataListenerList != null)
         {
            _loc1_["readDataListenerList"] = this.readDataListenerList;
         }
         return _loc1_;
      }
   }
}

