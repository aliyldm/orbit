package net.bigpoint.darkorbit.net.netty.handlers.serverEvents
{
   import net.bigpoint.darkorbit.com.module.EventUpdateCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventProxy;
   import net.bigpoint.darkorbit.utils.time.ServerTime;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ServerEventUpdateHandler extends DOAbstractSimpleCommand
   {
      
      public function ServerEventUpdateHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ServerEventProxy = retrieveProxy(ServerEventProxy.NAME) as ServerEventProxy;
         var _loc3_:EventUpdateCommand = param1.getBody() as EventUpdateCommand;
         _loc2_.update(_loc3_);
         ServerTime.instance.timestamp = _loc3_.timestamp;
         ServerTime.instance.utcTimeOffsetInSeconds = _loc3_.utcTimeOffset;
      }
   }
}

