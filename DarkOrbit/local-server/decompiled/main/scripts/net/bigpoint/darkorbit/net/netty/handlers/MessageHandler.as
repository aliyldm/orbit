package net.bigpoint.darkorbit.net.netty.handlers
{
   import net.bigpoint.darkorbit.com.module.MessageCommand;
   import net.bigpoint.darkorbit.com.module.MessageWildcardReplacementModule;
   import net.bigpoint.darkorbit.com.module.WildcardMessageModule;
   import net.bigpoint.darkorbit.gui.GuiManager;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractSimpleCommand;
   import net.bigpoint.darkorbit.mvc.common.utils.TextUtils;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.LogMessageProfileVOFactory;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class MessageHandler extends DOAbstractSimpleCommand
   {
      
      public function MessageHandler()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:String = null;
         super.execute(param1);
         var _loc2_:MessageCommand = param1.getBody() as MessageCommand;
         switch(_loc2_.messageModule.getLibcomModuleId())
         {
            case MessageWildcardReplacementModule.instance.getLibcomModuleId():
               return;
            case WildcardMessageModule.instance.getLibcomModuleId():
               _loc3_ = TextUtils.translateMessageKeyListWildcardModule((_loc2_.messageModule as WildcardMessageModule).message,true);
               switch(_loc2_.displayStyle)
               {
                  case MessageCommand.DISPLAYSTYLE_NORMAL:
                     this.writeNormal(_loc2_,_loc3_);
                     break;
                  case MessageCommand.DISPLAYSTYLE_BIG:
                     this.writeBig(_loc2_,_loc3_);
               }
               return;
            default:
               return;
         }
      }
      
      private function writeNormal(param1:MessageCommand, param2:String) : void
      {
         var _loc3_:GuiManager = GuiManager.instance;
         switch(param1.displayTarget)
         {
            case MessageCommand.DISPLAYTARGET_LOG:
               log(param2,LogMessageProfileVOFactory.LOG_ONLY_MESSAGE);
               break;
            case MessageCommand.DISPLAYTARGET_SCREEN:
               showScreenMessage(param2);
               break;
            case MessageCommand.DISPLAYTARGET_BOTH:
               log(param2);
         }
      }
      
      private function writeBig(param1:MessageCommand, param2:String) : void
      {
         var _loc3_:GuiManager = GuiManager.instance;
         switch(param1.displayTarget)
         {
            case MessageCommand.DISPLAYTARGET_LOG:
               log(param2,LogMessageProfileVOFactory.LOG_ONLY_MESSAGE);
               break;
            case MessageCommand.DISPLAYTARGET_SCREEN:
               addGlobalNotification(param2);
               break;
            case MessageCommand.DISPLAYTARGET_BOTH:
               addGlobalNotification(param2);
               log(param2,LogMessageProfileVOFactory.LOG_ONLY_MESSAGE);
         }
      }
   }
}

