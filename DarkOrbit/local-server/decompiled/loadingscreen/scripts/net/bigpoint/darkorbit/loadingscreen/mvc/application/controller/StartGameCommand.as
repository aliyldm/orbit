package net.bigpoint.darkorbit.loadingscreen.mvc.application.controller
{
   import flash.events.Event;
   import net.bigpoint.darkorbit.loadingscreen.application.ApplicationFacade;
   import org.puremvc.as3.interfaces.INotification;
   import org.puremvc.as3.patterns.command.SimpleCommand;
   
   public class StartGameCommand extends SimpleCommand
   {
      
      public function StartGameCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         ApplicationFacade(facade).appWindow.dispatchEvent(new Event("startGame"));
      }
   }
}

