package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.VersionCommand;
   import net.bigpoint.darkorbit.net.ConnectionManager;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class VersionHandler extends BaseHandler
   {
      
      public function VersionHandler()
      {
         super();
      }
      
      public static function run(param1:VersionCommand) : void
      {
         var _loc2_:Boolean = param1.equal;
         var _loc3_:ConnectionManager = _main.getConnectionManager();
         _loc3_.handleVersionResponse(_loc2_);
      }
   }
}

