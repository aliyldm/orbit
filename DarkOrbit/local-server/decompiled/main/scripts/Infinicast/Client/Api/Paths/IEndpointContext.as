package Infinicast.Client.Api.Paths
{
   import Infinicast.Client.Api.IEndpoint;
   
   public interface IEndpointContext
   {
      
      function get endpoint() : IEndpoint;
      
      function get endpointData() : *;
   }
}

