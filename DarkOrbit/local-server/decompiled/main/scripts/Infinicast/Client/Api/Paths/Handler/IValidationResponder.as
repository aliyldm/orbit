package Infinicast.Client.Api.Paths.Handler
{
   public interface IValidationResponder
   {
      
      function accept() : void;
      
      function correct(param1:*) : void;
      
      function reject() : void;
   }
}

