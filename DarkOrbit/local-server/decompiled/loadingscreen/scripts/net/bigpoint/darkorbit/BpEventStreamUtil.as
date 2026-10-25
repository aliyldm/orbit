package net.bigpoint.darkorbit
{
   import net.bigpoint.darkorbit.loadingscreen.mvc.application.model.JavascriptProxy;
   
   public class BpEventStreamUtil
   {
      
      public function BpEventStreamUtil()
      {
         super();
      }
      
      public static function rawTrack(param1:String, param2:Object = null) : void
      {
         JavascriptProxy.log("tracker - " + param1,param2);
      }
   }
}

