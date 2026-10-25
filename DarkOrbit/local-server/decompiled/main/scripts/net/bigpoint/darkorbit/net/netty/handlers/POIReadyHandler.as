package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.POIReadyCommand;
   import net.bigpoint.darkorbit.net.POIAssembly;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class POIReadyHandler extends BaseHandler
   {
      
      public function POIReadyHandler()
      {
         super();
      }
      
      public static function run(param1:POIReadyCommand) : void
      {
         POIAssembly.getInstance().assemblePOIReady();
      }
   }
}

