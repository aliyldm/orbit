package net.bigpoint.darkorbit.mvc.hintSystem.controller
{
   import net.bigpoint.darkorbit.mvc.hintSystem.HintSystemNotifications;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemCloseWindowCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemLoadSlidshowImagesAsyncCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.HintSystemWindowCloseAnimationFinished;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.hintWindow.confirmations.general.HintSystemConfirmationButtonClickCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.controller.netty.HintSystemAddAsyncMacroCommand;
   import net.bigpoint.darkorbit.mvc.hintSystem.model.HintSystemWindowsProxy;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintOverviewWindow.HintSystemHintOverviewWindowMediator;
   import net.bigpoint.darkorbit.mvc.hintSystem.view.hintWindow.HintSystemHintWindowMediator;
   import org.puremvc.as3.multicore.interfaces.INotification;
   import org.puremvc.as3.multicore.patterns.command.SimpleCommand;
   
   public class HintSystemRegisterMVCActorsCommand extends SimpleCommand
   {
      
      private var HintSystemGenaralConfirmationClickCommand:Class;
      
      public function HintSystemRegisterMVCActorsCommand()
      {
         super();
      }
      
      override public function execute(param1:INotification) : void
      {
         if(!facade.hasMediator(HintSystemHintWindowMediator.NAME))
         {
            facade.registerMediator(new HintSystemHintWindowMediator());
         }
         if(!facade.hasMediator(HintSystemHintOverviewWindowMediator.NAME))
         {
            facade.registerMediator(new HintSystemHintOverviewWindowMediator());
         }
         if(!facade.hasProxy(HintSystemWindowsProxy.NAME))
         {
            facade.registerProxy(new HintSystemWindowsProxy());
         }
         if(!facade.hasCommand(HintSystemNotifications.LOAD_SLIDESHOW_IMAGES))
         {
            facade.registerCommand(HintSystemNotifications.LOAD_SLIDESHOW_IMAGES,HintSystemLoadSlidshowImagesAsyncCommand);
         }
         if(!facade.hasCommand(HintSystemNotifications.CLOSE_HINTWINDOW))
         {
            facade.registerCommand(HintSystemNotifications.CLOSE_HINTWINDOW,HintSystemCloseWindowCommand);
         }
         if(!facade.hasCommand(HintSystemNotifications.OPEN_HINTWINDOW))
         {
            facade.registerCommand(HintSystemNotifications.OPEN_HINTWINDOW,HintSystemAddAsyncMacroCommand);
         }
         if(!facade.hasCommand(HintSystemNotifications.PLAY_HINT_SOUND))
         {
            facade.registerCommand(HintSystemNotifications.PLAY_HINT_SOUND,HintSystemPlayHintSoundCommand);
         }
         if(!facade.hasCommand(HintSystemNotifications.HINT_WINDOW_CLOSE_ANIMATION_FINISHED))
         {
            facade.registerCommand(HintSystemNotifications.HINT_WINDOW_CLOSE_ANIMATION_FINISHED,HintSystemWindowCloseAnimationFinished);
         }
         if(!facade.hasCommand(HintSystemNotifications.HINT_WINDOW_CONFIRMATION_CLICKED))
         {
            facade.registerCommand(HintSystemNotifications.HINT_WINDOW_CONFIRMATION_CLICKED,HintSystemConfirmationButtonClickCommand);
         }
      }
   }
}

