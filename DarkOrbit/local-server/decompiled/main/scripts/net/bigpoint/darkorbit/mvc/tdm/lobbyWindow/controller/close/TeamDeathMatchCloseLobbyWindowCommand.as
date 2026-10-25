package net.bigpoint.darkorbit.mvc.tdm.lobbyWindow.controller.close
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchCloseLobbyWindowCommand extends SimpleCommand
   {
      
      public function TeamDeathMatchCloseLobbyWindowCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
      }
   }
}

