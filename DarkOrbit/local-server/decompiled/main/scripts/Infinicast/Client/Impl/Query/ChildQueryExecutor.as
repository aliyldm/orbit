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
   
   public class ChildQueryExecutor extends BaseQueryExecutor
   {
      
      public function ChildQueryExecutor(param1:IConnector, param2:IPath, param3:ConnectorMessageManager)
      {
         super(param1,param2,param3);
      }
      
      public function setChildrenData(param1:ICDataQuery, param2:*, param3:Function = null) : void
      {
         var messageManager:ConnectorMessageManager;
         var self:ChildQueryExecutor = null;
         var query:ICDataQuery = param1;
         var data:* = param2;
         var completeCallback:Function = param3;
         self = this;
         var parameters:* = new Object();
         parameters["query"] = query.toJson();
         parameters["data"] = data;
         messageManager = super._messageManager;
         messageManager.sendMessageWithResponse(31,super._path,parameters,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               if(completeCallback != null)
               {
                  completeCallback(param1,0);
               }
               else
               {
                  self._connector.unhandeledErrorInfo(self._path,param1);
               }
            }))
            {
               if(completeCallback != null)
               {
                  completeCallback(null,int(json["fullCount"]));
               }
            }
         });
      }
      
      public function findChildren(param1:ICDataQuery, param2:Function) : void
      {
         var messageManager:ConnectorMessageManager;
         var self:ChildQueryExecutor = null;
         var query:ICDataQuery = param1;
         var callback:Function = param2;
         self = this;
         var data:* = new Object();
         data["query"] = query.toJson();
         messageManager = super._messageManager;
         messageManager.sendMessageWithResponse(3,super._path,ObjectExtensions.clone(data),function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var list:Vector.<IPathAndData> = null;
            var fullCount:int = 0;
            var array:Vector.<Object> = null;
            var ob:* = undefined;
            var pathAndData:PathAndData = null;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               callback(param1,null,0);
            }))
            {
               list = new Vector.<IPathAndData>();
               fullCount = int(json["fullCount"]);
               array = Vector.<Object>(json["list"]);
               for each(ob in array)
               {
                  pathAndData = new PathAndData();
                  pathAndData.path = self._connector.getObjectStateManager().getOrCreateLocalObject(String(ob["path"]));
                  pathAndData.data = ob["data"];
                  list.push(pathAndData);
               }
               callback(null,list,fullCount);
            }
         });
      }
      
      public function addChild(param1:*, param2:String, param3:Function) : void
      {
         var self:ChildQueryExecutor = null;
         var objectData:* = param1;
         var requestedIdentifier:String = param2;
         var callback:Function = param3;
         self = this;
         var data:* = new Object();
         data["requestedIdentifier"] = requestedIdentifier;
         data["data"] = objectData;
         super._messageManager.sendMessageWithResponse(4,super._path,ObjectExtensions.clone(data),function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               callback(param1,null,null);
            }))
            {
               callback(null,json["data"],self.getPathAndEndpointContext(context));
            }
         });
      }
      
      public function findOneOrAddChild(param1:ICDataQuery, param2:*, param3:Function) : void
      {
         var self:ChildQueryExecutor = null;
         var query:ICDataQuery = param1;
         var newObjectValue:* = param2;
         var action:Function = param3;
         self = this;
         var parameters:* = new Object();
         parameters["data"] = newObjectValue;
         parameters["query"] = query.toJson();
         super._messageManager.sendMessageWithResponse(19,super._path,parameters,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var data:* = undefined;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               action(param1,null,null,false);
            }))
            {
               data = json["data"];
               action(null,data["data"],self.getPathAndEndpointContext(context),Boolean(json["newlyCreated"]));
            }
         });
      }
      
      public function modifyAndGetChildrenData(param1:ICDataQuery, param2:AtomicChange, param3:Function) : void
      {
         var messageManager:ConnectorMessageManager;
         var self:ChildQueryExecutor = null;
         var query:ICDataQuery = param1;
         var data:AtomicChange = param2;
         var callback:Function = param3;
         self = this;
         var parameters:* = new Object();
         parameters["query"] = query.toJson();
         parameters["changes"] = data.toJson();
         if(data.hasNamedQueries())
         {
            parameters["named"] = data.getNamedQueryJson();
         }
         messageManager = super._messageManager;
         messageManager.sendMessageWithResponse(32,super._path,parameters,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var list:Vector.<IPathAndData> = null;
            var fullCount:int = 0;
            var array:Vector.<Object> = null;
            var ob:* = undefined;
            var pathAndData:PathAndData = null;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               callback(param1,null,0);
            }))
            {
               list = new Vector.<IPathAndData>();
               fullCount = int(json["fullCount"]);
               array = Vector.<Object>(json["list"]);
               for each(ob in array)
               {
                  pathAndData = new PathAndData();
                  pathAndData.path = self._connector.getObjectStateManager().getOrCreateLocalObject(String(ob["path"]));
                  pathAndData.data = ob["data"];
                  list.push(pathAndData);
               }
               callback(null,list,fullCount);
            }
         });
      }
      
      public function removeChildren(param1:ICDataQuery, param2:Function = null) : void
      {
         var messageManager:ConnectorMessageManager;
         var self:ChildQueryExecutor = null;
         var query:ICDataQuery = param1;
         var completeCallback:Function = param2;
         self = this;
         var parameters:* = new Object();
         parameters["query"] = query.toJson();
         messageManager = super._messageManager;
         messageManager.sendMessageWithResponse(33,super._path,parameters,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               if(completeCallback != null)
               {
                  completeCallback(param1,0);
               }
               else
               {
                  self._connector.unhandeledErrorInfo(self._path,param1);
               }
            }))
            {
               if(completeCallback != null)
               {
                  completeCallback(null,int(json["count"]));
               }
            }
         });
      }
      
      public function getAndListenOnChilden(param1:ICDataQuery, param2:Boolean, param3:Function, param4:Function, param5:Function, param6:Boolean, param7:Boolean, param8:Function = null) : void
      {
         var self:ChildQueryExecutor = null;
         var query:ICDataQuery = param1;
         var isRemove:Boolean = param2;
         var onAdd:Function = param3;
         var onChange:Function = param4;
         var onRemove:Function = param5;
         var isOncePerRole:Boolean = param6;
         var isSticky:Boolean = param7;
         var registrationCompleteCallback:Function = param8;
         self = this;
         var parameters:* = new Object();
         parameters["query"] = query.toJson();
         if(isRemove)
         {
            parameters["remove"] = true;
         }
         if(isOncePerRole)
         {
            parameters["once"] = true;
         }
         if(isSticky)
         {
            parameters["sticky"] = true;
         }
         super._messageManager.sendMessageWithResponse(38,super._path,parameters,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var array:Vector.<Object> = null;
            var ob:* = undefined;
            var ctx:PathAndEndpointContext = null;
            var d:* = undefined;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               if(registrationCompleteCallback != null)
               {
                  registrationCompleteCallback(param1);
               }
            }))
            {
               array = Vector.<Object>(json["list"]);
               for each(ob in array)
               {
                  ctx = new PathAndEndpointContext(self._connector.path(String(ob["path"])),context.endpoint,context.endpointData);
                  d = ob["data"];
                  onAdd(d,ctx);
               }
               if(registrationCompleteCallback != null)
               {
                  registrationCompleteCallback(null);
               }
            }
         });
         if(!isRemove)
         {
            super._messageManager.registerHandler(10,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
            {
               if(onAdd != null)
               {
                  onAdd(param1,param3);
               }
            });
            super._messageManager.registerHandler(12,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
            {
               if(onChange != null)
               {
                  onChange(param1,param3);
               }
            });
            super._messageManager.registerHandler(11,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
            {
               if(onRemove != null)
               {
                  onRemove(param1,param3);
               }
            });
         }
         else
         {
            super._messageManager.registerHandler(10,super._path,null);
            super._messageManager.registerHandler(11,super._path,null);
            super._messageManager.registerHandler(12,super._path,null);
         }
      }
      
      public function onChildAdd(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         this.onChildHandler(param1,param2,param3,10);
      }
      
      public function onChildChange(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         this.onChildHandler(param1,param2,param3,12);
      }
      
      public function onChildDelete(param1:Function, param2:HandlerRegistrationOptions = null, param3:Function = null) : void
      {
         this.onChildHandler(param1,param2,param3,11);
      }
      
      private function onChildHandler(param1:Function, param2:HandlerRegistrationOptions, param3:Function, param4:int) : void
      {
         var callback:Function = param1;
         var options:HandlerRegistrationOptions = param2;
         var completeCallback:Function = param3;
         var connector2EpsMessageType:int = param4;
         var self:ChildQueryExecutor = this;
         super._messageManager.addHandler(callback == null,connector2EpsMessageType,super._path,function(param1:*, param2:ICError, param3:IPathAndEndpointContext, param4:int):void
         {
            if(param1 != null)
            {
               Console.writeLine(Connector2EpsMessageType.toString(connector2EpsMessageType) + " " + JSON.stringify(param1) + " " + param3.path.toString());
            }
            else
            {
               Console.writeLine(Connector2EpsMessageType.toString(connector2EpsMessageType) + " null " + param3.path.toString());
            }
            callback(param1,param3);
         },completeCallback,options);
      }
   }
}

