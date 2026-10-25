package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.contactsWindow.model.vo.ContactsWindowContactListEntryVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowShipSelectedCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowShipSelectedCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:int = int((param1.getBody() as Array)[0]);
         var _loc3_:String = (param1.getBody() as Array)[1];
         var _loc4_:ContactsWindowContactListEntryVO = contactProxy.getListEntryByUserID(_loc2_);
         if(!_loc4_)
         {
            _loc4_ = new ContactsWindowContactListEntryVO(_loc3_,ContactsWindowContactListEntryVO.STATE_NONE,_loc2_);
         }
         contactProxy.updateSelectedUserTo(_loc4_);
      }
   }
}

