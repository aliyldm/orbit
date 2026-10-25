package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.LegacyModule;
   import net.bigpoint.darkorbit.com.module.NewQuestsAvailableCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   import net.bigpoint.darkorbit.net.netty.HandlerLookup;
   
   public class NewQuestsAvailableHandler extends BaseHandler
   {
      
      public function NewQuestsAvailableHandler()
      {
         super();
      }
      
      public static function run(param1:NewQuestsAvailableCommand) : void
      {
         HandlerLookup.execute(new LegacyModule("L|n|MSG|0|2|log_msg_new_quests_available"));
      }
   }
}

