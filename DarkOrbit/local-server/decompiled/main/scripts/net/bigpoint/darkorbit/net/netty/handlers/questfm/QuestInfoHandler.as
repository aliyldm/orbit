package net.bigpoint.darkorbit.net.netty.handlers.questfm
{
   import net.bigpoint.darkorbit.com.module.QuestInfoCommand;
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import net.bigpoint.darkorbit.net.netty.BaseHandler;
   
   public class QuestInfoHandler extends BaseHandler
   {
      
      public function QuestInfoHandler()
      {
         super();
      }
      
      public static function run(param1:QuestInfoCommand) : void
      {
         var _loc2_:QuestProxy = _facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
         _loc2_.addNewQuestInfo(param1);
      }
   }
}

