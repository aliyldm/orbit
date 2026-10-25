package net.bigpoint.darkorbit.mvc.groupsystem.control
{
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.GroupSystemMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class GroupSystemCleanupCommand extends SimpleCommand
   {
      
      public function GroupSystemCleanupCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:GroupProxy = facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
         if(_loc2_)
         {
            _loc2_.cleanup();
         }
         var _loc3_:GroupSystemMediator = facade.retrieveMediator(GroupSystemMediator.NAME) as GroupSystemMediator;
         if(_loc3_)
         {
            _loc3_.cleanup();
         }
      }
   }
}

