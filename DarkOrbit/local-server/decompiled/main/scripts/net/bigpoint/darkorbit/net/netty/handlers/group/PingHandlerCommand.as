package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.darkorbit.com.module.PingCommand;
   import net.bigpoint.darkorbit.map.model.minimap.MarkerVO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class PingHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function PingHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:PingCommand = param1.getBody() as PingCommand;
         screenManager.minimap.addMapMarker(new MarkerVO(null,_loc2_.x,_loc2_.y,10));
      }
   }
}

