package net.bigpoint.darkorbit.net.netty.handlers.group
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.GroupErrorCommand;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class GroupErrorHandler extends SimpleCommand
   {
      
      public function GroupErrorHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:GroupErrorCommand = param1.getBody() as GroupErrorCommand;
         switch(_loc2_.type)
         {
            case GroupErrorCommand.ERRORTYPE_PING_FAILED:
            case GroupErrorCommand.ERRORTYPE_FOLLOW_FAILED:
               sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(BPLocale.getItem("label_grp_follow_impossible")));
               break;
            case GroupErrorCommand.ERRORTYPE_NO_GROUP:
            case GroupErrorCommand.ERRORTYPE_NO_INVITATION:
         }
      }
   }
}

