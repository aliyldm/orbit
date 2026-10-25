package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestFailedCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestFailedHandler extends BaseHandler
   {
      
      public function QuestFailedHandler()
      {
         super();
      }
      
      public static function run(param1:QuestFailedCommand) : void
      {
         _main.getConnectionManager().questAssembly.assembleQuestFailed(param1.id);
      }
   }
}

