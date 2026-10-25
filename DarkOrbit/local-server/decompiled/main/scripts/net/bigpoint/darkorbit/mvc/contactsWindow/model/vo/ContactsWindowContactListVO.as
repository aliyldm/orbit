package net.bigpoint.darkorbit.mvc.contactsWindow.model.vo
{
   public class ContactsWindowContactListVO
   {
      
      private var _listEntries:Vector.<ContactsWindowContactListEntryVO>;
      
      public function ContactsWindowContactListVO(param1:Vector.<ContactsWindowContactListEntryVO>)
      {
         super();
         if(param1 != null)
         {
            this._listEntries = param1;
         }
         else
         {
            this._listEntries = new Vector.<ContactsWindowContactListEntryVO>();
         }
      }
      
      public function get listEntries() : Vector.<ContactsWindowContactListEntryVO>
      {
         return this._listEntries;
      }
   }
}

