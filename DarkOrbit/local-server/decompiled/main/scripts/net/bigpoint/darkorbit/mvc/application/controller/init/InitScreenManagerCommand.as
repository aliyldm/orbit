package net.bigpoint.darkorbit.mvc.application.controller.init
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.GuiNotifications;
   import net.bigpoint.darkorbit.mvc.gui.messages.controller.MessageCommandParams;
   import net.bigpoint.darkorbit.mvc.gui.messages.model.MessageIDs;
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.simpleWindow.HintSystemAddBySimpleWindowAsyncMacroCommand;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class InitScreenManagerCommand extends DOAbstractAsyncCommand
   {
      
      public function InitScreenManagerCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         GameFacade.getInstance().sendNotification(GuiNotifications.SHOW_MESSAGE_SMALL,new MessageCommandParams(BPLocale.getItem("loadingClaim")).setId(MessageIDs.SMALL_MESSAGE__QUICKLOADER));
         registerCommand(HintSystemNotifications.SHOW_SIMPLE_WINDDOW_HINTWINDOW,HintSystemAddBySimpleWindowAsyncMacroCommand);
         commandComplete();
      }
   }
}

