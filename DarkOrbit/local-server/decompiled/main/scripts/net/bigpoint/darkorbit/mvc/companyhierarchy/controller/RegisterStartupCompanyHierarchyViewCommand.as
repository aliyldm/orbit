package net.bigpoint.darkorbit.mvc.companyhierarchy.controller
{
   import net.bigpoint.darkorbit.mvc.companyhierarchy.CompanyHierarchyNotifications;
   import org.puremvc.as3.multicore.interfaces.ICommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class RegisterStartupCompanyHierarchyViewCommand extends SimpleCommand implements ICommand
   {
      
      public function RegisterStartupCompanyHierarchyViewCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         facade.registerCommand(CompanyHierarchyNotifications.SELECTED_COMPANY_CHANGED,SelectedCompanyInHierarchyWindowChangedCommand);
      }
   }
}

