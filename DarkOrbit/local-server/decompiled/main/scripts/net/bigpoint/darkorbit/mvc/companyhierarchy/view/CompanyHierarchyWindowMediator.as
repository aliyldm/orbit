package net.bigpoint.darkorbit.mvc.companyhierarchy.view
{
   import mx.collections.ArrayList;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.CompanyHierarchyNotifications;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.components.CompanyHierarchyWindowView;
   import net.bigpoint.darkorbit.mvc.companyhierarchy.view.components.ICompanyHierarchyWindowHandler;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.mediator.Mediator;
   
   public class CompanyHierarchyWindowMediator extends Mediator implements IMediator, ICompanyHierarchyWindowHandler
   {
      
      public static const NAME:String = "CompanyHierarchyWindowMediator";
      
      public function CompanyHierarchyWindowMediator(param1:CompanyHierarchyWindowView)
      {
         super(NAME,param1);
         param1.handler = this;
      }
      
      private function get companyHierarchyWindow() : CompanyHierarchyWindowView
      {
         return super.viewComponent as CompanyHierarchyWindowView;
      }
      
      override public function listNotificationInterests() : Array
      {
         return [CompanyHierarchyNotifications.RANKED_CLANS_UPDATE,CompanyHierarchyNotifications.SELECTED_COMPANY_CHANGED];
      }
      
      override public function handleNotification(param1:INotification) : void
      {
         switch(param1.getName())
         {
            case CompanyHierarchyNotifications.RANKED_CLANS_UPDATE:
               this.companyHierarchyWindow.updateClansList(param1.getBody() as ArrayList);
               break;
            case CompanyHierarchyNotifications.SELECTED_COMPANY_CHANGED:
               this.companyHierarchyWindow.mainTabBar.selectedIndex = (param1.getBody() as int) - 1;
               this.companyHierarchyWindow.updateCompanyLogo();
         }
      }
      
      public function handleFactionTabChanged(param1:int) : void
      {
         param1 += 1;
         facade.sendNotification(CompanyHierarchyNotifications.SELECTED_COMPANY_CHANGED,param1);
      }
   }
}

