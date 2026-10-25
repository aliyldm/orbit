package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.KillScreenUpdateCommand;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class KillScreenUpdateHandler extends BaseHandler
   {
      
      public function KillScreenUpdateHandler()
      {
         super();
      }
      
      public static function run(param1:KillScreenUpdateCommand) : void
      {
         var _loc3_:IModule = null;
         var _loc2_:Killscreen = Killscreen.getInstance();
         _loc2_.clearOptions();
         for each(_loc3_ in param1.options)
         {
            HandlerLookup.execute(_loc3_);
         }
         _loc2_.displayOptions();
      }
   }
}

