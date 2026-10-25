package net.bigpoint.darkorbit.mvc.commandCenter.control
{
   import net.bigpoint.darkorbit.com.module.CommandCenterNewsClickedRequest;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.commandCenter.model.CommandCenterNewsVO;
   import net.bigpoint.darkorbit.mvc.common.ConnectionNotifications;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventProxy;
   import net.bigpoint.darkorbit.mvc.serverEvents.model.ServerEventVO;
   import net.bigpoint.eventstream.EventStreamClient;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class CommandCenterNewsClickedCommand extends DOAbstractSimpleCommand
   {
      
      public function CommandCenterNewsClickedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:ServerEventVO = null;
         super.execute(param1);
         var _loc2_:CommandCenterNewsVO = param1.getBody() as CommandCenterNewsVO;
         EventStreamClient.track("flash.commandCenter.shown",{
            "layer":_loc2_.key,
            "viewCount":_loc2_.clickCount
         });
         var _loc3_:ServerEventProxy = retrieveProxy(ServerEventProxy.NAME) as ServerEventProxy;
         var _loc4_:Vector.<String> = _loc2_.data.getEventNames();
         var _loc6_:int = int(_loc4_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc5_ = _loc3_.eventModel.getEventByType(_loc4_[_loc7_]);
            if(_loc5_)
            {
               sendNotification(ConnectionNotifications.SEND_NETTY_REQUEST,new CommandCenterNewsClickedRequest(_loc2_.key,_loc5_.id));
               return;
            }
            _loc7_++;
         }
      }
   }
}

