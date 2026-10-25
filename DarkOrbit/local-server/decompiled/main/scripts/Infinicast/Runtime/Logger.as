package Infinicast.Runtime
{
   public class Logger
   {
      
      public function Logger()
      {
         super();
      }
      
      public function exception(param1:String, param2:Object) : void
      {
      }
      
      public function error(param1:String, param2:Object = undefined) : void
      {
      }
      
      public function warn(param1:String) : void
      {
      }
      
      public function debug(param1:String) : void
      {
      }
      
      public function info(param1:String) : void
      {
      }
      
      public function get isDebugEnabled() : Boolean
      {
         return LoggerSettings.CurrentLogLevel === 0;
      }
   }
}

