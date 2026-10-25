package Infinicast.Client.Impl.Helper
{
   import Infinicast.Client.Api.Errors.ICError;
   import Infinicast.Client.Api.IPath;
   import Infinicast.Client.Impl.IConnector;
   import Infinicast.Runtime.Logger;
   import Infinicast.Runtime.LoggerFactory;
   
   public class ErrorHandlingHelper
   {
      
      private static var _logger:Logger = LoggerFactory.getLogger("ErrorHandlingHelper");
      
      public function ErrorHandlingHelper()
      {
         super();
      }
      
      public static function checkIfHasErrorsAndCallHandlersFull(param1:IConnector, param2:ICError, param3:Function, param4:IPath) : void
      {
         if(param2 != null)
         {
            if(param3 != null)
            {
               param3(param2);
            }
            else
            {
               param1.unhandeledErrorInfo(param4,param2);
            }
            return;
         }
         if(param3 != null)
         {
            param3(null);
         }
      }
      
      public static function checkIfHasErrorsAndCallHandlersNew(param1:IConnector, param2:ICError, param3:Function, param4:IPath) : Boolean
      {
         if(param2 != null)
         {
            if(param3 != null)
            {
               param3(param2);
            }
            else
            {
               param1.unhandeledErrorInfo(param4,param2);
            }
            return true;
         }
         return false;
      }
   }
}

