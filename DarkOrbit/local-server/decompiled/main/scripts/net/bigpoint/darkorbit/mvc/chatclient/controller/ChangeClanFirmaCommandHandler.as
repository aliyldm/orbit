package net.bigpoint.darkorbit.mvc.chatclient.controller
{
   import net.bigpoint.darkorbit.com.module.porting.clan.ChangeClanFirmaCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ChangeClanFirmaCommandHandler extends BaseHandler
   {
      
      public function ChangeClanFirmaCommandHandler()
      {
         super();
      }
      
      public static function run(param1:ChangeClanFirmaCommand) : void
      {
         if(!param1)
         {
         }
      }
   }
}

