package net.bigpoint.darkorbit.mvc.gui.messages.controller
{
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.LogWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class LogMessageCommand extends AbstractMessageCommand
   {
      
      public function LogMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MessageCommandParams = param1.getBody() as MessageCommandParams;
         if(_loc2_)
         {
            this.writeToLog(_loc2_);
         }
      }
      
      private function writeToLog(param1:MessageCommandParams) : void
      {
         if(param1.type != LogMessageProfileVOFactory.LOG_ONLY_MESSAGE)
         {
            sendNotification(GuiNotifications.SHOW_MESSAGE_SCREEN,param1);
         }
         var _loc2_:LogWindowMediator = facade.retrieveMediator(LogWindowMediator.NAME) as LogWindowMediator;
         if(_loc2_)
         {
            _loc2_.logMessage(param1.message);
         }
      }
   }
}

