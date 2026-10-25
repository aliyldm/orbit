package Infinicast.Client.Api.Paths.Handler.Requests
{
   import Infinicast.Client.Api.Errors.ICError;
   
   public interface IAPResponder
   {
      
      function respond(param1:*) : void;
      
      function respondWithError(param1:ICError) : void;
   }
}

