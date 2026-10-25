package net.bigpoint.darkorbit.net.netty.handlers.portals
{
   import net.bigpoint.darkorbit.com.module.JumpGateRemoveCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class JumpGateRemoveHandlerCommand extends DOAbstractSimpleCommand
   {
      
      public function JumpGateRemoveHandlerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:JumpGateRemoveCommand = param1.getBody() as JumpGateRemoveCommand;
         screenManager.map.removeEntityById(_loc2_.gateId);
      }
   }
}

