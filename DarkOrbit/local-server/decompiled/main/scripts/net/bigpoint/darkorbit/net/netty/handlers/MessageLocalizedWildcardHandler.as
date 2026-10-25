package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.MessageLocalizedWildcardCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class MessageLocalizedWildcardHandler extends BaseHandler
   {
      
      public function MessageLocalizedWildcardHandler()
      {
         super();
      }
      
      public static function run(param1:MessageLocalizedWildcardCommand) : void
      {
         var _loc2_:IModule = null;
         for each(_loc2_ in param1.wildCardReplacements)
         {
            HandlerLookup.execute(_loc2_);
         }
      }
   }
}

