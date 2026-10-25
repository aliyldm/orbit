package net.bigpoint.darkorbit.mvc.companyhierarchy.controller
{
   import net.bigpoint.darkorbit.mvc.companyhierarchy.model.proxy.CompanyHierarchyProxy;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SelectedCompanyInHierarchyWindowChangedCommand extends SimpleCommand implements ICommand
   {
      
      public function SelectedCompanyInHierarchyWindowChangedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:CompanyHierarchyProxy = facade.retrieveProxy(CompanyHierarchyProxy.NAME) as CompanyHierarchyProxy;
         _loc2_.handleFactionTabSwitchedRequest(param1.getBody() as int);
      }
   }
}

