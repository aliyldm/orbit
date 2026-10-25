package net.bigpoint.darkorbit.mvc.events.control
{
   import net.bigpoint.darkorbit.mvc.events.model.EventProxy;
   import net.bigpoint.darkorbit.mvc.events.model.interfaces.IDOEvent;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class AddEventCommand extends SimpleCommand
   {
      
      public function AddEventCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:EventProxy = facade.retrieveProxy(EventProxy.NAME) as EventProxy;
         var _loc3_:IDOEvent = param1.getBody() as IDOEvent;
         _loc2_.addEvent(_loc3_);
      }
   }
}

