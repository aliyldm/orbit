package Infinicast.Client.Api.Paths
{
   public interface IListeningEndedContext extends IPathAndEndpointContext
   {
      
      function get isDisconnected() : Boolean;
      
      function wasLastListenerOfRole(param1:String) : Boolean;
      
      function getListenerCount(param1:String) : int;
   }
}

