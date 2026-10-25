package Infinicast.Client.Impl.Responder
{
   import Infinicast.Client.Api.IEndpoint;
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Api.Paths.Handler.IValidationResponder;
   import Infinicast.Client.Impl.Messaging.ConnectorMessageManager;
   
   public class ValidationResponder implements IValidationResponder
   {
      
      private var _endpointInfo:IEndpoint;
      
      private var _acceptJson:*;
      
      private var _messageManager:ConnectorMessageManager;
      
      private var _path:IPath;
      
      private var _validateMessageType:int;
      
      public function ValidationResponder(param1:int, param2:ConnectorMessageManager, param3:*, param4:IPath, param5:IEndpoint)
      {
         super();
         this._validateMessageType = param1;
         this._messageManager = param2;
         this._acceptJson = param3;
         this._path = param4;
         this._endpointInfo = param5;
      }
      
      public function accept() : void
      {
         this._messageManager.sendValidatedMessage(this._validateMessageType,this._path,this._acceptJson,this._endpointInfo.endpointId);
      }
      
      public function correct(param1:*) : void
      {
         this._messageManager.sendValidatedMessage(this._validateMessageType,this._path,param1,this._endpointInfo.endpointId);
      }
      
      public function reject() : void
      {
      }
   }
}

