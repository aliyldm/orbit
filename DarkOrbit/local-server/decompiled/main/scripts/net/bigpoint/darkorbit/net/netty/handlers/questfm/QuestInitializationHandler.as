package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestDefinitionModule;
   import net.bigpoint.darkorbit.com.module.QuestInitializationCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestInitializationHandler extends BaseHandler
   {
      
      public function QuestInitializationHandler()
      {
         super();
      }
      
      public static function run(param1:QuestInitializationCommand) : void
      {
         var _loc2_:QuestDefinitionModule = param1.quest;
         _main.getConnectionManager().questAssembly.assembleQuestInitialization(_loc2_);
      }
   }
}

