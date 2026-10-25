package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.data.stats.PingStats;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class StayingAliveHandler extends SimpleCommand
   {
      
      public function StayingAliveHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         PingStats.instance.pong();
      }
   }
}

