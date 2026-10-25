package net.bigpoint.darkorbit.net.netty.handlers
{
   import com.greensock.TweenNano;
   import net.bigpoint.darkorbit.com.module.LegacyModule;
   import net.bigpoint.darkorbit.com.module.ReloginCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class ReloginHandler extends BaseHandler
   {
      
      public function ReloginHandler()
      {
         super();
      }
      
      public static function run(param1:ReloginCommand) : void
      {
         TweenNano.delayedCall(param1.delayInMillis / 1000,HandlerLookup.execute,[new LegacyModule("0|i|" + param1.mapID)]);
      }
   }
}

