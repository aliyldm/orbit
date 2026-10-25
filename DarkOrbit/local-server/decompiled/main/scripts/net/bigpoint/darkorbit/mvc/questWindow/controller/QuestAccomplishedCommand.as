package net.bigpoint.darkorbit.mvc.questWindow.controller
{
   import net.bigpoint.darkorbit.mvc.questWindow.model.QuestProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class QuestAccomplishedCommand extends SimpleCommand
   {
      
      public function QuestAccomplishedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:int = int(param1.getBody()[0]);
         var _loc3_:int = int(param1.getBody()[1]);
         this.questProxy.questAccomplished(_loc2_,_loc3_);
      }
      
      private function get questProxy() : QuestProxy
      {
         return facade.retrieveProxy(QuestProxy.NAME) as QuestProxy;
      }
   }
}

