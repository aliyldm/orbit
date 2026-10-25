package Infinicast.Client.Impl.Contexts
{
   import Infinicast.Client.Api.IEndpoint;
   import Infinicast.Client.Api.Paths.IAPathContext;
   import Infinicast.Client.Api.Paths.IListeningChangedContext;
   
   public class APListeningChangedContext extends APathContext implements IAPathContext, IListeningChangedContext
   {
      
      private var _endpoint:IEndpoint;
      
      private var _endpointData:*;
      
      public function APListeningChangedContext()
      {
         super();
      }
      
      public function get endpoint() : IEndpoint
      {
         return this._endpoint;
      }
      
      public function set endpoint(param1:IEndpoint) : void
      {
         this._endpoint = param1;
      }
      
      public function get endpointData() : *
      {
         return this._endpointData;
      }
      
      public function set endpointData(param1:*) : void
      {
         this._endpointData = param1;
      }
   }
}

