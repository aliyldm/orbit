package net.bigpoint.darkorbit.net.netty.handlers.tdm
{
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.TDMStatusNotification;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TeamDeathMatchStatusUpdateHandler extends SimpleCommand
   {
      
      public function TeamDeathMatchStatusUpdateHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         sendNotification(TDMStatusNotification.UPDATE,param1.getBody());
      }
   }
}

