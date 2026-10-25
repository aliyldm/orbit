package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.com.module.porting.clan.JoinClanCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class JoinClanCommHandler extends BaseHandler
   {
      
      public function JoinClanCommHandler()
      {
         super();
      }
      
      public static function run(param1:JoinClanCommand) : void
      {
         if(!param1)
         {
         }
      }
   }
}

