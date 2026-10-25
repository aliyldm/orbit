package net.bigpoint.darkorbit.mvc.chatclient.controller.init
{
   import net.bigpoint.darkorbit.mvc.application.controller.DOAbstractLoadLanguagesAsyncCommand;
   import net.bigpoint.darkorbit.mvc.chatclient.ChatPathSettings;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class DOChatInitLocaleAsyncCommand extends DOAbstractLoadLanguagesAsyncCommand
   {
      
      public function DOChatInitLocaleAsyncCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = ChatPathSettings.chatLocaURL;
         loadLanguages(new <String>[_loc2_],new <String>["chat"],commandComplete);
      }
   }
}

