package net.bigpoint.darkorbit.mvc.questWindow.controller
{
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class QuestGiverAcceptQuestCommand extends SimpleCommand
   {
      
      public function QuestGiverAcceptQuestCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:QuestProxy = facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
         var _loc3_:Array = param1.getBody() as Array;
         var _loc4_:int = _loc3_[0] as int;
         _loc2_.sendAcceptQuestRequest(_loc4_);
      }
   }
}

