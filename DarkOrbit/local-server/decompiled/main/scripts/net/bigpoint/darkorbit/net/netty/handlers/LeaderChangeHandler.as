package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.LeaderChangeCommand;
   import net.bigpoint.darkorbit.net.netty.handlers.group.base.GroupSystemHandler;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class LeaderChangeHandler extends GroupSystemHandler
   {
      
      public function LeaderChangeHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:LeaderChangeCommand = param1.getBody() as LeaderChangeCommand;
         groupProxy.handleLeaderChange(_loc2_.leaderId);
      }
   }
}

