package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.MessageQueueModule;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class MessageQueueHandler extends BaseHandler
   {
      
      public function MessageQueueHandler()
      {
         super();
      }
      
      public static function run(param1:MessageQueueModule) : void
      {
         var _loc2_:IModule = null;
         for each(_loc2_ in param1.messageQueue)
         {
            HandlerLookup.execute(_loc2_);
         }
      }
   }
}

