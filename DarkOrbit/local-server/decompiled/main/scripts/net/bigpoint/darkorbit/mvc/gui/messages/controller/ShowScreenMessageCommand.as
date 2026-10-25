package net.bigpoint.darkorbit.mvc.gui.messages.controller
{
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import net.bigpoint.darkorbit.mvc.gui.messages.view.MessagesMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ShowScreenMessageCommand extends AbstractMessageCommand
   {
      
      public function ShowScreenMessageCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:MessageCommandParams = param1.getBody() as MessageCommandParams;
         if(_loc2_)
         {
            this._message(_loc2_.message,_loc2_.type);
            return;
         }
         throw new Error("Send this notification with a proper MessageCommandParams instance.");
      }
      
      protected function _message(param1:String, param2:String) : void
      {
         var _loc3_:MessagesMediator = facade.retrieveMediator(MessagesMediator.NAME) as MessagesMediator;
         _loc3_.instantLogView.addMessage(param1,LogMessageProfileVOFactory.getLogMessageProfile(param2));
      }
   }
}

