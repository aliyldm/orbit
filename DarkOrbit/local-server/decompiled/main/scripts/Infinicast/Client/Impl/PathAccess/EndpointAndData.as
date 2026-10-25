package Infinicast.Client.Impl.PathAccess
{
   import Infinicast.Client.Api.IEndpoint;
   
   public class EndpointAndData implements IEndpointAndData
   {
      
      private var _data:*;
      
      private var _endpoint:IEndpoint;
      
      public function EndpointAndData()
      {
         super();
      }
      
      public function get data() : *
      {
         return this._data;
      }
      
      public function set data(param1:*) : void
      {
         this._data = param1;
      }
      
      public function get endpoint() : IEndpoint
      {
         return this._endpoint;
      }
      
      public function set endpoint(param1:IEndpoint) : void
      {
         this._endpoint = param1;
      }
   }
}

