package Infinicast.Client.Api.Paths
{
   import Infinicast.Client.Api.IEndpoint;
   import Infinicast.Client.Api.IPath;
   
   public interface IPathAndEndpointContext
   {
      
      function get path() : IPath;
      
      function get endpoint() : IEndpoint;
      
      function get endpointData() : *;
   }
}

