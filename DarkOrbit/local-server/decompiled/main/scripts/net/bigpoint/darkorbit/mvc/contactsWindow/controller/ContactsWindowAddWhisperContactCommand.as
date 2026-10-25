package net.bigpoint.darkorbit.mvc.contactsWindow.controller
{
   import net.bigpoint.darkorbit.mvc.chatclient.model.DOChatUserVO;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class ContactsWindowAddWhisperContactCommand extends AbstractContactWindowCommand
   {
      
      public function ContactsWindowAddWhisperContactCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:DOChatUserVO = param1.getBody() as DOChatUserVO;
         if(!_loc2_ || !_loc2_.username || !contactProxy)
         {
            return;
         }
         var _loc3_:Number = Number(_loc2_.userId);
         contactProxy.addWhisperContact(_loc2_.username,isNaN(_loc3_) || _loc3_ <= 0 ? -1 : int(_loc3_),_loc2_.clanTag,_loc2_.factionId);
      }
   }
}

