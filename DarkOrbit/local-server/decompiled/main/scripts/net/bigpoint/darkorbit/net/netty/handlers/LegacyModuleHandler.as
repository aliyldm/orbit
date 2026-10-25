package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.LegacyModule;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class LegacyModuleHandler extends BaseHandler
   {
      
      public function LegacyModuleHandler()
      {
         super();
      }
      
      public static function run(param1:LegacyModule) : void
      {
         _main.getConnectionManager().onData(param1.message);
      }
   }
}

