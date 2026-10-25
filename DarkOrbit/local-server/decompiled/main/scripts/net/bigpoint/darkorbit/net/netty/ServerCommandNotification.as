package net.bigpoint.darkorbit.net.netty
{
   import net.bigpoint.com.module.IModule;
   import org.puremvc.as3.multicore.patterns.observer.Notification;
   
   public class ServerCommandNotification extends Notification
   {
      
      private static const PREFIX:String = "ServerCommandNotification";
      
      public function ServerCommandNotification(param1:IModule)
      {
         super(ServerCommandNotification.PREFIX + param1.getLibcomModuleId(),param1);
      }
   }
}

