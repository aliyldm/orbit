package net.bigpoint.darkorbit.mvc.tdm.spawnPoint.controller
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.InGameCatalog;
   import net.bigpoint.darkorbit.audio.AudioManager;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.common.view.components.LeaveGamePopUp;
   import net.bigpoint.darkorbit.mvc.tdm.spawnPoint.view.TDMLeaveGamePopUpMediator;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.TDMStatusModel;
   import net.bigpoint.darkorbit.mvc.tdm.statusWindow.model.TDMStatusProxy;
   import org.puremvc.as3.multicore.interfaces.IMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class TDMShowLeaveMatchDialogCommand extends SimpleCommand
   {
      
      public function TDMShowLeaveMatchDialogCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:String = null;
         var _loc4_:LeaveGamePopUp = null;
         var _loc6_:TDMStatusModel = null;
         super.execute(param1);
         _loc2_ = BPLocale.getItem("tdm_popup_leavegame_message");
         var _loc3_:TDMStatusProxy = facade.retrieveProxy(TDMStatusProxy.NAME) as TDMStatusProxy;
         if(_loc3_)
         {
            _loc6_ = _loc3_.getData() as TDMStatusModel;
            if(_loc6_.remainingSeconds < _loc6_.initSeconds)
            {
               _loc2_ = BPLocale.getItem("tdm_popup_leavegame_noreward_message");
            }
            else
            {
               _loc2_ = BPLocale.getItem("tdm_popup_leavegame_message");
            }
         }
         _loc4_ = FlexWindowManager.getInstance().getWindowByType(FlexWindowManager.LEAVEMATCH_POPUP) as LeaveGamePopUp;
         if(_loc4_ == null)
         {
            _loc4_ = FlexWindowManager.getInstance().createWindow(FlexWindowManager.LEAVEMATCH_POPUP,FlexWindowManager.WINDOW_CENTERED) as LeaveGamePopUp;
            _loc4_.title = BPLocale.getItem("tdm_popup_leavegame_title");
            _loc4_.message = _loc2_;
            if(_loc4_.visible)
            {
               AudioManager.playSoundEffect(InGameCatalog.SOUND_ID_QUEST_WINDOW_OPEN_SOUND);
            }
         }
         var _loc5_:IMediator = new TDMLeaveGamePopUpMediator(_loc4_);
         facade.registerMediator(_loc5_);
      }
   }
}

