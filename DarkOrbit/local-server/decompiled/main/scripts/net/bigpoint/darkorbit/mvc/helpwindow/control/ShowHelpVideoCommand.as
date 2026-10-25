package net.bigpoint.darkorbit.mvc.helpwindow.control
{
   import net.bigpoint.as3toolbox.bplocale.BPLocale;
   import net.bigpoint.darkorbit.gui.windows.FlexWindowManager;
   import net.bigpoint.darkorbit.mvc.common.controller.finisher.FLVFinisher;
   import net.bigpoint.darkorbit.mvc.common.model.assets.AssetsProxy;
   import net.bigpoint.darkorbit.mvc.helpwindow.view.HelpVideoPopUp;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class ShowHelpVideoCommand extends SimpleCommand
   {
      
      public function ShowHelpVideoCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         super.execute(param1);
         var _loc2_:FlexWindowManager = FlexWindowManager.getInstance();
         var _loc3_:AssetsProxy = facade.retrieveProxy(AssetsProxy.NAME) as AssetsProxy;
         var _loc4_:HelpVideoPopUp = _loc2_.createWindow(FlexWindowManager.HELP_VIDEO_POPUP) as HelpVideoPopUp;
         var _loc5_:FLVFinisher = _loc3_.getLib("disablingPepper") as FLVFinisher;
         _loc4_.helpVideo = _loc5_.getURL();
         _loc4_.text = BPLocale.getItem("text_pepper_flash_player_fix");
         _loc4_.title = BPLocale.getItem("low_performance_pepper_flash_player_header");
      }
   }
}

