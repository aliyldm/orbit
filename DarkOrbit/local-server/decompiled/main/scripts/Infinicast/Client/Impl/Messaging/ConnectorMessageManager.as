package Infinicast.Client.Impl.Messaging
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
   
   public class ConnectorMessageManager implements IEndpoint2ServerNetLayerHandler
   {
      
      private var _connector2EpsProtocol:Connector2EpsProtocol = new Connector2EpsProtocol();
      
      private var _receiver:IMessageReceiver = new ConnectorMessageReceiver();
      
      private var _connector:IConnector;
      
      private var _requestId:int = 1;
      
      private var _sender:IMessageSender;
      
      private var requestIdLock:LockObject = new LockObject();
      
      public function ConnectorMessageManager()
      {
         super();
      }
      
      public function onConnect() : void
      {
         this.sendInitMessage(this._connector.getSpace(),this._connector.getRole(),this._connector.getCredentials());
      }
      
      public function onReceiveFromServer(param1:APlayStringMessage) : void
      {
         this.getReceiver().receive(param1);
      }
      
      public function onDisconnect() : void
      {
         this._connector.triggerDisconnect();
      }
      
      public function onPing(param1:int, param2:int) : void
      {
         this._connector.receivedPing(param1,param2);
      }
      
      public function setSender(param1:IMessageSender) : void
      {
         this._sender = param1;
      }
      
      public function sendMessageWithResponseString(param1:int, param2:String, param3:*, param4:Function) : void
      {
         var messageType:int = param1;
         var pathString:String = param2;
         var data:* = param3;
         var responseHandler:Function = param4;
         var self:ConnectorMessageManager = this;
         var messageRequestId:int = this.getRequestId();
         this._receiver.addResponseHandler(0,ObjectExtensions.toString(messageRequestId),function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            responseHandler(param1,param2,param3);
         });
         this._sender.sendMessage(this._connector2EpsProtocol.encodeMessageWithResponse(messageType,pathString,data,messageRequestId));
      }
      
      public function sendMessageWithResponse(param1:int, param2:IPath, param3:*, param4:Function) : void
      {
         var _loc5_:String = "";
         if(param2 != null)
         {
            _loc5_ = param2.toString();
         }
         this.sendMessageWithResponseString(param1,_loc5_,param3,param4);
      }
      
      private function getRequestId() : int
      {
         var _loc1_:int = 0;
         return int(++this._requestId);
      }
      
      public function sendInitMessage(param1:String, param2:String, param3:*) : void
      {
         this._sender.sendMessage(this._connector2EpsProtocol.encodeInitConnector(param1,param2,param3));
      }
      
      public function sendRequestAnswer(param1:int, param2:IPath, param3:*, param4:String, param5:int) : void
      {
         this._sender.sendMessage(this._connector2EpsProtocol.encodeMessageWithRequestId(param1,param2.toString(),param3,param4,param5));
      }
      
      public function sendMessageString(param1:int, param2:String, param3:*) : void
      {
         this._sender.sendMessage(this._connector2EpsProtocol.encodeMessage(param1,param2,param3));
      }
      
      public function sendMessage(param1:int, param2:IPath, param3:*) : void
      {
         this.sendMessageString(param1,param2.toString(),param3);
      }
      
      public function sendValidatedMessage(param1:int, param2:IPath, param3:*, param4:String) : void
      {
         this._sender.sendMessage(this._connector2EpsProtocol.encodeValidatedMessage(param1,param2.toString(),param3,param4));
      }
      
      public function addHandler(param1:Boolean, param2:int, param3:IPath, param4:Function, param5:Function, param6:HandlerRegistrationOptionsData, param7:Function = null) : void
      {
         var sticky:*;
         var terminationHandler:Boolean;
         var listeningType:int;
         var roleFilter:String;
         var self:ConnectorMessageManager = null;
         var messageRequestId:int = 0;
         var isDelete:Boolean = param1;
         var messageType:int = param2;
         var path:IPath = param3;
         var handler:Function = param4;
         var completeCallback:Function = param5;
         var options:HandlerRegistrationOptionsData = param6;
         var listenTerminationHandler:Function = param7;
         self = this;
         var consomeOnePerRole:* = null;
         if(options != null)
         {
            consomeOnePerRole = options.isOncePerRole;
         }
         sticky = null;
         if(options != null && options.isSticky)
         {
            sticky = true;
         }
         terminationHandler = listenTerminationHandler != null;
         listeningType = 0;
         if(options != null)
         {
            listeningType = options.listenerType;
         }
         roleFilter = "";
         if(options != null && !StringExtensions.IsNullOrEmpty(options.roleFilter))
         {
            roleFilter = options.roleFilter;
         }
         if(isDelete)
         {
            this._receiver.removeHandlers(Connector2EpsMessageType.toString(messageType) + "_ListenTerminate",path.toString());
            if(!this._receiver.removeHandlers(Connector2EpsMessageType.toString(messageType),path.toString()))
            {
               completeCallback(null);
               return;
            }
            messageRequestId = this.getRequestId();
            this._sender.sendMessage(this._connector2EpsProtocol.encodeRemoveHandlerMessage(path.toString(),messageType,messageRequestId,""));
         }
         else
         {
            messageRequestId = this.getRequestId();
         }
         this._receiver.addResponseHandler(0,ObjectExtensions.toString(messageRequestId),function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            if(param2 != null)
            {
               if(completeCallback != null)
               {
                  completeCallback(param2);
               }
               else
               {
                  self.getConnector().unhandeledErrorInfo(path,param2);
               }
            }
            else if(completeCallback != null)
            {
               completeCallback(null);
            }
         });
         if(!isDelete)
         {
            this._sender.sendMessage(this._connector2EpsProtocol.encodeRegisterHandlerMessage(messageType,path.toString(),messageRequestId,consomeOnePerRole,sticky,listeningType,roleFilter,terminationHandler));
            this._receiver.addHandler(Connector2EpsMessageType.toString(messageType),path,handler);
            if(listenTerminationHandler != null)
            {
               this._receiver.addHandler(Connector2EpsMessageType.toString(messageType) + "_ListenTerminate",path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
               {
                  self._receiver.removeHandlers(Connector2EpsMessageType.toString(messageType),path.toString());
                  Console.writeLine("Listenterminate received " + JSON.stringify(param1));
                  var _loc5_:APathContext = new APathContext();
                  _loc5_.path = param3.path;
                  var _loc6_:int = ListenTerminateReason.parse(String(param1["reason"]));
                  listenTerminationHandler(_loc6_,_loc5_);
               });
            }
         }
      }
      
      public function registerHandler(param1:int, param2:IPath, param3:Function) : void
      {
         if(param3 != null)
         {
            this._receiver.addHandler(Connector2EpsMessageType.toString(param1),param2,param3);
         }
         else
         {
            this._receiver.removeHandlers(Connector2EpsMessageType.toString(param1),param2.toString());
         }
      }
      
      public function getReceiver() : IMessageReceiver
      {
         return this._receiver;
      }
      
      public function setConnector(param1:IConnector) : void
      {
         this._connector = param1;
         this.getReceiver().setConnector(param1);
      }
      
      public function getConnector() : IConnector
      {
         return this._connector;
      }
      
      public function sendDebugPingInfo(param1:IPath, param2:int) : void
      {
         this._sender.sendMessage(this._connector2EpsProtocol.encodeDebugPingInfo(param1.toString(),param2));
      }
      
      public function sendDebugMessage(param1:IPath, param2:int, param3:*) : void
      {
      }
      
      public function sendUpdateDebugStatistics(param1:*, param2:Function) : void
      {
         var filters:* = param1;
         var handler:Function = param2;
         var self:ConnectorMessageManager = this;
         var messageRequestId:int = this.getRequestId();
         this._receiver.addResponseHandler(0,ObjectExtensions.toString(messageRequestId),function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            handler(param1);
         });
         this._sender.sendMessage(this._connector2EpsProtocol.encodeMessageWithResponse(25,"",filters,messageRequestId));
      }
      
      public function destroy() : void
      {
         this._receiver.destroy();
         this._sender.destroy();
      }
   }
}

