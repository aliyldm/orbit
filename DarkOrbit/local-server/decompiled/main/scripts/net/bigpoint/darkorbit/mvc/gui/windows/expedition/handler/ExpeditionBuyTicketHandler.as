package net.bigpoint.darkorbit.mvc.gui.windows.expedition.handler
{
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionBuyTicketCommand;
   import net.bigpoint.darkorbit.net.JavascriptProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class ExpeditionBuyTicketHandler extends BaseHandler
   {
      
      public function ExpeditionBuyTicketHandler()
      {
         super();
      }
      
      public static function run(param1:ExpeditionBuyTicketCommand) : void
      {
         if(!param1.result)
         {
            JavascriptProxy.referToURL("internalDock&tpl=internalDockSpecials&shopItem=resource_key_access-dse",null);
         }
      }
   }
}

