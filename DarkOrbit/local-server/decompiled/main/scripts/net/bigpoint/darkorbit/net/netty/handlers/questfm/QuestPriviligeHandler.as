package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestPrivilegeCommand;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestPriviligeHandler extends BaseHandler
   {
      
      public function QuestPriviligeHandler()
      {
         super();
      }
      
      public static function run(param1:QuestPrivilegeCommand) : void
      {
         _main.getConnectionManager().questAssembly.assemblePrivilegedQuest(param1.questId);
      }
   }
}

