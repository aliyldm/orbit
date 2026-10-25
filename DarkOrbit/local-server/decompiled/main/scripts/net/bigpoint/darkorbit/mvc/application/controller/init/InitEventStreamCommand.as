package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.darkorbit.Main;
   import net.bigpoint.darkorbit.mvc.application.model.vo.StartupVO;
   import net.bigpoint.darkorbit.settings.Settings;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class InitEventStreamCommand extends SimpleCommand
   {
      
      public function InitEventStreamCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:StartupVO = param1.getBody() as StartupVO;
         if(Settings.eventStreamContext)
         {
            new EventStreamClient(Settings.eventStreamContext,_loc2_.stage);
            EventStreamClient.track("client_init",{"clientVersion":Main.VERSION});
         }
      }
   }
}

