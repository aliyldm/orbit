package Infinicast.Client.Impl.PathAccess
{
   import Infinicast.Client.Api.Errors.ICError;
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Api.Paths.Handler.Requests.IAPResponder;
   import Infinicast.Client.Impl.Messaging.ConnectorMessageManager;
   
   public class RequestResponder implements IAPResponder
   {
      
      private var _messageManager:ConnectorMessageManager;
      
      private var _path:IPath;
      
      private var _requestId:int;
      
      private var _targetEndpoint:String;
      
      public function RequestResponder(param1:ConnectorMessageManager, param2:IPath, param3:String, param4:int)
      {
         super();
         this._messageManager = param1;
         this._path = param2;
         this._targetEndpoint = param3;
         this._requestId = param4;
      }
      
      public function respond(param1:*) : void
      {
         this._messageManager.sendRequestAnswer(0,this._path,param1,this._targetEndpoint,this._requestId);
      }
      
      public function respondWithError(param1:ICError) : void
      {
         this._messageManager.sendRequestAnswer(50,this._path,param1.toJson(),this._targetEndpoint,this._requestId);
      }
   }
}

