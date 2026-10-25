package net.bigpoint.darkorbit.loadingscreen.mvc.application.model
{
   import flash.external.ExternalInterface;
   
   public class JavascriptProxy
   {
      
      public static const FUNCTION_REFER_TO_URL:String = "referToURL";
      
      public static const FUNCTION_REFER_TO_EXTERNAL_URL_IN_NEW_WINDOW:String = "referToExternalURLInNewWindow";
      
      public function JavascriptProxy()
      {
         super();
      }
      
      public static function call(param1:String, param2:Array, param3:Function = null, param4:Array = null) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call.apply(null,[param1].concat(param2));
            return;
         }
         if(param3 != null)
         {
            param3(param4[0]);
         }
      }
      
      public static function log(param1:String, param2:Object = null) : void
      {
      }
   }
}

