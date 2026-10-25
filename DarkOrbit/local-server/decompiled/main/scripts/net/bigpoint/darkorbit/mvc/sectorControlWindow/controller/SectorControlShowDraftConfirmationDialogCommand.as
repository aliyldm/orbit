package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.com.module.SectorControlDraftConfirmationCommand;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups.SectorControlDraftConfirmationPopUp;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups.SectorControlDraftConfirmationPopUpMediator;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlShowDraftConfirmationDialogCommand extends SimpleCommand
   {
      
      public function SectorControlShowDraftConfirmationDialogCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc3_:SectorControlDraftConfirmationPopUp = null;
         super.execute(param1);
         var _loc2_:SectorControlDraftConfirmationCommand = param1.getBody() as SectorControlDraftConfirmationCommand;
         if(facade.hasMediator(SectorControlDraftConfirmationPopUpMediator.NAME))
         {
            facade.removeMediator(SectorControlDraftConfirmationPopUpMediator.NAME);
         }
         _loc3_ = FlexWindowManager.getInstance().createWindow(FlexWindowManager.SECTORCONTROL_PARTICIPATION_POPUP,FlexWindowManager.WINDOW_CENTERED) as SectorControlDraftConfirmationPopUp;
         _loc3_.title = BPLocale.getItem("sectorcontrol_popup_participation_title");
         _loc3_.countDownText = BPLocale.getItem("sectorcontrol_popup_participation_message");
         _loc3_.cancleMessage = BPLocale.getItem("label_no");
         _loc3_.confirmationMessage = BPLocale.getItem("label_yes");
         _loc3_.startTimer(_loc2_.seconds);
         var _loc4_:IMediator = new SectorControlDraftConfirmationPopUpMediator(_loc3_);
         facade.registerMediator(_loc4_);
      }
   }
}

