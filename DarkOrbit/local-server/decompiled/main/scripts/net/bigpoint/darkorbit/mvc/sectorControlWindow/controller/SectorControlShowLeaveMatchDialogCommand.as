package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.LeaveGamePopUp;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups.SectorControlLeaveGamePopUpMediator;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlShowLeaveMatchDialogCommand extends SimpleCommand
   {
      
      public function SectorControlShowLeaveMatchDialogCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(facade.hasMediator(SectorControlLeaveGamePopUpMediator.NAME))
         {
            facade.removeMediator(SectorControlLeaveGamePopUpMediator.NAME);
         }
         var _loc2_:LeaveGamePopUp = FlexWindowManager.getInstance().createWindow(FlexWindowManager.LEAVEMATCH_POPUP,FlexWindowManager.WINDOW_CENTERED) as LeaveGamePopUp;
         _loc2_.title = BPLocale.getItem("sectorcontrol_popup_leavegame_title");
         _loc2_.message = BPLocale.getItem("sectorcontrol_popup_leavegame_message");
         var _loc3_:IMediator = new SectorControlLeaveGamePopUpMediator(_loc2_);
         facade.registerMediator(_loc3_);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_QUEST_WINDOW_OPEN_SOUND);
      }
   }
}

