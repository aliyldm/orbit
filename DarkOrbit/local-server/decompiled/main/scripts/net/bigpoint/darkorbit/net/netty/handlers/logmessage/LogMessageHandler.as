package net.bigpoint.darkorbit.net.netty.handlers.logmessage
{
   import net.bigpoint.darkorbit.com.module.LogMessageCommand;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class LogMessageHandler extends DOAbstractSimpleCommand
   {
      
      public function LogMessageHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:LogMessageCommand = param1.getBody() as LogMessageCommand;
         var _loc3_:String = TextUtils.getTooltipTextByMessageLocalizedWildcardCommand(_loc2_.message);
         if(_loc2_.style == LogMessageCommand.STYLE_LARGE)
         {
            switch(_loc2_.visibility)
            {
               case LogMessageCommand.VISIBILITY_LOG:
                  sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc3_).setType(LogMessageProfileVOFactory.LOG_ONLY_MESSAGE));
                  break;
               case LogMessageCommand.VISIBILITY_LOG_AND_SCREEN:
                  sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc3_).setType(LogMessageProfileVOFactory.LOG_ONLY_MESSAGE));
                  sendNotification(GuiNotifications.ADD_GLOBAL_NOTIFICATION_MESSAGE,new MessageCommandParams().setMessage(_loc3_));
                  break;
               case LogMessageCommand.VISIBILITY_SCREEN:
                  sendNotification(GuiNotifications.ADD_GLOBAL_NOTIFICATION_MESSAGE,new MessageCommandParams().setMessage(_loc3_));
            }
         }
         else
         {
            switch(_loc2_.visibility)
            {
               case LogMessageCommand.VISIBILITY_LOG:
                  sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc3_).setType(LogMessageProfileVOFactory.LOG_ONLY_MESSAGE));
                  break;
               case LogMessageCommand.VISIBILITY_LOG_AND_SCREEN:
                  showScreenMessage(_loc3_);
                  sendNotification(GuiNotifications.LOG_MESSAGE,new MessageCommandParams().setMessage(_loc3_).setType(LogMessageProfileVOFactory.LOG_ONLY_MESSAGE));
                  break;
               case LogMessageCommand.VISIBILITY_SCREEN:
                  showScreenMessage(_loc3_);
            }
         }
      }
   }
}

