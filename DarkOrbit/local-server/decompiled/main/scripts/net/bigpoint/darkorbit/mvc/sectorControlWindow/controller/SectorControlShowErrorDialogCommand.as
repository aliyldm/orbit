package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.SectorControlErrorCommand;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.battlestationswindow.view.components.popups.PopUpWithErrorMessage;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlShowErrorDialogCommand extends SimpleCommand
   {
      
      public function SectorControlShowErrorDialogCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:SectorControlErrorCommand = param1.getBody() as SectorControlErrorCommand;
         switch(_loc2_.errorType)
         {
            case SectorControlErrorCommand.ERRORTYPE_LEVEL_TOO_LOW:
               this.showUserLevelTooLowErrorMessage();
               break;
            case SectorControlErrorCommand.ERRORTYPE_NO_TICKETS_LEFT:
               this.showNoTicketsLeftErrorMessage();
               break;
            case SectorControlErrorCommand.ERRORTYPE_QUEUE_FULL:
               this.showQueueFullErrorMessage();
         }
      }
      
      private function showQueueFullErrorMessage() : void
      {
         var _loc1_:PopUpWithErrorMessage = null;
         _loc1_ = PopUpWithErrorMessage(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_ERROR_MESSAGE,FlexWindowManager.WINDOW_CENTERED));
         _loc1_.title = BPLocale.getItem("sectorcontrol_popup_queue_full_title");
         _loc1_.setPopupText(BPLocale.getItem("sectorcontrol_popup_queue_full_message"));
      }
      
      private function showUserLevelTooLowErrorMessage() : void
      {
         var _loc1_:PopUpWithErrorMessage = null;
         _loc1_ = PopUpWithErrorMessage(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_ERROR_MESSAGE,FlexWindowManager.WINDOW_CENTERED));
         _loc1_.title = BPLocale.getItem("sectorcontrol_popup_levelrequirement_title");
         _loc1_.setPopupText(BPLocale.getItem("sectorcontrol_popup_levelrequirement_message"));
      }
      
      private function showNoTicketsLeftErrorMessage() : void
      {
         var _loc1_:PopUpWithErrorMessage = PopUpWithErrorMessage(FlexWindowManager.getInstance().createWindow(FlexWindowManager.BS_POP_UP_WITH_ERROR_MESSAGE,FlexWindowManager.WINDOW_CENTERED));
         _loc1_.title = BPLocale.getItem("sectorcontrol_popup_noticketsleft_title");
         _loc1_.setPopupText(BPLocale.getItem("sectorcontrol_popup_noticketsleft_message"));
      }
   }
}

