package Infinicast.Runtime
{
   public class LoggerFactory
   {
      
      public function LoggerFactory()
      {
         super();
      }
      
      public static function getLogger(param1:String) : Logger
      {
         return new Logger();
      }
   }
}

