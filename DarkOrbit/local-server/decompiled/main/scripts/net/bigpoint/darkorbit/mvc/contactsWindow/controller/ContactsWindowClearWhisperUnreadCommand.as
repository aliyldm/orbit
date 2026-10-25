package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowClearWhisperUnreadCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowClearWhisperUnreadCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(!contactProxy)
         {
            return;
         }
         var _loc2_:Array = param1.getBody() as Array;
         if(!_loc2_ || _loc2_.length == 0)
         {
            return;
         }
         var _loc3_:String = _loc2_[0] as String;
         var _loc4_:int = _loc2_.length > 1 ? int(_loc2_[1]) : -1;
         contactProxy.clearWhisperUnread(_loc3_,_loc4_);
      }
   }
}

