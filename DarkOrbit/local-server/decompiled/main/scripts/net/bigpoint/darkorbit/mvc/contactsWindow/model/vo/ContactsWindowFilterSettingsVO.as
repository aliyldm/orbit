package net.bigpoint.darkorbit.mvc.contactsWindow.model.vo
{
   public class ContactsWindowFilterSettingsVO
   {
      
      public var showContacts:Boolean;
      
      public var showClanMembers:Boolean;
      
      public var showRequests:Boolean;
      
      public var showBlocked:Boolean;
      
      public function ContactsWindowFilterSettingsVO(param1:Boolean, param2:Boolean, param3:Boolean, param4:Boolean)
      {
         super();
         this.showContacts = param1;
         this.showClanMembers = param2;
         this.showRequests = param3;
         this.showBlocked = param4;
      }
   }
}

