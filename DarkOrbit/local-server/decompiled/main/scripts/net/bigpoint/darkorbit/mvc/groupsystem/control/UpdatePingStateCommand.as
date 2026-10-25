package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class UpdatePingStateCommand extends SimpleCommand
   {
      
      public function UpdatePingStateCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:GroupProxy = facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
         _loc2_.pingMode = Boolean(param1.getBody());
      }
   }
}

