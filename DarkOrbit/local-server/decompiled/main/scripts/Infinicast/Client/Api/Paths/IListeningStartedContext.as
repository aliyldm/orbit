package Infinicast.Client.Api.Paths
{
   public interface IListeningStartedContext extends IPathAndEndpointContext
   {
      
      function isFirstListenerOfRole(param1:String) : Boolean;
      
      function getListenerCount(param1:String) : int;
   }
}

