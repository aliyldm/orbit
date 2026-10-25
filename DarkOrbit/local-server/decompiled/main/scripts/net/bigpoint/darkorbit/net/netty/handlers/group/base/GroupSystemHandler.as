package net.bigpoint.darkorbit.net.netty.handlers.group.base
{
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.groupsystem.model.proxy.GroupProxy;
   import net.bigpoint.darkorbit.mvc.groupsystem.view.GroupSystemMediator;
   
   public class GroupSystemHandler extends DOAbstractSimpleCommand
   {
      
      public function GroupSystemHandler()
      {
         super();
      }
      
      protected function get groupMediator() : GroupSystemMediator
      {
         return facade.retrieveMediator(GroupSystemMediator.NAME) as GroupSystemMediator;
      }
      
      protected function get groupProxy() : GroupProxy
      {
         return facade.retrieveProxy(GroupProxy.NAME) as GroupProxy;
      }
   }
}

