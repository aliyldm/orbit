package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.ClearMarkersCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ClearMarkersHandler extends BaseHandler
   {
      
      public function ClearMarkersHandler()
      {
         super();
      }
      
      public static function run(param1:ClearMarkersCommand) : void
      {
         MarkRangeHandler.removeAll();
         MarkPositionHandler.removeAll();
      }
   }
}

