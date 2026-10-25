package net.bigpoint.darkorbit.mvc.sectorControlWindow.controller
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups.SectorControlLeaveQueuePopUp;
   import net.bigpoint.darkorbit.mvc.sectorControlWindow.view.components.popups.SectorControlLeaveQueuePopUpMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class SectorControlShowLeaveQueueDialogCommand extends SimpleCommand
   {
      
      public function SectorControlShowLeaveQueueDialogCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         if(facade.hasMediator(SectorControlLeaveQueuePopUpMediator.NAME))
         {
            facade.removeMediator(SectorControlLeaveQueuePopUpMediator.NAME);
         }
         var _loc2_:SectorControlLeaveQueuePopUp = FlexWindowManager.getInstance().createWindow(FlexWindowManager.SECTORCONTROL_LEAVEQUEUE_POPUP,FlexWindowManager.WINDOW_CENTERED) as SectorControlLeaveQueuePopUp;
         _loc2_.title = BPLocale.getItem("title_sectorcontrol_ingame_status");
         _loc2_.message = BPLocale.getItem("sectorcontrol_lobby_window_popup_message");
         var _loc3_:uint = param1.getBody() as uint;
         var _loc4_:SectorControlLeaveQueuePopUpMediator = new SectorControlLeaveQueuePopUpMediator(_loc2_);
         _loc4_.matchID = _loc3_;
         facade.registerMediator(_loc4_);
         AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_QUEST_WINDOW_OPEN_SOUND);
      }
   }
}

