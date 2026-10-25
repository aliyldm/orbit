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
   
   public class ChildrenWithListenersQueryExecutor extends BaseQueryExecutor
   {
      
      public function ChildrenWithListenersQueryExecutor(param1:IConnector, param2:IPath, param3:ConnectorMessageManager)
      {
         super(param1,param2,param3);
      }
      
      public function getChildrenWithListeners(param1:Function, param2:int, param3:int) : void
      {
         var self:ChildrenWithListenersQueryExecutor = null;
         var callback:Function = param1;
         var start:int = param2;
         var limit:int = param3;
         self = this;
         var settings:* = new Object();
         if(start >= 0)
         {
            settings["start"] = start;
         }
         if(limit >= 0)
         {
            settings["limit"] = limit;
         }
         super._messageManager.sendMessageWithResponse(49,super._path,settings,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var array:Vector.<Object> = null;
            var resultList:Vector.<IPathAndCount> = null;
            var ob:* = undefined;
            var job:* = undefined;
            var path:String = null;
            var count:int = 0;
            var ele:PathAndCount = null;
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               callback(param1,null,null,0);
            }))
            {
               array = Vector.<Object>(json["list"]);
               if(array == null)
               {
                  throw new Error("GetMatchingPathsWithListeners should always contain a list, even if it is empty");
               }
               resultList = new Vector.<IPathAndCount>();
               for each(ob in array)
               {
                  job = ob;
                  path = String(job["p"]);
                  count = int(job["c"]);
                  ele = new PathAndCount();
                  ele.count = count;
                  ele.path = self._connector.getObjectStateManager().getOrCreateLocalObject(path);
                  resultList.push(ele);
               }
               callback(null,resultList,self.getPathContext(self._path),int(json["count"]));
            }
         });
      }
   }
}

