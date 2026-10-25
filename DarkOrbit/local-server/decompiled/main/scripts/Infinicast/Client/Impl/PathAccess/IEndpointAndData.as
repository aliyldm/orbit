package Infinicast.Client.Impl.PathAccess
{
   import Infinicast.Client.Api.IEndpoint;
   
   public interface IEndpointAndData
   {
      
      function get data() : *;
      
      function set data(param1:*) : void;
      
      function get endpoint() : IEndpoint;
      
      function set endpoint(param1:IEndpoint) : void;
   }
}

