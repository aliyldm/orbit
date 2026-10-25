package net.bigpoint.darkorbit.net.netty.handlers
{
   import flash.utils.setTimeout;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.KillScreenPostCommand;
   import net.bigpoint.darkorbit.gui.windows.components.Killscreen;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class KillScreenPostHandler extends BaseHandler
   {
      
      public function KillScreenPostHandler()
      {
         super();
      }
      
      public static function run(param1:KillScreenPostCommand) : void
      {
         var _loc3_:IModule = null;
         var _loc2_:Killscreen = Killscreen.getInstance();
         _main.getGuiManager().showRepairWindow(param1.playerShipAlias,param1.killerName,param1.killerEpppLink);
         HandlerLookup.execute(param1.cause);
         for each(_loc3_ in param1.options)
         {
            HandlerLookup.execute(_loc3_);
         }
         setTimeout(_loc2_.displayOptions,1);
      }
   }
}

