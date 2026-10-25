package Infinicast.Client.Impl.PathAccess
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
   import Infinicast.Client.Impl.Query.*;
   import Infinicast.Client.Impl.Responder.*;
   import Infinicast.Client.Protocol.*;
   import Infinicast.Client.Protocol.Messages.*;
   import Infinicast.Client.Utils.*;
   import Infinicast.Runtime.*;
   import flash.utils.Dictionary;
   
   public class PathImpl implements IPath
   {
      
      private var _childQueryExecutor:ChildQueryExecutor = null;
      
      private var _childWithListenersQueryExecutor:ChildrenWithListenersQueryExecutor = null;
      
      private var _pathQueryWithHandlerExecutor:PathQueryWithHandlerExecutor = null;
      
      private var _logger:Logger = LoggerFactory.getLogger("PathImpl");
      
      private var _listenerQueryExecutor:ListenerQueryExecutor = null;
      
      private var _advancedOptions:* = null;
      
      private var _internalPath:String;
      
      private var _connector:IConnector;
      
      private var _root:PathImpl;
      
      public var messageManager:ConnectorMessageManager;
      
      public function PathImpl(param1:String)
      {
         super();
         this._internalPath = param1;
      }
      
      private static function handleCompleteHandlerAsyncVoid(param1:Promise, param2:ICError) : void
      {
         if(param2 != null)
         {
            param1.reject(new ICException(param2));
         }
         else
         {
            param1.resolve(null);
         }
      }
      
      private static function getRoleCountDictionary(param1:*) : Dictionary
      {
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc2_:Dictionary = new Dictionary();
         var _loc3_:Vector.<Object> = Vector.<Object>(param1["roleCount"]);
         if(_loc3_ != null)
         {
            for each(_loc4_ in _loc3_)
            {
               _loc5_ = String(_loc4_["role"]);
               _loc6_ = String(_loc4_["handlerType"]);
               _loc7_ = int(_loc4_["count"]);
               if(_loc6_ == "Message")
               {
                  DictionaryExtensions.add(_loc2_,_loc5_,_loc7_);
               }
            }
         }
         return _loc2_;
      }
      
      public function getPathAddress() : String
      {
         return PathUtils.cleanup(this._internalPath);
      }
      
      private function copy() : PathImpl
      {
         var _loc1_:PathImpl = new PathImpl(this._internalPath);
         _loc1_.setMessageManager(this.messageManager);
         _loc1_.setRoot(this.getRoot());
         _loc1_._advancedOptions = this._advancedOptions;
         return _loc1_;
      }
      
      public function path(param1:String) : IPath
      {
         var _loc2_:PathImpl = new PathImpl(this.combinePath(param1));
         _loc2_.setMessageManager(this.messageManager);
         _loc2_.setRoot(this.getRoot());
         _loc2_.setConnector(this.getConnector());
         return _loc2_;
      }
      
      public function setConnector(param1:IConnector) : void
      {
         this._connector = param1;
      }
      
      private function combinePath(param1:String) : String
      {
         return PathUtils.combine(this._internalPath,param1);
      }
      
      public function setMessageManager(param1:ConnectorMessageManager) : void
      {
         this.messageManager = param1;
      }
      
      public function getConnector() : IConnector
      {
         if(this._root == null)
         {
            return this._connector;
         }
         return this.getRoot().getConnector();
      }
      
      public function setRoot(param1:PathImpl) : void
      {
         this._root = param1;
         this.messageManager = param1.messageManager;
      }
      
      public function getRoot() : PathImpl
      {
         if(this._root == null)
         {
            return this;
         }
         return this._root;
      }
      
      public function parentPath() : IPath
      {
         return this.parentPathWithDepth(1);
      }
      
      public function parentPathWithDepth(param1:int) : IPath
      {
         var _loc2_:String = this._internalPath;
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ = PathUtils.getParentPath(_loc2_);
            if(StringExtensions.IsNullOrEmpty(_loc2_))
            {
               return null;
            }
            _loc3_++;
         }
         var _loc4_:PathImpl = new PathImpl(_loc2_);
         _loc4_.setMessageManager(this.messageManager);
         _loc4_.setRoot(this.getRoot());
         return _loc4_;
      }
      
      public function setData(param1:*, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var json:* = param1;
         var completeCallback:Function = param2;
         self = this;
         this.messageManager.sendMessageWithResponse(5,this,json,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            if(!self.checkIfHasErrorsAndCallHandlersNew(param2,completeCallback))
            {
               if(completeCallback != null)
               {
                  completeCallback(null);
               }
            }
         });
      }
      
      public function modifyDataAtomicAndGetResult(param1:AtomicChange, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var data:AtomicChange = param1;
         var completeCallback:Function = param2;
         self = this;
         var json:* = new Object();
         json["changes"] = data.toJson();
         if(data.hasNamedQueries())
         {
            json["named"] = data.getNamedQueryJson();
         }
         this.messageManager.sendMessageWithResponse(30,this,json,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var resultJson:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               if(completeCallback != null)
               {
                  completeCallback(param1,null);
               }
               else
               {
                  self.getConnector().unhandeledErrorInfo(self,param1);
               }
            }))
            {
               if(completeCallback != null)
               {
                  completeCallback(null,resultJson["data"]);
               }
            }
         });
      }
      
      public function modifyDataAtomic(param1:AtomicChange, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var data:AtomicChange = param1;
         var completeCallback:Function = param2;
         self = this;
         var json:* = new Object();
         json["changes"] = data.toJson();
         if(data.hasNamedQueries())
         {
            json["named"] = data.getNamedQueryJson();
         }
         json["returnData"] = false;
         this.messageManager.sendMessageWithResponse(30,this,json,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var resultJson:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               if(completeCallback != null)
               {
                  completeCallback(param1);
               }
               else
               {
                  self.getConnector().unhandeledErrorInfo(self,param1);
               }
            }))
            {
               if(completeCallback != null)
               {
                  completeCallback(null);
               }
            }
         });
      }
      
      public function modifyDataSetValue1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValue2(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValue3(param1:String, param2:Boolean, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValue4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValue5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmpty1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmpty2(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmpty3(param1:String, param2:Boolean, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmpty4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmpty5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataIncValue1(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().incValue(param1,param2),param3);
      }
      
      public function modifyDataIncValue2(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().incValue(param1,param2),param3);
      }
      
      public function modifyDataDecValue1(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().decValue(param1,param2),param3);
      }
      
      public function modifyDataDecValue2(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().decValue(param1,param2),param3);
      }
      
      public function modifyDataAddToSet1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSet2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSet3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSet4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSet5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSet1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSet2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSet3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSet4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSet5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataAddToArray1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArray2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArray3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArray4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArray5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArray1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArray2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArray3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArray4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArray5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomic(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataSetValueAndGetResult1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValueAndGetResult2(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValueAndGetResult3(param1:String, param2:Boolean, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValueAndGetResult4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValueAndGetResult5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValue(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmptyAndGetResult1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmptyAndGetResult2(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmptyAndGetResult3(param1:String, param2:Boolean, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmptyAndGetResult4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataSetValueIfEmptyAndGetResult5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().setValueIfEmpty(param1,param2),param3);
      }
      
      public function modifyDataIncValueAndGetResult1(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().incValue(param1,param2),param3);
      }
      
      public function modifyDataIncValueAndGetResult2(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().incValue(param1,param2),param3);
      }
      
      public function modifyDataDecValueAndGetResult1(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().decValue(param1,param2),param3);
      }
      
      public function modifyDataDecValueAndGetResult2(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().decValue(param1,param2),param3);
      }
      
      public function modifyDataAddToSetAndGetResult1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSetAndGetResult2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSetAndGetResult3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSetAndGetResult4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataAddToSetAndGetResult5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSetAndGetResult1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSetAndGetResult2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSetAndGetResult3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSetAndGetResult4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromSetAndGetResult5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromSet(param1,param2),param3);
      }
      
      public function modifyDataAddToArrayAndGetResult1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArrayAndGetResult2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArrayAndGetResult3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArrayAndGetResult4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataAddToArrayAndGetResult5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().addToArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArrayAndGetResult1(param1:String, param2:*, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArrayAndGetResult2(param1:String, param2:Vector.<Object>, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArrayAndGetResult3(param1:String, param2:String, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArrayAndGetResult4(param1:String, param2:int, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function modifyDataRemoveFromArrayAndGetResult5(param1:String, param2:Number, param3:Function = null) : void
      {
         this.modifyDataAtomicAndGetResult(new AtomicChange().removeFromArray(param1,param2),param3);
      }
      
      public function addDebugMessage(param1:*, param2:*) : void
      {
         if(param1 is AMessageLevel && param2 is String)
         {
            this.addDebugMessage1(int(param1),String(param2));
         }
         else
         {
            if(!(param1 is AMessageLevel && param2 is Object))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.addDebugMessage2(int(param1),param2);
         }
      }
      
      public function getData(param1:Function, param2:GetDataOptions = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var options:GetDataOptions = param2;
         self = this;
         var data:* = null;
         if(options != null)
         {
            data = new Object();
         }
         data = this.applyAdvancedOptions(data);
         this.messageManager.sendMessageWithResponse(28,this,data,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               callback(param1,null,null);
            }))
            {
               callback(null,json,self.getPathAndEndpointContext(context));
            }
         });
      }
      
      private function applyAdvancedOptions(param1:*) : *
      {
         var _loc2_:* = param1;
         if(this._advancedOptions != null)
         {
            if(_loc2_ == null)
            {
               _loc2_ = new Object();
            }
            if(this._advancedOptions["accessId"] != null)
            {
               param1["accessId"] = String(this._advancedOptions["accessId"]);
            }
         }
         return _loc2_;
      }
      
      public function modifyDataRemoveFromArrayAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataRemoveFromArrayAndGetResult1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataRemoveFromArrayAndGetResult2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataRemoveFromArrayAndGetResult3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataRemoveFromArrayAndGetResult4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataRemoveFromArrayAndGetResult5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function deleteData(param1:Function = null) : void
      {
         var self:PathImpl = null;
         var completeCallback:Function = param1;
         self = this;
         this.messageManager.sendMessageWithResponse(22,this,new Object(),function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.checkIfHasErrorsAndCallHandlersFull(param2,completeCallback);
         });
      }
      
      public function modifyDataAddToArrayAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataAddToArrayAndGetResult1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataAddToArrayAndGetResult2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataAddToArrayAndGetResult3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataAddToArrayAndGetResult4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataAddToArrayAndGetResult5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function deleteDataAndListeners(param1:Function = null) : void
      {
         var self:PathImpl = null;
         var completeCallback:Function = param1;
         self = this;
         var options:* = new Object();
         options["listeners"] = true;
         this.messageManager.sendMessageWithResponse(22,this,options,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.checkIfHasErrorsAndCallHandlersFull(param2,completeCallback);
         });
      }
      
      public function modifyDataRemoveFromSetAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataRemoveFromSetAndGetResult1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataRemoveFromSetAndGetResult2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataRemoveFromSetAndGetResult3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataRemoveFromSetAndGetResult4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataRemoveFromSetAndGetResult5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function deleteListeners(param1:Function = null) : void
      {
         var self:PathImpl = null;
         var completeCallback:Function = param1;
         self = this;
         var options:* = new Object();
         options["listeners"] = true;
         options["data"] = false;
         this.messageManager.sendMessageWithResponse(22,this,options,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.checkIfHasErrorsAndCallHandlersFull(param2,completeCallback);
         });
      }
      
      public function modifyDataAddToSetAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataAddToSetAndGetResult1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataAddToSetAndGetResult2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataAddToSetAndGetResult3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataAddToSetAndGetResult4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataAddToSetAndGetResult5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function addReminder(param1:ReminderSchedulingOptions, param2:*, param3:Function = null) : void
      {
         this.addOrReplaceReminder(null,param1,param2,param3);
      }
      
      public function modifyDataDecValueAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataDecValueAndGetResult1(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataDecValueAndGetResult2(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function addOrReplaceReminder(param1:*, param2:ReminderSchedulingOptions, param3:*, param4:Function = null) : void
      {
         var self:PathImpl = null;
         var queryJson:* = param1;
         var schedulingOptions:ReminderSchedulingOptions = param2;
         var json:* = param3;
         var completeCallback:Function = param4;
         self = this;
         var data:* = new Object();
         if(queryJson != null)
         {
            data["query"] = queryJson;
         }
         data["data"] = json;
         data["scheduled"] = schedulingOptions.toJson();
         this.messageManager.sendMessageWithResponse(36,this,data,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.checkIfHasErrorsAndCallHandlersFull(param2,completeCallback);
         });
      }
      
      public function modifyDataIncValueAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataIncValueAndGetResult1(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataIncValueAndGetResult2(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function deleteReminder(param1:*, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var queryJson:* = param1;
         var completeCallback:Function = param2;
         self = this;
         this.messageManager.sendMessageWithResponse(37,this,queryJson,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.checkIfHasErrorsAndCallHandlersFull(param2,completeCallback);
         });
      }
      
      public function modifyDataSetValueIfEmptyAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataSetValueIfEmptyAndGetResult1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataSetValueIfEmptyAndGetResult2(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is Boolean && param3 is Function)
         {
            this.modifyDataSetValueIfEmptyAndGetResult3(String(param1),Boolean(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataSetValueIfEmptyAndGetResult4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataSetValueIfEmptyAndGetResult5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function sendRequest(param1:*, param2:Function) : void
      {
         var self:PathImpl = null;
         var data:* = param1;
         var answer:Function = param2;
         self = this;
         this.messageManager.sendMessageWithResponse(1,this,data,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            var json:* = param1;
            var err:ICError = param2;
            var context:IPathAndEndpointContext = param3;
            if(!self.checkIfHasErrorsAndCallHandlersNew(err,function(param1:ICError):void
            {
               err.customJson = json;
               answer(param1,null,null);
            }))
            {
               answer(null,json,context);
            }
         });
      }
      
      public function modifyDataSetValueAndGetResult(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataSetValueAndGetResult1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataSetValueAndGetResult2(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is Boolean && param3 is Function)
         {
            this.modifyDataSetValueAndGetResult3(String(param1),Boolean(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataSetValueAndGetResult4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataSetValueAndGetResult5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function sendMessage(param1:*, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var json:* = param1;
         var completeCallback:Function = param2;
         self = this;
         this.messageManager.sendMessageWithResponse(7,this,json,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.checkIfHasErrorsAndCallHandlersFull(param2,completeCallback);
         });
      }
      
      public function sendMessageWithRequiredListener(param1:*, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var json:* = param1;
         var completeCallback:Function = param2;
         self = this;
         json["requiresReceiver"] = true;
         this.messageManager.sendMessageWithResponse(7,this,json,function(param1:*, param2:ICError, param3:IPathAndEndpointContext):void
         {
            self.checkIfHasErrorsAndCallHandlersFull(param2,completeCallback);
         });
      }
      
      public function modifyDataRemoveFromArray(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataRemoveFromArray1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataRemoveFromArray2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataRemoveFromArray3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataRemoveFromArray4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataRemoveFromArray5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function addDebugPingInfo(param1:int) : void
      {
         this.messageManager.sendDebugPingInfo(this,param1);
      }
      
      public function addDebugMessage1(param1:int, param2:String) : void
      {
         var _loc3_:* = new Object();
         _loc3_["text"] = param2;
         this.addDebugMessage(param1,_loc3_);
      }
      
      public function addDebugMessage2(param1:int, param2:*) : void
      {
         var _loc3_:* = new Object();
         _loc3_["level"] = int(param1);
         _loc3_["info"] = param2;
         this.messageManager.sendDebugMessage(this,int(param1),_loc3_);
      }
      
      public function withAdvancedOptions(param1:*) : IPath
      {
         var _loc2_:PathImpl = this.copy();
         _loc2_._advancedOptions = param1;
         return _loc2_;
      }
      
      public function extractPathParams(param1:String) : Dictionary
      {
         return PathUtils.parsePath(param1,this.toString());
      }
      
      public function pathAddressElement(param1:int) : String
      {
         return PathUtils.getPathAddressElement(this.getPathAddress(),param1);
      }
      
      public function onDataChange(param1:Function, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this.executorForPathHandler.onDataChange(callback,null,function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self.executorForPathHandler.unhandeledError(param1);
            }
         });
      }
      
      public function modifyDataAddToArray(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataAddToArray1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataAddToArray2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataAddToArray3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataAddToArray4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataAddToArray5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function onMessage(param1:Function, param2:Function = null, param3:Function = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var registrationCompleteCallback:Function = param2;
         var listenTerminationHandler:Function = param3;
         self = this;
         this.executorForPathHandler.onMessage(callback,null,function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self.executorForPathHandler.unhandeledError(param1);
            }
         },listenTerminationHandler);
      }
      
      public function modifyDataRemoveFromSet(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataRemoveFromSet1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataRemoveFromSet2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataRemoveFromSet3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataRemoveFromSet4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataRemoveFromSet5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function onValidateDataChange(param1:Function, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this.executorForPathHandler.onValidateDataChange(callback,null,function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self.executorForPathHandler.unhandeledError(param1);
            }
         });
      }
      
      public function modifyDataAddToSet(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataAddToSet1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is Vector.<Object> && param3 is Function)
         {
            this.modifyDataAddToSet2(String(param1),Vector.<Object>(param2),Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataAddToSet3(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataAddToSet4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataAddToSet5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function onValidateMessage(param1:Function, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this.executorForPathHandler.onValidateMessage(callback,null,function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self.executorForPathHandler.unhandeledError(param1);
            }
         });
      }
      
      public function modifyDataDecValue(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataDecValue1(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataDecValue2(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function onRequest(param1:Function, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this.executorForPathHandler.onRequest(function(param1:*, param2:IAPResponder, param3:IPathAndEndpointContext):void
         {
            callback(param1,param2,param3);
         },null,function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self.executorForPathHandler.unhandeledError(param1);
            }
         });
      }
      
      public function modifyDataIncValue(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataIncValue1(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataIncValue2(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function onReminder(param1:Function, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this.executorForPathHandler.onReminder(callback,null,function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self.executorForPathHandler.unhandeledError(param1);
            }
         });
      }
      
      public function modifyDataSetValueIfEmpty(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataSetValueIfEmpty1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataSetValueIfEmpty2(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is Boolean && param3 is Function)
         {
            this.modifyDataSetValueIfEmpty3(String(param1),Boolean(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataSetValueIfEmpty4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataSetValueIfEmpty5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function onIntroduce(param1:Function, param2:Function = null) : void
      {
         var self:PathImpl = null;
         var callback:Function = param1;
         var registrationCompleteCallback:Function = param2;
         self = this;
         this.executorForPathHandler.onIntroduce(function(param1:*, param2:IPathAndEndpointContext):void
         {
            callback(param1,param2);
         },function(param1:ICError):void
         {
            if(registrationCompleteCallback != null)
            {
               registrationCompleteCallback(param1);
            }
            else if(param1 != null)
            {
               self.executorForPathHandler.unhandeledError(param1);
            }
         });
      }
      
      public function modifyDataSetValue(param1:*, param2:*, param3:*) : void
      {
         if(param1 is String && param2 is Object && param3 is Function)
         {
            this.modifyDataSetValue1(String(param1),param2,Function(param3));
         }
         else if(param1 is String && param2 is String && param3 is Function)
         {
            this.modifyDataSetValue2(String(param1),String(param2),Function(param3));
         }
         else if(param1 is String && param2 is Boolean && param3 is Function)
         {
            this.modifyDataSetValue3(String(param1),Boolean(param2),Function(param3));
         }
         else if(param1 is String && param2 is int && param3 is Function)
         {
            this.modifyDataSetValue4(String(param1),int(param2),Function(param3));
         }
         else
         {
            if(!(param1 is String && param2 is Number && param3 is Function))
            {
               throw new ArgumentError("Bad combination of parameter types");
            }
            this.modifyDataSetValue5(String(param1),Number(param2),Function(param3));
         }
      }
      
      public function checkIfHasErrorsAndCallHandlersNew(param1:ICError, param2:Function) : Boolean
      {
         return ErrorHandlingHelper.checkIfHasErrorsAndCallHandlersNew(this.getConnector(),param1,param2,this);
      }
      
      public function checkIfHasErrorsAndCallHandlersFull(param1:ICError, param2:Function) : void
      {
         ErrorHandlingHelper.checkIfHasErrorsAndCallHandlersFull(this.getConnector(),param1,param2,this);
      }
      
      private function getPathAndEndpointContext(param1:IPathAndEndpointContext) : IAPathContext
      {
         var _loc2_:APathContext = new APathContext();
         _loc2_.path = param1.path;
         return _loc2_;
      }
      
      private function getPathContext(param1:IPath) : IAPathContext
      {
         var _loc2_:APathContext = new APathContext();
         _loc2_.path = param1;
         return _loc2_;
      }
      
      public function toString() : String
      {
         return this.getPathAddress();
      }
      
      private function get executorForPathHandler() : PathQueryWithHandlerExecutor
      {
         if(this._pathQueryWithHandlerExecutor == null)
         {
            this._pathQueryWithHandlerExecutor = new PathQueryWithHandlerExecutor(this.getRoot().getConnector(),this,this.messageManager);
         }
         return this._pathQueryWithHandlerExecutor;
      }
      
      public function get children() : IChildrenQuery
      {
         if(this._childQueryExecutor == null)
         {
            this._childQueryExecutor = new ChildQueryExecutor(this.getRoot().getConnector(),this,this.messageManager);
         }
         return new ChildrenQuery(this,this._childQueryExecutor);
      }
      
      public function get pathByListeners() : IPathByListenersQuery
      {
         if(this._childWithListenersQueryExecutor == null)
         {
            this._childWithListenersQueryExecutor = new ChildrenWithListenersQueryExecutor(this.getRoot().getConnector(),this,this.messageManager);
         }
         return new PathByListenersQuery(this,this._childWithListenersQueryExecutor);
      }
      
      public function get listeners() : IListenerQuery
      {
         if(this._listenerQueryExecutor == null)
         {
            this._listenerQueryExecutor = new ListenerQueryExecutor(this.getRoot().getConnector(),this,this.messageManager);
         }
         return new ListenerQuery(this,this._listenerQueryExecutor);
      }
      
      public function get parentPathAddress() : String
      {
         return PathUtils.getObjectListPath(this.getPathAddress());
      }
      
      public function get id() : String
      {
         return PathUtils.getLastPathPart(this.getPathAddress());
      }
   }
}

