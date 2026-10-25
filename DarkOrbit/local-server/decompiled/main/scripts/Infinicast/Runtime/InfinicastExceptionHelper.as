package Infinicast.Runtime
{
   public class InfinicastExceptionHelper
   {
      
      public function InfinicastExceptionHelper()
      {
         super();
      }
      
      public static function ExceptionToString(param1:Error) : String
      {
         return param1.message + " " + param1.getStackTrace();
      }
   }
}

