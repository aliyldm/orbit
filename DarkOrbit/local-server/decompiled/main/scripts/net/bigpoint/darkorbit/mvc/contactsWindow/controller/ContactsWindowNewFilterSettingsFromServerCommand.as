package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowFilterSettingsVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowNewFilterSettingsFromServerCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowNewFilterSettingsFromServerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:ContactsWindowFilterSettingsVO = param1.getBody() as ContactsWindowFilterSettingsVO;
         contactProxy.showContacts = _loc2_.showContacts;
         contactProxy.showClanmembers = _loc2_.showClanMembers;
         contactProxy.showRequests = _loc2_.showRequests;
         contactProxy.showBlocked = _loc2_.showBlocked;
      }
   }
}

