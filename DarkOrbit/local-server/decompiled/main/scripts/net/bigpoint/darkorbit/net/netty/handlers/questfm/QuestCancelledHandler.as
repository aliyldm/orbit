package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestCancelledCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestCancelledHandler extends BaseHandler
   {
      
      public function QuestCancelledHandler()
      {
         super();
      }
      
      public static function run(param1:QuestCancelledCommand) : void
      {
         _main.getConnectionManager().questAssembly.assembleQuestCancelled(param1.id);
      }
   }
}

